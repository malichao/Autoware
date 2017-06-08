# Autoware Docker

## What's new comparing to Autoware's native docker
1. Fix "Could not open X display" issue
2. Add user's home directory into the container
3. Remove git clone of Autoware repo and build process
4. EXPOSE 22 port for ssh

With these changes, you could have access to your own directory and save all your work after you quite the container. That mean you could develop the code with your IDE in the host computer and run it inside the container. Since ROS could run across multiple machines, you could run the computation nodes inside the container and open the RViz in your host computer.

## Install docker
```
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# For Ubuntu 14.04
Repo = "deb https://apt.dockerproject.org/repo ubuntu-trusty main"
# For Ubuntu 16.04
Repo = "deb https://apt.dockerproject.org/repo ubuntu-xenial main"

echo $Repo | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install docker-engine
```

## How to build
```
sudo ./build.sh
```

## How to run
```
sudo ./run.sh
```
To fix X display issue, you need to copy the .Xauthority from your home directory into container's root directory.e.g.  
`cp /home/user/.Xauthority /.Xauthority`  
But eventually this should be solved in the docker image.

## How to create another terminal
`sudo docker ps` to find out the CONTAINER ID
`sudo docker exec -it CONTAINER_ID /bin/bash` to connet to the running container

## Testing the Autoware
1. Download the data from following sites and place in “~/autoware-data”  
  A script for generating a demo launch file:  
  http://db3.ertl.jp/autoware/sample_data/my_launch.sh  
  Map/calibration/path data (Moriyama area):  
  http://db3.ertl.jp/autoware/sample_data/sample_moriyama_data.tar.gz  
  rosbag data:  
  http://db3.ertl.jp/autoware/sample_data/sample_moriyama_150324.tar.gz  

1. Unpack the demo data as follows.  
`cd autoware-data`  
`tar xfz sample_moriyama_data.tar.gz`  
`tar xfz sample_moriyama_150324.tar.gz`  
1. Generate launch files
`~my_launch.sh`
The following set of launch files should have been generated.
my_launch/
my_map.launch      # Load PointClouds and vector maps  
my_sensing.launch  # Load device drivers  
my_localization.launch   # Localozation  
my_detection.launch   # Object detection  
my_mission_planning.launch  # Path planning  
my_motion_planning.launch   # Path following  
1. Build the Autoware
`cd Autoware/ros`
`./catkin_make_release`
1. Run the Autoware
`cd Autoware/ros`
`./run`

**Note** After launching the run_time manager, you could choose to run the Rviz and load the setting from your host machine instead of running it inside the container, which doesn't work well on my machine.
