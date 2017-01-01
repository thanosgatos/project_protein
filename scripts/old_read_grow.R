read_grow <- function(path, file_type) {
  # Reads both grow and igrow files
  # Args:
  # path: the path to the grow/igrow file to be read,
  # file_type: "grow" or "igrow", depending on the type of the file to be read
  # Returns: a data frame containing the data from the grow/igrow file

  # Specify column widths for the grow/igrow files
  column_widths <- c(2, 2, 2, 2, 5, 1, 4, 6, 5, 4, 5, 6, 4, 5, 1, 2, 6, 4)

  # Read in the data, while stripping leading and trailing white space from
  # unquoted character fields
  grow <- as.data.frame(read.fwf(path, widths = column_widths,
                                 strip.white = TRUE, stringsAsFactors = FALSE,
                                 na.strings = " "))

  # Rename variables
  colnames(grow) <- c(
    "drop_1",
    "interaction_from",
    "interaction_to",
    "lhs_chain_id",
    "lhs_residue_number",
    "drop_6",
    "lhs_residue_name",
    "lhs_atom_number",
    "lhs_atom_name",
    "drop_10",
    "rhs_atom_name",
    "rhs_atom_number",
    "rhs_residue_name",
    "rhs_residue_number",
    "drop_15",
    "rhs_chain_id",
    "distance",
    "drop_18"
  )

  # Drop variables and change the type of others
  grow <- grow[, !(colnames(grow) %in% c("drop_1", "drop_6", "drop_10",
                                         "drop_15", "drop_18"))]

  grow$interaction_from <- as.factor(grow$interaction_from)
  grow$interaction_to <- as.factor(grow$interaction_to)
  grow$lhs_chain_id <- as.factor(grow$lhs_chain_id)
  grow$rhs_chain_id <- as.factor(grow$rhs_chain_id)

  # Create interaction_type variable, assign values, add it to the data frame
  interaction_type <- character(length = nrow(grow))


  for (i in seq_along(grow$interaction_to)) {
    if (grow$interaction_from[i] == "p") {
      if (grow$interaction_to[i] == "P") {
        interaction_type[i] <- "Protein-Protein"
      } else if (grow$interaction_to[i] == "L") {
        interaction_type[i] <- "Protein-Ligand"
      } else if (grow$interaction_to[i] == "M") {
        interaction_type[i] <- "Protein-Metal"
      } else if ((grow$interaction_to[i] == "N") &
                 substr(grow$rhs_residue_name[i], 1, 1) == "D") {
        interaction_type[i] <- "Protein-DNA"
      } else if ((grow$interaction_to[i] == "N") &
                 substr(grow$rhs_residue_name[i], 1, 1) == "R") {
        interaction_type[i] <- "Protein-RNA"
      }
    } else {
      interaction_type[i] <- "Unknown"
    }
  }


  grow <- cbind(grow, interaction_type)

  # Create pdb variable, add it to the data frame
  pdb <- rep(ifelse(file_type == "grow",
                    substr(path, nchar(path) - 8, nchar(path) - 5),
                    substr(path, nchar(path) - 13, nchar(path) - 10)),
             length = nrow(grow))

  grow <- cbind(grow, pdb)

  # Drop columns and rearrange the rest
  grow <- grow[, !(colnames(grow) %in% c("interaction_from", "interaction_to"))]
  grow <- grow[, c(
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

  #Return the data frame created
  grow
}
