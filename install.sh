#!/bin/bash
export PROGRAM_NAME="UptimeLogger"
export SERVICE_NAME="br.com.victorwads.uptimelogger"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v lsb_release >/dev/null; then
        os_name=$(lsb_release -si)
    elif [[ -f /etc/os-release ]]; then
        os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    fi

    case "$os_name" in
    "Ubuntu")
        # Define o comando para obter o tempo de inicialização no Ubuntu
        source installUbuntu.sh
        ;;
    *)
        # Define o comando para obter o tempo de inicialização no linux Generico
        source installLinux.sh
        ;;
    esac
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Define o comando para obter o tempo de inicialização no macOS
    source installDarwin.sh
else
    # Define o comando para obter o tempo de inicialização no Linux
    echo "Service install support Only MacOs and Ubuntu now, seek for future version or contribute yourself in:"
    echo "https://github.com/victorwads/UptimeLogger"
    exit 1
fi

# Check for restart option
if [[ "$*" == *"--restart"* || "$*" == *"--reload"* ]]; then
    restartService
    exit 0
fi

# Check for restart option
if [[ "$*" == *"--uninstall"* ]]; then
    removeService

    read -p "Deseja apagar todos os logs registrados? (y/N) " choice
    case "$choice" in
    y | Y)
        echo "Removing program files and logs using sudo"
        sudo rm -rf "$INSTALL_FOLDER"
        ;;
    *)
        echo "Removing program files using sudo"
        sudo rm -f "$INSTALL_FOLDER/watch.sh"
        sudo rm -f "$INSTALL_FOLDER/uptime_logger.sh"
        sudo rm -f "$INSTALL_FOLDER/log_latest.txt"
        ;;
    esac
    echo ""

    exit 0
fi

# Check for restart option
if [[ "$*" == *"--reinstall"* ]]; then
    removeService

    echo "Removing old program files using sudo"
    sudo rm -f "$INSTALL_FOLDER/watch.sh"
    sudo rm -f "$INSTALL_FOLDER/uptime_logger.sh"
    sudo rm -f "$INSTALL_FOLDER/log_latest.txt"
    echo ""

    if [[ "$*" == *"--uninstall"* ]]; then
        exit 0
    fi
fi

# Install Files
echo "Copying files to $INSTALL_FOLDER using sudo"
if [[ ! -d "$INSTALL_FOLDER" ]]; then
    sudo mkdir "$INSTALL_FOLDER"
fi
sudo cp ./uptime_logger.sh "$INSTALL_FOLDER"
sudo cp ./watch.sh "$INSTALL_FOLDER"

installService
