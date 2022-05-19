import sys

if __name__ == "__main__":
    cdhit_f = sys.argv[1]
    out_dir = sys.argv[2]

    out_data = []

    with open(cdhit_f, 'r') as cdhit_data:
        current_cluster = []
        current_repseq = ""
        for line in cdhit_data:
            if line[0] == ">":
                # Cluster ended; flush to output data
                for seq in current_cluster:
                    out_data.append([current_repseq, seq])
                current_cluster = []

            else:
                data = line.split("\t")[1].split(" ")[1:3]
                current_cluster.append(data[0].split("...")[0][1:])              # Trimming for the seq id & adding it the the cluster
                if "at" not in data[1]:
                    current_repseq = data[0].split("...")[0][1:]

            # Flush last cluster
        for seq in current_cluster:
            out_data.append([current_repseq, seq])

        # Finished; write to file
        with open(out_dir, 'w') as out_f:
            for alignment in out_data:
                out_f.write("\t".join(alignment) + "\n")