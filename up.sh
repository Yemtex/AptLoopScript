#!/bin/bash

for i in 1 2
do
  echo "************************************************"
  echo "**                  STARTING                  **"
  echo "************************************************"
  sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y
done

echo
echo "************************************************"
echo "**                  Reboot                    **"
echo "************************************************"

while true; do
    read -p "Do you wish to reboot your pc [Y/N]?" yn
    case $yn in
        [Yy]* ) reboot || systemctl reboot || shutdown -r now;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
