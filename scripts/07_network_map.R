source("scripts/setup.R")

#
node_edge <- read.csv("datasets/sankey_node_edge.csv")
# world boundary, 
world <- sf::read_sf("D:\\QGIS Projects\\Shp\\World Countries\\World_Countries.shp")


# French names of the countries
french_names <- c("Aruba (Pays-Bas)", "Antigua-et-Barbuda", "Afghanistan", "Algérie", "Azerbaïdjan",
                  "Albanie", "Arménie", "Andorre", "Angola", "Samoa américaines (États-Unis)", "Argentine", 
                  "Australie", "Autriche", "Anguilla (Royaume-Uni)", "Bahreïn", "Barbade", "Botswana", 
                  "Bermudes (Royaume-Uni)", "Belgique", "Bahamas", "Bangladesh", "Belize", 
                  "Bosnie-Herzégovine", "Bolivie", "Myanmar", "Bénin", "Biélorussie", "Îles Salomon", 
                  "Brésil", "Bhoutan", "Bulgarie", "Île Bouvet (Norvège)", "Brunei Darussalam", 
                  "Burundi", "Canada", "Cambodge", "Tchad", "Sri Lanka", "Congo-Brazzaville", 
                  "République Démocratique du Congo", "Chine", "Chili", "Îles Caïmans (Royaume-Uni)", 
                  "Îles Cocos (Keeling) (Australie)", "Cameroun", "Comores", "Colombie", 
                  "Îles Mariannes du Nord (États-Unis)", "Costa Rica", "République Centrafricaine", 
                  "Cuba", "Cap-Vert", "Îles Cook (Nouvelle-Zélande)", "Chypre", "Danemark", "Djibouti", 
                  "Dominique", "Île Jarvis (États-Unis)", "République Dominicaine", "Équateur", "Égypte", 
                  "Irlande", "Guinée équatoriale", "Estonie", "Érythrée", "Salvador", "Éthiopie", 
                  "République tchèque", "Guyane française", "Finlande", "Fidji", "Îles Falkland (Royaume-Uni)", 
                  "États fédérés de Micronésie", "Îles Féroé (Danemark)", "Polynésie française", 
                  "Île Baker (États-Unis)", "France", "Terres Australes et Antarctiques Françaises", 
                  "Gambie", "Gabon", "Géorgie", "Ghana", "Gibraltar (Royaume-Uni)", "Grenade", "Guernesey (Royaume-Uni)", 
                  "Groenland (Danemark)", "Allemagne", "Îles Glorieuses", "Guadeloupe", "Guam (États-Unis)", 
                  "Grèce", "Guatemala", "Guinée", "Guyana", "Palestine", "Haïti", "Îles Heard et McDonald (Australie)", 
                  "Honduras", "Île Howland (États-Unis)", "Croatie", "Hongrie", "Islande", "Île de Man (Royaume-Uni)", 
                  "Inde", "Territoire britannique de l'océan Indien (Royaume-Uni)", "Iran", "Israël", "Italie", 
                  "Côte d'Ivoire", "Irak", "Japon", "Jersey (Royaume-Uni)", "Jamaïque", "Île Jan Mayen (Norvège)", 
                  "Jordanie", "Atoll Johnston (États-Unis)", "Île Juan de Nova", "Kenya", "Kirghizistan", 
                  "Corée du Nord", "Kiribati", "Corée du Sud", "Île Christmas (Australie)", "Koweït", "Kazakhstan", 
                  "Laos", "Liban", "Lettonie", "Lituanie", "Liberia", "Slovaquie", "Liechtenstein", "Lesotho", 
                  "Luxembourg", "Libye", "Madagascar", "Martinique", "République de Moldavie", "Mayotte", 
                  "Mongolie", "Montserrat (Royaume-Uni)", "Malawi", "Macédoine", "Mali", "Monaco", "Maroc", 
                  "Île Maurice", "Îles Midway (États-Unis)", "Mauritanie", "Malte", "Oman", "Maldives", "Monténégro", 
                  "Mexique", "Malaisie", "Mozambique", "Nouvelle-Calédonie", "Niue", "Île Norfolk (Australie)", 
                  "Niger", "Vanuatu", "Nigéria", "Pays-Bas", "Norvège", "Népal", "Nauru", "Suriname", "Nicaragua", 
                  "Nouvelle-Zélande", "Paraguay", "Îles Pitcairn (Royaume-Uni)", "Pérou", "Îles Paracel", 
                  "Îles Spratleys (Disputées)", "Pakistan", "Pologne", "Panama", "Portugal", "Papouasie-Nouvelle-Guinée", 
                  "Palau", "Guinée-Bissau", "Qatar", "Réunion", "Îles Marshall", "Roumanie", "Philippines", 
                  "Porto Rico (États-Unis)", "Russie", "Rwanda", "Arabie Saoudite", "Saint-Pierre-et-Miquelon", 
                  "Saint-Kitts-et-Nevis", "Seychelles", "Afrique du Sud", "Sénégal", "Île Sainte-Hélène (Royaume-Uni)", 
                  "Slovénie", "Sierra Leone", "Saint-Marin", "Singapour", "Somalie", "Espagne", "Serbie", "Sainte-Lucie", 
                  "Soudan", "Svalbard (Norvège)", "Suède", "Géorgie du Sud et Îles Sandwich du Sud (Royaume-Uni)", 
                  "Syrie", "Suisse", "Émirats Arabes Unis", "Trinité-et-Tobago", "Thaïlande", "Tadjikistan", 
                  "Îles Turks et Caïques (Royaume-Uni)", "Tokelau (Nouvelle-Zélande)", "Tonga", "Togo", 
                  "Sao Tomé-et-Principe", "Tunisie", "Turquie", "Tuvalu", "Taïwan", "Turkménistan", "Tanzanie", 
                  "Ouganda", "Royaume-Uni", "Ukraine", "États-Unis", "Burkina Faso", "Uruguay", "Ouzbékistan", 
                  "Saint-Vincent-et-les Grenadines", "Venezuela", "Îles Vierges britanniques (Royaume-Uni)", 
                  "Vietnam", "Îles Vierges américaines (États-Unis)", "Namibie", "Wallis-et-Futuna (France)", 
                  "Sahara Occidental", "Île Wake (États-Unis)", "Samoa", "Eswatini", "Yémen", "Zambie", "Zimbabwe", 
                  "Soudan du Sud", "Indonésie", "Timor-Oriental", "Curaçao (Pays-Bas)", "Bonaire (Pays-Bas)")
world <- world %>% mutate(french_name = french_names)

# country of interest
coi <- unique(node_edge$source)
coi_boundary <- world %>% 
  filter(french_name %in% coi) %>% 
  select(french_name, geometry)

centroid <- coi_boundary %>% 
  st_centroid() %>% 
  st_coordinates() %>% 
  as.data.frame() %>% 
  rename(lon = X, lat = Y)

coi_data <- coi_boundary %>% 
  bind_cols(centroid) %>% 
  left_join(y = node_edge %>% filter(source == "Bénin" & destination != "Bénin") %>% 
              rename(french_name = destination),
            by = "french_name")

##
ggplot(data = coi_data)+
  geom_sf(data = world, color = NA, fill = "gray80")+
  geom_sf(mapping = aes(fill = flow), color = "white")+
  geom_point(mapping = aes(x = lon, y = lat), size = 3, color = "white")+
  geom_point(mapping = aes(x = lon, y = lat), color = cplt[4])+
  geom_curve(data = coi_data %>% mutate(benx = 2.34, beny = 9.64),
             mapping = aes(x = benx, y = beny, xend = lon, yend = lat),
             color = cplt[4])+
  scale_fill_gradientn(colours = cplt, na.value = NA,
                       limits = c(min(coi_data$flow, na.rm = T), max(coi_data$flow, na.rm = T)), 
                       breaks = seq(0, max(coi_data$flow, na.rm = T), 60))+
  theme_void()+
  labs(fill = "Nombre de collaborations entre Bénin et d'autres pays")+
  theme(
    legend.position = "bottom",
    legend.key.height = unit(0.4, units = "lines"),
    legend.key.width = unit(5, units = "lines"),
    legend.title.position = "top",
    legend.title = element_text(hjust = .5, size = 30, family = "msb"),
    legend.text = element_text(size = 25, family = "mm")
  )
#save
ggsave("plots/collab_Benin_Autres_pays.jpeg", width = 30, height = 15, units = "cm")

### V2
ggplot(data = coi_data)+
  geom_sf(data = world, color = NA, fill = "gray80")+
  geom_sf(fill = cplt[1], color = "white")+
  geom_point(mapping = aes(x = lon, y = lat, size = flow), color = "white")+
  geom_point(mapping = aes(x = lon, y = lat, size = flow), stroke = .1, color = cplt[4])+
  geom_curve(data = coi_data %>% mutate(benx = 2.34, beny = 9.64),
             mapping = aes(x = benx, y = beny, xend = lon, yend = lat),
             color = cplt[4])+
  scale_size_continuous(limits = c(min(coi_data$flow, na.rm = T), max(coi_data$flow, na.rm = T)), 
                       breaks = seq(0, max(coi_data$flow, na.rm = T), 90),
                       labels = c("0", "≤ 90", paste0(seq(0, max(coi_data$flow, na.rm = T), 80))[3:6]
                                  ))+
  theme_void()+
  labs(size = "Nombre de collaborations entre Bénin et d'autres pays")+
  theme(
    legend.position = "bottom",
    legend.title.position = "top",
    legend.title = element_text(hjust = .5, size = 30, family = "msb"),
    legend.text = element_text(size = 25, family = "mm")
  )
# save
ggsave("plots/collab_Benin_Autres_pays_V2.jpeg", width = 30, height = 15, units = "cm")


