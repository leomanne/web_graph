/*
 * SPDX-FileCopyrightText: 2024 Sebastiano Vigna
 *
 * SPDX-License-Identifier: Apache-2.0 OR LGPL-2.1-or-later
 */

 use std::collections::VecDeque;
 use std::time::Instant;
 use clap::Parser;
 use webgraph::prelude::*;
 
 #[derive(Parser, Debug)]
 #[command(about = "Calculates the link access time of a graph", long_about = None)]
 struct Args {
     // The basename of the graph.
     basename: String,
 }
 
 fn main() -> Result<(), Box<dyn std::error::Error>> {
     let args = Args::parse();
     
     let graph = BvGraph::with_basename(&args.basename).load()?;
     let num_nodes = graph.num_nodes();
     let mut seen = vec![false; num_nodes];
     let mut queue = VecDeque::new();
     
     let mut total_link_access_time = 0.0;
     let mut link_access_count = 0;
 
     for start in 0..num_nodes {
         if seen[start] {
             continue;
         }
         queue.push_back(start as _);
         seen[start] = true;
 
         while !queue.is_empty() {
             let current_node = queue.pop_front().unwrap();
             println!("{}", current_node);
             
             let start_time = Instant::now();
             for succ in graph.successors(current_node) {
                 if !seen[succ] {
                     queue.push_back(succ);
                     seen[succ] = true;
                 }
             }
             let duration = start_time.elapsed().as_secs_f64();
             total_link_access_time += duration;
             link_access_count += 1;
         }
     }
     
     if link_access_count > 0 {
         println!("{:.9}", total_link_access_time / link_access_count as f64);
     } else {
         println!("No links accessed.");
     }
 
     Ok(())
 }
 