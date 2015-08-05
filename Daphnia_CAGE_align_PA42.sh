#!/bin/bash

#PBS -N CAGE_align_PA42v2
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

GENOME=/N/u/rtraborn/Mason/PA42_Workflows/PA42_scaffold2.0.fasta
WD=/N/u/rtraborn/Mason/scratch/Daphnia/CAGE_data/

echo "Indexing the PA42v2.0 assembly"

bwa index $GENOME

cd $WD

echo "Aligning the CAGE reads to PA42"

for FQ in *.fastq
do
bwa aln -t16 -B 3 -n 2 $GENOME -f $(basename $FQ .fastq).sai $FQ
bwa samse $GENOME $(basename $FQ .fastq).sai $FQ |
    samtools view -uS - |
    samtools sort - $(basename $FQ .fastq) && samtools index $(basename $FQ .fastq).bam	
done

echo "Alignment Complete"

echo "Job Complete!"
