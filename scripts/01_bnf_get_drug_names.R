library(tidyverse)
library(rvest)
library(arrow)

bnf_drugs <- read_html("https://bnf.nice.org.uk/drug/")

bnf_drug_names <- bnf_drugs %>%
  html_elements(".grid3 span") %>%
  html_text()

bnf_drug_addresses <- bnf_drugs %>%
  html_elements(".grid3 a") %>%
  html_attr("href")


bnf_drug_table <- tibble::tibble(bnf_drug_names = bnf_drug_names,
                                 bnf_drug_addresses = bnf_drug_addresses)

arrow::write_feather(x = bnf_drug_table, "./data/bnf_drug_table.feather")
