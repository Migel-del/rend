FROM nginx:latest

USER root

# Устанавливаем OpenSSH server (опционально)
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    usermod -s /bin/bash root && passwd -u root && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Настраиваем nginx
RUN rm /etc/nginx/conf.d/default.conf

# Копируем твои конфиги
COPY nginx.conf /rend/nginx.conf
COPY nginx2.conf /rend/nginx2.conf

EXPOSE 8080 22

# Запуск nginx (и SSH, если нужно)
CMD /usr/sbin/sshd -D & nginx -c /rend/nginx2.conf -g 'daemon off;'
