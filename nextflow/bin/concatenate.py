import os
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import sys

output_dir = sys.argv[1]
fasta_files = sys.argv[2:]
os.makedirs(output_dir, exist_ok=True)
concatenated_fasta = os.path.join(output_dir, 'concatenated_sequences.fasta')
 
# Define the desired gene order
gene_order = [
    "Tb927.10.13980",
    "Tb927.10.15300",
    "Tb927.9.10660",
    "Tb927.8.3810",
    "Tb927.10.4720",
    "Tb927.11.1940",
    "Tb927.4.980",
    "Tb927.10.1820",
    "Tb927.6.3660",
    "Tb927.1.3230",
    "Tb927.5.1220",
    "Tb927.6.1100",
    "Tb927.11.3980",
    "Tb927.6.2630",
    "Tb927.7.6560",
    "Tb927.10.2810",
    "Tb927.3.4350",
    "Tb927.6.5000",
    "Tb927.8.3480"
]
 
# Step 1: Concatenate all gene sequences from each isolate into a single sequence
with open(concatenated_fasta, 'w') as outfile:
    for fasta_file in fasta_files:
        if fasta_file.endswith('.fasta') or fasta_file.endswith('.fas'):
            concatenated_sequence = ''
            records_dict = SeqIO.to_dict(SeqIO.parse(fasta_file, 'fasta'))
            
            for gene_id in gene_order:
                if gene_id in records_dict:
                    concatenated_sequence += str(records_dict[gene_id].seq)
                else:
                    print(f"Warning: Gene {gene_id} not found in {fasta_file}")
            # Create a new record with the concatenated sequence
            new_record = SeqRecord(
                Seq(concatenated_sequence),
                id=os.path.splitext(fasta_file)[0],  # Use the file name without extension as the ID
                description=''
            )
            SeqIO.write(new_record, outfile, 'fasta')