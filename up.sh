#!/bin/bash
for i in 1 2
do
   echo "-----------------------------STARTING-----------------------------"
   sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y
done
