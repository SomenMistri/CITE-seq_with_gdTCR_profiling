#!/bin/bash
# Set Partition
#SBATCH  --partition=bigmem
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=16
# Request memory
#SBATCH --mem=256G
# time (usually it is done in 6-12 hours)
#SBATCH --time 15:00:00
# Name of this job
#SBATCH --job-name=05-18-2023_10X_E17_thymus_HTO_GEX
# Output of this job, stderr and stdout are joined by default
# %x=job-name %j=jobid
#SBATCH --output=%x_%j.out
# Notify me via email -- please change the username!
#SBATCH --mail-user=somen-kumar.mistri@med.uvm.edu
#SBATCH --mail-type=ALL

echo -n "scRNA-Seq cellranger Pipeline beginning at: "; date

###################################
### Data Gathering ###
#now give absolute path of the parent analysis folder 
cd /gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/
mkdir raw_data_symlink
cd raw_data_symlink/

echo "Symlinking Raw Data"
# into this raw_data folder sym link with the original location of the data
ln -s /gpfs1/home/s/m/smistri/data/10X_E17_thymus_repeat_05_18_23/*.fastq.gz ./
echo -n "Symlinks created in: "; pwd
cd ..




#Go to the scratch folder where you want your output folders to be:
cd /gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23

#make "Libraries_GEX_CSP" and "Feature_reference_HTO" (here give only information on hastags, not ADT antibodies)csv format files and copy into the analysis folder

/gpfs1/home/s/m/smistri/tools/cellranger/cellranger-4.0.0/cellranger count --id=10X_E17_thymus_repeat_05_18_23_GEX_HTO \
                 --transcriptome=/gpfs1/home/s/m/smistri/reference_sequences/cellranger_references/refdata-gex-mm10-2020-A \
                 --libraries=/gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/Libraries_GEX_CSP \
                 --feature-ref=/gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/Feature_reference_HTO \
                 --expect-cells=7000 \
                 --jobmode=local \
                 --localcores=16 \
                 --localmem=14
                 
# Now,remove the raw_data_symlink folder as we don't need it anymore
echo "Deleting the raw_data_symlink folder ..."
rm -r raw_data_symlink

echo "The End"
                
                 
##Copy this .sh file to the $analysis folder
##upon logging in to VACC, navigate to the ANALYSIS folder and run " sbatch 2_cellranger_count_script_GEX_HTO_VACC.sh"
##check status of Jobs by running "squeue -u netid"

