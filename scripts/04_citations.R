source("scripts/setup.R")

# import works data
works <- read.csv("datasets/works-2024-12-11T10-37-10.csv", check.names = F)

year_citation <- works %>% 
  select(publication_year, cited_by_count) %>% 
  summarise(n = sum(cited_by_count), .by = "publication_year")

# year range
min_year <- min(year_citation$publication_year, na.rm = T)
max_year <- max(year_citation$publication_year, na.rm = T)

#
min_citation <- min(year_citation$n, na.rm = T)
max_citation <- max(year_citation$n, na.rm = T)

ggplot(data = year_citation, mapping = aes(x = publication_year, y = n))+
  geom_line(color = "white", linewidth = 1.1)+
  scale_x_continuous(breaks = seq(min_year, max_year, 1))+
  geom_label(mapping = aes(label = n, y = n), 
             label.padding = unit(.08, units = "lines"),
             label.r = unit(0.09, units = "lines"),
            size = 11, family = "mm", color = color_plt[5])+
  #scale_y_continuous(breaks = seq(min_citation, max_citation, 50))+
  labs(x = "Années de publications", y = "Nombre de Citation")+
  theme(plot.background = element_rect(fill = color_plt[5]),
        panel.background = element_rect(fill = color_plt[5]),
        panel.grid = element_blank(),
        #
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.line.x = element_line(linewidth = .5, color = color_plt[1]),
        axis.text.x = element_text(size = 50, family = "mm", 
                                   colour = color_plt[4], 
                                   angle = 90, hjust = 1, vjust = 0.5),
        axis.ticks = element_line(colour = color_plt[1]),
        axis.title = element_text(colour = color_plt[1], family = "msb", size = 60),
        axis.title.x = element_text(colour = color_plt[1], 
                                    family = "msb", size = 60, 
                                    margin = margin(t = .4, b = .8, unit = "lines"))
        
  )
# save
ggsave(filename = "plots/year_and_citation.jpeg", width = 30, height = 20, units = "cm")
