FROM nginx

RUN apt-get update
RUN apt-get install -y wget unzip

WORKDIR /web

RUN wget -qq https://github.com/timoguic/acit4640-py-mysql/archive/refs/heads/master.zip -O /tmp/source.zip
RUN unzip /tmp/source.zip
RUN cp -r acit4640-py-mysql-master/frontend /web/src
RUN rm -rf acit4640-py-mysql-master

WORKDIR /web/src

RUN cp index.html /usr/share/nginx/html

RUN mkdir /etc/nginx/templates
COPY default.conf.template /etc/nginx/templates

EXPOSE 8000
