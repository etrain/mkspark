#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SCALA_VERSION=2.10
PROJECT=

# Figure out where the Scala framework is installed
FWDIR="$(cd `dirname $0`; pwd)"

if [ -z "$1" ]; then
  echo "Usage: run-main.sh <class> [<args>]" >&2
  exit 1
fi

ASSEMBLY_DEPS_JAR="" #pipeline-assembly-0.1-deps.jar
if [ -e "$FWDIR"/target/scala-$SCALA_VERSION/$PROJECT-assembly-*-deps.jar ]; then
  export ASSEMBLY_DEPS_JAR=`ls "$FWDIR"/target/scala-$SCALA_VERSION/$PROJECT-assembly*-deps.jar`
fi

if [[ -z $ASSEMBLY_DEPS_JAR ]]; then
  ASSEMBLY_JAR=""
  if [ -e "$FWDIR"/target/scala-$SCALA_VERSION/$PROJECT-assembly-*.jar ]; then
    export ASSEMBLY_JAR=`ls "$FWDIR"/target/scala-$SCALA_VERSION/$PROJECT-assembly*.jar`
  fi

  if [[ -z $ASSEMBLY_JAR ]]; then
    echo "Failed to find assembly JAR in $FWDIR/target" >&2
    echo "You need to run sbt/sbt assembly or sbt/sbt assembly-package-dependency before running this program" >&2
    exit 1
  fi
  CLASSPATH="$FWDIR/conf:$ASSEMBLY_JAR"
else
  CLASSPATH="$FWDIR/conf:$ASSEMBLY_DEPS_JAR"
  CLASSPATH="$CLASSPATH:$FWDIR/target/scala-$SCALA_VERSION/classes"
fi

# Find java binary
if [ -n "${JAVA_HOME}" ]; then
  RUNNER="${JAVA_HOME}/bin/java"
else
  if [ `command -v java` ]; then
    RUNNER="java"
  else
    echo "JAVA_HOME is not set" >&2
    exit 1
  fi
fi

# Set SPARK_MEM if it isn't already set since we also use it for this process
SPARK_MEM=${SPARK_MEM:-512m}
export SPARK_MEM

JAVA_OPTS="$JAVA_OPTS -Xms$SPARK_MEM -Xmx$SPARK_MEM ""$SPARK_JAVA_OPTS"

exec "$RUNNER" -Djava.library.path=$FWDIR/lib -cp "$CLASSPATH" $JAVA_OPTS "$@"
