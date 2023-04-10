# UptimeLogger

Started this project to log my MacOs restarting from nothing a lot of times.
some time it can keep like 5min uptime, some times 15min.

I started this script to help create a report of how much times restarts and for how long the system could keep up.

## Runing 

just run:
```bash
cd Scrtpits

# To Log
bash uptime_logger.sh

# To Log and Debbug [-d | --debug]
bash uptime_logger.sh --debug
```

## Install as Service

The `install.sh` provides a easy to intall service. This will install de files copying to a program folder according to the OS and create service to run on System Load.

Every 1 system startUp it will create a file at `/PROGRAM_FOLDER/logs` and that file will be updated every second with de how long the SO have been alive.

`For now, it was only tested on MacOs.`

```bash
cd Scrtpits

# To Install
./install.sh

# To Reinstall / Update
./install.sh --reinstall
# To Uninstall
./install.sh --uninstall
# To Just Restart Services [--restart | --reload]
./install.sh --restart
```
