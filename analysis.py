import os 
import matplotlib.pyplot as plt 
import pandas as pd 
import numpy as np
import seaborn as sns 
import csv 

csv_dir2 = '../workdir/Mosdepth/'

for isolate in os.listdir(csv_dir2):
    if isolate.endswith('.mosdepth.global.dist.txt'):
        file_path = os.path.join(csv_dir2, isolate)
        df = pd.read_csv(file_path, sep='\t', header=None, usecols=[0, 1, 2])
        plt.figure(figsize=(8, 5))
        sns.lineplot(data=df, x=2, y=1, label=isolate)
        plt.xlabel("Location")
        plt.ylabel("Coverage")
        plt.title("Line Plot for {isolate}")
        plt.savefig(os.path.join(output_dir, filename), dpi=300, bbox_inches='tight')
