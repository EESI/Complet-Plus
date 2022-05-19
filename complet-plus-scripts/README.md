# Complet+ scripts

## completplus.sh

The shell script to run for Complet+.

The required arguments are the clustering results file that the user wishes to run Complet+ on, the FASTA file of sequences, and the name of the new clustering results file that Complet+ will make. The user may also specify the options they wish to run MMseqs2's search with, as a string.

```
completplus.sh <i:clusterResults.tsv> <i:sequences.fasta> <o:newClusteringResults.tsv> [options]
```

For example, let's say we have a clustering results file called ***defaultClusters.tsv***, a FASTA file called ***allSeqs.fasta***, and we would like the resultant file to be called ***completClusters.tsv***. To run Complet+ with using a MMseqs2 ***search sensitivity of 1*** and an ***e-value threshold of 0.1***, the command would look like the following:

```
completplus.sh defaultClusters.tsv allSeqs.fasta completClusters.tsv "-s 7.5 -e 0.1"
```

## convert_cdhit.py

A helper Python script for converting CD-HIT clustering results to match the format used by MMseqs2 (and consequently, Complet+).

```
python convert_cdhit.py <i:cdhitResults.clstr> <o:mmseqsFormattedResults.tsv>
```

Example usage:

```
python convert_cdhit.py cdhitClusters.clstr cdhitClusters.tsv
```

## find_RHs.py

The Python script run by ***completplus.sh*** to filter the sequence alingment down to the reciprocal hits. Not intended for user use.

## relabel_seqs.py

The Python script run by ***completplus.sh*** to relabel the sequences using the reciprocal hits from the sequence alignment. Not intended for user use.
