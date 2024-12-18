source("scripts/setup.R")

# import works data
works <- read.csv("datasets/works-2024-12-11T10-37-10.csv", check.names = F)

# pub trend
works_trend <- works %>% 
  count(publication_year)
min_year <- min(works_trend$publication_year, na.rm = T)
max_year <- max(works_trend$publication_year, na.rm = T)
#
min_count <- min(works_trend$n, na.rm = T)
max_count <- max(works_trend$n, na.rm = T)

ggplot2::ggplot(data = works_trend)+
  geom_point(mapping = aes(x = publication_year, y = n), 
             color = color_plt[1], size = 6)+
  geom_line(mapping = aes(x = publication_year, y = n), 
            color = "white", linewidth = 1.1)+
  geom_point(mapping = aes(x = publication_year, y = n), 
             color = color_plt[4], size = 3)+
  scale_x_continuous(breaks = seq(min_year, max_year, 1))+
  scale_y_continuous(breaks = seq(min_count, max_count, 2))+
  labs(x = "Années de publications", y = "Nombre de publications")+
  theme(plot.background = element_rect(fill = color_plt[5]),
        panel.background = element_rect(fill = color_plt[5]),
        panel.grid = element_blank(),
        #
        axis.line = element_line(linewidth = .5, color = color_plt[1]),
        axis.text.x = element_text(size = 50, family = "mm", 
                                 colour = color_plt[4], 
                                 angle = 90, hjust = 1, vjust = 0.5),
        axis.text.y = element_text(size = 50, family = "mm", 
                                   colour = color_plt[4]),
        axis.ticks = element_line(colour = color_plt[1]),
        axis.title = element_text(colour = color_plt[1], family = "msb", size = 60),
        axis.title.x = element_text(colour = color_plt[1], 
                                    family = "msb", size = 60, 
                                    margin = margin(t = .4, b = .8, unit = "lines"))
        
        )


ggsave(filename = "plots/pub_trend.jpeg", width = 30, height = 20, units = "cm")
