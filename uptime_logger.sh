#!/bin/bash
DEBUG=false

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOGS_DIR="$SCRIPT_DIR/logs"
LOG_LATEST="$LOGS_DIR/latest"
if [[ ! -d "$LOGS_DIR" ]]; then
    mkdir "$LOGS_DIR"
fi
chmod -R 766 "$LOGS_DIR"
chmod 777 "$LOGS_DIR"

# Allowed Shutdown Features
UPDATE_FILE="$LOGS_DIR/updated"
SHUTDOWN_FILE="$LOGS_DIR/shutdown"

# Allow Shutdown Script
if [[ "$*" == *"-s"* ]] || [[ "$*" == *"--allow-shutdown"* ]]; then
    touch "$SHUTDOWN_FILE"
    chmod 766 "$SHUTDOWN_FILE"
    exit 0
fi
if test -f "$SHUTDOWN_FILE" && test -f "$LOG_LATEST"; then
    echo "shutdown allowed" >>"$LOG_LATEST"
    rm "$SHUTDOWN_FILE"
fi

# Registra a data e hora de inicialização
if [ -f "$UPDATE_FILE" ]; then
    STARTUP="$(cat "$UPDATE_FILE")"
    rm "$UPDATE_FILE"
    echo "Continuing from update of $STARTUP"
else
    STARTUP="$(date +"%Y-%m-%d_%H-%M-%S")"
fi

# Set log files names
LOG_FILE="$LOGS_DIR/log_$STARTUP.txt"
ln -sf $LOG_FILE $LOG_LATEST

# Verifica se o modo de depuração está habilitado
if [[ "$*" == *"--debug"* ]] || [[ "$*" == *"-d"* ]]; then
    DEBUG=true
    echo ""
    echo "OSTYPE: $OSTYPE"
    echo "SCRIPT_DIR: $SCRIPT_DIR"
    echo "LOGS_DIR: $LOGS_DIR"
    echo "LOG_LATEST: $LOG_LATEST"
    echo "LOG_FILE: $LOG_FILE"
    echo "STARTUP: $STARTUP"
fi

# Loop infinito para atualizar o uptime a cada 5 minutos
while true; do

    # Verifica o tipo de sistema operacional
    if [[ "$OSTYPE" == "darwin"* ]]; then
        UPTIME=$(echo "$(($(date +%s) - $(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')))" | awk '{printf "%d days, %02d:%02d:%02d",($1/60/60/24),($1/60/60%24),($1/60%60),($1%60)}')
    else
        # Define o comando para obter o tempo de inicialização no Linux
        UPTIME=$(uptime -p)
    fi

    echo "Init: $STARTUP" >"$LOG_FILE"
    echo "last record: $UPTIME" >>"$LOG_FILE"

    if [ $DEBUG = true ]; then
        echo ""
        echo "Init: $STARTUP"
        echo "last record: $UPTIME"
    fi
    sleep 1
done
