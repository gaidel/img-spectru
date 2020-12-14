#! /usr/bin/env bash
set -e # Exit immidiately on non-zero result

echo "> Installing ROS noetic"

sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt-get update
apt install ros-noetic-ros-base ros-noetic-mavros ros-noetic-mavros-extras ros-noetic-rosbash
echo "source /opt/ros/noetic/setup.bash" >> /home/pi/.bashrc
source /home/pi/.bashrc

# поставить install_geographiclib_datasets.sh - для запуска mavros требуется 
curl https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh > /home/pi/install_geographiclib_datasets.sh
chmod +x /home/pi/install_geographiclib_datasets.sh
./home/pi/install_geographiclib_datasets.sh
rm /home/pi/install_geographiclib_datasets.sh

echo "ROS installed OK!"