FROM nginx:latest

USER root

# Устанавливаем OpenSSH server (опционально)
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    usermod -s /bin/bash root && passwd -u root && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Удаляем дефолтный nginx-конфиг
RUN rm /etc/nginx/conf.d/default.conf

# ⚙️ Исправляем mime.types (используем стандартный путь, чтобы не было ошибки)
RUN mkdir -p /rend && cp /etc/nginx/mime.types /rend/mime.types

# Копируем твои конфиги
COPY nginx.conf /rend/nginx.conf
COPY nginx2.conf /rend/nginx2.conf

# Открываем порты
EXPOSE 8080 22

# Запускаем SSH и Nginx
CMD /usr/sbin/sshd -D & nginx -c /rend/nginx2.conf -g 'daemon off;'
