#!/bin/bash
# Set Partition
#SBATCH --partition=bigmem
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=16
# Request memory
#SBATCH --mem=256G # 16x16=256
# Time
#SBATCH --time 10:00:00
# Name of this job
#SBATCH --job-name=job_name_placeholder  # Update to a descriptive job name
# Output of this job, stderr and stdout are joined by default
# %x=job-name %j=jobid
#SBATCH --output=%x_%j.out
# Notify via email -- replace the email address!
#SBATCH --mail-user=your_email@example.com  # Update with your email address
#SBATCH --mail-type=ALL

echo -n "scRNA-Seq cellranger vdj Pipeline beginning at: "; date

###################################
# Provide the absolute path of the parent analysis folder
cd /path/to/analysis/folder/  # Update to your analysis folder

# Note: Check whether the the "raw_data_symlink" folder is present in this folder which was created in the 2_data_FastQC_MultiQC step.

# Run cellranger vdj 7.1.0 (cellranger 7.1.0 has been tested to work with γδ TCR)
/path/to/cellranger/cellranger-7.1.0/cellranger vdj --id=VDJ_output \
                 --fastqs=/path/to/analysis/folder/raw_data_symlink2 \
                 --reference=/path/to/reference_sequences/cellranger_references/vdj_IMGT_mouse_custom_2020 \
                 --sample=VDJ \ # edit based on the name of sample fq.gz files
                 --jobmode=local \
                 --localcores=16 \
                 --localmem=14
                 

echo "The End"