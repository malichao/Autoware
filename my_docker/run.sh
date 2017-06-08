#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=$XAUTHORITY

nvidia-docker run \
  --net=host\
  -e SHELL\
  -e DISPLAY\
  -e DOCKER=1\
  -v "$HOME:$HOME:rw"\
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"\
	-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
	-it autoware-1
