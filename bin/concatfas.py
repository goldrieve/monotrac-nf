#!/usr/bin/env python

import os
import glob

consensus_dirs = [d for d in os.listdir(".") if os.path.isdir(d) and d.endswith("_CDS")]
if not consensus_dirs:
    print("No consensus directory found!")
    exit(1)

input_directory = consensus_dirs[0]
print(f"Using input directory: {input_directory}")

# Extract directory name for output file
dir_name = os.path.basename(os.path.normpath(input_directory))
output_file = os.path.join(input_directory, f"{dir_name}.fas")  # Output file named after the directory

# Check if the input directory exists
if not os.path.exists(input_directory):
    print(f"The directory {input_directory} does not exist!")
else:
    print(f"Input directory: {input_directory}")

    # List the files in the directory for debugging
    print("Files in directory:", os.listdir(input_directory))

    # Modify the pattern to find .fas files
    fasta_files = glob.glob(os.path.join(input_directory, "*.fas"))
    
    print(f"Found {len(fasta_files)} files.")
    
    if len(fasta_files) > 0:
        with open(output_file, "w") as outfile:
            for fasta_file in fasta_files:
                gene_name = os.path.splitext(os.path.basename(fasta_file))[0]  # Extract filename without extension
                print(f"Processing file: {fasta_file}")
                
                with open(fasta_file, "r") as infile:
                    lines = infile.readlines()
                    sequence = "".join(line.strip() for line in lines if not line.startswith(">"))  # Combine sequence lines
                    outfile.write(f">{gene_name}\n{sequence}\n")
        
        print(f"Combined {len(fasta_files)} FASTA files into {output_file}")
    else:
        print("No .fasta files found.")