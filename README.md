# new_pi_desktop

Process to install Raspbian OS desktop version on a new Raspberry Pi.

# Description

This repository contains instructions and bash scripts I use to configure new Raspberry Pi devices with the Raspbian OS desktop software. My process is still manual but its getting better (docker is in my future). I use the Raspberry Pi Image Installer to copy the latest Raspberry Foundation image to a SD card. I enable SSH and set up Wi-Fi on the SD card while its still in my laptop. I strongly recommend creating a **new user** account and delete the **pi** account. 

# Laptop-based Image Copy and SSH Setup

Flash the latest Raspberry Pi image to an SD card,  then update the mounted boot drive

- Download the Raspberry Pi Image Installer at https://www.raspberrypi.org/downloads/

```
cd /Volumes/boot
touch ssh
```
- Edit the wpa supplicant file
```
vi wpa_supplicant.conf
```
- Edit **SSID** and **PASSWORD** for your network
```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
ssid="SSID"
psk="PASSWORD"
key_mgmt=WPA-PSK
}
```
- Unmount the SD card; insert into your Raspberry Pi and boot.  I like to use a monitor and keyboard/mouse combination for the initial setup and then use VNC. 

# Configuring Your Raspberry Pi

* Select country, language, timezone and language
* Enter a password
* Select your wireless network (if applicable)
* Update software 

- Login as **pi** and execute raspi-config to set up the following

  * new password for pi user
  * hostname 
  * character set localization
  * time zone
  * interfaces for camera, SPI and I2C
  
```
sudo raspi-config 
```

- Optional - If the terminal font is too small then you can change it from the command line
```
sudo vi /etc/default/console-setup 
```
- Enter the following, save and exit
```
FONTFACE="Terminus
FONTSIZE="16x32"
```
- Install screen to avoid timout on ssh session
```
sudo apt -y install screen
screen bash
```
## Install git and then clone `newpi` repository
```
sudo apt-get -y install git
git clone https://github.com/parttimehacker/newpi.git

At this point you should clone newpi into the **pi** user home directory. Run the `./start-and-network.sh` bash script to get upgrades and set up file sharing on the network.
```
- Make start-and-network.sh executable and run the script
```
cd newpi
chmod +x *.sh
./start-and-network.sh
```
- NOTE - Raspberry pi buster release has an issue with netatalk. You need to add home to the conf
```
sudo vi /etc/netatalk/afp.conf
```
- Add the following at the bottom
```
[Homes]
  basedir regex = /home
```
- It is a good idea to reboot and test the network

- Optional - test the I2C bus for devices
`sudo i2cdetect -y 1`

## Lets add some security and new user

- Create a **newuser** and password
```
sudo useradd -m newuser -G sudo
sudo passwd newuser
```

- Add a no password required for **newuser** at the bottom
```
sudo visudo
newuser ALL=NOPASSWD: ALL
```
- Save and then add /bin/bash to the **newuser**
```
sudo vi /etc/passwd
/bin/bash
```
- Logout and login as the **newuser**

- Remove the **pi** user and /home/pi:

Login to the **new user** account and delete the **pi** account to improve your security. 

`sudo deluser -remove-home pi`

- Completes the configuration with Python development enviroment and some of my favorite modules

## Set up postgresql data base user

- start DB

`sudo -u postgres psql`

- create a user (a ‘role’ in Postgres terminology) and terminate with semicolon

`CREATE ROLE pi WITH LOGIN PASSWORD ‘password’;`

- create a database:

`CREATE DATABASE diyhas WITH OWNER pi;`

- exit with

`\q`
     
## Install system status service
------------

`git clone https://github.com/parttimehacker/diystatus.git`

- Follow instructions

```
cd diystatus
chmod +x *.sh
./import.script.sh
./setup.systemctl.sh diystatus
```

Licence
-------

MIT

Authors
-------

`newpi` was written by `Dave Wilson <parttimehacker@gmail.com>`_.

