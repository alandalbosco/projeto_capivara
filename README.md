# Projeto Capivara

Este repositório contém a estrutura reprodutível para o mapeamento de ocorrências de *Hydrochoerus hydrochaeris* no Brasil utilizando dados do GBIF.

# Estrutura do Repositório

- **Data/**: Diretório contendo os dados do projeto.
  - **L0/**: Dados brutos originais obtidos via API do GBIF (imutáveis).
  - **L1/**: Dados limpos e filtrados prontos para a plotagem espacial.
- **Scripts/**: Códigos em R organizados logicamente.
  - `1_processar_dados.R`: Coleta automática do GBIF e triagem dos dados.
  - `2_gerar_mapa.R`: Projeção espacial, geração do mapa com ggplot2 e exportação.
- **Results/**: Output visual do mapa gerado em alta resolução (.tiff).

# Criado em "RStudio 2026.01.0 Build 392"