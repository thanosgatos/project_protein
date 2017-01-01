# Read the PDB names list ------------------------------------------------------
whole_pdb_list <- read.csv("./data_processed/whole_pdb_list.csv",
                           header = FALSE, stringsAsFactors = FALSE)
whole_pdb_list <- whole_pdb_list$V1


# Remove and redownload all grow files smaller than 100 bytes ------------------
for (pdb in whole_pdb_list) {

  if (file.size(sprintf("./data/grow/%s.grow", pdb)) < 100) {

    print(sprintf("Removing %s.grow...", pdb))
    file.remove(sprintf("./data/grow/%s.grow", pdb))

    print(sprintf("Downloading %s.grow...", pdb))
    download.file(
      url = sprintf(
        "http://www.ebi.ac.uk/thornton-srv/databases/pdbsum/%s/grow.out",
        pdb
      ),
      destfile = sprintf("./data/grow/%s.grow", pdb),
      quiet = TRUE,
      method = "curl"
    )

    if (readLines(sprintf("./data/grow/%s.grow", pdb), n = 1) !=
        "# Grow v2.00  output from newsec") {
      print(sprintf("%s.grow is empty! Writing first line comment...", pdb))
      write.table(
        "# Grow v2.00  output from newsec",
        file = sprintf("./data/grow/%s.grow", pdb),
        quote = FALSE,
        col.names = FALSE,
        row.names = FALSE
      )
    }

  }

}


