#!/usr/bin/env python

import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import seaborn as sns 
import csv
import sys

csv_dir = '.'
output2_file = 'combined_raw.csv'
dataframes = []

for file_path in sys.argv[1:]:
    if file_path.endswith('.mosdepth.global.dist.txt'):


        df = pd.read_csv(file_path, names=['GeneID', 'Coverage', 'Location'], sep='\t')

        file_name = os.path.basename(file_path)
        df['source_file'] = os.path.splitext(file_path)[0].split('.')[0]

        dataframes.append(df)

combined_df = pd.concat(dataframes, axis=0)
combined_df.to_csv(output2_file, index=False, sep='\t', quoting=csv.QUOTE_NONE, escapechar=' ')