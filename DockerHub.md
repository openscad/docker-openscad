# Official OpenSCAD Docker images

Maintained by the [OpenSCAD](https://www.openscad.org/) Team.

## Supported tags and respective Dockerfile links

* [`trixie`](https://github.com/openscad/docker-openscad/blob/main/openscad/trixie/Dockerfile) **`dev`** based on Debian 13 (trixie)
* [`bookworm`](https://github.com/openscad/docker-openscad/blob/main/openscad/bookworm/Dockerfile) based on Debian 12 (bookworm)
* [`2021.01`](https://github.com/openscad/docker-openscad/blob/main/openscad/buster/Dockerfile) **`latest`** based on Debian 11 (buster)
* [`2019.05`](https://github.com/openscad/docker-openscad/blob/main/openscad/buster/Dockerfile) based on Debian 11 (buster)
* [`2015.03`](https://github.com/openscad/docker-openscad/blob/main/openscad/buster/Dockerfile) based on Debian 10 (stretch)

The `dev`tag is rebuilt regularly from the `master` branch of the OpenSCAD repository. Additional tags are set with the date of the build, so for example the build on March 25th, 2024 will be tagged as both `dev` and `dev.2024-03-25`.

## Quick Reference

* For help use the [mailing list](https://openscad.org/community.html#forum) or the [#openscad](https://openscad.org/community.html#irc) IRC channel on libera.chat. 

* Bug reports and feature requests can be filed at https://github.com/openscad/docker-openscad/issues

* Documentation about OpenSCAD can be found at https://openscad.org/documentation.html

  * Get started with the [Tutorial](https://en.wikibooks.org/wiki/OpenSCAD_Tutorial)
  * A quick reference card is available as [Cheatsheet](https://openscad.org/cheatsheet/index.html)
  * For more details, see the [User Manual](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual#The_OpenSCAD_User_Manual) and [Language Reference](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual#The_OpenSCAD_Language_Reference)
  * The list of [Books](https://openscad.org/documentation-books.html) includes some directly about OpenSCAD and others using OpenSCAD to help teach topics like Math, Geometry, and 3D printing. 

## What is OpenSCAD?

<img src="https://www.openscad.org/images/openscad.png" width="200" align="left" hspace="20">
OpenSCAD is software for creating solid 3D CAD models. It is free software and available for Linux/UNIX, Windows and Mac OS X. Unlike most free software for creating 3D models (such as Blender) it does not focus on the artistic aspects of 3D modelling but instead on the CAD aspects. Thus it might be the application you are looking for when you are planning to create 3D models of machine parts but pretty sure is not what you are looking for when you are more interested in creating computer-animated movies.

OpenSCAD is not an interactive modeller. Instead it is something like a 3D-compiler that reads in a script file that describes the object and renders the 3D model from this script file. This gives you (the designer) full control over the modelling process and enables you to easily change any step in the modelling process or make designs that are defined by configurable parameters.

OpenSCAD provides two main modelling techniques: First there is constructive solid geometry (aka CSG) and second there is extrusion of 2D outlines. Autocad DXF files can be used as the data exchange format for such 2D outlines. In addition to 2D paths for extrusion it is also possible to read design parameters from DXF files. Besides DXF files OpenSCAD can read and create 3D models in the STL and OFF file formats.

## License

The OpenSCAD binary is distributed under the [GNU General Public License v3.0](https://spdx.org/licenses/GPL-3.0-or-later.html) (or later). The source code can be found in the [github repository](https://github.com/openscad/openscad/) under the release version / tag that is the same as the docker image tag.

For the development builds the matching source code can be found via the commit hash shown via `docker run openscad/openscad:dev openscad --info | head -n1` 

## General Use of the images

For general use (running OpenSCAD in a container), please use the `openscad/openscad` images published and documented at Docker Hub.

* [openscad/openscad](https://hub.docker.com/repository/docker/openscad/openscad)

### Rendering to a STL/3MF Model

```bash
docker run \
    -it \
    --rm \
    -v $(pwd):/openscad \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    openscad/openscad:latest \
    openscad -o CSG.3mf CSG.scad
```

### Rendering a PNG

```bash
docker run \
    -it \
    --rm \
    --init \
    -v $(pwd):/openscad \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    openscad/openscad:latest \
    xvfb-run -a openscad -o CSG.png CSG.scad
```

Note that PNG renderings currently still needs the X display in all release versions. So this needs `--init` and run via `xvfb-run`.

That limitation is lifted in the latest dev snapshots due to the built-in EGL support.

## Usage in Makefiles

OpenSCAD supports usage in Makefiles, e.g.

```
%.stl: %.scad
	openscad -m make -o ./stl/$@ -d $@.deps $<
	openscad -m make --render -o ./png/$@.png $<
```

Using the docker container version allows this too, by transforming the
tool calls to the `$(shell ...)` notation. Note that this does not easily
supports the `-m make` option as that would run inside the container and
may need extra attention. The currently published containers do not have
`make` installed.

```
%.stl: %.scad

	docker run \
		-it \
		--rm \
		-v $(shell pwd):/openscad \
		-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
		openscad/openscad:latest \
		openscad -o ./stl/$@ -d $@.deps $<

	docker run \
		-it \
		--rm \
		--init \
		-v $(shell pwd):/openscad \
		-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
		openscad/openscad:latest \
		xvfb-run -a openscad -o ./png/$@.png $<
```

## CI support, for internal use

* `openscad/appimage-*`
* `openscad/mxe-*`
* `openscad/src-*`

All docker images can be viewed with a [Docker Hub search for `openscad/`](https://hub.docker.com/search?q=openscad%2F&image_filter=open_source&type=image).
