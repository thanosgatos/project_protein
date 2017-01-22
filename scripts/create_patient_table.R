# Create patient_table
load("./data_processed/TCGA_MAF.RData")

# Get patient IDs and their cohort from TCGA_MAF
## (We know each patient ID is only in one cohort, since we're talking about
## primary tumors)
patient_maf <- unique(TCGA_MAF[, c("Sample", "Cohort")])
colnames(patient_maf) <- c("patient_id", "cohort")

# TCGA cohorts
cohorts <- c("TCGA-ACC",  "TCGA-BLCA", "TCGA-BRCA", "TCGA-CESC", "TCGA-CHOL",
             "TCGA-COAD", "TCGA-DLBC", "TCGA-ESCA", "TCGA-GBM",  "TCGA-HNSC",
             "TCGA-KICH", "TCGA-KIRC", "TCGA-KIRP", "TCGA-LAML", "TCGA-LGG",
             "TCGA-LIHC", "TCGA-LUAD", "TCGA-LUSC", "TCGA-MESO", "TCGA-OV",
             "TCGA-PAAD", "TCGA-PCPG", "TCGA-PRAD", "TCGA-READ", "TCGA-SARC",
             "TCGA-SKCM", "TCGA-STAD", "TCGA-TGCT", "TCGA-THCA", "TCGA-THYM",
             "TCGA-UCEC", "TCGA-UCS",  "TCGA-UVM")

patient_table <- data.frame()
i <- 1

for (cohort in  cohorts) {

  print(sprintf("Processing %s cohort (%d/33)...", cohort, i))

  # Load the cohort's survival data file
  load(sprintf("./data/survival/%s.RData", cohort))

  # Get the clinical data frame from the TCGA list
  clinical <- TCGA$clinical

  # Add patient IDs to the clinical data frame
  patient_id <- rownames(clinical)
  clinical <- cbind(patient_id, clinical)

  # Filter clinical with the patient_maf we have from TCGA_MAF
  current_cohort <- clinical[which(patient_id %in% patient_maf$patient_id), ]

  # Add the cohort column
  current <- merge(current_cohort, patient_maf, by = "patient_id", all.x = TRUE)

  # Keep only the columns needed
  current <- current[, c("patient_id", "cohort", "gender", "race",
                         "vital_status", "days_to_death",
                         "days_to_last_followup", "clinical_stage",
                         "clinical_T", "clinical_N", "clinical_M",
                         "pathologic_stage", "pathologic_T",
                         "pathologic_N", "pathologic_M")]

  # Create patient_table
  patient_table <- rbind(patient_table, current)

  i <- i + 1

}

print("patient_table created!")

# We get 2773 rows. There are observations in patient_maf that have no clinical
# data in the data/survival/TCGA-"cohort".RData files

# Add these missing patients to the patient_table
patient_table <- merge(patient_maf, patient_table,
                       by = c("patient_id", "cohort"), all = TRUE)

# Save the annotation table as an RData object in data_processed/
save(list = "patient_table", file = "./data_processed/patient_table.RData")
