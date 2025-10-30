FROM node:18-alpine
WORKDIR /app
COPY server.js .
RUN npm install express ws
ENV PORT=10000
EXPOSE 10000
CMD ["node", "server.js"]
