ARG EDGE_VERSION=11.0
FROM sagcr.azurecr.io/webmethods-edge-runtime:${EDGE_VERSION}

WORKDIR /opt/softwareag/wpm

ADD --chown=sagadmin:sagadmin wpm ./wpm /opt/softwareag/wpm
ENV PATH=/opt/softwareag/wpm/bin:$PATH

RUN /opt/softwareag/wpm/bin/wpm.sh install -ws https://packages.softwareag.com -wr softwareag -d /opt/softwareag/IntegrationServer -j eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJwa2ctbWdyLWV4dC11c2VyIiwiYXVkIjoicGFja2FnZS1tYW5hZ2VyIiwiaXNzIjoiU29mdHdhcmVBRyIsIm51bURheXMiOiIxMjAiLCJpZCI6InRsdW5kc3RyQHNvZnR3YXJlYWcuY29tIiwibGFiZWwiOiJXUE0iLCJleHAiOjE3MTI4Mjk0NTV9.TN5mszNhip2CYYsNETDVjxTOMlLNM8XuIGl-COzhmWschtOEi0xBe_DkXH9pYgQQ9KTp7fOLTNthf3M06c0lLZW8gyyN-rJmkSRm_JmAavU-_5qYd1NmyXaliJUuO4RikHVM5jQqB4DEL2blPQIEpmdQjGMve8JAwYEduDK0yisxVUrIzYDOq11YN627WKYQsT4OSmaveS30MG35x6GLBIOLgVEwHSaVFVI0aaqoyymb0zUQlUPa4nt75IZeingVQeZMsyf8GdPFYMFWrUIyuYXqJqNlHQOdEJ7I1UVDx2q9BdpSMfl4qtT7j32mN-wkMr96-UGvhy-pwb1k2g7Wgw WmJDBCAdapter

RUN /opt/softwareag/wpm/bin/wpm.sh install -u tlundstr -p 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 -d /opt/softwareag/IntegrationServer -r https://github.com/tlundstr T2Utilities

WORKDIR /
