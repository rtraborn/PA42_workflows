#!/bin/bash

#!/bin/bash

#PBS -N rRNA_filter_PA42v2_0
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=16,vmem=100gb
#PBS -l walltime=8:00:00
#PBS -q shared
#BS -m abe
#PBS -M rtraborn@indiana.edu

module load samtools

rRNA=/N/u/rtraborn/Mason/scratch/Daphnia/rRNA_seqs/Daphnia_rRNA.fasta 
rRNAdust=$HOME/genome_analysis/rRNAfilter/rRNAdust
sponge=$HOME/genome_analysis/moreutils/sponge
WD=/N/u/rtraborn/Mason/scratch/Daphnia/CAGE_data/bam

cd $WD

for BM in *.bam
do
echo $BM rRNAdust
  ($rRNAdust -t8 $rRNA $BM -e 3 | samtools view -bS - 2> /dev/null | $sponge $(basename $BM .bam).filtered.bam) 2>&1 | sed 's/Excluded: //'
  done | tee complete_rRNA_stats.log


