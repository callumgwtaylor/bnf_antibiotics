library(rvest)
library(tidyverse)

open_prescribing_download_names <- function(url){
  
  full_url = str_c("https://openprescribing.net", url, sep = "")
  
  infection_section <- read_html(full_url)
  
  infection_drugs <- infection_section %>%
    html_elements(".starter-template > a") %>%
    html_text()
  
  print(as.character(url))
  Sys.sleep(2)
    infection_drugs %>%
    as_tibble() %>%
    mutate(url = url)
}

