import pandas as pd
import csv
import os
import glob

# Output file name
output_file = "combined.csv"

# Get all CSV files in the current directory
csv_files = glob.glob("*.csv")

# Ensure there are CSV files to process
if not csv_files:
    print("Error: No CSV files found in the current directory.")
    exit(1)

# List to hold DataFrames
dataframes = []

# Iterate over found CSV files
for file_path in csv_files:
    try:
        df = pd.read_csv(file_path, sep=',')  # Assuming CSV is comma-separated
        
        # Add a column with the file name (without extension)
        file_name = os.path.basename(file_path)
        df['source_file'] = os.path.splitext(file_name)[0]

        # Append to list
        dataframes.append(df)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        exit(1)

# Combine all DataFrames
combined_df = pd.concat(dataframes, axis=0, ignore_index=True)

# Save output as a tab-separated file
combined_df.to_csv(output_file, index=False, sep=',', quoting=csv.QUOTE_NONE, escapechar=' ')

print(f"Combined CSV saved as {output_file} in {os.getcwd()}")