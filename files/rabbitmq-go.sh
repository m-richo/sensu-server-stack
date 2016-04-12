#!/bin/bash

if [ ! -f /.run-rabbitmq-server-firstrun ]; then
  echo "Setting up RabbitMQ SSL config"
#   cat >/etc/rabbitmq/rabbitmq.config <<EOF
# [
#   {rabbit, [
#     {ssl_listeners, [5671]},
#     {ssl_options, [{cacertfile,"/etc/rabbitmq/ssl/cacert.pem"},
#                    {certfile,"/etc/rabbitmq/ssl/cert.pem"},
#                    {keyfile,"/etc/rabbitmq/ssl/key.pem"},
#                    {verify,verify_peer},
#                    {fail_if_no_peer_cert,false}]}
#   ]}
# ].
# EOF

  # add the vhost
  : ${VHOST_NAME=sensu}
  : ${VHOST_USER=sensu}
  : ${VHOST_PASSWORD=secret}

  (sleep 5 && rabbitmqctl add_vhost /${VHOST_NAME} && rabbitmqctl add_user ${VHOST_USER} ${VHOST_PASSWORD} && rabbitmqctl set_permissions -p /${VHOST_NAME} ${VHOST_USER} ".*" ".*" ".*") &

  touch /.run-rabbitmq-server-firstrun
fi

exec /usr/sbin/rabbitmq-server
