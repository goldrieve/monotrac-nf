import os
import pandas as pd

# Directory containing the CSV files
input_dir = '.'
output_file = 'combined.csv'

# List to store dataframes
dataframes = []

# Iterate through all files in the directory
for filename in os.listdir(input_dir):
    if filename.endswith('.csv'):
        file_path = os.path.join(input_dir, filename)
        # Read the CSV file
        df = pd.read_csv(file_path)
        # Add a new column with the filename up to the first underscore
        df['SourceFile'] = filename.split('_')[0]
        # Append the dataframe to the list
        dataframes.append(df)

# Combine all dataframes into one
combined_df = pd.concat(dataframes, ignore_index=True)

# Save the combined dataframe to a new CSV file
combined_df.to_csv(output_file, index=False)

print(f"Combined CSV saved to {output_file}")