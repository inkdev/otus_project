FROM grafana/grafana:5.0.0

ENV GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

WORKDIR /etc/grafana/provisioning/dashboards/

COPY ./Dashboards/Crawler_metrics-1557607095717.json "/etc/grafana/provisioning/dashboards/"
COPY datasource.yaml "/etc/grafana/provisioning/datasources/"
COPY dashboards.yaml "/etc/grafana/provisioning/dashboards/"
