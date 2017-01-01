pdb_ids <- read.csv(file = "whole_pdb_list.csv", header = FALSE)[,1]
for (p in 1:length(pdb_ids)) {
  print(sprintf("processing %s", pdb_ids[p]))
  if(file.exists(sprintf("./grow/%s.grow", pdb_ids[p])) == FALSE) {
    download.file(url = sprintf("http://www.ebi.ac.uk/thornton-srv/databases/pdbsum/%s/grow.out", pdb_ids[p]),
                  destfile = sprintf("./grow/%s.grow", pdb_ids[p]), quiet = TRUE, method = "curl")
  }
  if(readLines(sprintf("./grow/%s.grow", pdb_ids[p]), n = 1) != "# Grow v2.00  output from newsec") {
    write.table("# Grow v2.00  output from newsec", file = sprintf("./grow/%s.grow", pdb_ids[p]), quote = FALSE, col.names = FALSE, row.names = FALSE)
  }
}
