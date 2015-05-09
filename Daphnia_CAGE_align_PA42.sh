#!/bin/bash

#PBS -N RTR_ML_batch
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=1,vmem=500gb
#PBS -l walltime=48:00:00
#PBS -q shared
#BS -m abe
#PBS -M rtraborn@indiana.edu


ulimit -s unlimited
module load bwa

GENOME=/home/rtraborn/Daphnia/genome_sequence/DP.fasta
for FQ in *.fastq
do
bwa aln -t6 -B 3 $GENOME -f $(basename $FQ .fastq).sai $FQ
bwa samse $GENOME $(basename $FS .fastq).sai $FQ
    samtools view -uS - |
    samtools sort - $(basename $FQ .fastq)
done
