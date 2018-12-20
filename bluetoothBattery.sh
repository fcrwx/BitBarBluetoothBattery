#!/bin/bash

# <bitbar.title>Bluetooth Battery Status</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Karl Olson [karl.olson@gmail.com]</bitbar.author>
# <bitbar.author.github>fcrwx</bitbar.author.github>
# <bitbar.desc>Displays battery percentages of all Bluetooth devices</bitbar.desc>
# <bitbar.image></bitbar.image>
# <bitbar.dependencies>bash</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/fcrwx/BitBarBluetoothBattery/blob/master/README.md</bitbar.abouturl>

# Line pairing trick taken from:
#  https://stackoverflow.com/questions/1513861/how-do-i-pair-every-two-lines-of-a-text-file-with-bash

###
### Customization
###

warningThreshold=20
okayColor="green"
warnColor="red"

###
### Get battery percentages for all bluetooth devices
###

percentages=`                          \
ioreg -r -d 1 -k BatteryPercent        \
| egrep '"Product"|"BatteryPercent"'   \
| sed 's/.*= //'                       \
| sed 's/"//'                          \
| sed 's/"/:/'                         \
| sed '$!N;s/\n/ /'                    \
`

warning=false

###
### Output each percentage, and check for any low batteries
###

output="/"
while read -r line; do
	percentage=${line##* }
	if [ "$percentage" != "" ]
	then
		if [ $percentage -lt $warningThreshold ]
		then
			warning=true
		fi
		output+="$percentage/"
	fi
done <<< "$percentages"

if $warning
then
	echo "$output| color=$warnColor"
else
	echo "$output| color=$okayColor"
fi

###
### Pull-down area
###

echo "---"

command="terminal=true bash=open param1=/System/Library/PreferencePanes/Bluetooth.prefPane"

while read -r line; do
        percentage=${line##* }
	if [ "$percentage" != "" ]
	then
		if [ $percentage -lt $warningThreshold ]
	        then
			echo "$line% | color=$warnColor $command"
		else
			echo "$line% | color=$okayColor $command"
		fi
	fi
done <<< "$percentages"

