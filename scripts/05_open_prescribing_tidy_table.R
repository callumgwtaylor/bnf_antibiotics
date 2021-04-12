library(tidyverse)
library(arrow)

open_drugs <- arrow::read_arrow("./data/open_prescribing_drugs.feather")
open_classes <- arrow::read_arrow("./data/open_prescribing_infection_section.feather")

open_prescribing_section <- open_classes %>%
  filter(subsection_number == "" & subsubsection_number == "") %>%
  select(section_code, section_name) %>%
  rename(section_number = section_code)

open_prescribing_subsection <- open_classes %>%
  filter(subsubsection_number == "" & subsection_number != "" ) %>%
  rename(subsection_name = section_name) %>%
  select(subsection_name, subsection_number)

open_prescribing_subsubsection <- open_classes %>%
  filter(subsubsection_number != "" & subsection_number != "" ) %>%
  rename(subsubsection_name = section_name) %>%
  select(subsubsection_name, subsection_number, subsubsection_number)

open_classes_complete <- open_classes %>%
  select(-section_name) %>%
  left_join(open_prescribing_section, by = "section_number") %>%
  left_join(open_prescribing_subsection, by = "subsection_number") %>%
  left_join(open_prescribing_subsubsection, by = c("subsection_number", "subsubsection_number"))


open_drugs_complete <- left_join(open_drugs, open_classes_complete, by = "url")  
arrow::write_feather(x = open_drugs_complete, "./data/open_drugs_complete.feather")
