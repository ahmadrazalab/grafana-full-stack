openssl genpkey -algorithm RSA -out grafana.key
openssl req -x509 -new -nodes -key grafana.key -sha256 -days 1825 -out grafana.crt
openssl genpkey -algorithm RSA -out loki.key
openssl req -new -key loki.key -out loki.csr
openssl x509 -req -in loki.csr -CA grafana.crt -CAkey grafana.key -CAcreateserial -out loki.crt -days 1825
openssl genpkey -algorithm RSA -out promtail.key
openssl req -new -key promtail.key -out promtail.csr
openssl x509 -req -in promtail.csr -CA grafana.crt -CAkey grafana.key -CAcreateserial -out promtail.crt -days 1825





> loki-config.yaml
server:
  http_listen_port: 3100
  grpc_listen_port: 9095
  http_tls_config:
    cert_file: /path/to/loki.crt
    key_file: /path/to/loki.key
    client_auth_type: RequireAndVerifyClientCert
    ca_file: /path/to/ca.crt

> /etc/promtail/config.yml

clients:
  - url: http://x.x.x.x:3100/loki/api/v1/push
    tls_config:
      cert_file: /path/to/promtail.crt
      key_file: /path/to/promtail.key
      ca_file: /path/to/ca.crt
