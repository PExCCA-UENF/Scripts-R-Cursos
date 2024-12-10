# Pacotes necessários para o processamento e manipulação
if(!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)

# Função para importar os dados
import_from_INMET_BDMEP <-
  function(file){
    require(tidyverse)
    df_id <-
      read_csv2(
        file = file,
        col_names = F,
        n_max = 9
      ) |> 
      separate(
        col = X1, 
        into = c("info", "value"), 
        sep = ": "
      ) |> 
      pivot_wider(
        names_from = info, 
        values_from = value
      )
    
    df_data <-
      read_csv2(
        file = file,
        na = "null",
        skip = 10,
        col_types = cols(`Hora Medicao` = col_time(format = "%H%M"))
      ) |> 
      select(!starts_with("...")) 
    
    df_final <-
      bind_cols(df_id, df_data)
    
    return(df_final)
  }

# Listando arquivos para importação
files <- list.files(path = "Dados/Dados_Bruto_INMET/", full.names = T)

# Importando dados em loop aplicado com map
dados <-
  map_df(
    .x = files,
    .f = ~ import_from_INMET_BDMEP(file = .x)
  )

# Manipulação necessária; Calculo da Precipitação Acumulada
dados_f <-
  dados |>
  drop_na() |> 
  group_by(`Codigo Estacao`) |> 
  summarise(
    across(
      Nome:Longitude,
      unique
    ),
    Prec_Acc = sum(`PRECIPITACAO TOTAL, HORARIO(mm)`)
  ) |> 
  ungroup() |> 
  mutate(
    across(
      Latitude:Longitude, 
      parse_number),
    across(
      c(`Codigo Estacao`, Nome),
      as.factor
    )
  )

# Verificando Resultados
str(dados_f)
View(dados_f)

# Exportando Arquivo
write_csv(
  dados_f,
  file = "Dados/Precipitacao_Acumulada_RS_Abril_Maio_2024.csv"
)

