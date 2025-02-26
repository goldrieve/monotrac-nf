import Bio 
from Bio import SeqIO
import os 
import glob 



def get_reference_order(reference_fasta):
    return [record.id for record in SeqIO.parse(reference_fasta, "fasta")]

def reorder_fasta(input_fasta, reference_order, output_fasta):
    seq_dict = {record.id: record for record in SeqIO.parse(input_fasta, "fasta")}
    ordered_records = [seq_dict[gene] for gene in reference_order if gene in seq_dict]
    SeqIO.write(ordered_records, output_fasta, "fasta")

def process_fasta_files(fasta_files, reference_fasta, output_dir="reordered_fastas"):
    os.makedirs(output_dir, exist_ok=True) 
    reference_order = get_reference_order(reference_fasta)

    for fasta_file in fasta_files: 
        output_fasta = os.path.join(output_dir, os.path.basename(fasta_file))
        reorder_fasta(fasta_file, reference_order, output_fasta)
        

fasta_files = glob.glob("C.fasta/*.fas")
reference_fasta = "C.fasta/57AT.fas"
process_fasta_files(fasta_files, reference_fasta)