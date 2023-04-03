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

Creating an image with debug symbols depends if the app is compiled with `cmake` or `qmake`. To enable debugging set `BUILD_TYPE="Debug"` and `DEBUG="+"` in `scripts/build-images.sh


Before
```
--build-arg BUILD_TYPE="Release" \
--build-arg DEBUG="-" \
```

After
```
--build-arg BUILD_TYPE="Debug" \
--build-arg DEBUG="+" \
```

Example to run gdb in a container
```
docker run --ulimit core=-1 -it -v $(pwd):/input openscad/openscad:2021.01-debug
apt update; apt install gdb -y
xvfb-run gdb --ex run --args openscad --info
```