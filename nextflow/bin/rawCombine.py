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