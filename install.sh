#!/bin/bash
PROGRAM_NAME="UptimeLogger"
SERVICE_NAME="br.com.victorwads.uptimelogger"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Define o comando para obter o tempo de inicialização no macOS
    INSTALL_FOLDER="/Library/$PROGRAM_NAME"
    SERVICE_FILE="/Library/LaunchDaemons/$SERVICE_NAME.plist"
else
    # Define o comando para obter o tempo de inicialização no Linux
    echo "Service install support Only MacOs now, seek for future version or contribute yourself in:"
    echo "https://github.com/victorwads/UptimeLogger"
    exit 1
fi

# Check for restart option
if [[ "$*" == *"--restart"* || "$*" == *"--reload"* ]]; then
    echo "Restarting services using sudo"
    sudo launchctl unload "$SERVICE_FILE"
    sudo launchctl load "$SERVICE_FILE"
    exit 0
fi

# Check for restart option
if [[ "$*" == *"--uninstall"* || "$*" == *"--reinstall"* ]]; then
    echo "Stoping services using sudo"
    sudo launchctl unload "$SERVICE_FILE"
    sudo rm "$SERVICE_FILE"

    echo "Removing files using sudo"
    sudo rm -r "$INSTALL_FOLDER"
    if [[ "$*" == *"--uninstall"* ]]; then
        exit 0
    fi
fi

SERVICE_PLIST=$(
    cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   <key>Label</key>
   <string>$SERVICE_NAME</string>
   <key>ProgramArguments</key>
   <array>
      <string>/bin/bash</string>
      <string>$INSTALL_FOLDER/uptime_logger.sh</string>
   </array>
   <key>KeepAlive</key>
   <true/>
</dict>
</plist>
EOF
)

# Installing
echo "Copying files to $INSTALL_FOLDER using sudo"
if [[ ! -d "$INSTALL_FOLDER" ]]; then
    sudo mkdir "$INSTALL_FOLDER"
fi
sudo cp ./uptime_logger.sh "$INSTALL_FOLDER"
sudo cp ./watch.sh "$INSTALL_FOLDER"

echo "Installer service at $SERVICE_FILE using sudo"
echo "$SERVICE_PLIST" | sudo tee "$SERVICE_FILE" >/dev/null

echo "Starting service"
sudo launchctl load "$SERVICE_FILE"
