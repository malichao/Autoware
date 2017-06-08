FROM nvidia/cuda:8.0-devel-ubuntu14.04
MAINTAINER Yuki Iida <aiueo.0409@gmail.com>

# Arguments
ARG user
ARG uid
ARG home
ARG workspace
ARG shell

RUN apt-get update && apt-get install -y \
        software-properties-common \
        wget curl git cmake cmake-curses-gui \
				zsh screen tree sudo ssh synaptic

# Latest X11 / mesa GL
RUN apt-get install -y\
  xserver-xorg-dev-lts-wily\
  libegl1-mesa-dev-lts-wily\
  libgl1-mesa-dev-lts-wily\
  libgbm-dev-lts-wily\
  mesa-common-dev-lts-wily\
  libgles2-mesa-lts-wily\
  libwayland-egl1-mesa-lts-wily\
  libopenvg1-mesa

# Dependencies required to build rviz
RUN apt-get install -y\
  qt4-dev-tools\
  libqt5core5a libqt5dbus5 libqt5gui5 libwayland-client0\
  libwayland-server0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1\
  libxcb-render-util0 libxcb-util0 libxcb-xkb1 libxkbcommon-x11-0\
  libxkbcommon0

# Intall ROS
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -
RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-get update && apt-get install -y \
        ros-indigo-desktop-full ros-indigo-nmea-msgs \
        ros-indigo-nmea-navsat-driver ros-indigo-sound-play \
        ros-indigo-jsk-visualization \
        ros-indigo-perception-pcl \
        ros-indigo-openni-launch \
        ros-indigo-turtlebot-simulator \
        libnlopt-dev freeglut3-dev qtbase5-dev \
        libqt5opengl5-dev libssh2-1-dev libarmadillo-dev libpcap-dev gksu \
				ros-indigo-grid-map \
				ros-indigo-velocity-controllers \
				ros-indigo-gps-common 

RUN rosdep init \
        && rosdep update \
        && echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc

# Develop
RUN apt-get install -y \
        libboost-all-dev \
        libflann-dev \
        libgsl0-dev \
        libgoogle-perftools-dev \
        libeigen3-dev \
				libglew-dev

# Additional development tools
RUN apt-get install -y x11-apps python-pip build-essential
RUN pip install catkin_tools

# Intall some basic GUI and sound libs
RUN apt-get install -y \
                xz-utils file locales dbus-x11 pulseaudio dmz-cursor-theme \
                fonts-dejavu fonts-liberation hicolor-icon-theme \
                libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module \
                libasound2 libgtk2.0-0 libdbus-glib-1-2 libxt6 libexif12 \
                libglapi-mesa libgl1-mesa-glx libgl1-mesa-dri \
        && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX

# Intall some basic GUI tools
RUN apt-get install -y \
        cmake-qt-gui \
        gnome-terminal

# Install OpenCV
RUN apt-get update && apt-get -y install \
		libopencv-dev build-essential cmake git \
		libgtk2.0-dev pkg-config python-dev python-numpy \
		libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-0 \
		libjasper-dev libavcodec-dev libavformat-dev libswscale-dev \
		libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev \
		libtbb-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev \
		libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip

RUN wget https://github.com/opencv/opencv/archive/2.4.13.zip && \
    unzip 2.4.13.zip && \
    rm 2.4.13.zip && \
    cd opencv-2.4.13/ && \
    mkdir build && \
    cd build/ && \
    cmake -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D CUDA_GENERATION=Auto -D WITH_QT=ON -D WITH_OPENGL=ON -D WITH_VTK=ON .. && \
    make -j8 && \
    make install 
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:/usr/local/lib/pkgconfig


# Make SSH available
EXPOSE 22

# Mount the user's home directory
VOLUME "${home}"

# Add basic user
ENV USERNAME=${user}

# Switch to user
USER "${user}"

# Clone user into docker image and set up X11 sharing 
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"


# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

COPY ${home}/.Xauthority /.Xauthority

# Install Autoware
#RUN git clone https://github.com/CPFL/Autoware.git ${home}/Autoware-docker
#RUN /bin/bash -c 'source /opt/ros/indigo/setup.bash; cd ${home}/Autoware-docker/ros/src; catkin_init_workspace; cd ../; ./catkin_make_release'
#RUN echo "source ${home}/Autoware-docker/ros/devel/setup.bash" >> ${home}/.bashrc


