from Bio import SeqIO
import csv
import sys
import os

def calculate_aa_frequencies(fasta_file):
    # Extract isolate name properly
    isolate_name = os.path.splitext(os.path.basename(fasta_file))[0]
    csv_output = f"{isolate_name}_counts.csv"
    
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

    # Get all unique amino acids present
    all_amino_acids = sorted(set(aa for freqs in gene_frequencies.values() for aa in freqs))

    # Write frequencies to CSV
    with open(csv_output, "w", newline="") as csvfile:
        writer = csv.writer(csvfile)
        
        # Write header row
        header = ["isolate"] + [f"{gene}_{aa}" for gene in gene_frequencies.keys() for aa in all_amino_acids]
        writer.writerow(header)
        
        # Write row with relative frequencies
        row = [isolate_name] + [gene_frequencies[gene].get(aa, 0) for gene in gene_frequencies.keys() for aa in all_amino_acids]
        writer.writerow(row)

    print(f"Amino acid frequencies saved to {csv_output}")
    return csv_output  # Return output file name for debugging

if __name__ == "__main__":
    fasta_file = sys.argv[1]  # Get FASTA file path from command-line argument
    calculate_aa_frequencies(fasta_file)