import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import seaborn as sns 
import csv

csv_dir = '.'
output2_file = 'combined_raw.csv'
dataframes = []

for csv_file in os.listdir(csv_dir):
    if csv_file.endswith('.mosdepth.global.dist.txt'):
        file_path = os.path.join(csv_dir, csv_file)
        df = pd.read_csv(file_path, names=['GeneID', 'Coverage', 'Location'], sep='\t')
        df['source_file'] = os.path.splitext(csv_file)[0].split('.')[0]
        dataframes.append(df)

combined_df = pd.concat(dataframes, axis=0)
combined_df.to_csv(output2_file, index=False, sep='\t', quoting=csv.QUOTE_NONE, escapechar=' ')

plot_data = pd.read_csv('combined_raw.csv', sep='\t', usecols=['GeneID', 'Coverage', 'Location', 'source_file'])

plot_data['GeneID'] = pd.Categorical(plot_data['GeneID'], ordered=True)
num_genes = plot_data['GeneID'].nunique()
num_cols = 5
num_rows = -(-num_genes // num_cols)

g = sns.FacetGrid(plot_data, col='GeneID', hue='source_file', height=4, aspect=1.5, col_wrap=num_cols)
g.map_dataframe(sns.lineplot, x='Location', y='Coverage')
g.add_legend()
output_dir2="Plots"
filename2="plot_2.png"
plt.savefig(os.path.join(output_dir2, filename2), dpi=300, bbox_inches='tight')