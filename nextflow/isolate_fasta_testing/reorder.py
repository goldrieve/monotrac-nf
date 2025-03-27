import os 
from Bio import SeqIO
import sys 

input_dir = sys.argv[1]
output_dir = sys.argv[2]

os.makedirs(output_dir, exist_ok=True)

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
    "Tb927.8.3480",
    "Tb927.10.14170"
]

for filename in os.listdir(input_dir):
    if filename.endswith('.fasta') or filename.endswith('.fas'):
        input_filepath = os.path.join(input_dir, filename)
        output_filepath = os.path.join(output_dir, filename)

        records_dict = SeqIO.to_dict(SeqIO.parse(input_filepath, 'fasta'))

        reordered_records = [records_dict[gene_id] for gene_id in gene_order if gene_id in records_dict]

        missing_genes = [gene_id for gene_id in gene_order if gene_id not in records_dict]
        if missing_genes:
                print(f"Warning: The following genes were not found in {filename}: {', '.join(missing_genes)}")

        with open(output_filepath, 'w') as output_file:
            SeqIO.write(reordered_records, output_file, 'fasta')
        
        print(f"Processed {filename} -> {output_filepath}")

