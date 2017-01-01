tcga_path <- "../../gdc_tcga_fetcher/primary_data/%s.RData"

cohorts <- c("TCGA-ACC",  "TCGA-BLCA", "TCGA-BRCA", "TCGA-CESC", "TCGA-CHOL",
             "TCGA-COAD", "TCGA-DLBC", "TCGA-ESCA", "TCGA-GBM",  "TCGA-HNSC",
             "TCGA-KICH", "TCGA-KIRC", "TCGA-KIRP", "TCGA-LAML", "TCGA-LGG",
             "TCGA-LIHC", "TCGA-LUAD", "TCGA-LUSC", "TCGA-MESO", "TCGA-OV",
             "TCGA-PAAD", "TCGA-PCPG", "TCGA-PRAD", "TCGA-READ", "TCGA-SARC",
             "TCGA-SKCM", "TCGA-STAD", "TCGA-TGCT", "TCGA-THCA", "TCGA-THYM",
             "TCGA-UCEC", "TCGA-UCS",  "TCGA-UVM")

for (cohort in cohorts) {
  print(sprintf("processing %s cohort...", cohort))
  load(sprintf(tcga_path, cohort))
  missense_indices <- which(TCGA$mutation$Variant_Classification == "Missense_Mutation" & substr(TCGA$mutation$Tumor_Sample_Barcode, 14, 15) != "06" & grepl("?", TCGA$mutation$HGVSp_Short, fixed = TRUE) == FALSE)

  mutation <- data.frame(row.names = 1:length(missense_indices))
  mutation[, "Cohort"] <- toupper(cohort)
  mutation[, "Caller"] <- TCGA$mutation[missense_indices, "Mutation_Caller"]
  mutation[, "Sample"] <- substr(TCGA$mutation[missense_indices, "Tumor_Sample_Barcode"], 1, 12)
  mutation[, "Gene"] <- TCGA$mutation[missense_indices, "Hugo_Symbol"]
  mutation[, "EntrezID"] <- TCGA$mutation[missense_indices, "Entrez_Gene_Id"]
  mutation[, "SwissProt"] <- TCGA$mutation[missense_indices, "SWISSPROT"]
  mutation[, "Chromosome"] <- TCGA$mutation[missense_indices, "Chromosome"]
  mutation[, "Mutation"] <- substr(TCGA$mutation[missense_indices, "HGVSp_Short"], 3, nchar(TCGA$mutation[missense_indices, "HGVSp_Short"]))

  mutation[which(mutation$EntrezID == 0), "EntrezID"] <- NA
  mutation[which(mutation$SwissProt == ""), "SwissProt"] <- NA

  mutation <- mutation[which(mutation[, "Mutation"] != "" & mutation[, "Mutation"] != "="),]
  mutation <- mutation[order(mutation$Sample),]
  rownames(mutation) <- 1:nrow(mutation)
  print(length(unique(mutation$Sample)))

  save(mutation, file = sprintf("./maf/%s_maf.RData", cohort))
}
