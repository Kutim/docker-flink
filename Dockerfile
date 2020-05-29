FROM kutim/java:openjdk8
LABEL maintainer="1252900197@qq.com"

ENV MAVEN_VERSION=3.6.3
RUN wget -O /opt/maven.tar.gz https://mirror.bit.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -zxf /opt/maven.tar.gz -C /opt/ \
    && mv /opt/apache-maven-${MAVEN_VERSION} /opt/maven \
    && rm -rf /opt/maven.tar.gz

ENV MAVEN_HOME=/opt/maven
ENV PATH=$PATH:$MAVEN_HOME/bin

RUN cd /opt/ \
    && git clone https://github.com/apache/flink.git \
    && git clone https://github.com/apache/flink-shaded.git 

ENV FLINK_RELEASE=release-1.10.0
ENV FLINK_SHADED_VERSION=release-10.0

RUN cd /opt/flink &&  git checkout tags/${FLINK_RELEASE} \
    && cd /opt/flink-shaded &&  git checkout tags/${FLINK_SHADED_VERSION}

ENV HADOOP_VERSION=3.2.1
RUN cd /opt/flink-shaded \
    && mvn clean install -Dhadoop.version=${HADOOP_VERSION}

RUN cd /opt/flink \
    && mvn clean install -DskipTests -Dfast


