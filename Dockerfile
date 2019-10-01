FROM node:6.9.2-alpine

RUN npm install -g gitbook-cli@2.3.0

RUN gitbook fetch 3.2.2

RUN mkdir /src
WORKDIR /src
