# load package
source("scripts/setup.R")
source("scripts/utils.R")

# field
primary_field <- read_excel("datasets/publications_by_thematic_filtered.xlsx") %>% 
  rename(field = 1, n = 2) %>%  
  mutate(prop = round(n*100/sum(n), 2)) %>% 
  arrange(prop) %>% 
  mutate(field = stringr::str_wrap(field, 40))

primary_field$field <- factor(primary_field$field, levels = primary_field$field)
  
ggplot(data = primary_field %>% 
         mutate(label_pos = case_when(field == "Agroforesterie et durabilité agricole" ~ 60,
                                      TRUE ~ 7*prop)))+
  geom_col(mapping = aes(x = field, y = n, fill = prop), show.legend = F)+
  scale_fill_gradientn(colours = color_plt[1:5])+
  geom_text(mapping = aes(x = field, y = label_pos, 
                          label = paste0(field, "\n(", prop, "%)")),
            hjust = 0,
            color = if_else(primary_field$field == "Agroforesterie et durabilité agricole", 
                            color_plt[4], color_plt[5]),
            #angle = calc_angle(1:nrow(primary_field)),
            family = "msb", 
            size = if_else(primary_field$field == "Agroforesterie et durabilité agricole", 
                                           10, 7),
            lineheight = 0.3,
            )+
  coord_flip()+
  theme_void()

#save
ggsave(filename = "plots/field_contrib.jpeg", width = 14, height = 10, units = "cm")