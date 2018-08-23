FROM datastax/dse-server:6.0.2
	
USER root

RUN apt-get update
RUN apt-get -y install python-pip

RUN pip install jupyter
RUN pip install cassandra-driver
RUN pip install tweepy
RUN pip install pattern
RUN pip install pandas

USER dse

VOLUME ["/var/lib/jupyter"]

EXPOSE 8888

RUN cat /opt/dse/resources/spark/conf/spark-defaults.conf >> /config/spark-defaults.conf
RUN echo "# Settings required for accessing DSE on remote server" >> /config/spark-defaults.conf
RUN echo "spark.cassandra.connection.host dse" >> /config/spark-defaults.conf
RUN echo "spark.hadoop.cassandra.host dse" >> /config/spark-defaults.conf
RUN echo "spark.hadoop.fs.defaultFS dsefs://dse/" >> /config/spark-defaults.conf

ENTRYPOINT [ "/entrypoint.sh", "dse", "exec", "jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--notebook-dir=/var/lib/jupyter"]

