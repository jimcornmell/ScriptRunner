### ScriptRunner

This plugin is only supported on Plasma 6, I'm running Kubuntu 24.10.

This plugin is based on the simple template for a KRunner plugin using dbus:
https://github.com/KDE/krunner/tree/master/templates/runner6python

On installation it creates default config, edit ~/.config/scriptRunner/config.sh to set up your own.

The idea is to simply run a shell script `ScriptRunner.sh` with whatever you type as arguments. The shell script or
python program can then do anything you want.

In the included example the `ScriptRunner.sh` tries to match what you typed to a sensible website and then navigate to
it. So for example:

| Description                          | Pattern   | Example                    | Result                                                          |
|--------------------------------------|-----------|----------------------------|-----------------------------------------------------------------|
| Go to colour information             | rrggbb    | ff0000                     | https://www.colorhexa.com/ff0000                                |
| Go to cve information site           | cve*      | CVE-2021-44228             | https://ossindex.sonatype.org/vulnerability/CVE-2021-44228      |
| Go to git repo                       | name/name | jimcornmell/scriptRunner   | https://github.com/jimcornmell/scriptRunner                     |
| Open two man pages                   | command   | grep                       | https://linux.die.net/man/1/grep and https://cheat.sh/grep      |
| Go to ticket (site defined by config)| ABC-123   | ABC-123                    | https://someticketsite/ABC-123                                  |
| Go to url                            | http*     | http://www.google.com      | http://www.google.com                                           |

# Help and suggestions

If you can think of any more useful patterns then please let me know via email to scriptrunner@cornmell.com or use
github: https://github.com/jimcornmell/scriptRunner

This is my first krunner plugin and really just a tool for me.  If it works and is stable I'll add to the KDE store.
For now it's a manual installation.

# Installation

Just run these 4 commands:

```shell
cd ~/.local/share/krunner-sources
git clone git@github.com:jimcornmell/scriptRunner.git
cd scriptRunner
./install.sh
```
