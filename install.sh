#! /bin/bash

set -e
if [ "$#" -ne 1 ]; then
  echo "usage: ./install.sh <path-to-installation>"
  exit
fi

# Install dependencies
workspace_dir=$1

echo "Installing Dependencies"
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get -y update
sudo apt-get install -y g++-4.9
echo "Installing latest qt5"
sudo apt-get install -y qt5-default
sudo apt-get install -y cmake libqt5svg5-dev libprotobuf-dev protobuf-compiler libode-dev screen

mkdir temp_dir && cd temp_dir
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/vartypes/vartypes-0.7.tar.gz
tar xfz vartypes-0.7.tar.gz
cd vartypes-0.7
mkdir build && cd build
cmake ..
make -j8
sudo make install
cd ../../../
rm -rf temp_dir

# Install latest cmake
echo "Installing latest cmake"
mkdir temp_dir && cd temp_dir
wget https://cmake.org/files/v3.8/cmake-3.8.0.tar.gz
tar xf cmake-3.8.0.tar.gz
cd cmake-3.8.0
./configure
make -j8
sudo make install
cd ../../
rm -rf temp_dir

# Call the ros-install script here
echo "Installing ROS"
sudo chmod +x ros_install.sh
bash ros_install.sh

cd $workspace_dir
source "/opt/ros/jade/setup.bash"

if [ ! -d catkin_ws/src ]; then
	mkdir -p catkin_ws/src
fi
cd catkin_ws/src
catkin_init_workspace
cd ..
catkin_make

source "devel/setup.bash"
cd src/

# clone all the repositories
git clone https://github.com/krssg-ssl/robojackets.git
git clone https://github.com/krssg-ssl/plays.git
git clone https://github.com/krssg-ssl/ssl-vision.git
git clone https://github.com/krssg-ssl/kgpkubs_launch.git
git clone https://github.com/krssg-ssl/tactics.git
git clone https://github.com/krssg-ssl/ssl_robot.git
git clone https://github.com/krssg-ssl/ssl_common.git
git clone https://github.com/krssg-ssl/grsim_comm.git
git clone https://github.com/krssg-ssl/grSim.git
git clone https://github.com/krssg-ssl/belief_state.git
git clone https://github.com/krssg-ssl/skills.git
git clone https://github.com/krssg-ssl/vision_comm.git
git clone https://github.com/krssg-ssl/traj_controller.git
git clone https://github.com/krssg-ssl/navigation.git
# git clone https://github.com/krssg-ssl/refBox.git
git clone https://github.com/krssg-ssl/krssg_ssl_msgs.git

cd ..
