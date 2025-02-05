# concatenating the isolate fasta files into one large file removing the gene headers and adding headers for the name of each isolate.

for file in *.fas

    do 

    echo ">${file%%.*}" >> concatenated_genomes.fasta
    awk '!/^>/ {print}' "$file" >> concatenated_genomes.fasta

done