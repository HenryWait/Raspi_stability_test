#!/bin/bash
# This script is for testing stability after overclock and cooling capability on Raspberry Pi(es).
# stress is a required program for this script to work so please install with: sudo apt-get install stress

# clear the screen.
clear

# print ascii art header.
echo "$(tput setaf 2)
   .~~.   .~~.
  '. \ ' ' / .'$(tput setaf 1)
   .~ .~~~..~.
  : .~.'~'.~. :
 ~ (   ) (   ) ~
( : '~'.~.'~' : )
 ~ .~ (   ) ~. ~
  (  : '~' :  ) $(tput sgr0) Stability Test$(tput setaf 1)
   '~ .~~~. ~'
       '~'
$(tput sgr0)" 
 

# Show CPU frequency and temperature function:
temp_freq () {
    local FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq) # measure current CPU frequency on raspberry pi.
    local TEMP=$(vcgencmd measure_temp | tail -c 7) # Measure current temperature on raspberry pi.
    echo "The CPU frequency is $(($FREQ / 1000))mhz"
    echo "The CPU temperature is $TEMP"
}


# Determine model of pi this script is running on function:
pi_model () {
    # Determine how many cores this system has, pi 1 and zero have 1 core, pi 2 and 3 have 4.
    local CORES=$(nproc)
    if [ $CORES == 4 ]
    then
        echo "Running stress test for Raspberry Pi 2 or 3"
    else
        echo "Running stress test for Raspberry Pi 1 or ZERO"
    fi
}

# GLXGears test function:
glx_gears () {
    # glxgears to put load on GPU too
    glxgears > /home/$USER/Desktop/glxgears.log & sleep $TIME ; kill $!
}

# stress test function:
stress_test () {
    local TIME=250 # how long the stress test runs for
    local CORES=$(nproc) # determine how many cores this system has
    # stress test, should make pi reach max temp if ran long enough:
    echo "Running stress and GLXgears for $TIME seconds"
    stress --cpu $CORES --timeout $TIME > /home/$USER/Desktop/stress.log &
    glx_gears
}

PS3='Please enter your choice: '
options=("Stress Test" "Show temperature" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Stress Test")
            # print pi model 
            pi_model 
            # print CPU frequency and temperature before running at full load:
            temp_freq
            # run the stress test
            stress_test
            # print CPU frequency and temperature after running at full load:
            temp_freq
            ;;
        "Show temperature")
            # print CPU frequency and temperature
            temp_freq
            ;;
        "Quit")
            # quit the program
            break
            ;;
        *) echo invalid option;;
    esac
done
