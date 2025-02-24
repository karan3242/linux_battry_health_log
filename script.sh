#!/bin/bash

now=$(cat /sys/class/power_supply/BAT0/energy_full)
full=$(cat /sys/class/power_supply/BAT0/energy_full_design)
bat=$(cat /sys/class/power_supply/BAT0/capacity)

div(){
	echo "scale=3; ($now / $full) * 100" | bc
}

truecap(){
	echo "scale=3; ($bat * $(div)) / 100" | bc
}

day=$(date "+%D")
time=$(date "+%T")

echo "$day,$time,$(div),$(truecap),$bat" >> ~/opt/bat_helth_log/log.csv
