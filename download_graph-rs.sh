#!/bin/bash

graph_name=$1
destination_folder="../webgraph-rs/graphs"

if [ -z "$graph_name" ] || [ -z "$destination_folder" ]; then
    echo "Usage: $0 <graph_name> <destination_folder>"
    exit 1
fi

for ext in .properties .graph; do
    wget -c -P "$destination_folder" "http://data.law.di.unimi.it/webdata/$graph_name/$graph_name$ext"
done

cd $destination_folder
cargo run --release -- build offsets "$graph_name"
cargo run --release -- build ef "$graph_name"