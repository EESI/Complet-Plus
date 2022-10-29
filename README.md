# Complet-Plus: A Computationally Scalable Method to Improve Completeness of Large-Scale Protein Sequence Clustering

*Complet+* is a post-processing tool that merges clustering results using MMseqs2's *search* module. It is intended for useage with MMseqs2 clustering results, but can be run on any clustering results that is in a similar format.

Drexel University EESI Lab, 2022

Maintainer: Rachel Nguyen, rtn28 at dragons dot drexel dot edu

Owner: Gail Rosen, gailr at ece dot drexel dot edu

## Dependencies
Complet+ was developed with the following software:
- python=3.9
- MMseqs2=Release 13-45111

## Data requirement
1. clusterResults.tsv

The clustering results file format requires that each cluster have a representative sequence.

Please note that the actual clusterResults.tsv file itself should not have headers.

| Representative sequence  | Sequence |
| ------------- | ------------- |
| SEQUENCE_1  | SEQUENCE_1  |
| SEQUENCE_1  | SEQUENCE_2  |
| SEQUENCE_1  | SEQUENCE_3  |
| SEQUENCE_4  | SEQUENCE_4  |
| SEQUENCE_4  | SEQUENCE_5  |
| ... | ... |

2. sequences.fasta example

```
>SEQUENCE_1
rsiwskaggsaeeigaealgrmle
>SEQUENCE_2
tsadkshvrsiwskaggsaeeigaealgrmlesf
>SEQUENCE_3
wskaggsaeeigaealgrmle
...
```
####Output format

There are 3 columns: Old Cluster ID, Sequence ID, Complet+ Cluster ID


## Tutorial

### completplus.sh

Complet+ is run via the command line using the script *completplus.sh*.

If you are using Complet+ via the singularity container, the script's directory is already added to the PATH variable so you can simply run it as follows:

```
completplus <i:clusterResults.tsv> <i:sequences.fasta> <o:newClusteringResults.tsv> [options]
```

The arguments for the script are: the clustering results file that the user wishes to run Complet+ on, the FASTA file of sequences, and the name of the new clustering results file that Complet+ will make.

The user may also specify the options they wish to run MMseqs2's search with, as a string. This string is passed straight to the MMseqs2 *search* call, so any options that are availble to MMseqs2 search are available for use. If the user wishes to increase the amount of merging Complet+ does, they can increase the e-value threshold from its default value of [-e 1.000E-03].

For example, let's say we have a clustering results file called ***defaultClusters.tsv***, a FASTA file called ***allSeqs.fasta***, and we would like the resultant file to be called ***completClusters.tsv***. To run Complet+ with using a MMseqs2 ***search sensitivity of 1*** and an ***e-value threshold of 0.1***, the command would look like the following:

```
completplus defaultClusters.tsv allSeqs.fasta completClusters.tsv "-s 7.5 -e 0.1"
```

### find_RHs.py

The Python script run by ***completplus.sh*** to filter the sequence alingment down to the reciprocal hits. Not intended for user use.

### relabel_seqs.py

The Python script run by ***completplus.sh*** to relabel the sequences using the reciprocal hits from the sequence alignment. Not intended for user use.

## Running the Docker in Singularity  (Example of using the Docker)

```
singularity pull docker://eesilab/complet-plus:amd
```

To run example (where you want to output tempdir and output in current directory): ``` singularity exec -B $PWD:/data completplus_amd.sif bash completplus.sh -c /opt/complet-plus-scripts/example_input_files/step-0.tsv -s /opt/complet-plus-scripts/example_input_files/step-0.fasta -o /data/step-1.tsv ```

