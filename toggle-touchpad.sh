#!/bin/bash

if [ "$(gsettings get org.gnome.desktop.peripherals.touchpad send-events)" = "'enabled'" ];then
	gsettings set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
	notify-send -i touchpad-disabled-symbolic "Touchpad" "Disabled"
else
	gsettings set org.gnome.desktop.peripherals.touchpad send-events 'enabled'
	notify-send -i input-touchpad-symbolic "Touchpad" "Enabled"
fi
