FROM alpine:latest as builder

ARG KAFKA_VERSION=0.10.0.1
ARG SCALA_VERSION=2.11

RUN apk add --no-cache wget tar 

RUN wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && \ 
    rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

FROM amazonlinux:2

ARG KAFKA_HOME=/opt/kafka
ARG KAFKA_VERSION=0.10.0.1
ARG SCALA_VERSION=2.11
ARG YUM_REPOSITORY=yum-repository.platform.aws.chdev.org

ENV PATH="${PATH}:${KAFKA_HOME}/bin"

COPY --from=builder /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

RUN ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME}

RUN yum update -y && \
    yum install -y java-17-amazon-corretto-headless &&  \
    yum clean all

RUN rpm --import http://${YUM_REPOSITORY}/RPM-GPG-KEY-platform-noarch && \
    yum install -y yum-utils && \
    yum-config-manager --add-repo http://${YUM_REPOSITORY}/platform-noarch.repo && \
    yum install -y platform-tools-common && \
    yum clean all