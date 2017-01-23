library(tidyverse)
library(stringr)

annotation_table <- as_tibble(annotation_table)
patient_table <- as_tibble(patient_table)
TCGA_MAF <- as_tibble(TCGA_MAF)


# Given a gene (KRAS), filter the annotation_table
TCGA_MAF %>%
  filter(Gene == "KRAS") %>%
  select(PDB) %>%
  transmute(pdb = str_split(PDB, ";")) %>%
  unnest() %>%
  distinct()

annotation_table %>%
  semi_join(
    TCGA_MAF %>%
      filter(Gene == "KRAS") %>%
      select(PDB) %>%
      transmute(pdb = str_split(PDB, ";")) %>%
      unnest() %>%
      distinct(),
    by = "pdb"
  )



# Given a gene (KRAS), filter the patient_table
TCGA_MAF %>%
  filter(Gene == "KRAS") %>%
  select(patient_id = Sample) %>%
  distinct()

patient_table %>%
  semi_join(
    TCGA_MAF %>%
      filter(Gene == "KRAS") %>%
      select(patient_id = Sample) %>%
      distinct(),
    by = "patient_id"
  )


# Filter given cohort (TCGA-LUAD)
TCGA_MAF %>%
  group_by(Sample) %>%
  filter(Cohort == "TCGA-LUAD") %>%
  select(Cohort, Sample, PDB)

patient_table %>%
  filter(cohort == "TCGA-LUAD")

annotation_table %>%
  semi_join(
    TCGA_MAF %>%
      filter(Cohort == "TCGA-LUAD") %>%
      select(PDB) %>%
      transmute(pdb = str_split(PDB, ";")) %>%
      unnest(),
    by = "pdb"
  )
