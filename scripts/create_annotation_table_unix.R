# On Unix-based systems use this version of the create_annotation_table script,
# since it is significantly faster


# Create combined grow/igrow files ---------------------------------------------
# Store the working directories
working_directory <- "/home/thanos/Dropbox/R/project_protein"
grow_directory <- "/home/thanos/Dropbox/R/project_protein/data/grow"
igrow_directory <- "/home/thanos/Dropbox/R/project_protein/data/igrow"

file_types <- c("grow", "igrow")

for (type in file_types) {

  #Set wd to grow/igrow_directory and create the combined grow/igrow files
  setwd(eval(parse(text = as.name(sprintf("%s_directory", type)))))
  print(sprintf("Warning: WD changed to ./data/%s/", type))

  # Warning! OS-dependent command:
  system(sprintf("cat * > %s_combined.txt", type))
  # On Mac OS, instead of the previous command, use the following, since there
  # are restrictions on the number of files to be read/displayed at once
  #
  # for (i in 1:9) {
  #   system(sprintf("cat %d* >> %s_combined.txt", i, type))
  # }
  print(sprintf("%s_combined.txt created", type))

  system(sprintf(paste("mv %s/%s_combined.txt ",
                       "%s/data_combined/%s_combined.txt",
                       sep = ""),
                 eval(parse(text = as.name(sprintf("%s_directory", type)))),
                 type,
                 working_directory,
                 type))
  print(sprintf("%s_combined.txt moved to ./data_combined/", type))

  # Warning! OS-dependent command:
  system(sprintf("wc -l * > %s_line_numbers.txt", type))
  # On Mac OS, instead of the previous command, use the following, since there
  # are restrictions on the number of files to be read/displayed at once
  #
  # for (i in 1:9) {
  #   system(sprintf("wc -l %d* >> %s_line_numbers.txt", i, type))
  # }
  print(sprintf("%s_line_numbers.txt created", type))

  system(sprintf(paste("mv %s/%s_line_numbers.txt ",
                       "%s/data_combined/%s_line_numbers.txt",
                       sep = ""),
                 eval(parse(text = as.name(sprintf("%s_directory", type)))),
                 type,
                 working_directory,
                 type))
  print(sprintf("%s_line_numbers.txt moved to ./data_combined/", type))

}

setwd(working_directory)
print("Warning: WD changed back to original project_protein WD")


# Source read_grow() -----------------------------------------------------------
source('./scripts/read_grow.R')


# Create the annotation table --------------------------------------------------
# Read in the combined grow/igrow files
# The pdb column will be "wrong", since read_grow() is meant to read single
# grow/igrow files

print("Reading grow_combined.txt...")
grow_table <- read_grow("./data_combined/grow_combined.txt", "grow")
print("grow_table created!")

print("Reading igrow_combined.txt...")
igrow_table <- read_grow("./data_combined/igrow_combined.txt", "igrow")
print("igrow_table created!")

print("Processing grow_table and igrow_table...")

# Create the "fixed" pdb column for grow_table/igrow_table
grow_pdb <- read.table("./data_combined/grow_line_numbers.txt")
# Discard the "total" lines we get after each number's (1:9) PDBs
grow_pdb <- grow_pdb[-which(grow_pdb$V2 == "total"), ]
# Get the PDB ID and repeat as many times as the lines in each file - 1 (for the
# first comment line)
grow_pdb <- rep(substring(grow_pdb$V2, 1, 4), grow_pdb$V1 - 1)

igrow_pdb <- read.table("./data_combined/igrow_line_numbers.txt")
# Discard the "total" lines we get after each number's (1:9) PDBs
igrow_pdb <- igrow_pdb[-which(igrow_pdb$V2 == "total"), ]
# Get the PDB ID and repeat as many times as the lines in each file - here we
# don't have a comment line in the beginning of the file
igrow_pdb <- rep(substring(igrow_pdb$V2, 1, 4), igrow_pdb$V1)


# Replace "wrong" pdb column with the "fixed" one
grow_table <- grow_table[, colnames(grow_table) != "pdb"]
igrow_table <- igrow_table[, colnames(igrow_table) != "pdb"]

ifelse(
  nrow(grow_table) == length(grow_pdb),
  grow_table <- cbind(grow_table, grow_pdb),
  print("Warning: grow_table and grow_pdb are NOT the same length!")
)

ifelse(
  nrow(igrow_table) == length(igrow_pdb),
  igrow_table <- cbind(igrow_table, igrow_pdb),
  print("Warning: igrow_table and igrow_pdb are NOT the same length!")
)


# Rearrange grow_table/igrow_table
colnames(grow_table) <- c(
  "interaction_type",
  "lhs_chain_id",
  "lhs_residue_number",
  "lhs_residue_name",
  "lhs_atom_number",
  "lhs_atom_name",
  "rhs_atom_name",
  "rhs_atom_number",
  "rhs_residue_name",
  "rhs_residue_number",
  "rhs_chain_id",
  "distance",
  "pdb"
)
grow_table <- grow_table[, c(
  "pdb",
  "interaction_type",
  "lhs_chain_id",
  "lhs_residue_number",
  "lhs_residue_name",
  "lhs_atom_number",
  "lhs_atom_name",
  "rhs_atom_name",
  "rhs_atom_number",
  "rhs_residue_name",
  "rhs_residue_number",
  "rhs_chain_id",
  "distance"
)]

colnames(igrow_table) <- c(
  "interaction_type",
  "lhs_chain_id",
  "lhs_residue_number",
  "lhs_residue_name",
  "lhs_atom_number",
  "lhs_atom_name",
  "rhs_atom_name",
  "rhs_atom_number",
  "rhs_residue_name",
  "rhs_residue_number",
  "rhs_chain_id",
  "distance",
  "pdb"
)
igrow_table <- igrow_table[, c(
  "pdb",
  "interaction_type",
  "lhs_chain_id",
  "lhs_residue_number",
  "lhs_residue_name",
  "lhs_atom_number",
  "lhs_atom_name",
  "rhs_atom_name",
  "rhs_atom_number",
  "rhs_residue_name",
  "rhs_residue_number",
  "rhs_chain_id",
  "distance"
)]

print("grow_table and igrow_table ready!")

# Combine the two tables into one
annotation_table <- rbind(grow_table, igrow_table)

print("annotation_table ready!")


# Save the tables as RData objects in data_processed/ --------------------------
save(list = "grow_table",
     file = "./data_processed/grow_table.RData")
save(list = "igrow_table",
     file = "./data_processed/igrow_table.RData")
save(list = "annotation_table",
     file = "./data_processed/annotation_table.RData")


# ---------------------------------------------------------------------------- #

# for (type in file_types) {
#
#   print(sprintf("Reading %s_combined.txt...", type))
#   assign(
#     sprintf("%s_table", type),
#     read_grow(sprintf("./data_combined/%s_combined.txt", type), type)
#   )
#
#   print(sprintf("%s_table created!", type))
#
#   print(sprintf("Processing %s_table...", type))
#
#   # Create the "fixed" pdb column for grow/igrow_table
#   assign(
#     sprintf("%s_pdb", type),
#     read.table(sprintf("./data_combined/%s_line_numbers.txt", type))
#   )
#
#   # Discard the "total" lines
#   assign(
#     sprintf("%s_pdb", type),
#     eval(parse(text = as.name(
#       sprintf("%s_pdb", type)
#       )))[-which(eval(parse(text = as.name(
#         sprintf("%s_pdb", type)
#         )))$V2 == "total"), ]
#   )
#
#   # Get the PDB ID and repeat as many times as the (lines in each file - 1) (for
#   # the first comment line). For igrow it is as the (lines in each file), since
#   # we don't have a comment line in the beginning of the file
#   assign(
#     sprintf("%s_pdb", type),
#     ifelse(
#       type == "grow",
#       rep(
#         substring(eval(parse(text = as.name(sprintf("%s_pdb", type))))$V2, 1, 4),
#         eval(parse(text = as.name(sprintf("%s_pdb", type))))$V1 - 1
#       ),
#       rep(
#         substring(eval(parse(text = as.name(sprintf("%s_pdb", type))))$V2, 1, 4),
#         eval(parse(text = as.name(sprintf("%s_pdb", type))))$V1
#       )
#     )
#   )
#
#   # Replace "wrong" pdb column with the "fixed" one
#   assign(
#     sprintf("%s_table", type),
#     eval(parse(text = as.name(
#       sprintf("%s_table", type)
#       )))[, colnames(eval(parse(text = as.name(
#         sprintf("%s_table", type)
#         )))) != "pdb"]
#   )
#   ifelse(
#     nrow(eval(parse(text = as.name(sprintf("%s_table", type))))) ==
#       length(eval(parse(text = as.name(sprintf("%s_pdb", type))))),
#     assign(
#       sprintf("%s_table", type),
#       cbind(
#         eval(parse(text = as.name(sprintf("%s_table", type)))),
#         eval(parse(text = as.name(sprintf("%s_pdb", type))))
#       )
#     ),
#     print(sprintf("Warning: %s_table and %s_pdb are NOT the same length!",
#                   type,
#                   type))
#   )
#
#   # Rearrange grow_table/igrow_table
#   assign(
#     colnames(eval(parse(text = as.name(sprintf("%s_table", type))))),
#     c(
#       "interaction_type",
#       "lhs_chain_id",
#       "lhs_residue_number",
#       "lhs_residue_name",
#       "lhs_atom_number",
#       "lhs_atom_name",
#       "rhs_atom_name",
#       "rhs_atom_number",
#       "rhs_residue_name",
#       "rhs_residue_number",
#       "rhs_chain_id",
#       "distance",
#       "pdb"
#     )
#   )
#   assign(
#     sprintf("%s_table", type),
#     eval(parse(text = as.name(
#       sprintf("%s_table", type)
#       )))[, c(
#         "pdb",
#         "interaction_type",
#         "lhs_chain_id",
#         "lhs_residue_number",
#         "lhs_residue_name",
#         "lhs_atom_number",
#         "lhs_atom_name",
#         "rhs_atom_name",
#         "rhs_atom_number",
#         "rhs_residue_name",
#         "rhs_residue_number",
#         "rhs_chain_id",
#         "distance"
#       )]
#   )
#
#   print(sprintf("%s_table ready!", type))
#
# }
#
# # Combine the two tables into one
# annotation_table <- rbind(grow_table, igrow_table)
# print("annotation_table ready!")
#
# # Save the tables as RData objects in data_processed/ --------------------------
# save(list = "grow_table",
#      file = "./data_processed/grow_table.RData")
# save(list = "igrow_table",
#      file = "./data_processed/igrow_table.RData")
# save(list = "annotation_table",
#      file = "./data_processed/annotation_table.RData")


# ---------------------------------------------------------------------------- #
