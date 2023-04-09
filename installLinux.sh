#!/bin/bash

# Define o comando para obter o tempo de inicialização no Debian
INSTALL_FOLDER="/usr/local/$PROGRAM_NAME"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

function restartService() {
    echo "Restarting services using sudo"
    sudo systemctl daemon-reload
    sudo systemctl restart "$SERVICE_NAME"
    echo ""
}

function removeService() {
    echo "Stoping services using sudo"
    sudo systemctl stop "$SERVICE_NAME"
    sudo systemctl disable "$SERVICE_NAME"
    sudo rm "$SERVICE_FILE"
    echo ""
}

function installService() {
    SERVICE_FILE_CONTENT=$(
        cat <<EOF
[Unit]
Description=$PROGRAM_NAME
After=network.target

[Service]
ExecStart=/bin/bash $INSTALL_FOLDER/uptime_logger.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
    )

    echo "Installer service at $SERVICE_FILE using sudo"
    echo "$SERVICE_FILE_CONTENT" | sudo tee "$SERVICE_FILE" >/dev/null

    echo "Starting service"
    sudo systemctl daemon-reload
    sudo systemctl enable "$SERVICE_NAME"
    sudo systemctl start "$SERVICE_NAME"
}
