#!/bin/bash
DEBUG=false

# Registra a data e hora de inicialização
INIT_STRING="Init: $(date +"%Y-%m-%d %H:%M:%S")"
echo $INIT_STRING >$LOG_FILE

# Define o diretório do script e o diretório de log
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOGS_DIR="$SCRIPT_DIR/logs"
if [[ ! -d "$LOGS_DIR" ]]; then
    mkdir "$LOGS_DIR"
fi

# Set log files names
LOG_FILE="$LOGS_DIR/log_$(date +"%Y-%m-%d_%H-%M-%S").txt"
LOG_LATEST="$SCRIPT_DIR/log_latest.txt"

# Verifica se o modo de depuração está habilitado
if [[ "$*" == *"--debug"* ]] || [[ "$*" == *"-d"* ]]; then
    DEBUG=true
    echo "OSTYPE: $OSTYPE"
    echo "SCRIPT_DIR: $SCRIPT_DIR"
    echo "LOGS_DIR: $LOGS_DIR"
    echo "LOG_FILE: $LOG_FILE"
    echo "LOG_LATEST: $LOG_LATEST"
    echo "INIT_STRING: $INIT_STRING"
fi

# Cria um link simbólico para o último arquivo de log
ln -sf $LOG_FILE $LOG_LATEST

# Loop infinito para atualizar o uptime a cada 5 minutos
while true; do

    # Verifica o tipo de sistema operacional
    if [[ "$OSTYPE" == "darwin"* ]]; then
        UPTIME=$(echo "$(($(date +%s) - $(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')))" | awk '{printf "%d days, %02d:%02d:%02d",($1/60/60/24),($1/60/60%24),($1/60%60),($1%60)}')
    else
        # Define o comando para obter o tempo de inicialização no Linux
        UPTIME=$(uptime -p)
    fi

    if [ "$DEBUG" = true ]; then
        echo ""
        echo "$INIT_STRING"
        echo "last record: $UPTIME"
    fi

    echo "$INIT_STRING" >>"$LOG_FILE"
    echo "" >>"$LOG_FILE"
    echo "last record: $UPTIME" >"$LOG_FILE"
    sleep 1
done
