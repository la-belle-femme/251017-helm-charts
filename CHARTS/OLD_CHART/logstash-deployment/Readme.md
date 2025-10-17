A production-ready Logstash deployment on Kubernetes using the official Helm chart is built.  
This Logstash instance collects, transforms, and forwards logs to Elasticsearch for storage and visualization in Kibana.  
It also exposes metrics to Prometheus, which are visualized in Grafana dashboards. However, the grafana dashboard is to be manually imported on grafana UI with the json file in the folder.
The structure assumes prometheus and grafana are already installed(elasticsearch and kibana aswell) and the scrape config on prometheus.yml is to be manually added to an already existing prometheus.yml scrape config file.
The structure also assumes that Elasticsearch has a CA cert in the ca.crt which will be base64 coded and pasted in the secrets/logstash-tls-secret.yaml.
Also added are persistent storage, secure communication with TLS, environment-based secrets, and performance tuning with JVM and resource limits.
