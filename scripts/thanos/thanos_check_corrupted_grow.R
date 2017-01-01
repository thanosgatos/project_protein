# Read the PDB names list ------------------------------------------------------
whole_pdb_list <- read.csv("./data_processed/whole_pdb_list.csv",
                           header = FALSE, stringsAsFactors = FALSE)
whole_pdb_list <- whole_pdb_list$V1

i <- 1

# Repeat for all the pdb IDs
for (current_pdb in whole_pdb_list) {

  # Specify the path to the current grow file
  current_grow_path <- sprintf("./data/grow/%s.grow", current_pdb)

  corrupted_grow_files <- as.character(rep(NA, length(whole_pdb_list)))

  if ((file.size(current_grow_path) - 33) %% 67 > 0) {
    # assign(corrupted_grow_files[i], current_pdb)
    print(current_pdb)
  }

  i <- i + 1

}



corrupted <- c("2mlr","2mls", "3uvc", "4grg")

for (pdb in corrupted) {

  print(sprintf("processing %s", pdb))

  if (readLines(sprintf("./data/grow/%s.grow", pdb), n = 1) != "# Grow v2.00  output from newsec") {
    write.table(
      "# Grow v2.00  output from newsec",
      file = sprintf("./data/grow/%s.grow", pdb),
      quote = FALSE,
      col.names = FALSE,
      row.names = FALSE
    )
  }

}
