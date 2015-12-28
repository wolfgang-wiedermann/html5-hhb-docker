FROM ubuntu:14.04
MAINTAINER Wolfgang Wiedermann <info@html5-haushaltsbuch.de>

# Mysql Gruppe und Benutzer
RUN groupadd -r mysql && useradd -r -g mysql mysql

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -yq mysql-server-5.6 \
                        apache2 php5 \
                        libapache2-mod-php5 \
                        php5-mysql \ 
                        git \
                        openssh-client openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Akutelles stable Release holen
RUN cd /var/www/html && mkdir fibu && cd fibu && git init && \
    git remote add origin https://github.com/wolfgang-wiedermann/php_mobile_accounting.git && \ 
    git pull origin master 
#&& \
#    git checkout 03d0ddd3d40430aa7700a20

# siehe: https://docs.docker.com/userguide/dockervolumes/#volume-def
#VOLUME ["/etc/mysql", "/var/lib/mysql"]
EXPOSE 80 22

RUN service mysql start && sleep 30s \
    && mysql -u root -e "CREATE DATABASE fibu" \
    && mysql -u root -e "GRANT ALL PRIVILEGES ON fibu.* to fibu@localhost identified by 'fibu'" \
    && mysql -u root "fibu" < /var/www/html/fibu/sql/create-tables-and-views.sql \
    && mysql -u root "fibu" < /var/www/html/fibu/sql/sample_kontenplan_single.sql \
    && mysql -u root "fibu" -e "insert into fi_user values(0, 'test', '', 1, now());"

COPY startup.sh /bin/startup.sh
COPY config/Database.php /var/www/html/fibu/lib/Database.php
COPY config/apache2.conf /etc/apache2/apache2.conf
COPY config/.htaccess /var/www/html/fibu/.htaccess
COPY config/.htpasswd /var/www/html/fibu/.htpasswd
RUN chmod guo+x /bin/startup.sh

# SSH-Zugriff für root hinzufügen (vgl. https://docs.docker.com/examples/running_ssh_service/)
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

ENTRYPOINT ["/bin/startup.sh"]
