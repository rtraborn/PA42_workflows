#!/bin/bash

#PBS -N CAGE_align_PA42v3_rRNA_filter
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=16,vmem=200gb
#PBS -l walltime=18:00:00
#PBS -q shared
#BS -m abe
#PBS -M rtraborn@indiana.edu


ulimit -s unlimited
module load bwa/0.6.2
module load samtools
module load java

GENOME=/N/u/rtraborn/Mason/scratch/Daphnia/Daphnia_pulex_PA42_v3.0.fasta
WD=/N/u/rtraborn/Mason/scratch/Daphnia/CAGE_data/fastq
rRNA=/N/u/rtraborn/Mason/scratch/Daphnia/rRNA/Daphnia_rDNA.fasta

cd $WD

echo "Aligning the CAGE reads to PA42"

for FQ in *.fastq
do
bwa aln -t16 -B 3 -n 3 $GENOME -f $(basename $FQ .fastq).sai $FQ
bwa samse $GENOME $(basename $FQ .fastq).sai $FQ |
    samtools view -uS - |
    samtools sort - $(basename $FQ .fastq) && samtools index $(basename $FQ .fastq)	
done

echo "Alignment Complete"

echo "Filtering rRNA reads"

for BM in *.bam
do
echo $BM rRNAdust
  (rRNAdust -t16 $rRNA $BM -e 3 | samtools view -bS - 2> /dev/null | sponge $(basename $BM .bam).filtered.bam) 2>&1 | sed 's/Excluded: //'
  done | tee complete_rRNA_stats.log

echo "rRNA filtering complete"

echo "Job Complete!"
