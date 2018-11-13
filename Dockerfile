FROM centos:7

ENV REFRESHED_AT=2018-11-13

# Install prerequisites.

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install \
    gcc-c++ \
    mysql-connector-odbc \
    python-devel \
    python-pip \
    unixODBC \
    unixODBC-devel \
    wget; \
    yum clean all

RUN pip install \
    psutil \
    pyodbc

# Copy and expand Senzing_API.tgz

ADD artifacts/Senzing_API.tgz /opt/senzing

# Copy the repository's app directory.

COPY ./app /app

# Environment variables

ENV SENZING_ROOT=/opt/senzing
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib

# Work-around https://senzing.zendesk.com/hc/en-us/articles/360009212393-MySQL-V8-0-ODBC-client-alongside-V5-x-Server

RUN wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-libs-8.0.12-1.el7.x86_64.rpm \
 && rpm2cpio mysql-community-libs-8.0.12-1.el7.x86_64.rpm | cpio -idmv

# Run-time command

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["python"]
