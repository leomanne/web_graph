#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <graph_name>"
    exit 1
fi

# Assign input argument to variable
graph_name=$1

# Define arrays for the parameters
compression_windows=(1 3 7)
max_ref_counts=(-1 1 3)

cd ../webgraph-rs

# Create CSV file and add header
echo "graph_name,compression_window,max_ref_count,link_access_time" > results.csv

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
        transpose_graph_filename="${graph_name}transpose_${ref_name}_w-${compression_window}"
        
        # Run link access time measurement and collect results
        link_access_time_transpose=$(cargo run --release --example=link_access_time -- ${transpose_graph_filename} | tail -n 1)
        echo "${transpose_graph_filename},${compression_window},${max_ref_count},${link_access_time_transpose}" >> results.csv
    done
done

echo "All measurements completed. Results saved in results.csv"
