#!/bin/bash

STRLEN=${#2}
FILE=${1}.rst
printf '*%.0s' $(seq 1 $STRLEN) > $FILE 
echo "" >>  $FILE
echo "$2" >> $FILE
printf '*%.0s' $(seq 1 $STRLEN) >> $FILE
