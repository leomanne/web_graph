#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <graph_name>"
    exit 1
fi

# Assign input argument to variable
graph_path=$1
graph_name=$(basename "$graph_path")

# Define arrays for the parameters
compression_windows=(1 3 7)
max_ref_counts=(-1 1 3)

cd ../webgraph-rs

# Create CSV file and add header
echo "Graph Name,Compression Window,Avg Ref Chain,link_access_time" > access_time_rs_$graph_name.csv

# Loop through all combinations
for compression_window in "${compression_windows[@]}"; do
    for max_ref_count in "${max_ref_counts[@]}"; do
        # Determine the name for the output file if max_ref_count is -1
        if [ "$max_ref_count" -eq -1 ]; then
            ref_name="r-inf"
        else
            ref_name="r-${max_ref_count}"
        fi

        # Construct the graph filenames
        graph_filename="${graph_path}_${ref_name}_w-${compression_window}"
        
        # Run link access time measurement and collect results
        link_access_time=$(cargo run --release --example=link_access_time -- ${graph_filename} | tail -n 1)
        echo "${graph_filename},${compression_window},${max_ref_count},${link_access_time}" >> access_time_rs_$graph_name.csv
    done
done

echo "All measurements completed. Results saved in access_time_rs_$graph_name.csv"
