#!/bin/bash

#PBS -N CAGE_align_PA42
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=8,vmem=100gb
#PBS -l walltime=18:00:00
#PBS -q shared
#BS -m abe
#PBS -M rtraborn@indiana.edu


ulimit -s unlimited
module load bwa/0.6.2
module load samtools

GENOME=PA42_scaffold_1.0.fasta
WD=/N/u/rtraborn/Mason/scratch/Daphnia/CAGE_data/

cd $WD

echo "Aligning the CAGE reads to PA42"

for FQ in *.fastq
do
bwa aln -t8 -B 3 -n 3 $GENOME -f $(basename $FQ .fastq).sai $FQ
bwa samse $GENOME $(basename $FQ .fastq).sai $FQ |
    samtools view -ub - |
    samtools sort - $(basename $FQ .fastq) && samtools index $(basename $FQ .fastq).bam	
done

echo "Alignment Complete"

echo "Job Complete!"
