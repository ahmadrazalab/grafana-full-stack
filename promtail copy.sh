mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor > /etc/apt/keyrings/grafana.gpg
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list

apt-get update
apt-get install promtail
nano  /etc/promtail/config.yml 

journalctl -u loki -f


sudo usermod -aG adm promtail
systemctl restart promtail

# chmod o+r /var/log/nginx/




clients:
  - url: http://x.x.com/loki/api/v1/push
    basic_auth:
      username: xxxx
      password: xxxx

# nginx logs 
scrape_configs:
- job_name: nginx-api-prod
  static_configs:
  - targets:
      - localhost
    labels:
      job: nginx-api-prod
      __path__: /var/log/nginx/*log
      stream: stdout

