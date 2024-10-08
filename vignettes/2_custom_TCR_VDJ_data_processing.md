# Cellranger VDJ Data Processing for Seurat R Package

## Description
This repository includes both **R notebooks** and a **Bash script** designed to process output data from Cellranger VDJ, focusing on gene expression data related to T-cell receptors (TRG and TRD/TRA for γδ TCR, and TRA and TRB for αβ TCR).

### R Notebooks
Two new R notebook files have been added for more detailed and flexible processing:
- **[gdVDJ_cellranger_to_Seurat.Rmd](/R_notebooks/gdVDJ_cellranger_to_Seurat.Rmd)** (for γδ TCR data)
- **[abVDJ_cellranger_to_Seurat.Rmd](/R_notebooks/abVDJ_cellranger_to_Seurat.Rmd)** (for αβ TCR data)

These R Markdown files provide streamlined workflows to directly load and process Cellranger output data for integration with Seurat, a powerful R package for single-cell RNA sequencing analysis.

#### gdVDJ_cellranger_to_Seurat.Rmd:
This notebook is intended for the analysis of γδ TCR data. It requires two key input files:
- **barcodes.tsv.gz**: Found in the Cellranger count output folder (`filtered_feature_bc_matrix`).
- **all_contig_annotations.csv**: Found in the Cellranger VDJ output folder.

The workflow in this R notebook ensures that:
- Additional contigs per barcode (if present) are retained, with extra contigs labeled as `v_gene_g_2`, `v_gene_g_3`, etc., enabling more in-depth analysis of multiple TCR rearrangements per barcode.

#### abVDJ_cellranger_to_Seurat.Rmd:
This notebook is designed for the analysis of αβ TCR data and uses the following input files:
- **barcodes.tsv.gz**: Found in the Cellranger count output folder (`filtered_feature_bc_matrix`).
- **filtered_contig_annotations.csv**: From the Cellranger VDJ output folder, filtered to include only productive contigs.

Like the γδ TCR workflow, this notebook keeps track of multiple contigs per barcode, labeling them sequentially as `v_gene_a_2`, `v_gene_a_3`, etc., allowing for more detailed downstream analysis. Unlike the γδ TCR workflow, this script only analyses productive sequences.

### Bash Script (Older Version)
- **[2_custom_VDJ_data_processing.sh](/bash_scripts/2_custom_VDJ_data_processing.sh)**

This Bash script is the older method for processing Cellranger VDJ output. It performs tasks such as isolating productive rows, separating TRGV and TRDV rows, and demultiplexing data by barcode. However, note that it does not retain information for additional contigs beyond the first for each barcode, unlike the new R scripts.

## Purpose
The R notebooks and Bash script perform the following tasks:
- **Isolate Productive Rows**: Filters and processes rows marked as 'productive' based on the 'productive' column in the Cellranger output.
- **Separate TCR Chains**: Splits γδ TCR (TRGV and TRDV) or αβ TCR (TRA and TRB) into separate datasets for focused analysis.
- **Barcode Demultiplexing**: Organizes data into individual files based on unique barcodes.
- **Contig Count**: Tracks the number of contigs per barcode and retains multiple contigs for in-depth analysis.

## Instructions
### Pre-requisites
- For the R notebooks, ensure that `barcodes.tsv.gz` and either `all_contig_annotations.csv` (for γδ TCR) or `filtered_contig_annotations.csv` (for αβ TCR) are in the appropriate directory.
- For the Bash script, ensure the `raw_data.txt` file (converted from `all_contig_annotations.csv`) and `barcodes.tsv.gz` exist in the parent directory.

### Execution
1. For the R notebooks, open the respective `.Rmd` file in RStudio, provide the input files, and run the cells sequentially.
2. For the Bash script, navigate to the directory containing the Cellranger VDJ output and execute the script.

### Finalization
For both methods, the final output includes barcodes linked with their respective TCR information, ready for integration into Seurat for downstream analysis.

**Note:** The R scripts provide more flexibility and retain additional contig information per barcode, making them suitable for more detailed analyses compared to the older Bash script.

