FROM node:20-alpine
RUN mkdir -p /home/node/app/node_modules && mkdir -p /home/node/app/upload 
WORKDIR /home/node/app
COPY package*.json ./
RUN npm install
COPY --chown=node:node . .
EXPOSE 3000
CMD ["node", "./bin/www"]

