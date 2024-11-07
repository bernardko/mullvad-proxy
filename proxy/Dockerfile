FROM nginx:mainline-alpine

LABEL maintainer="Bernard Ko <bernardko@gmail.com>"

RUN apk update
RUN apk add curl

COPY ./nginx.conf /etc/nginx/nginx.conf