
# Generate Count Matrix from Sequence Reads

This document outlines the process for generating a count matrix from sequence reads of thymic gamma delta (γδ) T cells.

## Downloading Data to VACC Cluster

To begin the analysis, the data is downloaded to the VACC (Vermont Advanced Computing Center) cluster computing platform using `wget`. The sample dataset includes samples from four wild-type (WT) and four knockout (KO) thymic γδ T cells, each tagged by eight different oligo-conjugated antibodies.

### Download Command

For detailed `wget` commands used for downloading the dataset, refer to the [R notebook with wget commands](link-to-wget-notebook).

## Sample Information

The sample dataset comprises three different libraries:
- Gene Expression (GEX)
- Cell Surface Protein Expression (CSP):
    - Contains information on both surface protein-bound oligo antibodies and hashtag antibodies.
- VDJ Enriched Library (Gamma Delta TCR)

### Comparison

The study compares four WT and four KO samples tagged by eight different oligo-conjugated antibodies.


## Fastq Quality Control Step using FastQC and MultiQC

Following data download, a quality control step is conducted using FastQC and MultiQC to assess the quality of the Fastq files obtained.

### FastQC and MultiQC Analysis commands

For detailed commands used for FastQC and MultiQC Analysis, refer to the [R notebook with wget commands](link-to-wget-notebook).


## Alignment and Count Matrix Generation

The GEX and CSP libraries are aligned to the mouse genome using `cellranger count` twice:
1. **First Run:** Providing information only about hashtag oligo antibodies. The output of this run is named "HTO-GEX"
2. **Second Run:** Providing information only about antibody-derived tags targeting cell surface protein expression. The output of this run is named "ADT-GEX"

### Code Notebooks

- [First Cellranger Count Run - Hashtag Oligo Antibodies](link-to-first-notebook)
- [Second Cellranger Count Run - Antibody-Derived Tags](link-to-second-notebook)

The VDJ enriched Fastq files are aligned to a custom-made mouse IMGT sequences using the `cellranger vdj` argument on the VACC cluster.

For more details on the data processing steps and command line arguments used, please refer to the provided R notebook files running on the VACC clusters.
