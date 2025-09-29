#!/usr/bin/env python

import pandas as pd
import csv
import sys
import os

# Output file name
output_file = "combined.csv"

# List to hold DataFrames
dataframes = []

# Ensure at least one file is provided
if len(sys.argv) < 2:
    print("Error: No input files provided. Usage: python combinecsv.py file1.csv file2.csv ...")
    sys.exit(1)

# Iterate over provided CSV file paths
for file_path in sys.argv[1:]:
    if file_path.endswith('.csv'):
        try:
            df = pd.read_csv(file_path, sep=',')  # Assuming CSV is comma-separated
            
            # Add a column with the file name (without extension)
            file_name = os.path.basename(file_path)
            df['source_file'] = os.path.splitext(file_name)[0]

            # Append to list
            dataframes.append(df)
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            sys.exit(1)

# Combine all DataFrames
combined_df = pd.concat(dataframes, axis=0, ignore_index=True)

# Save output as a tab-separated file
combined_df.to_csv(output_file, index=False, sep='\t', quoting=csv.QUOTE_NONE, escapechar=' ')

print(f"Combined CSV saved as {output_file}")