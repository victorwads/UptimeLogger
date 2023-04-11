#!/bin/bash

# Define o comando para obter o tempo de inicialização no Ubuntu
INSTALL_FOLDER="/opt/$PROGRAM_NAME"
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
    SERVICE_UNIT=$(
        cat <<EOF
[Unit]
Description=$PROGRAM_NAME
After=network.target

[Service]
User=root
Type=simple
ExecStart=/bin/bash $INSTALL_FOLDER/uptime_logger
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF
    )

    # Installing
    echo "Installer service at $SERVICE_FILE using sudo"
    echo "$SERVICE_UNIT" | sudo tee "$SERVICE_FILE" >/dev/null

    echo "Starting service"
    sudo systemctl daemon-reload
    sudo systemctl enable "$SERVICE_NAME"
    sudo systemctl start "$SERVICE_NAME"
}
