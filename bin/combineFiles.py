import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import seaborn as sns 
import csv
import sys

# Define the directory containing the CSV files
csv_dir = '.'
output_file = 'combined_data.csv'
 
# List to hold individual DataFrames
dataframes = []
 
# Iterate over each CSV file in the directory
for file_path in sys.argv[1:]:
    if file_path.endswith('.summary.txt'):
        
        df = pd.read_csv(file_path, sep='\t')
       
        # Add a new column with the file name (without extension)
        file_name = os.path.basename(file_path)
        df['source_file'] = os.path.splitext(file_path)[0].split('.')[0]
       
        # Append the DataFrame to the list
        dataframes.append(df)
 
# Combine all DataFrames into a single DataFrame
combined_df = pd.concat(dataframes, axis=0)

# Save the combined DataFrame to a new CSV file
combined_df.to_csv(output_file, index=False, sep='\t', quoting=csv.QUOTE_NONE, escapechar=' ')