# Lovely Dockerfile for ELK stack
# Elasticsearch 2.0, Logstash 2.0, Kibana 4.2

FROM centos:6
MAINTAINER Lovely Systems https://github.com/lovelysystems/lovely.elk
LABEL version="0.0.2"

# ------------------------------------------------------------------------------
# Settings

ENV ELASTICSEARCH_VERSION 2.0.0
ENV LOGSTASH_VERSION 2.0.0
ENV LOGSTASH_INPUT_BEATS 0.9.6

ENV KIBANA_HOME /opt/kibana
ENV KIBANA_PACKAGE kibana-4.2.0-linux-x64.tar.gz

# ------------------------------------------------------------------------------
# install RPMs

COPY ./etc/yum.repos.d /etc/yum.repos.d

RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch \
 && yum install -y epel-release \
 && yum clean expire-cache \
 && yum install -y supervisor java-1.8.0-openjdk elasticsearch-${ELASTICSEARCH_VERSION} logstash-${LOGSTASH_VERSION}

# ------------------------------------------------------------------------------
# Kibana

RUN mkdir ${KIBANA_HOME} \
 && yum install -y tar which \
 && curl -O https://download.elastic.co/kibana/kibana/${KIBANA_PACKAGE} \
 && tar xzf ${KIBANA_PACKAGE} -C ${KIBANA_HOME} --strip-components=1 \
 && rm -f ${KIBANA_PACKAGE} \
 && groupadd -r kibana \
 && useradd -r -s /usr/sbin/nologin -d ${KIBANA_HOME} -c "Kibana service user" -g kibana kibana \
 && chown -R kibana:kibana ${KIBANA_HOME}

# Patch kibanas node exec command due to memory leak
# For details see https://github.com/elastic/kibana/issues/5170
RUN sed  -i '/exec /i \
    NODE_OPTIONS="${NODE_OPTIONS:=--max-old-space-size=250}"' /opt/kibana/bin/kibana && \
    sed -i 's/exec "\${NODE}"/exec "\${NODE}" ${NODE_OPTIONS}/' /opt/kibana/bin/kibana

# ------------------------------------------------------------------------------
# default settings
COPY ./etc /etc
RUN ln -s /etc/elasticsearch /usr/share/elasticsearch/config \
 && mkdir -p /usr/share/elasticsearch/logs \
 && chown elasticsearch:elasticsearch /usr/share/elasticsearch/logs \
 && mkdir -p /var/log/elasticsearch \
 && chown elasticsearch:elasticsearch /var/log/elasticsearch \
 && mkdir -p /var/elasticsearch \
 && chown elasticsearch:elasticsearch /var/elasticsearch

# ------------------------------------------------------------------------------
# upgrade logstash plugins
RUN /opt/logstash/bin/plugin install --version ${LOGSTASH_INPUT_BEATS} logstash-input-beats


# ------------------------------------------------------------------------------
# expose ports
#  5000 : logstash luberjack
#  5044 : logstash filebeat
#  5601 : kibana
#  9001 : supervisor
#  9200 : elasticsearch http
#  9300 : elasticseach transport
EXPOSE 5000 5044 5601 9001 9200 9300

# ------------------------------------------------------------------------------
# expose volumes
#  This allows the user of this docker to manipulate settings for his needs.
#   /var/elasticsearch : elasticsearch data
#   /etc/elasticsearch : elasticsearch configuration
#   /etc/logstash : logstash configuration
#   /etc/supervisord : supervisord configuration

VOLUME ["/var/elasticsearch", "/etc/elasticsearch", "/etc/logstash", "/etc/supervisord"]

# ------------------------------------------------------------------------------
# start the tools under supervisor control
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord/supervisor.conf"]
