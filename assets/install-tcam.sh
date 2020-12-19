#! /usr/bin/env bash
set -e # Exit immidiately on non-zero result

# Установка tiscamera 
# Инструкция Андрея - https://docs.google.com/document/d/1HajgVsfWfq8AePZro6mBG8YEuiCWmnv7w7mNPNb1Cos/edit
echo "$0 > Start TISCAM install: `date`" >> /home/pi/logsborki.txt
cd /home/pi/
git clone https://github.com/TheImagingSource/tiscamera.git
cd tiscamera
./scripts/install-dependencies.sh --compilation --runtime --yes --no-update
mkdir build
cd build
cmake ..
make -j4
make install
echo "$0 > TISCAM installed OK : `date`"
echo "$0 > TISCAM installed OK : `date`" >> /home/pi/logsborki.txt

# Установка BASLER pypylon
echo "$0 > Start BASLER install: `date`" >> /home/pi/logsborki.txt
#mkdir /home/pi/pylon

cd /home/pi/pylon
#apt-get install -f -y ./pylon_6.1.3.20159-deb0_armhf.deb
curl 'https://github.com/basler/pypylon/releases/download/1.6.0/pypylon-1.6.0-cp37-cp37m-linux_armv7l.whl' -O -L 
pip3 install pypylon-1.6.0-cp37-cp37m-linux_armv7l.whl
echo "$0 > BASLER installed OK : `date`"
echo "$0 > BASLER installed OK : `date`" >> /home/pi/logsborki.txt

# install nginx, nodejs
cd /home/pi/pylon
echo "$0 > Start nginx, nodejs install: `date`" >> /home/pi/logsborki.txt
apt-get install nginx -y
curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install nodejs -y

echo "$0 > nginx, nodejs installed OK : `date`"
echo "$0 > nginx, nodejs OK : `date`" >> /home/pi/logsborki.txt
