
library(tidyverse)
library(showtext)
library(ggimage)
library(ggtext)
source("scripts/utils.R")

## Right name and Order
# Creation of data frame
r_sdg <- tibble(
  sdg = c("No Poverty", "Zero Hunger", "Good Health and Wellbeing", 
           "Quality Education", "Gender Equality", "Clean Water and Sanitation", 
           "Affordable and Clean Energy", "Decent Work and Economic Growth",
           "Industry, Innovation, and Infrastructure","Reduced Inequalities",
           "Sustainable Cities and Communities", 
           "Responsible Consumption and Products", "Climate Action", 
           "Life Bellow Water", "Life on Land", "Peace, Justice and Strong Institutions", 
           "Partnerships for the Goals"),
  number = 1:17,
  color = c("#eb1b2d", "#d3a028", "#269b48", "#c31e33", "#ef402b", "#00aed9", 
            "#fdb713", "#8f1738", "#f36d25", "#e11383", "#f99d25", "#cf8d29", 
            "#48773e", "#007dbc", "#3db049", "#01558b", "#173668")
)
# Download images
wikipedia <- "https://en.wikipedia.org/wiki/Sustainable_Development_Goal_"
goal <- 1:17
image_url <- paste0(wikipedia, goal,"#/media/File:480px-Sustainable_Development_Goal_", goal, ".png")

#Download images in local
options(download.file.method = "wininet")
for (i in 1:17) {
  download.file(image_url[i], paste0("testme/", r_sdg$sdg[i], ".svg"))
}

## 
works <- read.csv("datasets/works-2024-12-11T10-37-10.csv", check.names = F)
sdg <- works %>% 
  select(sustainable_development_goals.display_name) %>% 
  rename(sdg = 1) %>% 
  filter(sdg != "") %>% 
  tidyr::separate_longer_delim(cols = sdg, delim = "|") %>% 
  mutate(sdg = stringr::str_to_title(gsub("-", "", trimws(sdg))),
         sdg = stringr::str_replace(sdg, "And", "and"),
         sdg = stringr::str_replace(sdg, "On", "on"),
         sdg = stringr::str_replace(sdg, "Justice,", "Justice"),
         sdg = stringr::str_replace(sdg, "and Production", "and Products"),
         sdg = stringr::str_replace(sdg, "Below", "Bellow"),
         sdg = stringr::str_replace(sdg, "For The Goals", "for the Goals")) %>% 
  count(sdg) %>% 
  mutate(prop = round(n*100/sum(n), 2)) %>% 
  left_join(y = r_sdg, by = "sdg")

## image data frame
img_data <- tibble(path = list.files("sdg_images/", pattern = ".png$", full.names = T),
                   sdg = gsub(".png", "", basename(path))) %>% 
  filter(sdg != "SDN")

# join img_data with sdg
sdg_ready <- sdg %>% 
  left_join(y = img_data, by = "sdg") %>% 
  arrange(prop)
sdg_ready$sdg <- factor(sdg_ready$sdg, levels = sdg_ready$sdg)

## Plot
bulb_posi <- 40
ggplot(data = sdg_ready, aes(x = sdg, y = prop))+
  geom_col(mapping = aes(y = bulb_posi, color = sdg, fill = sdg), 
           width = .01, show.legend = F)+
  geom_point(mapping = aes(y = bulb_posi, color = sdg, fill = sdg), size = 5,
             show.legend = F)+
  geom_point(mapping = aes(y = bulb_posi), color = "white", size = 3,
             show.legend = F)+
  geom_col(aes(fill =  sdg, color = sdg), width = 1, show.legend = FALSE)+
  geom_image(aes(image = path, y = 80), size = 0.08, by = "width")+
  geom_text(mapping = aes(y = bulb_posi + 14, 
                          label = paste0(round(prop, 1), "%"),
                          color = sdg),
            color = ifelse(sdg_ready$sdg == "Life on Land", "white", sdg_ready$color),
            family = "msb", size = 16,
            angle = calc_angle(1:nrow(sdg_ready)))+
  # add line
  ylim(-30, 80)+
  theme_void()+
  scale_fill_manual(values = sdg_ready$color)+
  scale_color_manual(values = sdg_ready$color)+
  theme(
    panel.background = element_blank(),
    plot.title.position = "plot",
  )+
  coord_polar(direction = 1, start = 0, clip = "off")

ggsave("plots/sdg.jpeg", width = 20, height = 20, units = "cm")