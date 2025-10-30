FROM nginx:latest

USER root

# Устанавливаем SSH и nginx
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    usermod -s /bin/bash root && passwd -u root && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Настраиваем sshd: пусть слушает все интерфейсы
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "Port 22" >> /etc/ssh/sshd_config

# Удаляем дефолтный nginx конфиг
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY nginx2.conf /etc/nginx/nginx.conf

EXPOSE 8080 22

# Запускаем sshd в фоне и nginx в foreground
CMD /usr/sbin/sshd -D & nginx -g 'daemon off;'
