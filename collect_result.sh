#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <graph_path>"
    exit 1
fi

# Assign input argument to variable
graph_path=$1
graph_name=$(basename "$graph_path")

# Define arrays for the parameters
compression_windows=(1 3 7)
max_ref_counts=(-1 1 3)

# Prepare results file
echo "Graph Name, Max Ref Count, Compression Window, Avg Ref Chain, Bits/Node, Bits/Link" > results_$graph_name.csv

# Loop through all combinations
for compression_window in "${compression_windows[@]}"; do
    for max_ref_count in "${max_ref_counts[@]}"; do
        # Determine the name for the output file if max_ref_count is -1
        if [ "$max_ref_count" -eq -1 ]; then
            ref_name="r-inf"
        else
            ref_name="r-${max_ref_count}"
        fi

        # Extract values from the generated properties file
        properties_file="${graph_path}_${ref_name}_w-${compression_window}.properties"
        avg_ref_chain="0"
        bits_per_node=$(grep -E "bitspernode=" "$properties_file" | cut -d'=' -f2)
        bits_per_link=$(grep -E "bitsperlink=" "$properties_file" | cut -d'=' -f2)

        # Save results to CSV
        echo "$graph_name, $max_ref_count, $compression_window, $avg_ref_chain, $bits_per_node, $bits_per_link" >> results_$graph_name.csv

        echo "Collected results for graph: $graph_path, max-ref-count: $max_ref_count, compression-window: $compression_window"
    done
done

echo "All executions completed. Results saved to results.csv."
