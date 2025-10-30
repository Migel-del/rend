FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY nginx2.conf /etc/nginx/nginx.conf

EXPOSE 8080
