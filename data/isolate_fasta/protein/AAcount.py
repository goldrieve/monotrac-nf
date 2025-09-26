from Bio import SeqIO
import csv
import os
import glob 

def calculate_aa_frequencies(fasta_file, output_dir):
    # Extract isolate name properly
    isolate_name = os.path.splitext(os.path.basename(fasta_file))[0]
    csv_output = os.path.join(output_dir, f"{isolate_name}_counts.csv")  # Save in AA_counts directory
    
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

    print(f"Amino acid frequencies saved to: {csv_output}")
    return csv_output  # Return output file name for debugging

if __name__ == "__main__":
    # Define the output directory
    output_dir = os.path.join(os.getcwd(), "AA_counts")
    
    # Create the output directory if it doesn’t exist
    os.makedirs(output_dir, exist_ok=True)

    # Get all FASTA files with .fas, .fasta, .fa, .faa
    fasta_files = glob.glob("*.fas") + glob.glob("*.fasta") + glob.glob("*.fa") + glob.glob("*.faa")

    if not fasta_files:
        print("No FASTA files found in the current directory.")
    else:
        print(f"Found {len(fasta_files)} FASTA files. Processing...\n")

        for fasta_file in fasta_files:
            calculate_aa_frequencies(fasta_file, output_dir)

        print("\nProcessing complete! All output files are saved in the 'AA_counts' directory.")