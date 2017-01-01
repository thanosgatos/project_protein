# Use this version of the script ONLY on Windows systems, as it is
# significantly slower than the version for Unix-based systems


# Source read_grow() -----------------------------------------------------------
source('./scripts/read_grow.R')

# Read the PDB names list ------------------------------------------------------
whole_pdb_list <- read.csv("./data_processed/whole_pdb_list.csv",
                           header = FALSE, stringsAsFactors = FALSE)
whole_pdb_list <- whole_pdb_list$V1

# Create the annotation table --------------------------------------------------
annotation_table <- data.frame()

# Repeat for all the pdb IDs
for (current_pdb in whole_pdb_list) {

  # Specify the path to the current grow file
  current_grow_path <- sprintf("./data/grow/%s.grow", current_pdb)

  # If the current grow file is corrupted, redownload it
  if ((file.size(current_grow_path) >= 100) &
      ((file.size(current_grow_path) - 33) %% 67 > 0)) {
    print(sprintf("Redownloading %s.grow...", current_pdb))
    download.file(
      url = sprintf(
        "http://www.ebi.ac.uk/thornton-srv/databases/pdbsum/%s/grow.out",
        current_pdb
      ),
      destfile = sprintf("./data/grow/%s.grow", current_pdb),
      quiet = TRUE
    )
    # If the first row in the downloaded file is not correct, replace the
    # file with an empty file which only has one line of text
    if (readLines(sprintf("./data/grow/%s.grow", current_pdb), n = 1) !=
        "# Grow v2.00  output from newsec") {
      write.table(
        "# Grow v2.00  output from newsec",
        file = sprintf("./data/grow/%s.grow", current_pdb),
        quote = FALSE,
        col.names = FALSE,
        row.names = FALSE
      )
    }
  }

  # Add the current grow file to the annotation_table, unless it is empty
  ifelse(
    (file.size(current_grow_path) >= 100),
    {
      current_grow <- read_grow(current_grow_path, file_type = "grow")
      annotation_table <- rbind(annotation_table, current_grow)
      print(sprintf("Added %s.grow to the annotation table.", current_pdb))
    },
    print(sprintf("Warning: %s.grow appears to be empty!", current_pdb))
  )

  # Specify the path to the current igrow file
  current_igrow_path <- sprintf("./data/igrow/%s.igrow.out", current_pdb)

  # Add the current igrow file to the annotation_table, unless it is empty
  ifelse(
    (file.size(current_igrow_path) >= 100),
    {
      current_igrow <- read_grow(current_igrow_path, file_type = "igrow")
      annotation_table <- rbind(annotation_table, current_igrow)
      print(sprintf("Added %s.igrow.out to the annotation table.", current_pdb))
    },
    print(sprintf("Warning: %s.igrow.out appears to be empty!", current_pdb))
  )

}

# Save the annotation table as an RData object in data_processed/ --------------
save(list = "annotation_table",
     file = "./data_processed/annotation_table.RData")

