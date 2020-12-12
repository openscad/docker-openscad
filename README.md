# docker-openscad 
OpenSCAD-related docker files

See the appimage/appimage-x86_64-openscad/Dockerfile for build instructions.

Use the ruXnme file to run under docker on Linux. 

Note: on older distros you may need to add binutils to the build environment (base), 
then use strip on qt5 Core:

on this appimage:
strip --remove-section=.note.ABI-tag AppDir/usr/lib/libQt5Core.so.5

On Debian based containers:
strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5


