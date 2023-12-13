ARG EDGE_VERSION

FROM sagcr.azurecr.io/webmethods-edge-runtime:${EDGE_VERSION}

ARG WPM_CRED

WORKDIR /opt/softwareag/wpm

ADD --chown=sagadmin:sagadmin wpm ./wpm /opt/softwareag/wpm
RUN chmod +x /opt/softwareag/wpm/bin/wpm.sh
ENV PATH=/opt/softwareag/wpm/bin:$PATH

RUN /opt/softwareag/wpm/bin/wpm.sh install -ws https://packages.softwareag.com -wr softwareag -d /opt/softwareag/IntegrationServer -j ${WPM_CRED} WmJDBCAdapter

WORKDIR /
