=========================
Lovely Systems ELK Docker
=========================

A docker for ELK (Elasticsearch, Logstash, Kibana).

This docker image provides an out of the box working ELK host with
Elasticsearch 2.0, Logstash 2.0 and Kibana 4.2.

.. _note:

    This image is work in progress.


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


Run It
------

This command will start the image:

    $ docker run -p 5601:5601 -p 9200:9200 -p 9001:9001 -p 5000:5000 -d lovelysystems/elk


.. _note:

To avoid a memory leak in kibanas node instance the node server will be
started with the flag --max-old-space-size=250 by default. To overwrite this
value set the environment variable 'NODE_OPTIONS' while running the container.
For example like this::

    $ docker run -e "NODE_OPTIONS=--max-old-space-size=100" -d lovelysystems/elk

Alternatively you can overwrite this value while building a container
depending on lovelysystems/elk by setting the proper ENV variable in the
Dockerfile. For example like this::

    FROM lovelysystems/elk:latest
    ENV NODE_OPTIONS --max-old-space-size=100
