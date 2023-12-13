FROM softwareag/webmethods-microservicesruntime:10.15.0.7

MAINTAINER SoftwareAG

USER root

COPY ${PACKAGE} /opt/softwareag/IntegrationServer/packages/${PACKAGE}

RUN chown 1724:1724 -R /opt/softwareag/IntegrationServer/packages/*

USER 1724
