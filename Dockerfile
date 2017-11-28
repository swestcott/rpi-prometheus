FROM hypriot/rpi-alpine:3.6

LABEL maintainer="swestcott@gmail.com"

ENV PROMETHEUS_VERSION 2.0.0

RUN sed -i -e 's/http/https/g' /etc/apk/repositories
RUN apk upgrade --update-cache

ADD https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-armv7.tar.gz /tmp/
#COPY prometheus-${PROMETHEUS_VERSION}.linux-armv7.tar.gz /tmp/

RUN cd /tmp \
	&& tar -zxvf /tmp/prometheus-${PROMETHEUS_VERSION}.linux-armv7.tar.gz \
	&& mkdir /etc/prometheus \
	&& cp /tmp/prometheus-${PROMETHEUS_VERSION}.linux-armv7/prometheus /bin/prometheus \
	&& cp /tmp/prometheus-${PROMETHEUS_VERSION}.linux-armv7/promtool /bin/promtool \
	&& cp /tmp/prometheus-${PROMETHEUS_VERSION}.linux-armv7/prometheus.yml /etc/prometheus/ \
	&& cp -r /tmp/prometheus-${PROMETHEUS_VERSION}.linux-armv7/console_libraries/ /etc/prometheus/ \
	&& cp -r /tmp/prometheus-${PROMETHEUS_VERSION}.linux-armv7/consoles/ /etc/prometheus/ \
	&& rm /tmp/prometheus-${PROMETHEUS_VERSION}.linux-armv7.tar.gz \
	&& rm -r /tmp/prometheus-${PROMETHEUS_VERSION}.linux-armv7/

EXPOSE 9090

VOLUME [ "/prometheus" ]

WORKDIR /prometheus

ENTRYPOINT [ "/bin/prometheus" ]

CMD [ "-config.file=/etc/prometheus/prometheus.yml", \
    "-storage.tsdb.path=/prometheus", \
    "-web.console.libraries=/etc/prometheus/console_libraries", \
    "-web.console.templates=/etc/prometheus/consoles" ]
