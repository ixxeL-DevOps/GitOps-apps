#!/bin/bash

search=".github/workflows/*.yaml"

if [ -f $search ]
then
  echo "search is a file"
elif [ -d $search ]
then
  echo "search is a dir"
fi

for source_file in $search
do
  if [ -d $source_file ]
  then
    echo "its a dir"
  else
    echo "not a dir"
  fi
done

