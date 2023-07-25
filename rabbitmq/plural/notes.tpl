You can connect to your rabbitmq cluster within kubernetes at the dns name: `rabbitmq.rabbitmq:5672`

To get username/password and some other important connection information, run `kubectl get secret rabbitmq-default-user -n rabbitmq -o yaml`. Note that you'll need to base64 decode the values of the secret data.