#!/bin/bash

: ${SPARK_HOME:?"Need to set SPARK_HOME"}

CLASS=$1
PROJECT=
shift

$SPARK_HOME/bin/spark-submit \
  --master `cat /root/spark-ec2/cluster-url` \
  --deploy-mode client \
  --class $CLASS \
  --driver-memory 4g \
  --driver-java-options "-Dspark.local.dir=/mnt/spark,/mnt1/spark -XX:+UseG1GC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps" \
  target/scala-2.10/$PROJECT-assembly-0.1.jar \
  "$@"
