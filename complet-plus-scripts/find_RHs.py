import sys
import csv
from collections import defaultdict

# Passes through the alignment file once, and returns a 2D list of the alignment & a dictionary of each query and its hits.
def parse_alignment(file_dir, delim='\t'):
    hits = []
    hits_dict = defaultdict(list)

    with open(file_dir, 'r', newline='') as csv_f:
        csv_reader = csv.reader(csv_f, delimiter=delim, quotechar='"')
        for row in csv_reader:
            hits.append(row)
            hits_dict[row[0]].append(row[1])

    return hits, hits_dict

# 1 = $(pwd)
# 2 = name of the alignment .tsv
# 3 = name of the filtered alignment .tsv, (where you want to write it to)
# 4 = e-val threshold.
if __name__ == "__main__":
    root_dir = sys.argv[1]                                  # The path of the working directory
    search_dir = root_dir + "/" + sys.argv[2]
    output_f = root_dir + "/" + sys.argv[3]

    hit_list, hit_dict = parse_alignment(search_dir)
    RH_list = []

    # Passing through the list of alignments
    for alignment in hit_list:
        # Exclude the alignment if it is a self-alignment
        if alignment[0] == alignment[1]:
            pass

        else:
            # Otherwise, check hit_dict to see if it has a reciprocal
            if alignment[0] in hit_dict[alignment[1]]:
                RH_list.append(alignment)

    # Writing RHs to file
    with open(output_f, 'w') as RH_f:
        for alignment in RH_list:
            RH_f.write("\t".join(alignment) + "\n")