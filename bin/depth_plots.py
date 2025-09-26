import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import seaborn as sns 
import glob
import sys

# getting the python scrypt to loop over the consensus files
if len(sys.argv) < 2:
    print("Usage: python script.py <base>")
    sys.exit(1)

# Get the base name from the command line
base = sys.argv[1]  
print(f"Base is: {base}")

# Stripping the name down to raw read code 
filename = os.path.basename(base)  
base_name = filename.split('.')[0]

# defining what data to plot 
plotting_data = pd.read_csv(base, names=['GeneID', 'Coverage', 'Location'], sep='\t')   

# Facet grid means for each sample a line plot will be made for each gene  
g = sns.FacetGrid(plotting_data, col='GeneID', col_wrap=5, height=4, sharex=False, sharey=False)  
g.map_dataframe(sns.lineplot, x='Location', y='Coverage')
g.add_legend()

# Outputs the graphs to the Depth_plots directory and names them after the raw reads codes  
output_dir = "."
output_file = os.path.join(output_dir, f"{base_name}.mosdepth.global.dist.png")
plt.savefig(output_file, dpi=300, bbox_inches='tight')


 