# The line below states we will base our new image on the Latest Official Ubuntu
FROM ubuntu:18.04

ENV PHP_MEMORY_LIMIT "-1"
ENV PHP_POST_MAX_SIZE "256M"
ENV PHP_UPLOAD_MAX_FILESIZE "256M"

# Identify the maintainer of an image
LABEL MAINTAINER="erickoo@juicyapp.com"

# Set timezone & hostname
ENV TZ Asia/Hong_Kong
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

####################    Installation    ####################

# Install apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php

# Update the image to the latest packages
RUN DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -y

# Install software & tools
RUN apt-get update && \
    apt install -y nano htop vim goaccess rsyslog cron zip unzip \
                    git libnss3-tools python3-pip openssh-server httpie

# Install apache2
RUN apt install -y apache2

# Install PHP 7.3+ and modules
RUN apt-get update && \
    apt install -y php7.3 php7.3-fpm php7.3-common php7.3-mysql php7.3-curl php7.3-intl \
    php7.3-cli php7.3-gd php7.3-mbstring php7.3-xml php7.3-soap php7.3-redis php7.3-zip

# Enable apache2 modules then restart
RUN apt install -y libapache2-mod-php7.3 && \
    a2enmod php7.3 && a2enmod rewrite && a2enmod headers && a2enmod proxy && a2enmod ssl

# Apache config file
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

RUN service apache2 restart

####################    Setup    ####################

# Add user and associated to www-data group
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/juicyapp --gecos "User" juicyapp
RUN echo "juicyapp:juicyapp" | chpasswd
RUN usermod -aG sudo juicyapp
RUN chown -R juicyapp:www-data /var/www/
RUN chmod 755 -R /var/www/

# Set php memory limit
RUN sed -i -r "s/memory_limit = 128M/memory_limit = $PHP_MEMORY_LIMIT/g" /etc/php/7.3/apache2/php.ini
RUN sed -i -r "s/post_max_size = 8M/memory_limit = $PHP_POST_MAX_SIZE/g" /etc/php/7.3/apache2/php.ini
RUN sed -i -r "s/upload_max_filesize = 2M/memory_limit = $PHP_UPLOAD_MAX_FILESIZE/g" /etc/php/7.3/apache2/php.ini

# Setup cron log with rsyslog
RUN sed -i.bak -r $'s/#cron.*\t\t\t\t\/var\/log\/cron.log/cron.*\t\t\t\t\/var\/log\/cron.log/g' /etc/rsyslog.d/50-default.conf

# Setup SSH service
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh

# install Certbot
# RUN apt install software-properties-common -y
# RUN add-apt-repository universe -y
# RUN add-apt-repository ppa:certbot/certbot -y
# RUN apt update
# RUN apt install certbot python-certbot-apache -y

# install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Clean up apt get temporary storage
RUN apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy startup script
COPY startup.sh /root/startup.sh
RUN chmod 755 /root/startup.sh

# Setup crontab
COPY crontab /root/juicyapp-crontab
RUN chmod 0644 /root/juicyapp-crontab

# Mount Volumes
VOLUME "/var/www/html/"

# Expose ports
EXPOSE 80 443 22

CMD ["./root/startup.sh"]
