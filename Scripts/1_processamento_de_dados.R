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
