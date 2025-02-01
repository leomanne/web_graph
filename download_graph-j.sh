#!/bin/bash

graph_name=$1
destination_folder="../webgraph/graphs"

if [ -z "$graph_name" ] || [ -z "$destination_folder" ]; then
    echo "Usage: $0 <graph_name> <destination_folder>"
    exit 1
fi

for ext in .properties .graph; do
    wget -c -P "$destination_folder" "http://data.law.di.unimi.it/webdata/$graph_name/$graph_name$ext"
done

cd $destination_folder
source setcp.sh
java it.unimi.dsi.webgraph.BVGraph -O "$graph_name"