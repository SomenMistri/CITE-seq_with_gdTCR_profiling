#!/bin/bash
# Set Partition
#SBATCH --partition=bigmem
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=16
# Request memory
#SBATCH --mem=256G # 16x16=256
# Time (estimated duration: 6-12 hours)
#SBATCH --time 15:00:00
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

# Note: Check whether the the "raw_data_symlink" folder is present in this folder which was created in the 2_data_FastQC_MultiQC step.

# Create "Libraries_GEX_CSP" and "Feature_reference_HTO" CSV files and copy them into the analysis folder

/path/to/cellranger/cellranger-7.1.0/cellranger count --id=ADT-GEX_output \
                 --transcriptome=/path/to/reference_sequences/cellranger_references/refdata-gex-mm10-2020-A \ #Downloaded from cellranger website with references
                 --libraries=/path/to/analysis/folder/Libraries_GEX_CSP \
                 --feature-ref=/path/to/analysis/folder/Feature_reference_ADT \
                 --expect-cells=7000 \ # Depends on your expected number of cells
                 --jobmode=local \
                 --localcores=16 \ # keep this the same as above
                 --localmem=14 # using a localmem of 14 instead of the full 16 worked better for me

echo "The End"

## Copy this .sh file to the $analysis folder
## Upon logging in to VACC, navigate to the ANALYSIS folder and run "sbatch 3.1_cellranger_count_GEX_HTO.sh"
## Check the status of jobs by running "squeue -u netid"

