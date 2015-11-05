=========================
Lovely Systems ELK Docker
=========================

A docker for ELK (Elasticsearch, Logstash, Kibana).

This docker image provides an out of the box working ELK host with
Elasticsearch 2.0, Logstash 2.0 and Kibana 4.2.


Documentation
=============

Detailed Documentation is coming soon.


For now
-------

Exposed Ports:

    - 5000 : logstash lumberjack
    - 5601 : kibana
    - 9001 : supervisord
    - 9200 : elasticsearch http
    - 9300 : elasticsearch transport

Exposed Volumes:

    - /var/elasticsearch : data volume for the elasticsearch database
    - /etc/elasticsearch : configuation for elasticsearch
    - /etc/supervisord : supervisord configuration
    - /etc/logstash : logstash configuration

You should mount the elasticsearch data volume to a persistent place.

It is most likely the logstash configuration which needs to be extended. It is
possible to use an external mount for this configuration or you can of course
use this docker image as a base image for your own configuration.
