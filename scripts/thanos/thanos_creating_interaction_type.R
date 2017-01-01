for (i in seq_along(grow$interaction_to)) {

  if (grow$interaction_from[i] == "P") {

    if (grow$interaction_to[i] == "P") {
      interaction_type[i] <- "Protein-Protein"
    } else if (grow$interaction_to[i] == "L") {
      interaction_type[i] <- "Protein-Ligand"
    } else if (grow$interaction_to[i] == "M") {
      interaction_type[i] <- "Protein-Metal"
    } else if ((grow$interaction_to[i] == "N") {
      interaction_type[i] <- "Protein-DNA/RNA"
    }

  } else if (grow$interaction_from[i] == "L") {

    if (grow$interaction_to[i] == "P") {
      interaction_type[i] <- "Ligand-Protein"
    } else if (grow$interaction_to[i] == "L") {
      interaction_type[i] <- "Ligand-Ligand"
    } else if (grow$interaction_to[i] == "M") {
      interaction_type[i] <- "Ligand-Metal"
    } else if ((grow$interaction_to[i] == "N") {
      interaction_type[i] <- "Ligand-DNA/RNA"
    }

  } else if (grow$interaction_from[i] == "M") {

    if (grow$interaction_to[i] == "P") {
      interaction_type[i] <- "Metal-Protein"
    } else if (grow$interaction_to[i] == "L") {
      interaction_type[i] <- "Metal-Ligand"
    } else if (grow$interaction_to[i] == "M") {
      interaction_type[i] <- "Metal-Metal"
    } else if ((grow$interaction_to[i] == "N") {
      interaction_type[i] <- "Metal-DNA/RNA"
    }

  } else if (grow$interaction_from[i] == "N") {

    if (grow$interaction_to[i] == "P") {
      interaction_type[i] <- "DNA/RNA-Protein"
    } else if (grow$interaction_to[i] == "L") {
      interaction_type[i] <- "DNA/RNA-Ligand"
    } else if (grow$interaction_to[i] == "M") {
      interaction_type[i] <- "DNA/RNA-Metal"
    } else if ((grow$interaction_to[i] == "N") {
      interaction_type[i] <- "DNA/RNA-DNA/RNA"
    }

  } else {

    interaction_type[i] <- "Unknown"

  }

}



