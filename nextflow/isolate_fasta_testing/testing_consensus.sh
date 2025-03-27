
# remember that conda environment will have to change  
#rename 's/CDS_//' *.fasta >>> for removing the CDS part of the process fasta files when it comes to it  

for sample in /Volumes/Seagate/monotrac/nextflow/isolate_fasta_testing/split_output/OG_isolate_fas/*.fasta
 
    do
    base=$(basename "$sample")
    dir="/Volumes/Seagate/monotrac/nextflow/isolate_fasta_testing"
    

    cat $dir/split_output/OG_isolate_fas/${base} $dir/split_output/SR_isolate_fas/${base} > $dir/combined/${base}.input.fasta
    mafft --auto $dir/combined/${base}.input.fasta > aligned/${base}.aligned 
done
