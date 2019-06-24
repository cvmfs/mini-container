# Builds a tarball with the cvmfs client that can
# Requires a cvmfs build and source tree

SOURCE_TREE =
BUILD_TREE =

TARBALL_PREFIX = cvmfs-mini
TARBALL_VERSION = 0.1
TARBALL_ARCH = amd64
TARBALL_NAME = $(TARBALL_PREFIX)-$(TARBALL_VERSION)-$(TARBALL_ARCH).tar.bz2
CONTENT_DIR = $(TARBALL_PREFIX)-$(TARBALL_VERSION)-$(TARBALL_ARCH)

CVMFS_TARGETS = $(CONTENT_DIR)/bin/cvmfs2 \
  $(CONTENT_DIR)/bin/libcvmfs_fuse_stub.so \
	$(CONTENT_DIR)/bin/libcvmfs_fuse.so
CVMFS_HELPERS = $(CONTENT_DIR)/mount_cvmfs.sh \
	$(CONTENT_DIR)/default.conf \
	$(CONTENT_DIR)/default.local
CVMFS_KEYS = $(CONTENT_DIR)/keys/cern.ch.pub \
	$(CONTENT_DIR)/keys/cern-it1.cern.ch.pub \
	$(CONTENT_DIR)/keys/cern-it4.cern.ch.pub \
	$(CONTENT_DIR)/keys/cern-it5.cern.ch.pub

all: $(TARBALL_NAME)

clean:
	rm -f $(TARBALL_NAME)
	rm -rf $(CONTENT_DIR)

$(TARBALL_NAME): $(CONTENT_DIR)/CONTENTS
	tar cfJ $@ $(CONTENT_DIR)
	rm -rf $(CONTENT_DIR)

$(CONTENT_DIR)/CONTENTS: $(CONTENT_DIR)/.done_bin $(CVMFS_HELPERS) $(CVMFS_KEYS) | $(SOURCE_TREE)/.git
	echo "Tarball version:          $(TARBALL_VERSION)" >> $@
	echo "Git revision:             $(shell cd $(SOURCE_TREE) && git rev-parse HEAD)" >> $@
	echo "CernVM-FS version:        $(shell cd $(BUILD_TREE)/cvmfs && ./cvmfs2 --version)" >> $@

$(CONTENT_DIR):
	mkdir -p $@

$(CONTENT_DIR)/.done_minbase: | $(CONTENT_DIR)
	mkdir -p $(CONTENT_DIR)/bin \
	  $(CONTENT_DIR)/lib \
		$(CONTENT_DIR)/keys
	ln -s lib $(CONTENT_DIR)/lib64
	touch $@

$(CONTENT_DIR)/default.conf: default.conf | $(CONTENT_DIR)
	cp $< $@

$(CONTENT_DIR)/default.local: | $(CONTENT_DIR)
	touch $@

$(CONTENT_DIR)/mount_cvmfs.sh: mount_cvmfs.sh | $(CONTENT_DIR)
	cp $< $@

$(CONTENT_DIR)/.done_bin: $(CVMFS_TARGETS)
	./libs.sh $(CONTENT_DIR)
	touch $@

$(CONTENT_DIR)/bin/cvmfs2: $(BUILD_TREE)/cvmfs/cvmfs2 $(CONTENT_DIR)/.done_minbase
	cp $< $@

$(CONTENT_DIR)/bin/libcvmfs_fuse_stub.so: $(BUILD_TREE)/cvmfs/libcvmfs_fuse_stub.so $(CONTENT_DIR)/.done_minbase
	cp $< $@

$(CONTENT_DIR)/bin/libcvmfs_fuse.so: $(BUILD_TREE)/cvmfs/libcvmfs_fuse.so $(CONTENT_DIR)/.done_minbase
	cp $< $@

$(CONTENT_DIR)/keys/cern.ch.pub: $(SOURCE_TREE)/mount/keys/cern.ch.pub $(CONTENT_DIR)/.done_minbase
	cp $< $@

$(CONTENT_DIR)/keys/cern-it1.cern.ch.pub: $(SOURCE_TREE)/mount/keys/cern-it1.cern.ch.pub $(CONTENT_DIR)/.done_minbase
	cp $< $@

$(CONTENT_DIR)/keys/cern-it4.cern.ch.pub: $(SOURCE_TREE)/mount/keys/cern-it4.cern.ch.pub $(CONTENT_DIR)/.done_minbase
	cp $< $@

$(CONTENT_DIR)/keys/cern-it5.cern.ch.pub: $(SOURCE_TREE)/mount/keys/cern-it5.cern.ch.pub $(CONTENT_DIR)/.done_minbase
	cp $< $@
