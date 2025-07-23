#!/bin/bash

LincName=root@192.168.56.22
ErrorNameFile=errors.txt

scp cat/s21_cat $LincName:/usr/local/bin 2> $ErrorNameFile
scp grep/s21_grep $LincName:/usr/local/bin 2> $ErrorNameFile
ERRORS="$(grep -e lost -e fail -e scp $ErrorNameFile | wc -l)"
cat $ErrorNameFile
rm $ErrorNameFile
if [ $ERRORS != 0 ]
then
  echo 'Deploy FAILED'
  exit 1
fi
echo 'Deploy SUCCEEDED'
exit 0