#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <graph_name> <max_ref_count> <compression_window>"
    exit 1
fi

# Assign input arguments to variables
graph_name=$1
max_ref_count=$2
compression_window=$3

cd ../webgraph-rs

# Determine the name for the output file if max_ref_count is -1
if [ "$max_ref_count" -eq -1 ]; then
    ref_name="r-inf"
else
    ref_name="r-${max_ref_count}"
fi

# Run the cargo command
cargo run --release -- to bvgraph ${graph_name} ${graph_name}_${ref_name}_w-${compression_window} --max-ref-count=${max_ref_count} --compression-window=${compression_window}

echo "Command executed successfully with graph: $graph_name, max-ref-count: $max_ref_count, compression-window: $compression_window"
