#!/bin/bash

cd cat
ERRORS1=$(bash test.sh | grep Failed | awk '{print $2}')
cd ../grep
ERRORS2=$(bash test.sh | grep Failed | awk '{print $2}')

if [ $ERRORS1 != 0 ] || [ $ERRORS2 != 0 ]
  then
    echo 'FAILED'
    exit 1
  fi
  echo 'SUCCEEDED'
  exit 0