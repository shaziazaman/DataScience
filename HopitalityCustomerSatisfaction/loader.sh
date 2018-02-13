#!/bin/sh
dataDir=<working directory>/statistics-2/Project3/data/json
#ls -1 $dataDir/*.json | sed 's/.json$//' | while read col; do 
cd $dataDir
ls -1 *.json | while read col; do 
    echo 'reading file ' $col
    #mongoimport --db analytics --collection reviews -c $col < $col.json; 
    mongoimport --db analytics --collection reviews --file $col; 
done
cd -
