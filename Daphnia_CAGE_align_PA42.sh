#!/bin/bash

#PBS -N RTR_PA42_CAGE_align
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=8,vmem=500gb
#PBS -l walltime=36:00:00
#PBS -q shared
#BS -m abe
#PBS -M rtraborn@indiana.edu


ulimit -s unlimited
module load bwa/0.6.2
module load samtools

WD=/N/dc2/projects/Daphnia_Gene_Expression/CAGE_data/demultiplexed/
GENOME=PA42_scaffold_1.0.fasta

cd $WD

echo "Indexing Genome"

bwa index $GENOME

echo "Aligning the reads"

for FQ in *.fastq
do
bwa aln -t8 -B 3 -n 3 $GENOME -f $(basename $FQ .fastq).sai $FQ
bwa samse $GENOME $(basename -s $FQ .fastq).sai $FQ
    samtools view -uS - |
    samtools sort - $(basename -s $FQ .fastq)
done

echo "Job Complete!"

