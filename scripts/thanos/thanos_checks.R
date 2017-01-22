library(tidyverse)

# Is grow_table NA-free?
grow_table %>%
  is.na() %>%
  colSums()
## YES!

# Is igrow_table NA-free?
igrow_table %>%
  is.na() %>%
  colSums()
## YES!


column_widths <- c(2, 2, 2, 2, 5, 1, 4, 6, 5, 4, 5, 6, 4, 5, 1, 2, 6, 4)

test_function <- function(path) {
  grow <- read.fwf(path, widths = column_widths,
                   strip.white = TRUE, stringsAsFactors = FALSE,
                   na.strings = " ")
  grow
}

# ---------------------------------------------------------------------------- #

column_widths <- c(2, 2, 2, 2, 5, 1, 4, 6, 5, 4, 5, 6, 4, 5, 1, 2, 6, 4)
x <- read.fwf("./data/grow/1a00.grow", widths = column_widths,
              strip.white = TRUE)
y <- read.fwf("./data/grow/1a00.grow", widths = column_widths,
              strip.white = TRUE, stringsAsFactors = FALSE)



# ---------------------------------------------------------------------------- #
type <- "grow"
sprintf(paste("mv %s/%s_combined.txt ",
              "%s/data_combined/%s_combined.txt",
              sep = ""),
        grow_directory,
        type,
        working_directory,
        type)

"mv /home/thanos/Dropbox/R/project_protein/data/grow/grow_combined.txt /home/thanos/Dropbox/R/project_protein/data_combined/grow_combined.txt"

"mv /home/thanos/Dropbox/R/project_protein/data/grow/grow_combined.txt /home/thanos/Dropbox/R/project_protein/data_combined/grow_combined.txt"

"mv /home/thanos/Dropbox/R/project_protein/data/grow/grow_combined.txt /home/thanos/Dropbox/R/project_protein/data_combined/grow_combined.txt"

"mv grow_directory/grow_combined.txt /home/thanos/Dropbox/R/project_protein/data_combined/grow_combined.txt"

"mv grow_directory/grow_line_numbers.txt /home/thanos/Dropbox/R/project_protein/data_combined/grow_line_numbers.txt"


"mv /home/thanos/Dropbox/R/project_protein/data/grow/grow_line_numbers.txt /home/thanos/Dropbox/R/project_protein/data_combined/grow_line_numbers.txt"
