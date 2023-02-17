FROM python:3.7

USER root

# --------------------------------------------------------
# JAVA
# --------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64/

# --------------------------------------------------------
# HADOOP
# --------------------------------------------------------
ENV HADOOP_VERSION=3.3.1
ENV HADOOP_URL=https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV PATH $HADOOP_PREFIX/bin/:$PATH
ENV PATH $HADOOP_HOME/bin/:$PATH

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs
RUN mkdir /hadoop-data

USER root

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

# ADD hadoop.env /hadoop.env

RUN set -x && cd / && ./entrypoint.sh

# --------------------------------------------------------
# SPARK
# --------------------------------------------------------

# ENV SPARK_VERSION spark-3.3.1-bin-hadoop3
# ENV SPARK_URL https://downloads.apache.org/spark/spark-3.3.1/spark-3.3.1-bin-hadoop3.tgz
# ENV SPARK_HOME=/opt/$SPARK_VERSION
# ENV PATH $SPARK_HOME/bin:$PATH
# ENV HADOOP_CONF_DIR=$SPARK_HOME/conf
# ENV PYSPARK_PYTHON=python3
# ENV PYTHONHASHSEED=1

# RUN set -x \
#     && curl -fSL "${SPARK_URL}" -o /tmp/spark.tar.gz \
#     && tar -xvzf /tmp/spark.tar.gz -C /opt/ \
#     && rm /tmp/spark.tar.gz*

# ADD conf/core-site.xml $SPARK_HOME/conf
# ADD conf/yarn-site.xml $SPARK_HOME/conf

#=========
# INSTALL PYTHON DEPS
#=========
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         gcc \
         g++ \
         subversion \
         python3-dev \
         gfortran \
         build-essential \
         libopenblas-dev \
         liblapack-dev \
         libqpdf-dev \
         pkg-config \
         libzbar-dev \
         libpython3.9-dev \
         qpdf \
         xvfb \
         gconf-service \
         libasound2 \
         libatk1.0-0 \
         libcairo2 \
         libcups2 \
         libfontconfig1 \
         libgdk-pixbuf2.0-0 \
         libgtk-3-0 \
         libnspr4 \
         libpango-1.0-0 \
         libxss1 \
         fonts-liberation \
         libappindicator1 \
         libnss3 \
         lsb-release \
         xdg-utils \
         wget \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --default-timeout=100 --upgrade pip
RUN pip install pikepdf==2.16.1 Cython numpy wheel setuptools --force-reinstall

ADD requirements.txt /requirements.txt

# run install
RUN pip install -r /requirements.txt
