#!/bin/bash

# Fungsi untuk menghentikan semua container dan menghapus volume
stop_and_remove_containers() {
    echo "Menghentikan dan menghapus container, termasuk volume..."
    docker-compose -p 'lampp' down --remove-orphans -v
    echo "Container dan volume telah dihapus."
}

# Fungsi untuk merestore file nginx.conf dari backup dan memulai container
switch_php_version() {
    local php_version=$1
    case $php_version in
        php7)
            echo "Beralih ke PHP 7..."
            cp nginx.conf.backup7 nginx.conf
            ;;
        php8)
            echo "Beralih ke PHP 8..."
            cp nginx.conf.backup8 nginx.conf
            ;;
        *)
            echo "Versi PHP tidak valid. Pilih 'php7' atau 'php8'."
            exit 1
            ;;
    esac
    start_containers
    echo "Berhasil beralih ke versi $php_version. Silakan pilih dari menu."
}

# Fungsi untuk memulai container dengan Docker Compose
start_containers() {
    echo "Memulai container Docker..."
    docker-compose -p 'lampp' up -d --build
    echo "Container sedang berjalan."
}

# Fungsi untuk membuat direktori jika belum ada
create_directories() {
    echo "Memeriksa dan membuat direktori jika belum ada..."
    mkdir -p ~/webserver/data
    mkdir -p ~/webserver/www
    echo "Direktori ~/webserver/data dan ~/webserver/www telah dibuat."
}

# Fungsi untuk menampilkan menu
show_menu() {
    while true; do
        echo "Pilih tindakan yang ingin dilakukan:"
        echo "1) Buat direktori ~/webserver/data dan ~/webserver/www"
        echo "2) Beralih ke PHP 7"
        echo "3) Beralih ke PHP 8"
        echo "4) Keluar"
        read -p "Masukkan pilihan Anda [1-4]: " choice

        case $choice in
            1)
                create_directories
                ;;
            2)
                stop_and_remove_containers
                switch_php_version php7
                ;;
            3)
                stop_and_remove_containers
                switch_php_version php8
                ;;
            4)
                echo "Keluar dari skrip."
                break
                ;;
            *)
                echo "Pilihan tidak valid. Harap pilih 1-4."
                ;;
        esac
    done
}

# Menjalankan menu utama
show_menu
