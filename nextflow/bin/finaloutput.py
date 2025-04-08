import os
import csv
import sys

# Check for correct usage
if len(sys.argv) != 3:
    print("Usage: python finaloutput.py <input_directory> <output_csv>")
    sys.exit(1)

# Get input directory and output CSV file from command-line arguments
input_directory = sys.argv[1]
output_csv = sys.argv[2]

# Initialize a list to store rows for the CSV
rows = []

# Iterate over all .txt files in the directory
for filename in os.listdir(input_directory):
    if filename.endswith(".txt"):
        file_path = os.path.join(input_directory, filename)
        with open(file_path, 'r') as file:
            content = file.read().strip()  # Read and strip content
        
        # Get filename without extension
        sample_name = os.path.splitext(filename)[0]
        
        # Strip off "predictions_" from the start and "_CDS_AA_counts" from the end
        if sample_name.startswith("predictions_"):
            sample_name = sample_name[len("predictions_"):]
        if sample_name.endswith("_CDS_AA_counts"):
            sample_name = sample_name[: -len("_CDS_AA_counts")]
        
        # Append the processed sample name and content to rows
        rows.append([sample_name, content])

# Write rows to the output CSV file
with open(output_csv, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["isolate", "competency"])  # Write header
    writer.writerows(rows)  # Write data rows

print(f"CSV file created at: {output_csv}")