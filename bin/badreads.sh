for sample in /Volumes/Seagate/monotrac/isolate_fasta_update/merge/*.fas
    
    do

    base=$(basename "$sample" ".fas")

    badread simulate --length 3000,1000 --reference $sample --quantity 20x --glitches 1000,100,100 --junk_reads 5 --random_reads 5 --chimeras 10 --identity 80,90,6 | gzip > VB_syn_reads/${base}.fq.gz

    done 