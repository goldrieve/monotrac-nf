import os
from Bio import SeqIO

def split_fasta_in_directory(input_dir, output_dir):
    """Process all FASTA files in a directory and save sequences as separate files."""
    os.makedirs(output_dir, exist_ok=True)  # Ensure output directory exists

    for filename in os.listdir(input_dir):  # Loop over all files in the directory
        if filename.endswith(".fas") or filename.endswith(".fasta"):  # Check file type
            input_fasta = os.path.join(input_dir, filename)  # Full path to input file
            base_name = os.path.splitext(filename)[0]  # Get filename without extension

            with open(input_fasta, "r") as fasta_file:
                for record in SeqIO.parse(fasta_file, "fasta"):
                    gene_id = record.id.split()[0]  # Get sequence ID (gene name)
                    output_filename = f"{base_name}_{gene_id}.fasta"  # Construct output filename
                    output_path = os.path.join(output_dir, output_filename)  # Full path to output file
                    
                    with open(output_path, "w") as output_file:
                        SeqIO.write(record, output_file, "fasta")
                    
                    print(f"Saved: {output_path}")  # Print progress

def process_multiple_directories(input_dirs, output_base_dir):
    """Loop over multiple directories and process them one by one."""
    for input_dir in input_dirs:
        dir_name = os.path.basename(os.path.normpath(input_dir))  # Get last folder name
        output_dir = os.path.join(output_base_dir, dir_name)  # Create output subdir for each input
        print(f"\nProcessing directory: {input_dir} -> Output: {output_dir}")
        split_fasta_in_directory(input_dir, output_dir)

# Example usage:
input_directories = ["/Volumes/Seagate/monotrac/nextflow/isolate_fasta_testing/OG_isolate_fas", "/Volumes/Seagate/monotrac/nextflow/isolate_fasta_testing/SR_isolate_fas"]
output_base_directory = "/Volumes/Seagate/monotrac/nextflow/isolate_fasta_testing/split_output"

process_multiple_directories(input_directories, output_base_directory)