#!/usr/bin/env python

import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import seaborn as sns 
import csv

df = pd.read_csv('combined_data.csv', sep='\t')
 
data_1 = pd.read_csv('combined_data.csv', sep='\t', usecols=['chrom', 'mean', 'source_file'])
plt.figure(figsize=(12,6))
sns.boxplot(x='chrom', y='mean', data=data_1, color='gray')
sns.stripplot(x='chrom', y='mean', data=data_1, hue='source_file', size=5, jitter=True, )
plt.xticks(rotation=90)
plt.xlabel('Genes')
plt.ylabel('Average coverage')
plt.legend(title="Isolate", bbox_to_anchor=(1, 1))
output_dir="."
filename="boxplot.png"
plt.savefig(os.path.join(output_dir, filename), dpi=300, bbox_inches='tight')


