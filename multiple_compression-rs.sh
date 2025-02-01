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

        # Run the cargo command
        cargo run --release -- to bvgraph ${graph_name} ${graph_name}_${ref_name}_w-${compression_window} --max-ref-count=${max_ref_count} --compression-window=${compression_window} --min-interval-length=3

        echo "Executed with graph: $graph_name, max-ref-count: $max_ref_count, compression-window: $compression_window"
    done
done

echo "All executions completed."
