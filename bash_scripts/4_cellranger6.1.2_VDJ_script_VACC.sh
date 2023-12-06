#!/bin/bash
# Set Partition
#SBATCH  --partition=bigmem
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=16
# Request memory
#SBATCH --mem=256G
# time
#SBATCH --time 15:00:00
# Name of this job
#SBATCH --job-name=VDJ_10X_E17_thymus_repeat_05_18_23
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
mkdir raw_data_symlink2
cd raw_data_symlink2/

echo "Symlinking Raw Data"
# into this raw_data folder sym link with the original location of the data
ln -s /gpfs1/home/s/m/smistri/data/10X_E17_thymus_repeat_05_18_23/*.fastq.gz ./
echo -n "Symlinks created in: "; pwd
cd ..


#run cellranger 7.1.0
/gpfs1/home/s/m/smistri/tools/cellranger/cellranger-6.1.2/cellranger vdj --id=10X_E17_thymus_repeat_05_18_23_VDJ \
                 --fastqs=/gpfs1/home/s/m/smistri/scratch/10X_E17_thymus_repeat_05_18_23/raw_data_symlink2 \
                 --reference=/gpfs1/home/s/m/smistri/reference_sequences/cellranger_references/vdj_IMGT_mouse_custom_2020 \
                 --sample=VDJ \
                 --jobmode=local \
                 --localcores=16 \
                 --localmem=14
                 
                 
# Now,remove the raw_data_symlink folder as we don't need it anymore
echo "Deleting the raw_data_symlink2 folder ..."
rm -r raw_data_symlink2