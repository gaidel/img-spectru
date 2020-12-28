#! /usr/bin/env bash
set -e # Exit immidiately on non-zero result
# TODO: составить скрипт из комбинации +prepare-ros и cmake-ros
echo "> Collecting ROS noetic"
echo "$0 > Collecting ROS noetic: `date`" >> /home/pi/logsborki.txt

# скрипт сборки ROS для гиперспектрометра
# по следум ручной сборки, под пользователем pi
# по статье https://varhowto.com/install-ros-noetic-raspberry-pi-4/
# установка пакетов ROS Noetic на RPI4: ros_comm + mavros + mavros_extras
# ??? а может ставить только mavros+mavros_extras? пусть зависимости сам тянет?...
#
# а вот тут описано как поставить DEB пакетом - но на arm64:
# https://zen.yandex.ru/media/id/5defebe43d008800b109142c/podgotovka-raspberry-pi-3-k-rabote-s-ros-noetic-5f9ab5604f93a25b1464438f

# Без этой хрени - не соберётся mavlink:
apt install --no-install-recommends -y python-future 
# задоно поставим picamera и pip
apt install --no-install-recommends -y python3-pip python3-picamera

# засос и сборка из исходников:
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu buster main" > /etc/apt/sources.list.d/ros-noetic.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt update
apt install -y python-rosdep python-rosinstall-generator python-wstool python-catkin-pkg python-rosdistro python-rospkg python-rosdep-modules  

echo "> rosdep init"
rosdep init
# TODO: Здесь надо добавить свои пакеты в источники
# echo "yaml file:///etc/ros/rosdep/${ROS_DISTRO}-rosdep-clover.yaml" >> /etc/ros/rosdep/sources.list.d/20-default.list
echo "> rosdep update"
rosdep update
sudo -u pi rosdep update
echo "> mkdir /home/pi/ros_catkin_ws & cd"
mkdir /home/pi/ros_catkin_ws
cd /home/pi/ros_catkin_ws
echo "> rosinstall_generator..."
rosinstall_generator ros_comm mavros mavros_extras image_common vision_opencv --rosdistro noetic --deps --wet-only --tar > noetic-ros_comm-wet.rosinstall
echo "> wstool init..."
wstool init src noetic-ros_comm-wet.rosinstall
echo "> rosdep install..."
rosdep install -y --from-paths src --ignore-src --rosdistro noetic -r --os=debian:buster

echo "ROS noetic prepared OK!"
echo "$0 > ROS noetic prepared OK!: `date`" >> /home/pi/logsborki.txt

cd src
git clone https://github.com/GT-RAIL/async_web_server_cpp
git clone https://github.com/RobotWebTools/web_video_server
cd ..
echo "ROS web_video_server cloned OK!"
echo "$0 > ROS web_video_server cloned!: `date`" >> /home/pi/logsborki.txt

# здесь я пропустил увеличение swap файла. Будет ли без этого работать? Или это сделать где-то раньше?
# руками ставил 1024 Мб
# sudo dphys-swapfile swapoff
# sudoedit /etc/dphys-swapfile
# sudo dphys-swapfile setup
# sudo dphys-swapfile swapon

echo "> Catkin make  ROS noetic"
echo "$0 > Catkin make  ROS noetic: `date`" >> /home/pi/logsborki.txt

cd /home/pi/ros_catkin_ws

echo "> catkin_make_isolated"
# компиляция исходников:
export ROS_PYTHON_VERSION=3
src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/noetic -j4 -DPYTHON_EXECUTABLE=/usr/bin/python3 -DROS_PYTHON_VERSION=3

echo "> install_geographiclib_datasets"
echo "$0 > install_geographiclib_datasets: `date`" >> /home/pi/logsborki.txt
# поставить install_geographiclib_datasets.sh - для запуска mavros требуется 
cd /home/pi/ros_catkin_ws/src/mavros/mavros/scripts/
./install_geographiclib_datasets.sh

# - это добавить и в .bashrc
source /opt/ros/noetic/setup.bash 

echo "> Setup ROS environment"
cat << EOF >> /home/pi/.bashrc
LANG='C.UTF-8'
LC_ALL='C.UTF-8'
ROS_DISTRO='noetic'
export ROS_HOSTNAME=\`hostname\`.local
source /opt/ros/noetic/setup.bash
# source /home/pi/hspr_ws/devel/setup.bash # - это потом раскомментим
EOF

# enable roscore service
systemctl enable roscore

# ? как потом исходники и всё лишнее удалить? нужны же только исполняемые файлы ????
echo "ROS catkin make OK!"
echo "$0 > ROS catkin make OK!: `date`" >> /home/pi/logsborki.txt
