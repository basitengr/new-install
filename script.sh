#!/bin/bash
apt update -y && apt upgrade -y

apt install -y wget vim curl openssh-server git lynx screen

#.......................apache......
apt install -y apache2

#.......................mysql......
apt install -y gnupg
wget https://dev.mysql.com/get/mysql-apt-config_0.8.19-1_all.deb
dpkg -i mysql-apt-config_0.8.19-1_all.deb
apt install -y mysql-server
systemctl status mysql.service

#....................install php 7 on debian.............

apt install -y apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

apt update -y

apt install -y php7.4 php7.4-mysql php7.4-mbstring php7.4-xml php7.4-bcmath php7.4-curl php7.4-gd php7.4-zip
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

composer -V

composer create-project --prefer-dist laravel/laravel /var/www/myapp

chown -R www-data.www-data /var/www/myapp
chmod -R 755 /var/www/myapp
chgrp -R www-data /var/www/myapp/storage /var/www/myapp/bootstrap/cache 
chmod -R ug+rwx /var/www/myapp/storage /var/www/myapp/bootstrap/cache

#....................test laravel installation.............
cd /var/www/myapp
php artisan serve

#output should be
#Laravel development server started: <http://127.0.0.1:8000>

# ------------------- apache configuration -------------------

cat /etc/apache2/sites-available/myapp.com.conf

<VirtualHost *:80>
    ServerName myapp.com

    ServerAdmin admin@myapp.com
    DocumentRoot /var/www/myapp/public

    <Directory /var/www/myapp/public>
        Options Indexes MultiViews
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
