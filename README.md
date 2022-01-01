# docker-openscad
This repository collects OpenSCAD related docker files. Some are meant for internal use in the OpenSCAD CI automation.

# General use

For general use, please check the `openscad/openscad` images published and documented at Docker Hub.

* [openscad/openscad](https://hub.docker.com/repository/docker/openscad/openscad)

# CI support, for internal use

* openscad/appimage-*
* openscad/mxe-*
* openscad/src-*

# Debug Builds

To create a debug build with symbols table for `gdb` debugging, modify this line in `scripts/build-images.sh`


Before
```
--build-arg BUILD_TYPE="Release" \
```

After
```
--build-arg BUILD_TYPE="Debug" \
```