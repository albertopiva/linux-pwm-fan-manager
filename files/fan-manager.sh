#!/bin/bash
source config.cfg;

actual=0

set0(){
    if [ "$actual" -ne 0 ]; then
        echo 0 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        actual=0
        sleep 2
    fi
}

set25(){
    if [ "$actual" -ne 25 ]; then
        echo 10000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        actual=25
        sleep 2
    fi
}

set50(){
    if [ "$actual" -ne 50 ]; then
        echo 20000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        actual=50
        sleep 2
    fi
}

set75(){
    if [ "$actual" -ne 75 ]; then
        echo 30000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        actual=75
        sleep 2
    fi
}

set100(){
    if [ "$actual" -ne 100 ]; then
        echo 40000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        actual=100
        sleep 2
    fi
}


read_temp() {
    getCPUtemp=$(cat /sys/class/thermal/thermal_zone0/temp)
    #getGPUtemp=$(cat /sys/class/thermal/thermal_zone1/temp)

    cpu_temp=$((getCPUtemp / 1000))
    
    echo $cpu_temp
    
    # if [ "$cpu_temp" -lt "$gpu_temp" ]; then
    #     echo $gpu_temp
    # else
    #     echo $cpu_temp
    # fi
}

monitor_temp() {
    while true; do
        temp=$(read_temp)
        echo "Current temperature: $temp °C"
        if [ "$temp" -ge "$level3" ]; then
            set100
        elif [ "$temp" -ge "$level2" ]; then
            set75
        elif [ "$temp" -ge "$level1" ]; then
            set50
        elif [ "$temp" -ge "$level0" ]; then
            set25
        else
            set0
        fi
        sleep 5
    done
}


start(){
    echo "Starting fan manager..."
    
    # check if pwm0 exists and create it if not
    if [ ! -d /sys/class/pwm/pwmchip0/pwm0 ]; then
        echo "pwm0 not found"
        echo 0 > /sys/class/pwm/pwmchip0/export
        sleep 0.2
    fi
    # set pwm0 period
    echo 40000 > /sys/class/pwm/pwmchip0/pwm0/period
    sleep 0.2
    # set pwm0 duty cycle to obtain 25% speed
    actual=1
    set0
    # set pwm0 polarity
    echo normal >  /sys/class/pwm/pwmchip0/pwm0/polarity
    sleep 0.2
    # enable pwm0
    echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
    
    # start monitoring temperature
    monitor_temp
}

start
