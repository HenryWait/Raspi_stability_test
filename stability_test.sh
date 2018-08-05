#!/bin/bash
# A simple stabilty test for the Raspberry Pi
# also shows CPU temperature

# clear the screen
clear

#show CPU frequency and temperature function:
temp_freq () {
    cat /sys/devices/system/system/cpu/cpu0/cpufreq/scaling_cur_freq
    vcgencmd measure_temp
}

#show CPU frequency and temperature before running at full load:
temp_freq

#sysbench test
sysbench --test=cpu --cpu-max-prime=50000 --num-threads=4 run >/dev/null 2>&1

#show CPU frequency and temperature after running at full load:
temp_freq
