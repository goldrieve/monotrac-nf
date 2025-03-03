import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import seaborn as sns 
import csv

# Define the directory containing the CSV files
csv_dir = '.'
output_file = 'combined_data.csv'
 
# List to hold individual DataFrames
dataframes = []
 
# Iterate over each CSV file in the directory
for csv_file in os.listdir(csv_dir):
    if csv_file.endswith('.summary.txt'):
        file_path = os.path.join(csv_dir, csv_file)
       
        # Read the CSV file into a DataFrame
        df = pd.read_csv(file_path, sep='\t')
       
        # Add a new column with the file name (without extension)
        df['source_file'] = os.path.splitext(csv_file)[0].split('.')[0]
       
        # Append the DataFrame to the list
        dataframes.append(df)
 
# Combine all DataFrames into a single DataFrame
combined_df = pd.concat(dataframes, axis=0)

# Save the combined DataFrame to a new CSV file
combined_df.to_csv(output_file, index=False, sep='\t', quoting=csv.QUOTE_NONE, escapechar=' ')

#print(f"Combined data saved to {output_file}")
#print(combined_df)
#sns.boxplot(x='chrom', y='mean', data=combined_df)

data_1 = pd.read_csv('combined_data.csv', sep='\t', usecols=['chrom', 'mean', 'source_file'])
plt.figure(figsize=(12,6))
sns.boxplot(x='chrom', y='mean', data=data_1, color='gray')
sns.stripplot(x='chrom', y='mean', data=data_1, hue='source_file', size=5, jitter=True, )
plt.xticks(rotation=90)
plt.xlabel('Genes')
plt.ylabel('Average coverage')
plt.legend(title="Isolate", bbox_to_anchor=(1, 1))
output_dir="."
filename="plot_1.png"
plt.savefig(os.path.join(output_dir, filename), dpi=300, bbox_inches='tight')