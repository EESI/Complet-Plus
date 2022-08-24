import sys
import csv
import collections


# Reads a delimited file as a 2D list.
def load_tsv(file_dir, delim='\t', verbose=False) -> list:
    list_csv = []
    with open(file_dir, 'r', newline='') as csv_f:
        csv_reader = csv.reader(csv_f, delimiter=delim, quotechar='"')
        for row in csv_reader:
            if verbose:
                print(row)
            if len(row) > 1:
                list_csv.append(row)

    return list_csv


# Populates a dictionary from file. Values are lists.
def load_multivalue_dict(f_dir, key_idx=0, value_idx=1) -> collections.defaultdict(list):
    out_dict = collections.defaultdict(list)
    data = load_tsv(f_dir)

    for dataline in data:
        out_dict[dataline[key_idx]].append(dataline[value_idx])

    return out_dict


# Writes a 2D list to tsv. A header can be specified as well.
def write_2Dlist_to_tsv(file_dir, data, header=[], delim="\t"):
    with open(file_dir, 'w', newline='') as tsv_f:
        writer = csv.writer(tsv_f, delimiter=delim, quotechar='"')

        if len(header) > 0:
            writer.writerow(header)

        writer.writerows(data)


# Writes a dict to tsv, as key-pair values delimited by a \t by default. A header can be specified as well.
def write_dict_to_tsv(file_dir, data, header=[], delim="\t"):
    with open(file_dir, 'w', newline='') as tsv_f:
        writer = csv.writer(tsv_f, delimiter=delim, quotechar='"')

        if len(header) > 0:
            writer.writerow(header)

        for k, v in data.items():
            writer.writerow([k] + [v])


# Recursive method for traversing the RH data and assigning recruitments to be made.
def traverse_targets(data: dict, recruitments: dict, query: str, og_query: str, verbose=False) -> dict:
    if verbose:
        print(query + "\t" + og_query)

    # First, check if the query has already been recruited.
    if query not in recruitments.keys():
        # We don't want the query to get recruited later on...
        recruitments[query] = og_query

    for target in data[query]:
        # Check if the target has already been recruited.
        if target not in recruitments.keys():
            # Recruit all the query's targets.
            recruitments[target] = og_query

            # But also examine its targets for more targets
            recruitments = traverse_targets(data, recruitments, target, og_query)

    return recruitments


if __name__ == "__main__":
    root_dir = sys.argv[1]                      # The working directory
    old_f = sys.argv[2]        # The filename of the old cluster results
    RH_f = root_dir + "/" + sys.argv[3]         # The filename of find_RHs.py
    new_f = sys.argv[4]        # The output filename for the new cluster results

    # 2D list of the old cluster results.
    cluster_data = load_tsv(
        old_f
    )

    # Dictionary of RH data.
    # Key = query, Value = list of the query's targets
    RH_data = load_multivalue_dict(
        RH_f
    )

    # Dictionary of recruitments to make. Mutable.
    # Key = target, Value = the SINGLE query it is being recruited to (str)
    # The format is inverse of the RH data dict.
    recruitment_dict = {}

    # Recruitment time. Iterate through the RH data dict.
    # sys.setrecursionlimit(500000)
    for query in RH_data:
        recruitment_dict = traverse_targets(RH_data, recruitment_dict, query, query)

    write_dict_to_tsv(
        root_dir + "/recruitments.tsv",
        recruitment_dict
    )

    # Merge!
    for line in cluster_data:
        # Appending a 3rd column to the cluster data, of the new cluster labels.
        if line[0] in recruitment_dict.keys():
            line.append(recruitment_dict[line[0]])
        else:
            line.append(line[0])

    write_2Dlist_to_tsv(
        new_f,
        cluster_data
    )
