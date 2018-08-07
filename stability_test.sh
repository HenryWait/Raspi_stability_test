#!/bin/bash
# A simple stabilty test for the Raspberry Pi
# also shows CPU temperature

# clear the screen
clear
# print ascii art header
echo "$(tput setaf 2)
   .~~.   .~~.
  '. \ ' ' / .'$(tput setaf 1)
   .~ .~~~..~.
  : .~.'~'.~. :
 ~ (   ) (   ) ~
( : '~'.~.'~' : )
 ~ .~ (   ) ~. ~
  (  : '~' :  ) $(tput sgr0) Stability Test $(tput setaf 1)
   '~ .~~~. ~'
       '~'
$(tput sgr0)" 
 

# show CPU frequency and temperature function:
temp_freq () {
    local FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq) # measure current CPU frequency on raspberry pi
    local TEMP=$(vcgencmd measure_temp | tail -c 7) # measure current temperature on raspberry pi
    echo "The CPU frequency is $(($FREQ / 1000))mhz"
    echo "The CPU temperature is $TEMP"
}

# stress test function:
stress_test () {
    local TIME=250 # how long the stress test runs for
    local CORES=$(nproc) # determine Raspberry Pi model
    # show CPU frequency and temperature before running at full load:
    temp_freq
    # stress test, should make pi reach max temp if ran long enough:
    echo "Running stress and GLXgears for $TIME seconds"
    if [ $CORES == 4 ]
    then
        echo "Running stress test for Raspberry Pi 2 or 3"
    else
        echo "Running stress test for Raspberry Pi 1 or Zero"
    fi
    stress --cpu $CORES --timeout $TIME > /dev/null &
    # glxgears to put load on GPU too
    glxgears > /dev/null & sleep $TIME ; kill $!
    # show CPU frequency and temperature after running at full load:
    temp_freq
}

PS3='Please enter your choice: '
options=("Stress Test" "Show temperature" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Stress Test")
            # run the stress test
            stress_test
            ;;
        "Show temperature")
            # show CPU frequency and temperature
            temp_freq
            ;;
        "Quit")
            # quit the program
            break
            ;;
        *) echo invalid option;;
    esac
done
