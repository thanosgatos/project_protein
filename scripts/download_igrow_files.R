pdb_ids <- read.csv(file = "whole_pdb_list.csv", header = FALSE)[,1]
for (p in 1:length(pdb_ids)) {
  print(sprintf("processing %s", pdb_ids[p]))
  if(file.exists(sprintf("./igrow/%s.igrow.out", pdb_ids[p])) == FALSE) {
    download.file(url = sprintf("http://www.ebi.ac.uk/thornton-srv/databases/PDBsum/%s/%s/igrow.out.gz", substr(pdb_ids[p], 2, 3), pdb_ids[p]),
                  destfile = sprintf("./igrow/%s.igrow.out.gz", pdb_ids[p]), quiet = TRUE, method = "curl")
    system(sprintf("gunzip %s", sprintf("./igrow/%s.igrow.out.gz", pdb_ids[p])))
  }
}
