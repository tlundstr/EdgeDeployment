ARG EDGE_VERSION

FROM sagcr.azurecr.io/webmethods-edge-runtime:${EDGE_VERSION}

ARG WPM_CRED
ARG GITHUB_CREDS_USR
ARG GITHUB_CREDS_PWS

WORKDIR /opt/softwareag/wpm

ADD --chown=sagadmin:sagadmin wpm ./wpm /opt/softwareag/wpm
RUN chmod +x /opt/softwareag/wpm/bin/wpm.sh
ENV PATH=/opt/softwareag/wpm/bin:$PATH

RUN /opt/softwareag/wpm/bin/wpm.sh install -ws https://packages.softwareag.com -wr softwareag -d /opt/softwareag/IntegrationServer -j ${WPM_CRED} WmJDBCAdapter

RUN /opt/softwareag/wpm/bin/wpm.sh install -u ${GITHUB_CREDS_USR} -p ${GITHUB_CREDS_PWS} -d /opt/softwareag/IntegrationServer -r https://github.com/tsvens TSUtils

WORKDIR /
