#!/bin/bash

#PBS -N PA42_genome_index
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=1,vmem=500gb
#PBS -l walltime=4:00:00
#PBS -q shared
#BS -m abe
#PBS -M rtraborn@indiana.edu

ulimit -s unlimited
module load bwa/0.6.2

GENOME=PA42_scaffold_1.0.fasta

bwa index $GENOME

echo "Job Complete!"

