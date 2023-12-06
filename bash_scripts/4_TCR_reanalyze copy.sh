#!/bin/bash
# Set Partition
#SBATCH  --partition=bigmem
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=24
# Request memory
#SBATCH --mem=384G
# time (usually it is done in 6-24 hours)
#SBATCH --time 30:00:00
# Name of this job
#SBATCH --job-name=05_18_23_GEX_ADT_TCR_reanalyze 
# Output of this job, stderr and stdout are joined by default
# %x=job-name %j=jobid
#SBATCH --output=%x_%j.out
# Notify me via email -- please change the username!
#SBATCH --mail-user=somen-kumar.mistri@med.uvm.edu
#SBATCH --mail-type=ALL

echo -n "scRNA-Seq cellranger Pipeline beginning at: "; date

echo -n "scRNA-Seq cellranger Pipeline beginning at: "; date

###################################
### Data Gathering ###
#now give absolute path of the parent analysis folder 
cd /gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/
mkdir raw_data_symlink1
cd raw_data_symlink1/

echo "Symlinking Raw Data"
# into this raw_data folder sym link with the original location of the data
ln -s /gpfs1/home/s/m/smistri/data/10X_E17_thymus_repeat_05_18_23/*.fastq.gz ./
echo -n "Symlinks created in: "; pwd
cd ..

### First part
#make "Libraries_GEX_CSP" and "Feature_reference_ADT" (here give only information of ADT antibodies, not hashtags) in csv format files and copy into the analysis folder
###This is using cellranger 4.0.0
/gpfs1/home/s/m/smistri/tools/cellranger/cellranger-4.0.0/cellranger count --id=10X_E17_thymus_repeat_05_18_23_GEX_ADT \
                 --transcriptome=/gpfs1/home/s/m/smistri/reference_sequences/cellranger_references/refdata-gex-mm10-2020-A \
                 --libraries=/gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/Libraries_GEX_CSP2 \
                 --feature-ref=/gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/Feature_reference_ADT \
                 --expect-cells=7000 \
                 --jobmode=local \
                 --localcores=24 \
                 --localmem=14                
                 
##Copy this .sh file to the $analysis folder "/gpfs1/home/s/m/smistri/scratch/10XB6_vs_SAP_KO_E17_thymus_02-08-2021"
##upon logging in to VACC, navigate to the ANALYSIS folder and run " sbatch 3_cellranger_count_script_GEX_ADT_VACC_with_TCR_reanalyze.sh"
##check status of Jobs by running "squeue -u netid"


# Now,remove the raw_data_symlink folder as we don't need it anymore
echo "Deleting the raw_data_symlink folder ..."
rm -r raw_data_symlink1


### Second Part
echo "Running cellranger reanalyze"
# Run Cellranger reanalyze function to remove TCR specific genes such as TRDV, TRAV, TRDC from the gene expression data so that expression of TCR specific genes may not dominate the clustering process. As we will have TCR information from the VDJ data, we can safely do this.
# For this, we have prepared the "ex_TCR_GENES_CSV.csv" file that has all the TCR related genes listed.
# Also, to run this, we have to provide with a filtered_feature_bc_matrix.h5 file that can be found in the "outs" folder of a cellranger count run
/gpfs1/home/s/m/smistri/tools/cellranger/cellranger-4.0.0/cellranger reanalyze --id=10X_E17_thymus_repeat_05_18_23_GEX_ADT_TCR_reanalyze \
                 --matrix=/gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/10X_E17_thymus_repeat_05_18_23_GEX_ADT/outs/filtered_feature_bc_matrix.h5 \
                 --exclude-genes=/gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/ex_TCR_GENES_CSV.csv

echo "The End"