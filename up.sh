#!/bin/bash
for i in 1 2 3 4 5
do
   echo "-----------------------------STARTING-----------------------------"
   sudo apt update & sudo apt upgrade -y & sudo apt full-upgrade -y & sudo autoremove -y
done
