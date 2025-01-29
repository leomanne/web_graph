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

# Loop through all combinations
for compression_window in "${compression_windows[@]}"; do
    for max_ref_count in "${max_ref_counts[@]}"; do
        # Determine the name for the output file if max_ref_count is -1
        if [ "$max_ref_count" -eq -1 ]; then
            ref_name="r-inf"
        else
            ref_name="r-${max_ref_count}"
        fi

        # Construct the graph filename
        graph_filename="${graph_name}_${ref_name}_w-${compression_window}"
        transpose_graph_filename="${graph_name}transpose_${ref_name}_w-${compression_window}"
        
        # Run the cargo build command for the original graph
        cargo run --release -- build ef ${graph_filename}
        echo "Executed build ef with graph: $graph_filename"
        
        # Run the cargo build command for the transposed graph
        cargo run --release -- build ef ${transpose_graph_filename}
        echo "Executed build ef with transposed graph: $transpose_graph_filename"
    done
done

echo "All builds completed."
