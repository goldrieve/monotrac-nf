import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import seaborn as sns 
import csv

df=pd.read_csv('NCBI_aligns.csv', sep=',', usecols=['Identity (%)', 'SampleName', 'GeneId', 'competency'])

plt.figure(figsize=(12,6))
sns.boxplot(x='competency', y='Identity (%)', data=df, color='gray')
sns.stripplot(x='competency', y='Identity (%)', data=df, hue='SampleName', size=5, jitter=True, alpha=0.6, dodge=False)  # Increased translucency and removed range dots
plt.xticks(rotation=90)
plt.xlabel('Competency')
plt.ylabel('Alingment Rate (%)')

plt.ylim(94, 100)

plt.legend(title="Isolate", bbox_to_anchor=(1, 2), ncol=5)

plt.savefig('boxplotPvM.png', dpi=300, bbox_inches='tight')