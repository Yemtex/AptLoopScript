#!/bin/bash

VERSION="1.0.11"

SCRIPT_URL="https://raw.githubusercontent.com/Yemtex/AptLoopScript/master/up.sh"

SCRIPT_FULLPATH=$(readlink -f "$0")

NEWSCRIPT="/tmp/newup.sh"
ARGS="$SCRIPT_FULLPATH"

FIRST_ARG="$1"


display_center()
{
        RED='\e[1;31m'
        GREEN='\e[1;32m'
        YELLOW='\e[1;33m'
        BLUE='\e[1;34m'
        MAGENTA='\e[1;35m'
        CYAN='\e[1;36m'
        END='\e[0m'

        COLUMNS=$(tput cols)
        printf "$RED%*s\n$END" $(((${#1}+$COLUMNS)/2)) "$1"
}


self_update()
{
        if [ ! -f "$NEWSCRIPT" ]
        then
                wget -O "$NEWSCRIPT" "$SCRIPT_URL"

                # checking for difference in both scripts
                DIFF=$(diff "$SCRIPT_FULLPATH" "$NEWSCRIPT")

                if [ ! -z "$DIFF" ]
                then
                        # running the new version
                        sh "$NEWSCRIPT" "$ARGS"

                        # now exit this old instance
                        exit 1
                else
                        # deleting the downloaded script (which is the same)
                        if [ $(id -u) -ne 0 ]
                        then
                                sudo rm -rf "$NEWSCRIPT"
                        else
                                rm -rf "$NEWSCRIPT"
                        fi

                        display_center "********************************************************************"
                        display_center "NO NEW VERSION FOUND, ALREADY THE LATEST VERSION."
                        display_center "********************************************************************"

                        main
                fi
        else
                if [ ! -z "$FIRST_ARG" ]
                then
                        display_center "********************************************************************"
                        display_center "FOUND A NEW VERSION, UPDATING MYSELF..."
                        display_center "********************************************************************"

                        if [ $(id -u) -ne 0 ]
                        then
                                sudo mv -f "$NEWSCRIPT" "$FIRST_ARG"
                        else
                                mv -f "$NEWSCRIPT" "$FIRST_ARG"
                        fi

                        main
                else
                        display_center "********************************************************************"
                        display_center "THE SCRIPT WAS NOT EXECUTED CORRECTLY"
                        display_center "Maybe Newup.sh executes itself and does not have the passed parameter"
                        display_center "********************************************************************"
                fi
        fi
}

my_reboot()
{
        if [ $(id -u) -ne 0 ]
        then
                sudo reboot || sudo systemctl reboot || sudo shutdown -r now
        else
                reboot || systemctl reboot || shutdown -r now
                
        fi

        sleep 5
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

                if [ $(id -u) -ne 0 ]
                then
                        sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y
                else
                        apt update && apt upgrade -y && apt full-upgrade -y && apt autoremove -y
                fi
        done

        display_center "********************************************************************"
        display_center "REBOOT"
        display_center "********************************************************************"

        while true; do
                read -p "Do you wish to reboot your pc [Y/N]?" yn
                case $yn in
                        [Yy]* ) my_reboot;;
                        [Nn]* ) exit;;
                        * ) echo "Please answer yes or no.";;
                esac
        done
}

self_update