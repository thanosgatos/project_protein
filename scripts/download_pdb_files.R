setwd("/Volumes/Data/academic/svmlab/ml/computational_biology_projects/protein_structure_on_cancer/data")

pdb_ids <- read.csv(file = "whole_pdb_list.csv", header = FALSE)[,1]
for (p in 1:length(pdb_ids)) {
  print(sprintf("processing %s", pdb_ids[p]))
  if(file.exists(sprintf("./pdb/%s.pdb", pdb_ids[p])) == FALSE) {
    download.file(url = sprintf("http://www.rcsb.org/pdb/files/%s.pdb", pdb_ids[p]),
                  destfile = sprintf("./pdb/%s.pdb", pdb_ids[p]), quiet = TRUE)
  } 
}
