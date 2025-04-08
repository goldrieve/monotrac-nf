from Bio import SeqIO

def split_fasta(input_fasta):
    with open(input_fasta, "r") as fasta_file:
        for record in SeqIO.parse(fasta_file, "fasta"):
            # Clean the header to avoid invalid filename characters
            filename = record.id.split()[0]  
            with open(filename, "w") as output_file:
                SeqIO.write(record, output_file, "fasta")

# Replace 'name in brackets' with the actual filename
split_fasta("SRR24321267_CDS.fas")