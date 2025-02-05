use std::env::args;
use anyhow::Result;
use clap::Parser;
use dsi_bitstream::prelude::*;
use dsi_progress_logger::prelude::*;
use lender::*;
use std::hint::black_box;
use std::path::PathBuf;
use webgraph::prelude::*;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Carica il grafo (sostituisci con il percorso corretto del tuo file)
    let graph = BVGraph::with_basename(&args.basename).load()?;

    let mut total_chain_length = 0;
    let mut chain_count = 0;

    // Itera su ogni nodo
    for node in 0..graph.num_nodes() {
        let mut current_node = node;
        let mut chain_length = 0;

        // Traccia la catena di riferimenti
        while let Some(reference) = graph.reference(current_node) {
            chain_length += 1;
            current_node = reference;
        }

        if chain_length > 0 {
            total_chain_length += chain_length;
            chain_count += 1;
        }
    }

    // Calcola la lunghezza media della catena di riferimenti
    let avg_ref_chain_length = total_chain_length as f64 / chain_count as f64;
    println!("Average reference chain length: {}", avg_ref_chain_length);

    Ok(())
}
