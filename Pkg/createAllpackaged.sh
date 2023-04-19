#!/bin/bash

# Seta o nome da branch atual
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Faz o checkout em cada tag existente
for TAG in $(git --no-pager tag); do
  git checkout $TAG
  
  # Executa o comando desejado
  ./createPackage.sh loop
done

# Volta para a branch main
git checkout $CURRENT_BRANCH
