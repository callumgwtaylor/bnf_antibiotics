library(tidyverse)
library(rvest)
library(arrow)

open_prescribing <- rvest::read_html("https://openprescribing.net/bnf/")

drug_categories_url <- open_prescribing %>%
  rvest::html_elements("#all-results li a") %>%
  rvest::html_attr("href") %>%
  tibble::as.tibble() %>%
  rename(url = value)

drug_categories_names <- open_prescribing %>%
  rvest::html_elements("#all-results li a") %>%
  rvest::html_text()

drug_categories <- tibble::tibble(drug_categories_names = drug_categories_names,
                                  drug_categories_url = drug_categories_url)

drug_categories <- drug_categories_names %>%
  str_split(":", simplify = TRUE) %>%
  tibble::as_tibble(names = c("section", "name")) %>%
  rename(section_code = V1,
         section_name = V2)

drug_categories_sections <- drug_categories$section_code %>%
  str_split("\\.", simplify = TRUE) %>%
  tibble::as_tibble(names = c("section", "subsection", "subsubsection")) %>%
  rename(section_number = V1,
         subsection_number = V2,
         subsubsection_number = V3)

open_prescribing_drug_sections <- bind_cols(drug_categories, drug_categories_url, drug_categories_sections)

open_prescribing_infection_section <- open_prescribing_drug_sections %>%
  filter(section_number == 5)

arrow::write_feather(x = open_prescribing_infection_section, "./data/open_prescribing_infection_section.feather")

