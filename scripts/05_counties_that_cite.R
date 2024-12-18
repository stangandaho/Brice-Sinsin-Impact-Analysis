source("scripts/setup.R")

# get sheets
all_sheet <- excel_sheets("datasets/top_articles.xlsx")

# read sheet a bind into single data frame
top_articles <- dplyr::bind_rows(
  purrr::map(all_sheet, read_xlsx, path = "datasets/top_articles.xlsx")
)

##
corrected_countries <- c(
  "Benin", "United States", "Germany", "Brazil", "United Kingdom", "Ethiopia", 
  "South Africa", "China", "Indonesia", "Australia", "Japan", "Portugal", 
  "Malaysia", "Nigeria", "Austria", "Canada", "Czech Republic", "France", 
  "India", "Kenya", "Belgium", "Spain", "Ghana", "Italy", "Poland", 
  "Slovenia", "Zimbabwe", "Argentina", "Bangladesh", "Burkina Faso", 
  "Switzerland", "Cameroon", "Norway", "Philippines", "Sweden", "Turkey", 
  "Tanzania", "Bhutan", "Ivory Coast", "Costa Rica", "Denmark", "Greece", 
  "Iran", "Laos", "Mexico", "Netherlands", "Taiwan", "Uganda", 
  "Democratic Republic of the Congo", "Congo (Brazzaville)", "Colombia", 
  "Cape Verde", "Ecuador", "Finland", "Guinea", "Hungary", "Cambodia", 
  "South Korea", "Mali", "Malawi", "Mozambique", "New Zealand", "Oman", 
  "Peru", "Papua New Guinea", "Pakistan", "Russia", "Seychelles", 
  "Singapore", "Slovakia", "Sao Tome and Principe", "Thailand", "Niger", 
  "Togo", "Sudan", "Senegal", "Burundi", "Algeria", "North Korea", 
  "Sierra Leone", "Egypt", "Vietnam", "Saudi Arabia", "Cuba", "Lithuania", 
  "Serbia", "French Guiana", "South Korea", "Paraguay", "Romania", 
  "Tunisia", "Venezuela", "Nepal", "Namibia", "Democratic Republic of the Congo", 
  "Gabon", "Gambia", "Ireland", "Iraq", "South Korea", "Malta", "Eswatini", 
  "Democratic Republic of the Congo", "Zambia", "Guinea-Bissau", "Chad", 
  "Haiti", "Lebanon", "Morocco", "Reunion", "Angola", "Georgia", "Madagascar", 
  "Jamaica", "Hong Kong", "Iran", "Liberia", "Rwanda"
)

french_names <- c("Bénin", "États-Unis d'Amérique", "Allemagne", "Brésil", "Royaume-Uni de Grande-Bretagne et d'Irlande du Nord", 
                  "Éthiopie", "Afrique du Sud", "Chine", "Indonésie", "Australie", "Japon", "Portugal", "Malaisie", "Nigéria", 
                  "Autriche", "Canada", "Tchéquie", "France", "Inde", "Kenya", "Belgique", "Espagne", "Ghana", "Italie", 
                  "Pologne", "Slovénie", "Zimbabwe", "Argentine", "Bangladesh", "Burkina Faso", "Suisse", "Cameroun", 
                  "Norvège", "Philippines", "Suède", "Turquie", "Tanzanie", "Bhoutan", "Côte d'Ivoire", "Costa Rica", 
                  "Danemark", "Grèce", "Iran", "République démocratique populaire lao", "Mexique", "Pays-Bas", "Taïwan", 
                  "Ouganda", "Congo RDC", "Congo", "Colombie", "Cap-Vert", "Équateur", "Finlande", "Guinée", "Hongrie", 
                  "Cambodge", "République de Corée", "Mali", "Malawi", "Mozambique", "Nouvelle-Zélande", "Oman", "Pérou", 
                  "Papouasie-Nouvelle-Guinée", "Pakistan", "Fédération de Russie", "Seychelles", "Singapour", "Slovaquie", 
                  "São Tomé-et-Príncipe", "Thaïlande", "Niger", "Togo", "Soudan", "Sénégal", "Burundi", "Algérie", 
                  "Corée", "Sierra Leone", "Égypte", "Vietnam", "Arabie Saoudite", "Cuba", "Lituanie", "Serbie", 
                  "Guyane française", "Corée du Sud", "Paraguay", "Roumanie", "Tunisie", "Venezuela", "Népal", "Namibie", 
                  "République démocratique du Congo", "Gabon", "Gambie", "Irlande", "Irak", "République de Corée", "Malte", 
                  "Eswatini", "République démocratique du Congo", "Zambie", "Guinée-Bissau", "Tchad", "Haïti", "Liban", 
                  "Maroc", "Réunion", "Angola", "Géorgie", "Madagascar", "Jamaïque", "Hong Kong", "Iran", "Libéria", 
                  "Rwanda")

# import world boundary
world <- sf::read_sf("D:\\QGIS Projects\\Shp\\World Countries\\World_Countries.shp")
top_summ <- top_articles %>% 
  summarise(count = sum(count), .by = "name") %>% 
  mutate(name_fr = french_names,
         COUNTRY = corrected_countries) %>% 
  left_join(y = world, by = "COUNTRY")

# countries that cite plot
ggplot(data = top_summ)+
  geom_sf(data = world, mapping = aes(geometry = geometry), color = NA, fill = "gray80")+
  geom_sf(mapping = aes(geometry = geometry, fill = count), color = "gray80")+
  guides(fill = guide_colorbar(title = "Nombre de citations"))+
  scale_fill_gradientn(colours = cplt, na.value = NA,
                       limits = c(min(top_summ$count), max(top_summ$count)), 
                       breaks = seq(0, max(top_summ$count), 40))+
  theme_void()+
  theme(
    legend.position = "bottom",
    legend.key.height = unit(0.4, units = "lines"),
    legend.key.width = unit(5, units = "lines"),
    legend.title.position = "top",
    legend.title = element_text(hjust = .5, size = 30, family = "msb"),
    legend.text = element_text(size = 25, family = "mm")
  )
#save
ggsave("plots/countries_map.jpeg", width = 30, height = 15, units = "cm")
