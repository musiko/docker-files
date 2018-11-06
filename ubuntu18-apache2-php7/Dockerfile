# The line below states we will base our new image on the Latest Official Ubuntu
FROM ubuntu:18.04

ENV MEMORY_LIMIT "128MB"

# Identify the maintainer of an image
LABEL MAINTAINER="info@juicyapphk.com"

# Update the image to the latest packages
RUN apt update && apt upgrade -y

# Install apt-utils
RUN apt -y install apt-utils

# Set timezone & hostname
ENV TZ Asia/Hong_Kong
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# RUN hostnamectl set-hostname 'ubuntu18_apache2_php7'

# Install vim apache2 and modules
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
RUN cd /etc/php/7.2/apache2/ && touch php.ini && echo "memory_limit = "$MEMORY_LIMIT >> php.ini

# Mount Volumes
VOLUME "/var/www/html/"

# Install SSH service
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80 443 22

# Start apache2 and tail to keeps container running
CMD /bin/bash service apache2 start && tail -f /dev/null
# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
