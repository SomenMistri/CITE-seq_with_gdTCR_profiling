# TRGV and TRDV usage

This repository provides an R Notebook guiding through the analysis of TRGV and TRGV usage using R.

There are two R notebooks: 
1. 8.1_TRGV_TRDV_usage.Rmd
2. 8.2_TRGV_TRDV_usage_freq_calculation.Rmd

## R Notebook: 8.1_TRGV_TRDV_usage: 
Click [here](/R_notebooks/8.1_TRGV_TRDV_usage.Rmd) to access the R notebook. This R script comprises four major steps analyzing T-cell receptor variable gene (TRGV and TRDV) usage patterns in single-cell RNA-seq data:

### Step 1: Data Loading and Variable Definition: 
Retrieve the necessary input file and load essential packages. Define variables and load clustered data, setting up subsets for subsequent analysis.

### Step 2:TRGV (γ chain) usage visualization:
Focus on visualizing TRGV gene usage patterns across various cell types and clusters. Generate UMAP plots for individual TRGV genes to depict their expression profiles.
	
<p align="center">
<img src="../figs/8_TRGV_featureplot.png" alt="8_TRGV_featureplot" width="700"/>
</p> 
	
### Step 3: TRDV (δ chain) usage visualization: 
Dedicated exploration similar to Step 2 but for TRDV genes. Visualize TRDV gene expression patterns across different cell types and clusters using UMAP plots.
	
<p align="center">
<img src="../figs/8_TRDV_featureplot.png" alt="8_TRDV_featureplot" width="700"/>
</p> 
	
### Step 4: Paired TRGV and TRDV Usage Heatmap Creation:
Perform comprehensive data processing steps. Remove ‘NA’ entries, group unique gene pairs, calculate counts, add log2 transformed values, fill missing combinations, and summarize duplicates. Generate a heatmap showcasing the relationship between paired TRGV and TRDV gene usage based on log2-transformed counts. Save the resulting heatmap as a PNG image for further exploration and analysis.
	
<p align="center">
<img src="../figs/8_TRGV_TRDV_Pheatmap.png" alt="8_TRGV_TRDV_Pheatmap" width="400"/>
</p>
