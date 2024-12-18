# https://openalex.org/works?page=1&filter=authorships.author.id%3Aa5002696613%7Ca5110569628%7Ca5020806180%7Ca5089934542%7Ca5089178832%7Ca5106139886%7Ca5105993235%7Ca5098191429%7Ca5069810051%7Ca5060155943%7Ca5112893529%7Ca5110070831%7Ca5090806164%7Ca5045968496

pkg_to_install <- c("ggplot2", "dplyr", 
                    "showtext", "sf", 
                    "readxl", "stringr",
                    "purrr", "ggsankey",
                    "grDevices")


for (pkg in pkg_to_install) {
  if (!pkg %in% rownames(installed.packages())) {
    install.packages(pkg, repos = "https://packagemanager.posit.co/cran/latest")
  }
}

rm(pkg, pkg_to_install)

# load package
library(ggplot2)
library(dplyr)
library(showtext)
library(sf)
library(readxl)
library(stringr)
library(ggsankey)

# Design
color_plt <- c("#736B53", "#F2A516", "#D97904", "#BF5B04", "#0D0D0D")
cplt <- c("#363432", "#196774", "#90A19D", "#F0941F", "#EF6024")

library(grDevices)
# Function to interpolate colors
generate_colors <- function(colors, n) {
  color_ramp <- colorRampPalette(colors)
  color_ramp(n)
}

# Generate 22 colors
extended_colors <- generate_colors(color_plt, 22)

# fonts
font_add("mm", "fonts/Montserrat-Medium.ttf")
font_add("msb", "fonts/Montserrat-SemiBold.ttf")
showtext_auto()

# country name
country_name <- c("Bénin", "Italie", "Belgique", "Danemark", "Allemagne", "Nigeria", "États-Unis", "Cameroun", "Royaume-Uni", "Suède", 
                  "Burkina Faso", "Côte d'Ivoire", "Afrique du Sud", "Namibie", "Niger", "Kenya", "Roumanie", "Autriche", "Serbie", 
                  "Pays-Bas", "Finlande", "France", "Philippines", "Éthiopie", "Sénégal", "Soudan", "Suisse", "Chine", "Turquie", "Tchad", 
                  "Togo", "Rwanda", "Espagne", "Ouganda", "Brésil", "Malawi", "Guadeloupe", "Portugal", "Estonie", "République tchèque", 
                  "Tanzanie", "Ghana", "Égypte", "Canada", "Maroc", "Pologne", "Corée du Sud", "Vietnam", "Colombie", "Congo-Brazzaville", 
                  "Inde", "Bolivie", "Mali"
)