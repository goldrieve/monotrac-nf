#!/usr/bin/env python

from Bio import SeqIO
import csv
import sys
import os

def calculate_aa_frequencies(fasta_file):
    # Extract isolate name properly
    isolate_name = os.path.splitext(os.path.basename(fasta_file))[0]
    csv_output = f"{isolate_name}_counts.csv"
    
    # Define expected gene order based on your header
    gene_order = [
        "Tb927.10.13980_1", "Tb927.10.15300_1", "Tb927.9.10660_1", "Tb927.8.3810_1",
        "Tb927.10.4720_1", "Tb927.11.1940_1", "Tb927.4.980_1", "Tb927.10.1820_1",
        "Tb927.6.3660_1", "Tb927.1.3230_1", "Tb927.5.1220_1", "Tb927.6.1100_1",
        "Tb927.11.3980_1", "Tb927.6.2630_1", "Tb927.7.6560_1", "Tb927.10.2810_1",
        "Tb927.3.4350_1", "Tb927.6.5000_1", "Tb927.8.3480_1"
    ]
    
    # Define amino acid order (standard amino acids + stop codon and X)
    aa_order = ['*', 'A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 
                'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y']
    
    # Dictionary to store amino acid frequencies per gene
    gene_frequencies = {}

    # Read FASTA file and calculate amino acid frequencies
    for record in SeqIO.parse(fasta_file, "fasta"):
        gene_id = record.id  # Gene identifier from FASTA header
        sequence = str(record.seq)  # Amino acid sequence
        total_aa = len(sequence)  # Total amino acids in sequence
        
        # Compute relative frequencies of each amino acid
        aa_frequencies = {aa: sequence.count(aa) / total_aa for aa in set(sequence)}
        gene_frequencies[gene_id] = aa_frequencies

    # Write frequencies to CSV with sorted columns
    with open(csv_output, "w", newline="") as csvfile:
        writer = csv.writer(csvfile)
        
        # Write header row in the specified order
        header = ["isolate"]
        for gene in gene_order:
            for aa in aa_order:
                header.append(f"{gene}_{aa}")
        writer.writerow(header)
        
        # Write row with relative frequencies in the same order
        row = [isolate_name]
        for gene in gene_order:
            for aa in aa_order:
                # Get frequency for this gene-aa combination, default to 0 if not present
                freq = gene_frequencies.get(gene, {}).get(aa, 0)
                row.append(freq)
        writer.writerow(row)

    print(f"Amino acid frequencies saved to {csv_output}")
    return csv_output  # Return output file name for debugging

if __name__ == "__main__":
    fasta_file = sys.argv[1]  # Get FASTA file path from command-line argument
    calculate_aa_frequencies(fasta_file)