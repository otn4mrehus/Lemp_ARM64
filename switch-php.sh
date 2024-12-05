#!/bin/bash

# Fungsi untuk menghentikan semua container dan menghapus volume
stop_and_remove_containers() {
    echo "Stopping and removing containers, including volumes..."
    docker-compose -p 'lampp' down --remove-orphans -v
    echo "Containers and volumes removed."
}

# Fungsi untuk merestore file nginx.conf dari backup dan memulai container
switch_php_version() {
    local php_version=$1
    case $php_version in
        php7)
            echo "Switching to PHP 7..."
            cp nginx.conf.backup7 nginx.conf
            ;;
        php8)
            echo "Switching to PHP 8..."
            cp nginx.conf.backup8 nginx.conf
            ;;
        *)
            echo "Invalid PHP version. Please choose 'php7' or 'php8'."
            exit 1
            ;;
    esac
    start_containers
}

# Fungsi untuk memulai container dengan Docker Compose
start_containers() {
    echo "Starting Docker containers..."
    docker-compose -p 'lampp' up -d --build
    echo "Containers are running."
}

# Fungsi untuk menampilkan menu
show_menu() {
    while true; do
        echo "Choose PHP version to switch:"
        echo "1) Switch to PHP 8"
        echo "2) Switch to PHP 7"
        echo "3) Exit"
        read -p "Enter your choice [1-3]: " choice

        case $choice in
            1)
                stop_and_remove_containers
                switch_php_version php8
                ;;
            2)
                stop_and_remove_containers
                switch_php_version php7
                ;;
            3)
                echo "Exiting script."
                break
                ;;
            *)
                echo "Invalid choice. Please select 1-3."
                ;;
        esac
    done
}

# Menjalankan menu utama
show_menu
