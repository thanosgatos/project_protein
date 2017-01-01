sifts_mapping <- read.csv("./sifts/uniprot_pdb.csv", skip = 1, row.names = 1, stringsAsFactors = FALSE)

cohorts <- c("TCGA-ACC",  "TCGA-BLCA", "TCGA-BRCA", "TCGA-CESC", "TCGA-CHOL",
             "TCGA-COAD", "TCGA-DLBC", "TCGA-ESCA", "TCGA-GBM",  "TCGA-HNSC",
             "TCGA-KICH", "TCGA-KIRC", "TCGA-KIRP", "TCGA-LAML", "TCGA-LGG",
             "TCGA-LIHC", "TCGA-LUAD", "TCGA-LUSC", "TCGA-MESO", "TCGA-OV",
             "TCGA-PAAD", "TCGA-PCPG", "TCGA-PRAD", "TCGA-READ", "TCGA-SARC",
             "TCGA-SKCM", "TCGA-STAD", "TCGA-TGCT", "TCGA-THCA", "TCGA-THYM",
             "TCGA-UCEC", "TCGA-UCS",  "TCGA-UVM")

TCGA_MAF <- data.frame(stringsAsFactors = FALSE)
for (cohort in cohorts) {
  print(sprintf("processing %s cohort...", cohort))
  load(file = sprintf("./maf/%s_maf.RData", cohort))
  mutation[, "PDB"] <- sifts_mapping[mutation[, "SwissProt"],]
  mutation <- mutation[which(is.na(mutation$PDB) == FALSE),]

  TCGA_MAF <- rbind(TCGA_MAF, mutation)
}
save(list = c("TCGA_MAF"), file = "./TCGA_MAF.RData")

whole_pdb_list <- sort(unique(unlist(strsplit(unique(TCGA_MAF$PDB), ";"))))
write.table(whole_pdb_list, "whole_pdb_list.csv", row.names = FALSE, col.names = FALSE, quote = FALSE)
