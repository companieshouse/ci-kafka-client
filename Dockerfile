FROM amazonlinux:latest

ARG CONFLUENT_KAFKA_VERSION=2.11
ARG JDK_VERSION=1.8.0
ARG YUM_REPOSITORY=yum-repository.platform.aws.chdev.org

COPY resources/confluent.repo /etc/yum.repos.d/confluent.repo
COPY resources/RPM-GPG-KEY-confluent /etc/pki/rpm-gpg/RPM-GPG-KEY-confluent

RUN yum update -y && \
    yum install -y java-${JDK_VERSION}-openjdk.x86_64 \
    confluent-kafka-${CONFLUENT_KAFKA_VERSION} && \
    yum clean all

RUN rpm --import http://${YUM_REPOSITORY}/RPM-GPG-KEY-platform-noarch && \
    yum install -y yum-utils && \
    yum-config-manager --add-repo http://${YUM_REPOSITORY}/platform-noarch.repo && \
    yum install -y platform-tools-common && \
    yum clean all
