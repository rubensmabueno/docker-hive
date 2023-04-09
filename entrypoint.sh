#!/bin/bash

if [[ "${@}" == *"metastore"* ]]; then
  schematool -dbType postgres -initSchema
fi

hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse

exec $@
