library(rvest)
library(arrow)
library(tidyverse)

source("./scripts/03_open_prescribing_download_drugs_function.R")

open_prescribing <- arrow::read_feather("./data/open_prescribing_infection_section.feather") %>%
  filter(subsubsection_number != "")

open_prescribing_names <- as.list(open_prescribing$url)

open_prescribing_drugs <- purrr::map(open_prescribing_names, open_prescribing_download_names) %>%
  bind_rows()


arrow::write_feather(x = open_prescribing_drugs, "./data/open_prescribing_drugs.feather")
