FROM alpine:latest as builder

ARG KAFKA_VERSION=0.11.0.0
ARG SCALA_VERSION=2.11

RUN apk update && apk add --no-cache wget tar gzip

RUN wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

FROM amazonlinux:2023

ARG KAFKA_HOME=/opt/kafka
ARG KAFKA_VERSION=0.11.0.0
ARG SCALA_VERSION=2.11
ARG YUM_REPOSITORY=yum-repository.platform.aws.chdev.org

ENV PATH="${PATH}:${KAFKA_HOME}/bin"

COPY --from=builder /kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

RUN ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME}

RUN yum update -y && \
    yum install -y java-21-amazon-corretto-headless &&  \
    yum clean all

RUN rpm --import http://${YUM_REPOSITORY}/RPM-GPG-KEY-platform-noarch && \
    yum install -y yum-utils && \
    yum-config-manager --add-repo http://${YUM_REPOSITORY}/platform-noarch.repo && \
    yum install -y platform-tools-common && \
    yum clean all