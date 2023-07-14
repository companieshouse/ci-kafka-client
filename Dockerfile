FROM amazonlinux:latest

ARG KAFKA_VERSION=0.11.0.0
ARG KAFKA_SCALA_VERSION=2.11
ARG CONFLUENT_KAFKA_VERSION=2.11
ARG JDK_VERSION=1.8.0
ARG YUM_REPOSITORY=yum-repository.platform.aws.chdev.org

COPY resources/confluent.repo /etc/yum.repos.d/confluent.repo

RUN yum install -y tar gzip wget

RUN yum update -y && \
    yum install -y java-${JDK_VERSION}-openjdk.x86_64 \
    confluent-kafka-${CONFLUENT_KAFKA_VERSION} && \
    yum clean all

RUN wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz
RUN tar -xzf kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt
ENV KAFKA_HOME /opt/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}
ENV PATH $PATH:${KAFKA_HOME}/bin
RUN rm -f kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz


RUN rpm --import http://${YUM_REPOSITORY}/RPM-GPG-KEY-platform-noarch && \
    yum install -y yum-utils && \
    yum-config-manager --add-repo http://${YUM_REPOSITORY}/platform-noarch.repo && \
    yum install -y platform-tools-common && \
    yum clean all
