# The line below states we will base our new image on the Latest Official Ubuntu
FROM ubuntu:18.04

ENV MEMORY_LIMIT "-1"

# Identify the maintainer of an image
LABEL MAINTAINER="info@juicyapphk.com"

# Update the image to the latest packages
RUN apt update && apt upgrade -y

# Install apt-utils and tools
RUN apt -y install apt-utils nano htop vim goaccess rsyslog cron git libnss3-tools
RUN apt -y python3-pip

# Setup cron log with rsyslog
RUN sed -i.bak -r $'s/#cron.*\t\t\t\t\/var\/log\/cron.log/cron.*\t\t\t\t\/var\/log\/cron.log/g' /etc/rsyslog.d/50-default.conf

# Set timezone & hostname
ENV TZ Asia/Hong_Kong
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# RUN hostnamectl set-hostname 'ubuntu18_apache2_php7'

# Install apache2 and modules
RUN apt install -y apache2 libapache2-mod-php7.2 && a2enmod php7.2 && a2enmod rewrite && a2enmod headers && a2enmod proxy && a2enmod ssl

# Install PHP 7.2+ and modules
RUN apt install -y software-properties-common
RUN apt install -y php7.2 php7.2-fpm php7.2-common php7.2-mysql php7.2-curl php7.2-cli php7.2-gd php7.2-mbstring php7.2-xml php7.2-soap php7.2-redis

# Add user and associated to www-data group
RUN adduser juicyapp
RUN usermod -aG sudo juicyapp
RUN chown -R juicyapp:www-data /var/www/
RUN chmod 755 -R /var/www/

# Apache config file
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Set php memory limit
RUN sed -i -r "s/memory_limit = 128M/memory_limit = $MEMORY_LIMIT/g" /etc/php/7.2/apache2/php.ini

# Mount Volumes
VOLUME "/var/www/html/"

# Install SSH service
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

# Clean up apt get temporary storage
RUN apt-get autoremove -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy startup script
COPY startup.sh /root/startup.sh
RUN chmod 755 /root/startup.sh

# Expose ports
EXPOSE 80 443 22

CMD ["./root/startup.sh"]
