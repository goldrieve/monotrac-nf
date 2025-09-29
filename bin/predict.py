#!/usr/bin/env python

import sys 
import pandas as pd 
import joblib 
import os 

script_dir = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join("ml.pkl")

model = joblib.load(model_path)  

expected_columns = model.feature_names_in_

if len(sys.argv) <2 : 
    print("Error: No input files provided.")
    sys.exit(1)

for input_files in sys.argv[1:]:
    try:
        data = pd.read_csv(input_files, sep=',', header=0)
        missing_columns = set(expected_columns) - set(data.columns)
        for col in missing_columns:
            data[col] = 0
        data = data[expected_columns]

        predictions = model.predict(data)

        output_files = f"{os.path.basename(input_files).replace('_AA_counts.csv', '_prediction.txt')}"
        print(f"\n Prediction for {input_files} (from {output_files}):\n")
        print("\n".join(predictions)) 

        with open(output_files, 'w') as f: 
            for pred in predictions:
                f.write(f"{pred}\n")

    except Exception as e:
        print(f"Error reading {input_files}: {e}")

