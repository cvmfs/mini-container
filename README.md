# CernVM-FS Standalone Client

This is a build system for a cvmfs standalone client.  The Makefile creates a
tarball which contains the cvmfs binaries plus config files and a mount helper
script.  The cvmfs client from the tarball can be used from any directory on a
platform compatible with the build platform.  No system-wide cvmfs installation
is needed.


## Creating the standalone tarball

In order to create the standalone tarball, you need the cvmfs git sources and
a cvmfs build tree with the compiled binaries.  You can then run

    make SOURCE_TREE=<directory> BUILD_TREE=<directory>

The tarball is portable to any node that runs the same Linux flavor and version.


## Using the standalone tarball

Extract the tarball into any directory and call

    <directory>/mount_cvmfs.sh <repository name> <mount point>

You might need to edit the `<directory>/default.local` file in order to over-
write the cache directory.  In order to unmount, use

    fusermount -u <mountpoint>

This tarball is usable if fuse is installed and available to regular users or --
on newer kernels -- as namespace root if /dev/fuse is available.
