# Currently, the script will create the files in the directory it is run in.

# Arguments:
# 1 = Cluster results, .csv or .tsv format.
# 2 = Sequences, .fasta format.
# 3 = Output file.
# 4 = Options, as a string.


CLU_F=$1
SEQ_F=$2
OUT_F=$3
SEARCH_OPTIONS=$4

ROOT_DIR=$(pwd)
SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
printf "\n\n"

echo "Specify an output directory for temp files. To create one in the current working directory, simply type '.'"
read tempLoc
tempDir=$tempLoc/tempDir
mkdir $tempDir


echo Cluster results file:		$CLU_F
echo Sequences file:			$SEQ_F
echo Merged cluster output file:	$OUT_F
echo Options:				$SEARCH_OPTIONS
printf "\n\n"

mkdir $tempDir/mmseqs-output
mkdir $tempDir/mmseqs-output/tmp

# Extracting the sequence information of the representative sequences from the .csv data.
## Note: the line following this one (that is commented out) is faster than the one following it, however not all versions 
## of grep support the --no-group-separator option. If the user's version of grep does support it, I suggest using the 
## first version for faster performance.
## grep -f <(awk '{print $1}' $CLU_F | sort | uniq) -A1 --no-group-separator $SEQ_F > rep-seqs.fasta
grep -f <(awk '{print $1}' $CLU_F | sort -T $tempDir | uniq) -A1 $SEQ_F | grep -v -- "^--$" > $tempDir/rep-seqs.fasta


# Making the databases.
mmseqs createdb $tempDir/rep-seqs.fasta $tempDir/mmseqs-output/repsDB


# Performing search.
mmseqs search $tempDir/mmseqs-output/repsDB $tempDir/mmseqs-output/repsDB $tempDir/mmseqs-output/searchDB $tempDir/mmseqs-output/tmp $SEARCH_OPTIONS


# Converting the output and sorting it .
mmseqs convertalis $tempDir/mmseqs-output/repsDB $tempDir/mmseqs-output/repsDB $tempDir/mmseqs-output/searchDB search.tsv
sort -T $tempDir -k11 -g -o search.tsv search.tsv


# Finding RBs.
python $SCRIPTS_DIR/find_RHs.py $tempDir "search.tsv" "searchRHs.tsv"


# Relabeling cluster results accordingly.
python $SCRIPTS_DIR/relabel_seqs.py $tempDir $CLU_F "searchRHs.tsv" $OUT_F

