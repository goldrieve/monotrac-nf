from Bio import SeqIO

def split_fasta(input_fasta):
    with open(input_fasta, "r") as fasta_file:
        for record in SeqIO.parse(fasta_file, "fasta"):
            # Clean the header to avoid invalid filename characters
            filename = f"{record.id}.fasta"
            with open(filename, "w") as output_file:
                SeqIO.write(record, output_file, "fasta")

# Replace 'your_file.fasta' with the actual filename
split_fasta("your_file.fasta")