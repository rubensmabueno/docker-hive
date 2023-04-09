FROM rubensminoru/hadoop:2.10.2
LABEL Rubens Minoru Andako Bueno <rubensmabueno@hotmail.com>

# Installing Hive
ENV HIVE_VERSION 2.3.9
ENV HIVE_HOME $APP_HOME/hive
ENV HIVE_CONF $HIVE_HOME/conf

WORKDIR $APP_HOME

RUN apt-get update && apt-get install -y wget netcat
RUN curl -s https://dlcdn.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz > apache-hive-$HIVE_VERSION-bin.tar.gz  && \
    tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
    mv apache-hive-$HIVE_VERSION-bin hive && \
    wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar && \
    mv postgresql-9.4.1212.jar $HIVE_HOME/lib/postgresql-jdbc.jar && \
    rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD config/core-site.xml $HADOOP_CONF_DIR/core-site.xml
ADD config/hadoop-env.sh $HADOOP_CONF_DIR/hadoop-env.xml
ADD config/core-site.xml $HIVE_HOME/conf/core-site.xml
ADD config/hive-site.xml $HIVE_HOME/conf/hive-site.xml
ADD config/beeline-log4j2.properties $HIVE_HOME/conf/beeline-log4j2.properties
ADD config/hive-env.sh $HIVE_HOME/conf/hive-env.sh
ADD config/hive-exec-log4j2.properties $HIVE_HOME/conf/hive-exec-log4j2.properties
ADD config/hive-log4j2.properties $HIVE_HOME/conf/hive-log4j2.properties
ADD config/ivysettings.xml $HIVE_HOME/conf/ivysettings.xml
ADD config/llap-daemon-log4j2.properties $HIVE_HOME/conf/llap-daemon-log4j2.properties

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENV PATH $HIVE_HOME/bin:$PATH

ENTRYPOINT ["/entrypoint.sh"]

CMD hiveserver2 --hiveconf hive.server2.enable.doAs=false
