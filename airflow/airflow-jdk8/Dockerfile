FROM apache/airflow:2.3.2 as airflow

USER root

# Install OpenJDK-8
ADD jdk-8u181-linux-x64.tar.gz /usr/local/env/jdk8/

# Set JAVA_HOME
ENV JAVA_HOME /usr/local/env/jdk8/jdk1.8.0_181/
RUN export JAVA_HOME
ENV PATH $JAVA_HOME/bin:$PATH

RUN apt update && apt-get install -y --no-install-recommends \
             vim \
      && apt-get autoremove -yqq --purge \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*
