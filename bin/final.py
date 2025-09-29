#!/usr/bin/env python

import pandas as pd
import sys
import os
import csv

if len(sys.argv) < 3:
    print("Usage: python final.py <file1> <file2> ... <output_file>")
    sys.exit(1)

*files, output_file = sys.argv[1:]

dataframes = []

for file_path in files:
    if file_path.endswith('.txt'):
        with open(file_path, 'r') as f:
            content = f.read().strip()
        file_name = os.path.basename(file_path)
        df = pd.DataFrame([[file_name, content]], columns=['file_name', 'content'])
        dataframes.append(df)

combined_df = pd.concat(dataframes, axis=0)
combined_df.to_csv(output_file, index=False, sep='\t', quoting=csv.QUOTE_NONE, escapechar=' ')

