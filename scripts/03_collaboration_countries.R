source("scripts/setup.R")

# import works data
works <- read.csv("datasets/works-2024-12-11T10-37-10.csv", check.names = F)
ct <- lapply(strsplit(works$authorships.countries, "\\|"), 
             function(x){
                 return(x[x != ""])
               }
             )

matricial <- matrix(data = 0, ncol = length(unique(unlist(ct))), 
                    nrow = length(unique(unlist(ct))))
colnames(matricial) <- unique(unlist(ct))
rownames(matricial) <- unique(unlist(ct))

# Populate the data frame with the number of times each country meets another
for (i in 1:length(ct)) {
  countries_in_list <- ct[[i]]
  if (length(countries_in_list) <= 0) {
    next
  }
  for (j in 1:length(countries_in_list)) {
    for (k in 1:length(countries_in_list)) {
      if (j != k) {
        matricial[countries_in_list[j], countries_in_list[k]] <- matricial[countries_in_list[j], countries_in_list[k]] + 1
      }
    }
  }
}


colnames(matricial) <- country_name
rownames(matricial) <- country_name


sankey_data <- matricial %>%
  as.data.frame() %>% 
  tibble::rownames_to_column ()%>%
  tidyr::gather(key = 'key', value = 'value', -rowname)%>% 
  #filter(value > 20) %>% 
  rename(source = rowname, destination = key, flow = value) %>% 
  filter(source != destination)
write.csv(sankey_data, "datasets/sankey_node_edge.csv", row.names = F)


# Prepare data for ggsankey
sankey_ready <- sankey_data %>%
  make_long(source, destination)

# Plot
ggplot(sankey_ready %>% mutate(hjust_value = if_else(x == "source", 1, 0)), aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = factor(node), label = node)) +
  geom_sankey(flow.alpha = .9, node.color = "white", show.legend = F) +
  scale_fill_manual(values = generate_colors(color_plt, 53))+
  geom_sankey_label(size = 8, 
                    color = color_plt[2], 
                    fill = "white",
                    label.padding = unit(.1, "lines"),
                    label.r = unit(0.09, "lines"),
                    family = "msb", 
                    mapping = aes(hjust = hjust_value)) +
  theme_sankey(base_size = 16)+
  theme(
    plot.margin = margin(0,r = 1,0,0, unit = "lines"),
    axis.title.x = element_blank(),
    axis.text = element_blank(),
    legend.title = element_blank(),
    legend.title.position = "left",
    
    legend.key.width = unit(.5, units = "lines")
  )

ggsave(filename = "plots/collaboration_among_countries_less_20.jpeg", width = 22, height = 16, units = "cm")