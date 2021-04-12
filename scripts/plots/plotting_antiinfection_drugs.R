library(tidyverse)
library(arrow)
library(ggraph)
library(igraph)

bnf <- read_feather("./data/bnf_infection_no_antivirals.feather")

bnf_sections <- bnf %>%
  select(section_name, subsection_name, subsubsection_name, bnf_drug_names) %>%
  arrange(section_name, subsection_name, subsubsection_name, bnf_drug_names)

bnf_sections_one <- bnf_sections %>%
  select(from = section_name, to = subsection_name)

bnf_sections_two <- bnf_sections %>%
  select(from = subsection_name, to = subsubsection_name)

bnf_sections_three <- bnf_sections %>%
  select(from = subsubsection_name, to = bnf_drug_names)

bnf_sections <- bind_rows(bnf_sections_one, bnf_sections_two, bnf_sections_three)

bnf_graph <- igraph::graph_from_data_frame(bnf_sections)
save_this_plot <- ggraph::ggraph(bnf_graph, layout = 'dendrogram', circular = TRUE) +
  ggraph::geom_edge_diagonal() +
  ggraph::geom_node_point() +
  geom_node_text(aes(label = name), repel = TRUE) +
  coord_flip() +
  scale_y_reverse()

ggsave(filename = "./plots/dendrogram.svg", save_this_plot, scale = 5)

