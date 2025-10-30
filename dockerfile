FROM nginx:latest

USER root

# Устанавливаем OpenSSH server и необходимые утилиты
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \              # ← добавлено -p
    echo 'root:root' | chpasswd && \
    usermod -s /bin/bash root && \
    passwd -u root && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Удаляем дефолтный nginx конфиг
RUN rm /etc/nginx/conf.d/default.conf

# Копируем твои конфиги
COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY nginx2.conf /etc/nginx/nginx.conf

# Открываем порты
EXPOSE 8080 22

# Запускаем SSH и Nginx
CMD service ssh start && nginx -g 'daemon off;'
