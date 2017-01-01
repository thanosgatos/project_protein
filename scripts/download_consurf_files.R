library(bio3d)

pdb_ids <- read.csv(file = "whole_pdb_list.csv", header = FALSE)[,1]
existing <- dir("./consurf")
pdb_ids <- setdiff(pdb_ids, existing)
for (p in 1:length(pdb_ids)) {
  print(sprintf("processing %s", pdb_ids[p]))
  if (dir.exists(sprintf("./consurf/%s", pdb_ids[p])) == FALSE) {
    dir.create(sprintf("./consurf/%s", pdb_ids[p]))  
  }
  if(file.size(sprintf("./pdb/%s.pdb", pdb_ids[p])) > 0) {
    pdb <- read.pdb(sprintf("./pdb/%s.pdb", pdb_ids[p]), verbose = FALSE)
    chains <- sort(unique(pdb$atom$chain))
    for (chain in chains) {
      print(sprintf("processing chain %s", chain))
      if(file.exists(sprintf("./consurf/%s/%s.grades", pdb_ids[p], chain)) == FALSE) {
        try(download.file(url = sprintf("http://www.ebi.ac.uk/thornton-srv/databases/pdbsum/data/consurf/%s/%s%s.gradesPE", substr(pdb_ids[p], 2, 3), pdb_ids[p], chain),
                          destfile = sprintf("./consurf/%s/%s.grades", pdb_ids[p], chain), quiet = TRUE), silent = TRUE)
          if(file.size(sprintf("./consurf/%s/%s.grades", pdb_ids[p], chain)) == 6716) {
            unlink(sprintf("./consurf/%s/%s.grades", pdb_ids[p], chain))
          }
      }
    }
  }
}
