import os
import sys
from Bio import AlignIO

def calculate_identity(alignment_file, format="fasta"):
    """Calculate alignment identity from a multiple sequence alignment file."""
    try:
        alignment = AlignIO.read(alignment_file, format)
    except FileNotFoundError:
        print(f"Error: File '{alignment_file}' not found")
        return None
    except Exception as e:
        print(f"Error reading '{alignment_file}': {e}")
        return None

    alignment_length = alignment.get_alignment_length()
    matches = sum(1 for i in range(alignment_length) if len(set(alignment[:, i])) == 1)
    identity = (matches / alignment_length) * 100 if alignment_length > 0 else 0

    return identity

def process_directory(input_dir, output_file):
    """Loop over multiple alignment files and save results into a single CSV."""
    with open(output_file, "w") as f:
        f.write("Filename,Identity (%)\n")  # CSV header
        
        for filename in os.listdir(input_dir):
            if filename.endswith(".fasta") or filename.endswith(".aln") or filename.endswith(".afa") or filename.endswith(".fasta.aligned"):
                filepath = os.path.join(input_dir, filename)
                identity = calculate_identity(filepath)
                
                if identity is not None:
                    f.write(f"{filename},{identity:.2f}\n")
                    print(f"Processed: {filename} → {identity:.2f}%")

    print(f"\nAll results saved to {output_file}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python aln_batch.py <input_directory> <output_csv>")
        sys.exit(1)

    input_directory = sys.argv[1]
    output_csv = sys.argv[2]

    process_directory(input_directory, output_csv)