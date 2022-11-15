FROM python:3

RUN apt update
RUN apt install -y wget unzip wait-for-it

RUN useradd -m -d /app backend
USER backend
WORKDIR /app

RUN wget -qq https://github.com/timoguic/acit4640-py-mysql/archive/refs/heads/master.zip -O /tmp/source.zip
RUN unzip /tmp/source.zip
RUN cp -r acit4640-py-mysql-master/backend /app/src
RUN rm -rf acit4640-py-mysql-master

RUN python -m pip install -r /app/src/requirements.txt

WORKDIR /app/src

COPY start.sh /app/start.sh
EXPOSE 8080

ENTRYPOINT ["bash", "/app/start.sh"]
