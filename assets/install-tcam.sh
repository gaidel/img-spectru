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
