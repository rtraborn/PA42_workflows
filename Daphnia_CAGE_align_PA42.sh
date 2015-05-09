#!/bin/bash

#PBS -N RTR_ML_batch
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=8,vmem=500gb
#PBS -l walltime=48:00:00
#PBS -q shared
#BS -m abe
#PBS -M rtraborn@indiana.edu


ulimit -s unlimited
module load bwa/0.6.2

WD=/N/dc2/projects/Daphnia_Gene_Expression/CAGE_data/demultiplexed/ 
GENOME=/N/dc2/projects/Daphnia_exon/PA42_assembly/step7_PA42_assembly/PA42_scaffold_1.0.fasta

cd $GENOME
echo "Indexing Genome..."
bwa index $GENOME

cd $WD

for FQ in *.fastq
do
bwa aln -t8 -B 3 -n 3 $GENOME -f $(basename $FQ .fastq).sai $FQ
bwa samse $GENOME $(basename $FS .fastq).sai $FQ
    samtools view -uS - |
    samtools sort - $(basename $FQ .fastq)
done

echo "Job Complete!"

