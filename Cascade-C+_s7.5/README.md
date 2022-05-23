# Example test: Cascade-C+ (s=7.5)

Files from the test case "Cascade-C+ (s=7.5)", as shown in the paper as Fig. 5 and in this repository in /Complet-Plus/figures/5a-scope.pdf

Included are all the files from this particular test case.

- step-0.fasta

The FASTA file of the sequences clustered. Contains all the sequences of the SCOPe dataset at the time of writing.

- step-0.tsv

The "Default" clustering results file, prior to running Complet+.

- complet-step-0.tsv

The clustering results file after running Complet+. The first two columns are identical to *step-0.tsv*; the third column are Complet+'s new cluster labels for each sequence.

## /step-0

Contains files created by the MMseqs2 cluster pipeline, in addition to a subfolder (*/complet*) that contains files created by the Complet+ pipeline.

### /step-0/complet

Contains files created by the Complet+ pipeline, in addition to a subfolder (*/mmseqs-output*) that contains files created by the *MMseqs2 search* done by Complet+ during its process.
