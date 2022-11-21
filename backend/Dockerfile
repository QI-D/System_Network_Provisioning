FROM python:3

RUN apt update
RUN apt install -y wait-for-it

RUN useradd -m -d /app backend
USER backend

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install -r requirements.txt
COPY . /app

ENTRYPOINT ["bash", "/app/start.sh"]
