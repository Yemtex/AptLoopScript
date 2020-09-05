#!/bin/bash

VERSION="0.0.2"

SCRIPT_URL="https://raw.githubusercontent.com/Yemtex/AptLoopScript/master/up.sh"

SCRIPT_FULLPATH="$0"
SCRIPT_DIRECTORY=$(dirname "$SCRIPT_FULLPATH")

NEWSCRIPT="/tmp/newup.sh"
ARGS="$SCRIPT_FULLPATH"

FIRST_ARG="$1"


display_center()
{
    # red=$'\e[1;31m'
    # grn=$'\e[1;32m'
    # yel=$'\e[1;33m'
    # blu=$'\e[1;34m'
    # mag=$'\e[1;35m'
    # cyn=$'\e[1;36m'
    # end=$'\e[0m'

    COLUMNS=$(tput cols)
    printf "\e[1;31m""%*s\n""\e[0m" $(((${#1}+$COLUMNS)/2)) "$1"
}


self_update()
{
    if [ ! -f "$NEWSCRIPT" ]
    then
        wget -O "$NEWSCRIPT" "$SCRIPT_URL"

        # checking for difference in both scripts
        DIFF=$(diff "$SCRIPT_FULLPATH" "$NEWSCRIPT")

        if [ "$DIFF" != "" ]
        then
            echo "Running the new version..."
            #sh up.sh
            bash "$NEWSCRIPT" "$ARGS"

            # now exit this old instance
            exit 1
        else
            echo "Running version $VERSION, already the latest version."

            main
        fi
    else
        echo "Found a new version $VERSION, updating myself..."
		# mv -f "$NEWSCRIPT" "$FIRST_ARG"

        main
    fi
            
}


main()
{
    display_center "********************************************************************"
    display_center "RUNNING $VERSION"
    display_center "********************************************************************"


	for i in 1 2
	do
		display_center "********************************************************************"
        display_center "STARTING"
        display_center "********************************************************************"
		sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y
	done


	display_center "********************************************************************"
    display_center "REBOOT"
    display_center "********************************************************************"

	while true; do
		read -p "Do you wish to reboot your pc [Y/N]?" yn
		case $yn in
			[Yy]* ) sudo reboot || sudo systemctl reboot || sudo shutdown -r now; sleep 5;;
			[Nn]* ) exit;;
			* ) echo "Please answer yes or no.";;
		esac
	done
}

self_update
