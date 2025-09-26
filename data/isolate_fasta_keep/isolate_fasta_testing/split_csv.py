import pandas as pd

# Define the file paths
alignments_csv = "/Volumes/Seagate/monotrac/nextflow/isolate_fasta_testing/ncbi_output.csv"
competency_csv = "/Volumes/Seagate/monotrac/nextflow/Good_ncbi_output/Isolate_Morphology/finaloutput.csv" ####### this needs to change to the atual competencies my pipeline predicts!!!
output_csv = "/Volumes/Seagate/monotrac/nextflow/isolate_fasta_testing/NCBI_aligns.csv"

# Read the alignments and competency CSV files
alignments_df = pd.read_csv(alignments_csv)
competency_df = pd.read_csv(competency_csv)

# Split the 'Filename' column into 'SampleName' and 'GeneId'
alignments_df[['SampleName', 'GeneId']] = alignments_df['Filename'].str.split('_Tb927', expand=True)
alignments_df['GeneId'] = 'Tb927' + alignments_df['GeneId']  # Add 'Tb927' back to the GeneId column

# Remove the '.fasta.aligned' part from the 'GeneId' column
alignments_df['GeneId'] = alignments_df['GeneId'].str.replace('.fasta', '', regex=False)

# Drop the 'Filename' column
alignments_df = alignments_df.drop(columns=['Filename'])

# Merge the competency data into the alignments DataFrame
merged_df = alignments_df.merge(competency_df, left_on='SampleName', right_on='isolate', how='left')

# Drop the redundant 'isolate' column after the merge
merged_df = merged_df.drop(columns=['isolate'])

# Save the updated DataFrame to a new CSV file
merged_df.to_csv(output_csv, index=False)

print(f"Updated CSV with competency column saved to {output_csv}")