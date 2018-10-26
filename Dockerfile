# Start from TensorFlow image
ARG TF_VERSION
FROM tensorflow/tensorflow:${TF_VERSION}
LABEL maintainer="Marco Capuccini <marco.capuccini@it.uu.se>"

# Install Java
RUN add-apt-repository ppa:webupd8team/java && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update -y && apt-get install -y \
  oracle-java8-installer \
  oracle-java8-set-default && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Hadoop
ARG HADOOP_VERSION
ENV HADOOP_VERSION ${HADOOP_VERSION}
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | gunzip \
  | tar -x -C /usr/ && \
  rm -rf "$HADOOP_HOME/share/doc" && \
  chown -R root:root "$HADOOP_HOME"

# Install Hadoop object storage dependencies
RUN curl  -sL --retry 3 \
  -o "$HADOOP_HOME/share/hadoop/common/lib/hadoop-aws-$HADOOP_VERSION.jar" \
  "http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/$HADOOP_VERSION/hadoop-aws-$HADOOP_VERSION.jar" && \
  curl  -sL --retry 3 \
  -o "$HADOOP_HOME/share/hadoop/common/lib/hadoop-openstack-$HADOOP_VERSION.jar" \
  "http://central.maven.org/maven2/org/apache/hadoop/hadoop-openstack/$HADOOP_VERSION/hadoop-openstack-$HADOOP_VERSION.jar"

# Install Spark
ARG SPARK_VERSION
ENV SPARK_VERSION ${SPARK_VERSION}
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
  "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ && \
  mv "/usr/$SPARK_PACKAGE" "$SPARK_HOME" && \
  chown -R root:root "$SPARK_HOME"

# Install Zeppelin
ARG Z_VERSION
ENV Z_VERSION ${Z_VERSION}
ENV Z_HOME /usr/zeppelin-$Z_VERSION
RUN curl -sL --retry 3 \
    "http://archive.apache.org/dist/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-all.tgz" \
    | gunzip \
    | tar x -C /usr/ && \
    mv "/usr/zeppelin-${Z_VERSION}-bin-all" "${Z_HOME}" && \
    chown -R root:root "$Z_HOME"

# Zeppelin pip deps
RUN pip install pandasql==0.7.3

# Reset workdir and default command
WORKDIR /
CMD /bin/bash
