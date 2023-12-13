ARG EDGE_VERSION=11.0
FROM sagcr.azurecr.io/webmethods-edge-runtime:${EDGE_VERSION} AS base

MAINTAINER SoftwareAG

USER root

COPY ${PACKAGE} /opt/softwareag/IntegrationServer/packages/${PACKAGE}

RUN chown 1724:1724 -R /opt/softwareag/IntegrationServer/packages/*

USER 1724
