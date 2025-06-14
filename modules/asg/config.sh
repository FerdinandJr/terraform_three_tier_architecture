#!/bin/bash

# Define GitHub repository name
GIT_REPO="php_mysql_nginx_docker_treasure-products"

set -e  # Exit immediately if a command exits with a non-zero status

# Update and install necessary packages
echo "Updating package list and installing required packages..."
sudo apt update -y
sudo apt install -y apache2 php php-mysql git php-fpm mysql-client

# Clone the Git repository
echo "Cloning the repository..."
sudo git clone https://github.com/FerdinandJr/$GIT_REPO.git /var/www/$GIT_REPO


#echo "Configuring Apache..."
sudo rm -rf /etc/apache2/sites-available/000-default.conf

sudo cp /var/www/$GIT_REPO/000-default.conf /etc/apache2/sites-available/


# echo "Configuring MySQL..."
# sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root@000!'; FLUSH PRIVILEGES;" || true
# sudo mysql -u root --password=root@000! -e "CREATE DATABASE IF NOT EXISTS my_store;"

# # Import database
# echo "Importing database..."
# sudo mysql -u root --password=root@000! my_store < /var/www/$GIT_REPO/my_store.sql

# sudo systemctl restart apache2

# echo "Setup completed successfully!"