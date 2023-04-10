#!/bin/bash

# Define o comando para obter o tempo de inicialização no macOS
INSTALL_FOLDER="/Library/$PROGRAM_NAME"
SERVICE_FILE="/Library/LaunchDaemons/$SERVICE_NAME.plist"

function restartService() {
    echo "Restarting services using sudo"
    sudo launchctl unload "$SERVICE_FILE"
    sudo launchctl load "$SERVICE_FILE"
    echo ""
}

function removeService() {
    echo "Stoping services using sudo"
    sudo launchctl unload "$SERVICE_FILE"
    sudo rm "$SERVICE_FILE"
    echo ""
}

function installService() {
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
      <string>$INSTALL_FOLDER/uptime_logger.sh</string>
   </array>
   <key>KeepAlive</key>
   <true/>
</dict>
</plist>
EOF
    )

    # Installing
    echo "Installer service at $SERVICE_FILE using sudo"
    echo "$SERVICE_PLIST" | sudo tee "$SERVICE_FILE" >/dev/null

    echo "Starting service"
    sudo launchctl load "$SERVICE_FILE"
}
