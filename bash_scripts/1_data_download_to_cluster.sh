# Use "cyberduck" or "filezilla" or similar tool to visualize the files in UVM VACC computing cluster
# Open your terminal and Log into VACC by typing this
ssh USERNAME@vacc-server.uvm.edu #when prompted, give password

# Navigate to data_folder and make data sub-folder
cd /gpfs1/home/USERNAME/data
mkdir "project_folder"

# navigate into the data_subfolder and download raw data files to the data_subfolder
# the raw data files (with stat and reports) links are usually found in ilab or email sent from the genomics core
cd /gpfs1/home/USERNAME/data/project_folder
wget https://example.com/raw_data_file.tar.gz

# Code for downloading file from password protected links
wget --user=USERNAME --ask-password --no-parent -r https://example.com/password_protected_link/

# Now navigate into raw_data_folder and run extraction code
cd /gpfs1/home/USERNAME/data/project_folder
tar -xvzf raw_data_file.tar.gz

# If you need to concatenate files from two or more runs, you can use commands similar to the following example
cat ./run1/RNA/file1.fastq.gz ./run2/RNA/file2.fastq.gz > merged_file.fastq.gz

# Replace “USERNAME”, “vacc-server.uvm.edu”, and “example.com” with the appropriate username, server domain, and links respectively as per your specific requirements.