#!/bin/bash

set -e  # Прерывать выполнение при любой ошибке

REPO_URL="https://github.com/decimal-kmn/shvirtd-example-python.git"
TARGET_DIR="/opt/shvirtd-example-python"
COMPOSE_FILE="compose.yaml"

# Проверяем, существует ли целевая директория
if [ -d "$TARGET_DIR" ]; then
    echo "Директория $TARGET_DIR уже существует. Обновляем репозиторий..."
    cd "$TARGET_DIR"
    git pull origin main
else
    echo "Клонируем репозиторий в $TARGET_DIR..."
    sudo mkdir -p /opt
    sudo git clone "$REPO_URL" "$TARGET_DIR"
    cd "$TARGET_DIR"
fi
                                                                                                                                                                                             
# Проверяем права доступа и меняем владельца на текущего пользователя                                                                                                                        
echo "Настраиваем права доступа..."                                                                                                                                                          
sudo chown -R $(whoami):$(whoami) "$TARGET_DIR"                                                                                                                                              
                                                                                                                                                                                             
# Проверяем существование compose.yaml                                                                                                                                                       
if [ ! -f "$COMPOSE_FILE" ]; then                                                                                                                                                            
    echo "Ошибка: Файл $COMPOSE_FILE не найден в репозитории!"                                                                                                                               
    exit 1                                                                                                                                                                                   
fi                                                                                                                                                                                           
                                                                                                                                                                                             
# Запускаем проект через Docker Compose                                                                                                                                                      
echo "Запускаем проект через Docker Compose..."                                                                                                                                              
docker compose -f "$COMPOSE_FILE" up -d                                                                                                                                                      
                                                                                                                                                                                             
echo "Проект успешно запущен!"                                                                                                                                                               
echo "Проверить статус: docker compose -f $TARGET_DIR/$COMPOSE_FILE ps"                                                                                                                      
echo "Посмотреть логи: docker compose -f $TARGET_DIR/$COMPOSE_FILE logs" 
