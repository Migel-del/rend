FROM nginx:latest

# Переключаемся на root (в nginx:latest это и так root, но укажем явно)
USER root

# Устанавливаем OpenSSH server и необходимые утилиты
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    usermod -s /bin/bash root && \
    passwd -u root && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Если ты хочешь использовать НЕ root пользователя:
# RUN useradd -ms /bin/bash myuser && echo 'myuser:password' | chpasswd
# RUN mkdir -p /home/myuser/.ssh && chmod 700 /home/myuser/.ssh
# RUN usermod -s /bin/bash myuser

# Копируем твои конфиги nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY nginx2.conf /etc/nginx/nginx.conf

# Открываем порты — 8080 (nginx) и 22 (ssh)
EXPOSE 8080 22

# Запускаем оба процесса: sshd и nginx
CMD service ssh start && nginx -g 'daemon off;'
