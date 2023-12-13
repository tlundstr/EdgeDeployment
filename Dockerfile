FROM sagcr.azurecr.io/webmethods-edge-runtime:11

MAINTAINER SoftwareAG

USER root

COPY ${PACKAGE} /opt/softwareag/IntegrationServer/packages/${PACKAGE}

RUN chown 1724:1724 -R /opt/softwareag/IntegrationServer/packages/*

USER 1724
