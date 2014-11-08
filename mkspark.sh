#!/bin/bash

#This script sets up a new scala source tree in first argument.
PROJECT=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -e $1 ]; then
  echo "Project $PROJECT already exists."
  exit 1
fi

mkdir $1

cd $1

#Todo - maybe make package directories as well?
mkdir -p src/main/scala/
mkdir -p src/test/scala/

#Now put a default build.sbt and other project goodness in here.
cp -r $DIR/skeleton/* ./
cp $DIR/skeleton/.gitignore ./

sed -i '' "s/name := \"\"/name := \"$PROJECT\"/" build.sbt
sed -i '' "s/PROJECT=/PROJECT=$PROJECT/" run-main.sh
sed -i '' "s/PROJECT=/PROJECT=$PROJECT/" run-spark.sh

cd ..
