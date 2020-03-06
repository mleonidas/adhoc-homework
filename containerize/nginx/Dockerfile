# your code goes here ...
FROM nginx:alpine

COPY ./nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/pki/nginx/certs/private \
      && chmod 0500 /etc/pki/nginx/certs/private

EXPOSE 80/tcp
EXPOSE 443/tcp
