FROM datastax/dse-server:6.7.4

RUN apt-get update && apt-get -y install python-pip
RUN pip install jupyter cassandra-driver pandas

EXPOSE 8888

RUN cat /opt/dse/resources/spark/conf/spark-defaults.conf >> /config/spark-defaults.conf
RUN echo "# Settings required for accessing DSE on remote server" >> /config/spark-defaults.conf
RUN echo "spark.cassandra.connection.host dse" >> /config/spark-defaults.conf
RUN echo "spark.hadoop.cassandra.host dse" >> /config/spark-defaults.conf
RUN echo "spark.hadoop.fs.defaultFS dsefs://dse/" >> /config/spark-defaults.conf

ENTRYPOINT [ "/entrypoint.sh", "dse", "exec", "jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--notebook-dir=/var/lib/jupyter"]
