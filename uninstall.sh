#!/bin/bash
# set -e

prefix="${XDG_DATA_HOME:-$HOME/.local/share}"
krunner_dbusdir="$prefix/krunner/dbusplugins"

rm $prefix/dbus-1/services/org.kde.ScriptRunner.service
rm $krunner_dbusdir/ScriptRunner.desktop

kquitapp6 krunner 2>&1 | grep -v "Message recipient disconnected from message bus without replying"
