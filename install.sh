#!/bin/bash
prefix="${XDG_DATA_HOME:-$HOME/.local/share}"
krunner_dbusdir="$prefix/krunner/dbusplugins"
services_dir="$prefix/dbus-1/services/"

mkdir -p $krunner_dbusdir
mkdir -p $services_dir

cp ScriptRunner.desktop $krunner_dbusdir
printf "[D-BUS Service]\nName=org.kde.ScriptRunner\nExec=\"$PWD/main.py\"" > $services_dir/org.kde.ScriptRunner.service

kquitapp6 krunner 2>&1 | grep -v "Message recipient disconnected from message bus without replying"

if [[ ! -e ~/.config/scriptRunner/config.sh ]]; then
    mkdir ~/.config/scriptRunner
    (
        echo "export TICKET_URL=\"https://duckduckgo.com/?q=\""
        echo "export BROWSER=\"vivaldi\""
        echo "export SEARCH_ENGINE=\"https://duckduckgo.com/?q=\""
    ) > ~/.config/scriptRunner/config.sh
fi
