#/usr/bin/bash
#
# Script: basic_and_network.sh
# Author: parttimehacker 
# Date:   January 2021 
# 
# Purpose:fresh install script for Raspberry Pi step 1 of 3 
# 
# Notes: get the latest packages and set up file sharing
# 
#!/bin/bash

echo "Welcome to DIY Installation Script for Raspbian OS"
echo "This script was modified from a script by LearnOpenCV.com"
echo "================================"
# Step 1: Update packages
echo "Updating raspbian packages\n"
sudo apt -y update
sudo apt-get -y update
sudo apt-get -y upgrade 
sudo apt-get -y dist-upgrade
echo
echo "================================"
echo "Apt updates and upgrade complete"
echo "================================"
echo
sudo sync

# Step 2: Apple development host file stuff
echo "Install Mac file sharing\n"
sudo apt-get -y install avahi-daemon
sudo systemctl enable avahi-daemon.service
sudo apt-get -y install netatalk
echo
echo "================================"
echo "avahi and netatalk installation complete"
echo "================================"
echo
sudo sync

# Step 3: Python stuff
echo "Install Python packages"
sudo apt-get -y install python-pip
sudo apt-get -y install build-essential python-dev python-smbus
sudo apt-get -y install i2c-tools
sudo apt-get -y install python3-dev python3-pip python3-venv
sudo -H pip3 install -U pip numpy
sudo apt-get -y install python3-testresources
sudo pip3 install pylint
sudo pip3 install paho-mqtt
sudo pip3 install psutil
sudo apt-get -y install python3-gpiozero
sudo apt-get -y install python-imaging python-pil
sudo python -m pip install --upgrade pip setuptools wheel
sudo apt-get -y install libfreetype6-dev libjpeg-dev libopenjp2-7-dev
sudo apt-get -y install python3-rpi.gpio
sudo pip3 install Pillow
echo
echo "================================"
echo "Python package installation complete"
echo "================================"
echo
sudo sync

# Step 4: Install firewall installation
echo "Install firewall"
sudo apt-get -y install ufw
sudo ufw allow 22
sudo ufw allow 548
sudo ufw allow 80
sudo ufw allow 5000
sudo ufw allow 5900
sudo ufw enable
sudo ufw status
echo
echo "================================"
echo "Firewall installation complete"
echo "================================"
echo
sudo sync
