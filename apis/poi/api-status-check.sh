#!/bin/bash

declare endpoint="https://openhackiaw3kcz1POI.azurewebsites.net/api/healthcheck/POI" #should be parameterized
declare -i maxretries=50
declare -i retryinterval=2
declare checkedstatus='json_status="healthy"'


while [[ true ]]; do
#   echo "$maxretries Checking $endpoint "
   result=`curl --max-time 5 -s $endpoint |\
     sed -re 's@(\[|\]|\{|\})@@g' -e 's/,/\n/g' |\
     sed -re 's@"(\w+)":\s*"?([^"]*)"?@json_\1="\2"@g' | \
     grep $checkedstatus |\
     wc -l`
#   echo "result: [$result]"
   if [[ $result == "0" ]]; then
      echo "unhealthy status"
   else
      echo "healthy status"
      exit 0
   fi
   if [[ $maxretries == 0 ]]; then
      echo " Too many retry : healthy check failed"
      exit 1;
   fi

   sleep $retryinterval
   let maxretries--
done
