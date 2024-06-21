#! /bin/bash
#The parent directory should have "raw_data.txt" file and "barcodes.tsv.gz" file (copied from "0_Cellranger_4_0_0_output/Gene_expression_HTO_output/HTO_filtered_feature_bc_matrix" folder 

####READ before running this script
#The cellranger vdj output of cellranger 3.0.2 and cellranger 6.1.2/7.1.0 is different
#in cellranger 6.1.2/7.1.0, the filtered_contig_annotations.csv file is not useful
#however, the all_contig_annotations.csv file is useful.
#The problem is that the format (column names) of this all_contig_annotations.csv file is not compatible with this script.
#To circumvent this problem, first change (delete columns, Add "None" text where Blank cells are) the all_contig_annotations.csv file needs to be modified according to the template.txt file
#Note: Make convert the the "productive" column values from "FASLE" to "TRUE" for all rows
#Finally, save the modified all_contig_annotations.csv file as raw_data.txt file
########### STEP 1 ##################
#####Isolate productive CDR3 containing rows######
#the raw_data.txt file has to have certain header columns. Please reformat any raw data as the sample.txt file
#use cd to navigate to the folder where cellranger VDJ (V3.0) output is located and convert that csv output to tab delimited text
#Then rename the file as raw_data.txt

#using cd navigate to the parent folder where "barcodes.tsv.gz" and "raw_data.txt" files are located
mkdir "output_folder"
#First, I want to keep only productive "TRUE" rows
#in awk "==" means equal to and "!=" means not equal to
#The following awk code will go to column 12 (productive) and print all lines that says "TRUE" in that column
awk '$12 == "TRUE" { print $0}' raw_data.txt > data_productive.txt
#now move the original data to a folder for future reference

########### STEP 2 ##################
#####Separate TRGV and TRD containing rows######
#make a folder where the input file of this step will be moved after finishing the step
mkdir "data_productive"
#now take the data_productive.txt file and separate TRGV reads and TRDV/TRAV reads
#Separate TRDV or TRGV reads from mix of TRGV and TRDV read lines (change the name TRDV or TRGV as needed). Using grep -i 'TRGV' selects lines with TRGV reads only
#Also I can use grep -E 'TRDV|TRAV' to find TRDV or TRAV reads
grep -E 'TRDV|TRAV' data_productive.txt > productive_TRDV_TRAV.txt
grep -E 'TRGV' data_productive.txt > productive_TRGV.txt
mv data_productive.txt data_productive


########### STEP 3 ##################
#####Separate reads based on unique barcodes for both TRGV and TRSDV######
#make a new folder where you want to put the barcode demultiplexed .txt file
mkdir "Separated_TRGV_TRDV"
mkdir "Barcode_seperated_TRGV"
mkdir "Barcode_seperated_TRDV"

#First for productive_TRGV.txt file
#Based on the fist column ($1), the raw file is going to be demultiplexed and each file will have all the lines that correspond to one unique barcode
awk -F '\t' '
    fname != "Barcode_seperated_TRGV/" $1".txt" {
        if (fname != "")
            close(fname)
        fname = "Barcode_seperated_TRGV/" $1".txt"
    }
    { print >fname }' productive_TRGV.txt

#Second for productive_TRDV_TRAV.txt file
#Based on the fist column ($1), the raw file is going to be demultiplexed and each file will have all the lines that correspond to one unique barcode
awk -F '\t' '
    fname != "Barcode_seperated_TRDV/" $1".txt" {
        if (fname != "")
            close(fname)
        fname = "Barcode_seperated_TRDV/" $1".txt"
    }
    { print >fname }' productive_TRDV_TRAV.txt

#Now move the input files of this step to a folder
mv productive_TRGV.txt Separated_TRGV_TRDV
mv productive_TRDV_TRAV.txt Separated_TRGV_TRDV

########### STEP 4 ##################
########### add new row with max contig number information######
#for TRGV first
#Now I want to identify barcode files that have 1,2 or more than 2 contigs (lines)
#Before doing that, first I am gonna add row number to each file (1, 2, 3, etc)
#Then I will ask max value of row number in each file and add that number to each row of that file.
#Later, using this max value, we can separate singlet, doublet and multilet
#using CD navigate to the "Barcode_seperated_TRGV" folder for TRGV files
cd ./Barcode_seperated_TRGV
mkdir "Barcode_seperated_TRGV_raw"
input="*.txt"
for f in $input
do
prefix=`basename $f .txt`
#add row number to each line
awk '{print $1=(FNR)"\t"$0}' OFS='\t' ${prefix}.txt > ${prefix}_row.txt
#identify max value in column 1 ($1) and then add that max value to each row of each file (finally remove the input)
awk -v max=$(awk 'BEGIN{a=   0}{if ($1>0+a) a=$1} END{print a}' OFS='\t' ${prefix}_row.txt) '{print $1=max"\t"$0}' OFS='\t' ${prefix}_row.txt > ${prefix}_row_max.txt
rm ${prefix}_row.txt
#now label single, double or multiple contig conaining files
#in awk "==" means equal to and "!=" means not equal to
awk '$1 == "1" { print "single" "\t" $0}' OFS='\t' ${prefix}_row_max.txt >> ${prefix}_row_max_TRGV.txt
awk '$1 == "2" { print "double" "\t" $0}' OFS='\t' ${prefix}_row_max.txt >> ${prefix}_row_max_TRGV.txt
awk '$1 > "2" { print "multi" "\t" $0}' OFS='\t' ${prefix}_row_max.txt >> ${prefix}_row_max_TRGV.txt
rm ${prefix}_row_max.txt
#Now add a new column at 1st position with frequency of total read per barcode (remove input file at the end)
awk -v sum=$(awk '{count=count+$18}END{print count}' ${prefix}_row_max_TRGV.txt) '{print $1=$18/sum"\t"$0}' ${prefix}_row_max_TRGV.txt > ${prefix}_contig_freq.txt
rm ${prefix}_row_max_TRGV.txt

#Now i want to sort based on highest frequency value in a file and then take the top line and print (append) it into a common file
#now sort them from highest read count to low (read count is in 1st column)
sort -t $'\t' -k1,1rn ${prefix}_contig_freq.txt > ${prefix}_contig_sort.txt
rm ${prefix}_contig_freq.txt
#Now I am appending all the lines (first line) from all the files to one single file
sed -n '1p' ${prefix}_contig_sort.txt >> TRGV_processed.txt
rm ${prefix}_contig_sort.txt
mv ${prefix}.txt Barcode_seperated_TRGV_raw
done
#now remove column 2 and 3 that has max contig id and row number
cut -d$'\t' -f1-2,5-22-  TRGV_processed.txt > TRGV_processed_delete.txt
#add header column
awk 'BEGIN {print "contig_freq_g\tcontig_type_g\tbarcode\tis_cell_g\tcontig_id_g\thigh_confidence_g\tlength_g\tchain_g\tv_gene_g\td_gene_g\tj_gene_g\tc_gene_g\tfull_length_g\tproductive_g\tcdr3_g\tcdr3_nt_g\treads_g\tumis_g\traw_clonotype_id_g\traw_consensus_id_g"} {print}' TRGV_processed_delete.txt > TRGV_processed_header.txt
#remove intermediate files
rm TRGV_processed.txt
rm TRGV_processed_delete.txt
#reorder columns to bring barcode column to first position
awk 'BEGIN { FS = "\t"; OFS = "\t" } { print $3, $1, $2, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20 }' TRGV_processed_header.txt > TRGV_processed_header_reordered.txt
rm TRGV_processed_header.txt
#Now move the final header containing files to output file
mv TRGV_processed_header_reordered.txt ../output_folder



########### STEP 5 ##################
#for both TRDV second
#using CD navigate to the "Barcode_seperated_TRDV" folder for TRGV files
cd ../Barcode_seperated_TRDV
mkdir "Barcode_seperated_TRDV_raw"
input="*.txt"
for f in $input
do
prefix=`basename $f .txt`
#add row number to each line
awk '{print $1=(FNR)"\t"$0}' OFS='\t' ${prefix}.txt > ${prefix}_row.txt
#identify max value in column 1 ($1) and then add that max value to each row of each file (finally remove the input)
awk -v max=$(awk 'BEGIN{a=   0}{if ($1>0+a) a=$1} END{print a}' OFS='\t' ${prefix}_row.txt) '{print $1=max"\t"$0}' OFS='\t' ${prefix}_row.txt > ${prefix}_row_max.txt
rm ${prefix}_row.txt
#now label single, double or multiple contig conaining files
#in awk "==" means equal to and "!=" means not equal to
awk '$1 == "1" { print "single" "\t" $0}' OFS='\t' ${prefix}_row_max.txt >> ${prefix}_row_max_TRDV.txt
awk '$1 == "2" { print "double" "\t" $0}' OFS='\t' ${prefix}_row_max.txt >> ${prefix}_row_max_TRDV.txt
awk '$1 > "2" { print "multi" "\t" $0}' OFS='\t' ${prefix}_row_max.txt >> ${prefix}_row_max_TRDV.txt
rm ${prefix}_row_max.txt
#Now add a new column at 1st position with frequency of total read per barcode (remove input file at the end)
awk -v sum=$(awk '{count=count+$18}END{print count}' ${prefix}_row_max_TRDV.txt) '{print $1=$18/sum"\t"$0}' ${prefix}_row_max_TRDV.txt > ${prefix}_contig_freq.txt
rm ${prefix}_row_max_TRDV.txt

#Now i want to sort based on highest frequency value in a file and then take the top line and print (append) it into a common file
#now sort them from highest read count to low (read count is in 1st column)
sort -t $'\t' -k1,1rn ${prefix}_contig_freq.txt > ${prefix}_contig_sort.txt
rm ${prefix}_contig_freq.txt
#Now I am appending all the lines (first line) from all the files to one single file
sed -n '1p' ${prefix}_contig_sort.txt >> TRDV_processed.txt
rm ${prefix}_contig_sort.txt
mv ${prefix}.txt Barcode_seperated_TRDV_raw
done
#now remove column 2 and 3 that has max contig id and row number
cut -d$'\t' -f1-2,5-22-  TRDV_processed.txt > TRDV_processed_delete.txt
#add header column
awk 'BEGIN {print "contig_freq_d\tcontig_type_d\tbarcode\tis_cell_d\tcontig_id_d\thigh_confidence_d\tlength_d\tchain_d\tv_gene_d\td_gene_d\tj_gene_d\tc_gene_d\tfull_length_d\tproductive_d\tcdr3_d\tcdr3_nt_d\treads_d\tumis_d\traw_clonotype_id_d\traw_consensus_id_d"} {print}' TRDV_processed_delete.txt > TRDV_processed_header.txt
#reorder columns to bring barcode column to first position
awk 'BEGIN { FS = "\t"; OFS = "\t" } { print $3, $1, $2, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20 }' TRDV_processed_header.txt > TRDV_processed_header_reordered.txt
rm TRDV_processed_header.txt
#Now move the final header containing files to output file
mv TRDV_processed_header_reordered.txt ../output_folder

#########STEP 6#########

#####Adding metadata#########
#going back to parent directory
cd ..
#copy the barcodes.tsv.gz file to output_folder
cp barcodes.tsv.gz ./output_folder
#go to that directory and extract the barcodes.tsv.gz file
cd ./output_folder
#make a directory to keep the barcode matched files
mkdir "barcode_matched_with_gex"
gunzip barcodes.tsv.gz
#add header column to barcodes.tsv file
awk 'BEGIN {print "barcode\tempty"} {print}' barcodes.tsv > barcodes_header.txt
#now for both TRGV and TRDV files
input="*_reordered.txt"
for f in $input
do
prefix=`basename $f .txt`
#add row number to each line
#match barcode information
awk ' BEGIN { FS = "\t"; OFS = "\t" } {if (NR==FNR) {a[$1]=$0; next} {print $1 "\t" a[$1]}}' ${prefix}.txt barcodes_header.txt > ${prefix}_barcode_matched.txt

#remove second column and save the output to "barcode_matched_with_gex" folder
cut -d$'\t' -f1,3-21-  ${prefix}_barcode_matched.txt > ./barcode_matched_with_gex/${prefix}_barcode_matched_final.txt
rm ${prefix}_barcode_matched.txt
done

# Now remove intermediate files and folders. If needed for troubleshooting, delete the following commands
cd .
rm -r data_productive
rm -r Separated_TRGV_TRDV
rm -r Barcode_seperated_TRGV
rm -r Barcode_seperated_TRDV

#Go to /output_folder/barcode_matched_with_gex/ 
#Use excel to join the two final files side by side and replace "blank" field to NA
#further editing will take place in excel  