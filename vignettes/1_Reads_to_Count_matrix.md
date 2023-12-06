
# Generate Count Matrix from Sequence Reads

This document outlines the process for generating a count matrix from sequence reads of thymic gamma delta (γδ) T cells.

## 1. Downloading Data to VACC Cluster

To begin the analysis, the data is downloaded to the VACC (Vermont Advanced Computing Center) cluster computing platform using `wget`. The sample dataset includes samples from four wild-type (WT) and four knockout (KO) thymic γδ T cells, each tagged by eight different oligo-conjugated antibodies.


- For detailed `wget` commands used for downloading the dataset, refer to the bash script [1_data_download_to_cluster.sh](/bash_scripts/1_data_download_to_cluster.sh).

## Sample Information

The sample dataset comprises three different libraries:
- Gene Expression (GEX)
- Cell Surface Protein Expression (CSP):
    - Contains information on both surface protein-bound oligo antibodies and hashtag antibodies.
- VDJ Enriched Library (Gamma Delta TCR)

### Comparison

The study compares four WT and four KO samples tagged by eight different oligo-conjugated antibodies.

### Sample fastq.gz file organization

Please move all the fastq.gz files from all different libraries into one folder for downstream QC and cellranger runs.


## 2. Fastq Quality Control Step using FastQC and MultiQC

Following data download, a quality control step is conducted using FastQC and MultiQC to assess the quality of the Fastq.gz files obtained. 

For detailed commands used for FastQC and MultiQC Analysis, refer to the bash script [1_data_FastQC_MulitQC.sh](/bash_scripts/1_data_FastQC_MulitQC.sh).


## 3. Alignment and Count Matrix Generation

The GEX and CSP libraries are aligned to the mouse genome using `cellranger count` twice:
1. **First Run:** Providing information only about hashtag oligo antibodies. The output of this run is named "HTO-GEX_output"
- [First Cellranger Count Run - Hashtag Oligo Antibodies (3.1_cellranger_count_GEX_HTO.sh)](/bash_scripts/3.1_cellranger_count_GEX_HTO.sh). _Files indicating the fastq.gz locations ["Libraries_GEX_CSP"](/references/Libraries_GEX_CSP) and feature references ["Feature_reference_HTO"](/references/Feature_reference_HTO) are required for this run._
  - Major output files of interest that needs to downloaded for R Seurat analysis:
    - /HTO-GEX_output/outs/filtered_feature_bc_matrix (rename it to "HTO_filtered_feature_bc_matrix")
    - /HTO-GEX_output/outs/filtered_feature_bc_matrix.h5
    - /HTO-GEX_output/outs/web_summary.html

2. **Second Run:** Providing information only about antibody-derived tags targeting cell surface protein expression. The output of this run is named "ADT-GEX_output".
- [Second Cellranger Count Run - Antibody-Derived Tags (3.2_cellranger_count_GEX_ADT.sh)](/bash_scripts/3.2_cellranger_count_GEX_ADT.sh). _Files indicating the fastq.gz locations ["Libraries_GEX_CSP"](/references/Libraries_GEX_CSP) and feature references ["Feature_reference_ADT"](/references/Feature_reference_ADT) are required for this run._
  - Major output files of interest that needs to downloaded for R Seurat analysis:
    - /ADT-GEX_output/outs/filtered_feature_bc_matrix (rename it to "ADT_filtered_feature_bc_matrix")
    - /ADT-GEX_output/outs/filtered_feature_bc_matrix.h5
    - /ADT-GEX_output/outs/web_summary.html

## 4. Remove TCR transcripts counts from gene expression (GEX) data (optional)
As we are will be doing a separate analysis of TCR VDJ from the enriched VDJ library, we do not need the TCR gene expression information from the GEX library. In case of αβ or γδ T cells, sometimes the TCR transcripts in the GEX data causes undesirable clustering pattern. To circumvent this problem, we can take a cellranger count output (either ADT-GEX or HTO-GEX), locate the "filtered_feature_bc_matrix.h5" file and run the cellranger reanalyze step using a list of all the TCR related genes stored in a .csv file ([ex_TCR_GENES_CSV.csv](/references/ex_TCR_GENES_CSV.csv)).

- For detailed cellranger commands used for removing TCR genes from the count matrix, refer to the bash script [4_TCR_counts_removal.sh](/bash_scripts/4_TCR_counts_removal.sh). The output of this run is named "Reanalyze_ADT_GEX_output".
  - Major output files of interest that needs to downloaded for R Seurat analysis:
    - /Reanalyze_ADT_GEX_output/outs/filtered_feature_bc_matrix (rename it to "Reanalyze_ADT_filtered_feature_bc_matrix")
    - /Reanalyze_ADT_GEX_output/outs/filtered_feature_bc_matrix.h5
    - /Reanalyze_ADT_GEX_output/outs/web_summary.html

## 5. Processing of enriched VDj library
The γδ VDJ enriched Fastq files are aligned to a custom-made mouse IMGT reference () using the `cellranger vdj` argument on the VACC cluster.

- For detailed cellranger commands used for processing the VDJ library fastq.gz files can be found in this bash script [5_cellranger_VDJ.sh](/bash_scripts/5_cellranger_VDJ.sh). The output of this run is named "VDJ_output".
  - Major output files of interest that needs to downloaded for downstream command-line processing:
    - /VDJ_output/outs/all_contig_annotations.csv (this is the file of interest if you are looking for γδ TCR)
    - /VDJ_output/outs/filtered_contig_annotations.csv (this is the file of interest if you are looking for conventional αβ TCR)
    - /VDJ_output/outs/web_summary.html

*After this point, the Downstream processing of this dataset is possible in personal mac or pc*
