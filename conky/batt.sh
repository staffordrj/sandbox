#!/bin/sh
power=$(cat /sys/class/power_supply/BAT*/power_now | paste -sd+ | bc)
energy=$(cat /sys/class/power_supply/BAT*/energy_now | paste -sd+ | bc)
full=$(cat /sys/class/power_supply/BAT*/energy_full | paste -sd+ | bc)
designfull=$(cat /sys/class/power_supply/BAT*/energy_full_design | paste -sd+ | bc)
AC=$(cat /sys/class/power_supply/AC/online)
percentage=$(echo "x=$energy/$full*100; scale=0; x/1" | bc -l)
life=$(echo "x=$full/$designfull*100; scale=0; x/1" | bc -l)
if [ $AC == 1 ]
then
  time=$(echo "($full-$energy)/$power*60*60" | bc -l)
  icons=(         )
else 
  time=$(echo "$energy/$power*60*60" | bc -l)
  icons=(          )
fi 
if [ $(echo "$time/1" | bc) -gt 1 ]; then
  time=$(date +%T -d "1970-01-01 + $time seconds")
fi
step=$(echo "x=$percentage/100*(${#icons[@]}-2); scale=0; x/1" | bc -l)
if [ $percentage == 100 ]
then
  step=$(echo "$step + 1" | bc)
  echo ${icons[step]}
else
  echo ${icons[step]} $percentage% $time
fi

#echo ${icons[step]} $percentage $time $life%
