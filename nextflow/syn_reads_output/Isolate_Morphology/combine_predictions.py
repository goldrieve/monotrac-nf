import os
import glob

output_file = "combined_predictions.txt"
input_files = glob.glob("predictions_*.txt")

with open(output_file, 'w') as outfile:
    for fname in input_files:
        base_name = os.path.basename(fname).replace('predictions_', '').replace('_CDS_AA_counts.txt', '')
        with open(fname) as infile:
            outfile.write(f"Prediction from {base_name}:\n")
            outfile.write(infile.read())
            outfile.write("\n\n")