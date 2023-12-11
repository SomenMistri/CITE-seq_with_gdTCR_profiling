# Cellranger VDJ Data processing

## Description
This Bash script is designed to handle and process output data obtained from Cellranger VDJ, specifically focusing on gene expression data related to T-cell receptors (TRGV and TRDV).
- [Custom Cellranger VDJ data processing for Seurat (2_custom_VDJ_data_processing.sh)](/bash_scripts/2_custom_VDJ_data_processing.sh). 

## Purpose
The script performs the following tasks:
- **Isolate Productive Rows:** Filters and segregates rows marked as 'productive' based on the 'productive' column containing 'TRUE' values. Please note that, for γδTCR analysis, we need to start with the "all_contig_annotations.csv" file instead of the "filtered_contig_annotations.csv" file. Additionally, for γδTCR analysis, we need to keep all the rows irrespective of whether they are productive or not. 
- **Separate TRGV and TRDV Rows:** Divides TRGV and TRDV/TRAV reads into separate files according to their identifiers.
- **Separate Reads by Unique Barcodes:** Demultiplexes the data using unique barcodes, organizing them into individual files.
- **Identify Contig Counts:** Determines the count of contigs (read sequences) per barcode and classifies them as single, double, or multiple based on the count.
- **Data Organization and Header Addition:** Reorganizes columns, adds headers and arranges processed data into designated folders for TRGV and TRDV.
- **Barcode Matching:** Merges processed data with barcodes from 'barcodes.tsv' (found in the cellranger count output folder - filtered_feature_bc_matrix), effectively linking each barcode from the GEX+ADT/HTO data with its TRGV/TRDV information. 

## Instructions
### Pre-requisites
- Ensure the 'raw_data.txt' file (which has been made from the all_contig_annotations.csv file) and 'barcodes.tsv.gz' files exist in the parent directory.
- Ensure that column name formatting of the 'raw_data.txt' file matches with the provided [template.txt )](/references/template.txt) file.


### Execution
1. Navigate to the directory containing the Cellranger VDJ output.
2. Execute the script.

### Finalization
Post-processing in Excel is recommended to pair barcode-linked TRGV and TRDV information together and perform additional manipulation or analysis on the processed data.

**Note:** Review the script carefully, follow the instructions, and leverage the processed data for further analysis or downstream applications.