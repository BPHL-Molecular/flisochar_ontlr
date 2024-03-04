#!/usr/bin/env bash
#SBATCH --account=Your-Group
#SBATCH --qos=Your-Group
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=YourEmail
#SBATCH --job-name=flisochar_test
#SBATCH --mail-type=NONE
#SBATCH --cpus-per-task=28
#SBATCH --mem=170gb
#SBATCH --time=10:00:00
#SBATCH --output=flisochar.log
#SBATCH --error=flisochar_%j.err

module purge
#module load python
module load nextflow apptainer
export APPTAINER_CACHEDIR=/HPC-DIRECTORY/YourGroup/YourUserName/nextflow_temp/ # storage of nexflow temporary directory
export PGAP_INPUT_DIR=/blue/HPC-DIRECTORY/YourGroup/YourUserName/repos/ncbi/pgap/ # path to pgap
export PATH=/apps/python3/3.6.5/bin:$PATH # path to python in cluster

###############################################################################

nextflow run flisochar_ontlr.nf --lreads "flisochar_test_data/LRdata/*.fastq.gz" --asb_tool dragonflye --genomeSize 3.5M --outdir flisochar_ontlr_test01

###############################################################################

