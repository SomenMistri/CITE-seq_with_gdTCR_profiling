#!/bin/bash
# Set Partition
#SBATCH --partition=bigmem
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=12
# Request memory
#SBATCH --mem=192G
# Time (please change this according to the demand of the job)
#SBATCH --time 5:00:00
# Name of this job
#SBATCH --job-name=job_name_placeholder   # Update job name to a descriptive one
# Output of this job, stderr and stdout are joined by default
# %x=job-name %j=jobid
#SBATCH --output=%x_%j.out
# Notify me via email -- replace email address here!
#SBATCH --mail-user=your_email@example.com   # Update with your email address
#SBATCH --mail-type=ALL

echo -n "scRNA-Seq QC Pipeline beginning at: "; date

###################################
echo -n "scRNA-Seq cellranger Pipeline beginning at: "; date

###################################
### Data Gathering ###
# Replace the generic path to the analysis folder
cd /path/to/analysis/folder/   # Update to your analysis folder
mkdir raw_data_symlink
cd raw_data_symlink/

echo "Symlinking Raw Data"
# Create symbolic links for the raw data
ln -s /path/to/original/data/*.fastq.gz ./   # Update to the original data path
echo -n "Symlinks created in: "; pwd

# Activate Conda environment
source /path/to/miniconda3/etc/profile.d/conda.sh   # Update Miniconda path
conda activate rnaseq_bulk # make a conda environment for this job and use it every time.

###################################
### FastQC on raw_data###

echo "Running FastQC on raw data..."
fastqc *.fastq.gz
echo "FastQC on raw data complete."

echo "Moving FastQC reports..."
mkdir fastqc_reports_raw_data
mv *fastqc.html fastqc_reports_raw_data/
mv *fastqc.zip fastqc_reports_raw_data/
echo "Moving fastqc reports on raw data complete."

# Perform MultiQC on the FastQC results
cd fastqc_reports_raw_data
multiqc .
cd ..

conda deactivate

echo "FASTQC and MULTIQC complete."

# Move "fastqc_reports_raw_data" folder to the analysis home folder
mv fastqc_reports_raw_data ../

# Note: the "raw_data_symlink" folder will be used for the downstream analysis. So, please keep it.
