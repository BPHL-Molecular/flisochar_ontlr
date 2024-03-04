# flisochar_ontlr
A new web-deployed workflow of FLISOCHAR that only supports ONT long reads.

[FLISOCHAR](https://github.com/BPHL-Molecular/flisochar) is a Florida BPHL Pipeline to genomically characterize bacterial isolates using a hybrid assembly method.


# Introduction

The pipeline flisochar_ontlr has the same functionality as [flisochar_wf](https://github.com/BPHL-Molecular/flisochar_wf), but flisochar_ontlr only processes ONT long reads.

Flisochar-ontlr mainly aims to perform specifies identification of bacterial isolates using de novo assembly methods from Oxford Nanopore techonologies's long-read sequencing data.
The pipeline is built in Nextflow, and Python is used to develop custom scripts, enabling the parse of output. It comes with singularity container to simplify installation.

# Workflow

The current worflow comprises:
1) Quality Control
2) De novo genome assembly
3) Species Identification
4) Genome Annotation
5) Detection of Antimicrobial Resistance Genes
6) Genomic Comparison

# Software Tools implemented
1. Quality control on reads: fastp, [longqc](https://github.com/yfukasawa/LongQC)
2. Three genome assemblers: canu, dragonflye, unicycler (run only canu and unicycler with pacbio long reads)
3. Taxonomic classification progams: [Kaiju](https://github.com/bioinformatics-centre/kaiju). This version only emplements Kraken and Mash.
4. Genome annotators: bakta, pgap, prokka (bakta is omitted in this version)
5. Antimicrobial resistance genes marker: AMRFinderPlus
6. Average nucleotide identity (ANI): pyANI(pgap)

# Installation
At the moment, it is meant to clone this repository to your local directory.[Clone a directory](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

## Software Requirements
Flisochar requires Python (version 3.6 or higher with the package Pandas installed), Nextlow, Singularity (apptainer) available in your system.

### Pgap

Currenly, the installation of [pgap](https://github.com/ncbi/pgap/wiki/Quick-Start) is also required. Before installing, we recommend to create a directory path for the installation under your group
```
mkdir /*/YourGroup/UserName/repos/ncbi/pgap
```
and cd to it. Set this environment variable <PGAP_INPUT_DIR> to the created path,
```
export PGAP_INPUT_DIR=/*/YourGroup/UserName/repos/ncbi/pgap/
```
simply to save everything on your HPC cluster. Note the slash at the end of the previous path(../pgap/) is required, so that all pgap's files are found in that directory. Download the pgap.py file as directed. Change the file into executable mode (chmod +x pgap.py). Then execute the command below on your terminal, and pagap installation will be complete.
```
./pgap.py --update -D apptainer
```

# Resource Requirements

Before running flisochar_ontlr, ensure that required computing resources are available.
Cores: 28, Memory: 180gb, Time ~ 2:00 hrs for one (long-read) bacterial sample

# Running Flisochar

Once the pipeline is available on your system (or on HiPerGator), get an interactive run by following these first steps:
```
export PGAP_INPUT_DIR=/*/YourGroup/UserName/repos/ncbi/pgap/
```

```
module load nextflow apptainer
```
The above two commands and resources may also be written in a job scheduler (sbatch or slurm script) instead.

## General Usage

```
nextflow run flisochar_ontlr.nf --lreads '*.fastq.gz' --asb_tool <canu or unicycler or dragonflye > --genomeSize <numberm or numberM> --outdir 'output path'

```
The full usage may be accessed by executing the following command:

```
nextflow flisochar_ontlr.nf --help
```

### Example
Run the pipeline on the test dataset in your working directory using the following command:

```
nextflow run flisochar_ontlr.nf --lreads 'LRdata/*.fastq.gz' --asb_tool canu --genomeSize 3.5m --outdir flisochar_ontonlytest01
```
#### Running with ONT data
You may find ONT reads data from the [flisochar](https://github.com/BPHL-Molecular/flisochar) page.
### Maxikraken2 Database
The flisochar_wf.nf worflow supports the maxikraken2 database if you want to use it to maximize Kraken percentages. However, users outside of the cluster HPG need to download maxikraken2 database from [here](https://lomanlab.github.io/mockcommunity/mc_databases.html). You will provide the path(where you downloaded the DB) and the name within the path (--kradb "/YOUR_PATH/kraken_databases"  --krdbName "maxikraken2_1903_140GB" ) when use the maxikraken2 database.

### Flisochar_ontlr Ouput
Flisochar_wf ouputs seven directories refecting the worklow's features.
(1) amrfinder,(2) ani_out, (3) annotation, (4) assemblies, (5) quality_control, (6) quast_out, and (7) species-identification

### Author: Tassy J-S. Bazile
