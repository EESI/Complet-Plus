# Complet+ helper scripts

## convert_cdhit.py

A helper Python script for converting CD-HIT clustering results to match the format used by MMseqs2 (and consequently, Complet+).

```
python convert_cdhit.py <i:cdhitResults.clstr> <o:mmseqsFormattedResults.tsv>
```

Example usage:

```
python convert_cdhit.py cdhitClusters.clstr cdhitClusters.tsv
```

