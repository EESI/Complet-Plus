# Complet-Plus: A Computationally Scalable Method to Improve Completeness of Large-Scale Protein Sequence Clustering

*Complet+* is a post-processing tool that merges clustering results using MMseqs2's *search* module. It is intended for useage with MMseqs2 clustering results, but can be run on any clustering results that is in a similar format.
Drexel University EESI Lab, 2022
Maintainer: Rachel Nguyen, rtn280 at dragons dot drexel dot edu
Owner: Gail Rosen, gailr at ece dot drexel dot edu

## Dependencies
Complet+ was developed with the following software:
- python=3.9
- MMseqs2=Release 13-45111

## Data requirement
1. clustering.tsv example

The clustering results file format requires that each cluster have a representative sequence.

Please note that the actual clustering.tsv file itself should not have headers.

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

## Tutorial

