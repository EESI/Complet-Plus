# Required params
c=""
s=""
o=""

# Optional params
t=""
opt=""

while [ "${1:-}" != "" ]; do
	case "$1" in
		"-c")
			shift 1
			VALUE=${1:-}
			if [ -z ${VALUE} ] || [[ "$1" =~ ^--.*$ ]]; then
				echo "<completplus>: The \"-c\" flag is missing a parameter."
				exit 1
			else
				c=$1
			fi
			;;
		"-s")
			shift 1
			VALUE=${1:-}
			if [ -z ${VALUE} ] || [[ "$1" =~ ^--.*$ ]]; then
				echo "<completplus>: The \"-s\" flag is missing a parameter."
				exit 1
			else
				s=$1
			fi
			;;
		"-o")
			shift 1
			VALUE=${1:-}
			if [ -z ${VALUE} ] || [[ "$1" =~ ^--.*$ ]]; then
				echo "<completplus>: The \"-o\" flag is missing a parameter."
				exit 1
			else
				o=$1
			fi
			;;

            # Optional

        "-O" | "--opt")
			shift 1
			VALUE=${1:-}
			if [ -z ${VALUE} ] || [[ "$1" =~ ^--.*$ ]]; then
				echo "<completplus>: The \"-O / --opt\" flag is missing a parameter."
				exit 1
			else
				opt=$1
			fi
			;;
        "-h" | "--help")
			shift 1
			printf "Completplus\n\tThere are three mandatory flags -c -s and -o.\n\tThese flags specify the cluster results file (csv/tsv), sequence file (fasta) and the resultant output file.\n\nOptional flags:\n\t-t\tSpecify a path to create a temp output folder for generated files.\n\t\tIf none is specified, this will default to the current working directory.\n\t-h\tHelp for options. --help can also be supplied.\n\t-O\tSpecify search options for mmseqs as a string, --opt can also be supplied.\n\t\tExample: completplus <...> -O \"-e 0.01 -s 7.5\"\n"
			exit 1
			;;
		"-t")
			shift 1
			VALUE=${1:-}
			if [ -z ${VALUE} ] || [[ "$1" =~ ^--.*$ ]]; then
				echo "<completplus>: The \"-t\" flag is missing a parameter."
				exit 1
			else
				t=$1
			fi
			;;
        *)
            shift 1
            printf "Invalid argument(s)! Use the -h or --help flag for help.\n"
            exit 1
	esac
	shift
	done

if [ -z $c ]; then
	echo "<completplus>: No parameter provided for \"-c\" flag. Use the -h or --help flag for help."
	exit 1
fi

if [ -z $s ]; then
	echo "<completplus>: No parameter provided for \"-s\" flag. Use the -h or --help flag for help."
	exit 1
fi

if [ -z $o ]; then
	echo "<completplus>: No parameter provided for \"-o\" flag. Use the -h or --help flag for help."
	exit 1
fi

if [ -z $t ]; then
    echo "Parameter not provided for \"-t\" flag, defaulting to current working directory for temp folder."
    t="."
fi


SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
printf "\n\n"



tempDir=$t/tempDir
mkdir $tempDir


CLU_F=$c
SEQ_F=$s
OUT_F=$o
SEARCH_OPTIONS=$opt
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

