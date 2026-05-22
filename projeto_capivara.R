#==============================================================================
# SCRIPT 1: COLETA, SALVAMENTO BRUTO (L0) E LIMPEZA DAS OCORRÊNCIAS (L1)
#==============================================================================

install.packages ('rnaturalearth')
install.packages ('rnaturalearthdata')
install.packages ('sf')
install.packages ('dplyr') 
install.packages ('rgbif')

library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(dplyr)
library(rgbif)

capivara_key <- name_backbone('Hydrochoerus hydrochaeris')$usageKey

occs_raw <- occ_data(scientificName = 'Hydrochoerus hydrochaeris',
                     country = 'BR',
                     hasCoordinate = TRUE,
                     limit = 50000)

dados_brutos <- occs_raw$data

dados_brutos_salvaveis <- dados_brutos %>% 
          select(where(~ !is.list(.)))

write.csv(dados_brutos_salvaveis, 
          file = "Data/L0/ocorrencias_capivara_raw.csv", 
          row.names = FALSE)

occs_df <- dados_brutos %>%
  select(species, decimalLongitude, decimalLatitude)

occs_clean <- occs_df %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude))

write.csv(occs_clean, 
          file = "Data/L1/ocorrencias_capivara_BR.csv", 
          row.names = FALSE)


#==============================================================================
# SCRIPT 2: FORMULAÇÃO DO MAPA E EXPORTAÇÃO (RESULTS)
#==============================================================================

install.packages ('sf')
install.packages ('ggplot2')
install.packages ('ggspatial')
install.packages ('rnaturalearth')

library(sf)
library(ggplot2)
library(ggspatial)
library(rnaturalearth)

occs_clean <- read.csv("Data/L1/ocorrencias_capivara_BR.csv")

shape_br <- ne_countries(scale = 'medium', country = 'Brazil', returnclass = 'sf')

occs_sf <- st_as_sf(occs_clean,
                    coords = c('decimalLongitude', 'decimalLatitude'),
                    crs = 4326)

shape_br <- st_transform(shape_br, 5641)
occs_sf <- st_transform(occs_sf, 5641)

mapa_distribuicao <- ggplot() +
  geom_sf(data = shape_br, fill = '#f9f9f9', color = '#444444', linewidth = 0.4) +
  geom_sf(data = occs_sf, color = '#228B22', alpha = 0.5, size = 1.2) +
  ggspatial::annotation_scale(
    location = 'bl',
    width_hint = 0.3
  ) +
  ggspatial::annotation_north_arrow(
    location = 'bl',
    which_north = 'true',
    pad_x = unit(0.6, 'cm'),
    pad_y = unit(1.2, 'cm'),
    style = ggspatial::north_arrow_fancy_orienteering
  ) +
  theme_minimal() +
  labs(
    title = bquote('Distribuição Geográfica de ' ~ italic('Hydrochoerus hydrochaeris')),
    subtitle = 'Dados obtidos via GBIF (Ocorrências no Brasil)',
    x = 'Longitude',
    y = 'Latitude'
  ) +
  theme(
    plot.title = element_text(face = 'bold', size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5),
    panel.grid.major = element_line(color = '#eaeaea')
  )

print(mapa_distribuicao)

ggsave(
  filename = 'Results/mapa_distribuicao_capivara_BR.tiff',
  plot = mapa_distribuicao,
  device = 'tiff',
  width = 20,
  height = 20,
  units = 'cm',
  dpi = 300,
  compression = 'lzw'
)
