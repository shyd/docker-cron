FROM debian:latest

RUN apt-get update && \
    apt-get -y install wget curl rsync openssh-client zip mysql-client cron

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /data

WORKDIR /data

CMD ["cron", "-f"]
