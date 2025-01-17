#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <graph_name>"
    exit 1
fi

# Assign input argument to variable
graph_path=$1
graph_name=$(basename "$graph_path")

echo $graph_path

# Define arrays for the parameters
compression_windows=(1 3 7)
max_ref_counts=(-1 1 3)

# Prepare results file
echo "Graph Name, Max Ref Count, Compression Window, Graph Size, Offset Size" > size_$graph_name.csv

# Loop through all combinations
for compression_window in "${compression_windows[@]}"; do
    for max_ref_count in "${max_ref_counts[@]}"; do
        
        # Determine the name for the output file if max_ref_count is -1
        if [ "$max_ref_count" -eq -1 ]; then
            ref_name="r-inf"
        else
            ref_name="r-${max_ref_count}"
        fi
        
        # Construct the file path
        graph_file="${graph_path}_${ref_name}_w-${compression_window}.graph"
        offsets_file="${graph_path}_${ref_name}_w-${compression_window}.offsets"
        
        # Check if the file exists
        if [ ! -f "$graph_file" ]; then
            echo "File not found: $graph_file"
            continue
        fi
        
        # Use du -b to obtain the byte dimension of the graph file
        graph_size=$(du -b "$graph_file" | cut -f1)
        # Convert to MB
        graph_size_mb=$(awk "BEGIN {printf \"%.2f\", $graph_size/1048576}")

        # Use du -b to obtain the byte dimension of the offsets file
        offsets_size=$(du -b "$offsets_file" | cut -f1)
        # Convert to MB
        offsets_size_mb=$(awk "BEGIN {printf \"%.2f\", $offsets_size/1048576}")
        
        # Save results to CSV
        echo "$graph_name, $max_ref_count, $compression_window, ${graph_size_mb}MB", ${offsets_size_mb}MB >> size_$graph_name.csv

        echo "Collected size for graph: $graph_name, max-ref-count: $max_ref_count, compression-window: $compression_window"
    done
done


echo "All executions completed. Results saved to size_$graph_name.csv."