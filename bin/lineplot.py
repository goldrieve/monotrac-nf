import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import seaborn as sns 
import csv

df = pd.read_csv('combined_raw.csv', sep='\t')

plot_data = pd.read_csv('combined_raw.csv', sep='\t', usecols=['GeneID', 'Coverage', 'Location', 'source_file'])

plot_data['GeneID'] = pd.Categorical(plot_data['GeneID'], ordered=True)
num_genes = plot_data['GeneID'].nunique()
num_cols = 5
num_rows = -(-num_genes // num_cols)

g = sns.FacetGrid(plot_data, col='GeneID', hue='source_file', height=4, aspect=1.5, col_wrap=num_cols)
g.map_dataframe(sns.lineplot, x='Location', y='Coverage')
g.add_legend()
output_dir2="."
filename2="depth.png"
plt.savefig(os.path.join(output_dir2, filename2), dpi=300, bbox_inches='tight')