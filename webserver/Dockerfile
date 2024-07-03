FROM node:20.12.2-buster-slim

WORKDIR /usr/src/app

COPY ./app/package*.json ./
RUN npm install
COPY ./app .

CMD ["npm", "run", "dev"]
