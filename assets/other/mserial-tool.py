#!/usr/bin/env python

import serial
port = serial.Serial("/dev/ttyAMA0", baudrate=57600, timeout=3.0)
port.readall()
