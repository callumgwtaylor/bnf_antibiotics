library(arrow)
library(tidyverse)

bnf <- arrow::read_feather("./data/bnf_drug_table.feather")
infection <- arrow::read_feather("./data/open_drugs_complete.feather")

infection <- infection %>%
  mutate(bnf_code = str_extract_all(value, "[:digit:]{7}[:alnum:]{2}")) %>%
  mutate(open_name = str_remove_all(value, "\\([:digit:]{7}[:alnum:]{2}\\)")) %>%
  select(-value) %>%
  mutate(bnf_code = as_vector(bnf_code)) %>%
  mutate(open_name = str_to_lower(open_name)) %>%
  mutate(open_name = str_remove(open_name, " $"))

bnf <- bnf %>%
  mutate(bnf_drug_names = str_to_lower(bnf_drug_names))

bnf_first <- bnf %>%
  mutate(open_name = bnf_drug_names)

infection <- left_join(infection, bnf_first, by = "open_name") %>%
  select(-bnf_drug_addresses)

write_csv(infection, "./data/infection.csv")
write_csv(bnf, "./data/bnf.csv")

infection_edit <- read_csv("./data/infection_hand_edit.csv") %>%
  filter(subsection_name != "Antiviral drugs")

bnf_filter <- left_join(bnf, infection_edit, by = "bnf_drug_names") %>%
  filter(section_number == 5) %>%
  select(-bnf_code, -open_name) %>%
  distinct()

arrow::write_feather(x = bnf_filter, "./data/bnf_infection_no_antivirals.feather")

