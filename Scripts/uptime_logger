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
if [[ "$*" == *"--debug"* ]]; then
    DEBUG=true
    echo ""
    echo "OSTYPE: $OSTYPE"
    echo "SCRIPT_DIR: $SCRIPT_DIR"
    echo "LOGS_DIR: $LOGS_DIR"
    echo "LOG_LATEST: $LOG_LATEST"
    echo "LOG_FILE: $LOG_FILE"
    echo "STARTUP: $STARTUP"
fi

function finishwithUpdate() {
    echo "$STARTUP" > "$UPDATE_FILE"
    cat "$UPDATE_FILE"
}

if [ $DEBUG = true ] && [[ "$*" == *"--exit-with-update"* ]]; then
    trap "finishwithUpdate; exit;" INT TERM
fi

# Loop infinito para atualizar o uptime a cada 5 minutos
while true; do

    LOG="init: $STARTUP"$'\n'
    LOG+="version: 2"$'\n'
    LOG+="ended: $(date +"%Y-%m-%d_%H-%M-%S")"$'\n'

    # Verifica o tipo de sistema operacional
    if [[ "$OSTYPE" == "darwin"* ]]; then
        kernelboottime=$(sysctl -n kern.boottime)
        boottimestamp=$(echo $kernelboottime | sed 's/^.*sec = \([0-9]*\), usec.*$/\1/')
        currenttimestamp=$(date +%s)
        elapsedtime=$((currenttimestamp - boottimestamp))

        LOG+="uptime: $elapsedtime"$'\n'
    else
        # Define o comando para obter o tempo de inicialização no Linux
        UPTIME=$(uptime -p)
        
        LOG+="lastrecord: $UPTIME"$'\n'
    fi

    echo "$LOG" >"$LOG_FILE"

    if [ $DEBUG = true ]; then
        echo "$LOG"
    fi
    sleep 1
done
