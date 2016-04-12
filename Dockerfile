FROM ubuntu
MAINTAINER Michael Richardson <michael@michaelandhelen.com>

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install redis-server

RUN apt-get -y install wget && \
wget -q http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
dpkg -i erlang-solutions_1.0_all.deb && \
apt-get update && \
apt-get -y install erlang-nox=1:18.2 && \
wget -q http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.0/rabbitmq-server_3.6.0-1_all.deb && \
dpkg -i rabbitmq-server_3.6.0-1_all.deb && \
echo "ulimit -n 65536" >> /etc/default/rabbitmq-server

RUN wget -q http://repositories.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add - && \
echo "deb     http://repositories.sensuapp.org/apt sensu main" | sudo tee /etc/apt/sources.list.d/sensu.list && \
apt-get update && \
apt-get -y install sensu uchiwa

RUN apt-get install -y supervisor

ADD files/config.json /etc/sensu/config.json
ADD files/uchiwa.json /etc/sensu/uchiwa.json
ADD files/rabbitmq-go.sh /rabbitmq-go.sh
ADD files/supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE  3000 5672

CMD ["/etc/init.d/supervisor","start"]
