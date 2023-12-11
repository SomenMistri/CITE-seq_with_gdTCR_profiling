#!/bin/bash
# Set Partition
#SBATCH --partition=bigmem
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=16
# Request memory
#SBATCH --mem=256G # 16x16=256
# Time (estimated duration: quick)
#SBATCH --time 2:00:00
# Name of this job
#SBATCH --job-name=job_name_placeholder  # Update to a descriptive job name
# Output of this job, stderr and stdout are joined by default
# %x=job-name %j=jobid
#SBATCH --output=%x_%j.out
# Notify via email -- replace the email address!
#SBATCH --mail-user=your_email@example.com  # Update with your email address
#SBATCH --mail-type=ALL

echo -n "scRNA-Seq cellranger count Pipeline beginning at: "; date

###################################
# Provide the absolute path of the parent analysis folder
cd /path/to/analysis/folder/  # Update to your analysis folder

echo "Running cellranger reanalyze"
# Run Cellranger reanalyze function to remove TCR specific genes such as TRDV, TRAV, TRDC from the gene expression data so that expression of TCR specific genes may not dominate the clustering process. As we will have TCR information from the VDJ data, we can safely do this.
# For this, we have prepared the "ex_TCR_GENES_CSV.csv" file that has all the TCR related genes listed.
# Also, to run this, we have to provide with a filtered_feature_bc_matrix.h5 file that can be found in the "outs" folder of a cellranger count run
/path/to/cellranger/cellranger-7.1.0/cellranger reanalyze --id=Reanalyze_ADT_GEX_output \
                 --matrix=/path/to//outs/filtered_feature_bc_matrix.h5 \
                 --exclude-genes=/path/to/analysis/folder/ex_TCR_GENES_CSV.csv

echo "The End"