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
  (  : '~' :  ) $(tput sgr0) Stability Test$(tput setaf 1)
   '~ .~~~. ~'
       '~'
$(tput sgr0)" 

#show CPU frequency and temperature function:
temp_freq () {
    cat /sys/devices/system/system/cpu/cpu0/cpufreq/scaling_cur_freq
    vcgencmd measure_temp
}

stress_test () {
    #set variable to number of cores the system has
    local CORES=nproc
    #sysbench test, runs pi at full tilt for long enough to reach max temp
    sysbench --test=cpu --cpu-max-prime=50000 --num-threads=$CORES run >/dev/null 2>&1
}

# Menu 
PS3='Please enter your choice: '
options=("Stress Test" "Show temperature" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Stress Test")
            echo "Running sysbench"
            #show CPU frequency and temperature before running at full load:
            temp_freq
            stress_test
            #show CPU frequency and temperature after running at full load:
            temp_freq
            ;;
        "Show temperature")
            echo ""
            #show CPU frequency and temperature
            temp_freq
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
