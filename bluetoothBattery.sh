#!/bin/bash

# <bitbar.title>Bluetooth Battery Status</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Karl Olson [karl.olson@gmail.com]</bitbar.author>
# <bitbar.author.github>fcrwx</bitbar.author.github>
# <bitbar.desc>Displays battery percentages of all Bluetooth devices</bitbar.desc>
# <bitbar.image></bitbar.image>
# <bitbar.dependencies>bash</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/fcrwx/battery-percent</bitbar.abouturl>

# Line pairing trick taken from:
#  https://stackoverflow.com/questions/1513861/how-do-i-pair-every-two-lines-of-a-text-file-with-bash

percentages=`                          \
ioreg -r -d 1 -k BatteryPercent        \
| egrep '"Product"|"BatteryPercent"'   \
| sed 's/.*= //'                       \
| sed 's/"//'                          \
| sed 's/"/:/'                         \
| sed '$!N;s/\n/ /'                    \
`

warning=false
warningThreshold=20

###
### Output each percentage, and check for any low batteries
###

output="/"
while read -r line; do
	percentage=${line##* }
	if [[ $percentage < $warningThreshold ]];
	then
		warning=true
	fi;
	output+="$percentage/"
done <<< "$percentages"

if $warning;
then
	echo "$output| color=red"
else
	echo "$output| color=green"
fi;

###
### Pull-down area
###

echo "---"

prefPane="open /System/Library/PreferencePanes/Bluetooth.prefPane"
openTerminal="true"

while read -r line; do
        percentage=${line##* }
        if [[ $percentage < $warningThreshold ]];
        then
                echo "$line | color=red terminal=$openTerminal bash=\"$prefPane\""
	else
                echo "$line | color=green terminal=$openTerminal bash=\"$prefPane"
        fi;
done <<< "$percentages"

