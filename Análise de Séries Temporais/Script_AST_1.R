
#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 04/08/2023                        #
#==============================================================================#

#                 ANÁLISE DE SÉRIES TEMPORAIS NO R - PARTE 1                   #

#------------------------------------------------------------------------------#
# As séries temporais são observações que ocorrem periodicamente ao longo do tempo.
# Objetivos da análise de séries temporais:
# 1. Investigar o mecanismo gerador da série temporal; 
# 2. Descrever o comportamento da série; 
# 3. Verificar a existência de tendências, ciclos e variações sazonais;
# 4. Fazer previsões de valores futuros da série a curto ou longo prazo; 
# 5. Procurar periodicidades relevantes nos dados; 
#    Nesse caso, a análise espectral pode ser de grande utilidade, que é uma forma
#    alternativa de identificar, descrever e analisar sinais no domínio da frequência. 

## Uma série temporal pode ser facilmente visualizada em um gráfico, em que:
#  eixo x representa o tempo (indexação);
#  eixo y representa os valores da série.

# MANIPULAÇÃO E ANÁLISE EXPLORATÓRIA  DE SÉRIES TEMPORAIS ---------------------#
# A manipulação e a visualização de dados, em geral, podem ser feita com o R base, 
# mas o 'tidyverse' facilita as tarefas de análise de dados, além de ter melhor 
# performance computacional. 

# Vamos verificar se o pacote 'tidyverse' está instalado e instalá-lo (se for necessário).
# Em seguida, o capote será carregado. 
if(!require(tidyverse)){
  install.packages('tidyverse')
  library(tidyverse)
}

# O `tidyverse` é uma coleção de pacotes da linguagem R construídos para a ciência 
# de dados. Na prática, carregar o 'tidyverse' é o mesmo que carregar os seguintes pacotes:
# 'tibble': para data frames repaginados;
# 'readr': para importarmos bases para o R;
# 'tidyr' e dplyr: para arrumação e manipulação de dados;
# 'stringr': para trabalharmos com textos;
# 'forcats': para trabalharmos com fatores;
# 'ggplot2': para visualização de dados;
# 'purrr': para programação funcional.

## Importação dos dados ---#
# Vamos usar séries temporais do Banco de Dados Meteorológicos do Instituto Nacional de
# Meteorologia (INMET). Esses dados podem ser baixados do site: https://bdmep.inmet.gov.br/

# Esses dados estão disponíveis no GitHub do PExCCA-UENF:
url_dados <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/An%C3%A1lise%20de%20S%C3%A9ries%20Temporais/dados_A607_D_2012-01-01_2022-12-31.csv'

## Esse arquivo possui dados diários de variáveis meteorológicas do município de 
## Campos dos Goytacazes (RJ), para o período de 2012 a 2022.

dados_campos <-
  readr::read_delim(url_dados, 
                    skip = 10, 
                    na = 'null', 
                    delim = ';', 
                    col_names = T,
                    locale = locale(decimal_mark = ',')) %>% 
  dplyr::select(!ends_with('7')) %>%   # Excluindo a coluna que termina com o prefixo 7.
  dplyr::rename(Data = `Data Medicao`,
         Prec = `PRECIPITACAO TOTAL, DIARIO (AUT)(mm)`,
         Tmed = `TEMPERATURA MEDIA, DIARIA (AUT)(°C)`,
         Tmin = `TEMPERATURA MINIMA, DIARIA (AUT)(°C)`,
         Tmax = `TEMPERATURA MAXIMA, DIARIA (AUT)(°C)`,
         UR = `UMIDADE RELATIVA DO AR, MEDIA DIARIA (AUT)(%)`)
print(dados_campos)

# Atalho de teclado do pipe (pacote 'magrittr') %>%: Ctrl + Shift + M
# A ideia do operador pipe é usar o valor resultante de uma expressão como 
# primeiro argumento da próxima função, possibilitando o encadeamento de funções.

range(dados_campos$Data)   # Retorna a data inicial e final da coluna 'Data.

## Verinficando a sequência de datas da série temporal ---#
## Primeiro, vamos criar um vetor com todas as datas possíveis para o período dos dados.
Data.ref <- seq.Date(
  from = min(dados_campos$Data), 
  to = max(dados_campos$Data), 
  by='1 day') %>% 
  print()

# Agora, vamos comparar as datas de referência (Data.ref) com as datas do conjunto de dados.
dfinal <- 
  dados_campos %>% 
  dplyr::full_join(y = data.frame(Data = Data.ref),   
            by = 'Data') %>% 
  tidyr::separate(
    col = 'Data',
    into = c('Ano', 'Mes', 'Dia'),
    sep = '-', remove = F) %>% 
  print()

### A função 'full_join()' retorna todas as linhas e todas as colunas de x e y .
### Onde não há valores correspondentes, retorna NA para o que falta.

### A função `separate()` permite separar variáveis concatenadas em uma única coluna.

## Verificando os valores ausentes ---#
summary(dfinal)

is.na(dfinal) %>% 
  colSums()

# Para remover as linhas que contêm 'NA', podemos usar a função `drop_na()`.
tidyr::drop_na(dados_campos)

## Transformando as séries diárias em séries mensais ---#
### Acumulado mensal de precipitação:
Pmensal <- 
  dfinal %>% 
  dplyr::group_by(Ano, Mes) %>% 
  dplyr::summarise(PrecM = sum(Prec, na.m = F)) %>% 
  print()

### A função `group_by()` agrupa os dados com base em uma variável categórica.
### A função 'summarise()' permite agregar sumarizações unindo diversos cálculos
### ao longo de uma base de dados. 

### Médias mensais de temperaturas (média, máxima e mínima):
Tmensal <- 
  dfinal %>% 
  dplyr::group_by(Ano, Mes) %>% 
  dplyr::summarise(across(
    .cols = c('Tmed', 'Tmax', 'Tmin'),
    .fns = list(media = mean, mediana = median)
    )) %>%
  tidyr::unite(col = 'Data',
    c(Ano, Mes),
    sep = '-', remove = F) %>% 
  dplyr::mutate(Data = 
                  lubridate::ym(Data)) %>%
  print()

### A função `unite()` permite unir variáveis concatenadas.
### A função `mutate()` permite criar novas colunas ou modificar as existentes.
### A função 'ym' transforma datas armazenadas em vetores numéricos e de caracteres 
### em objetos Date, com componentes de ano e mês.

## Gráfico de linha da temperatura média mensal máxima:
Tmensal %>%
  ggplot2::ggplot(
    aes(x = Data, y = Tmax_media)) +
  geom_line() +
  scale_x_date(date_breaks = '1 year',
               date_labels = '%Y') +
  scale_y_continuous(limits = c(24, 35), 
                     breaks = seq(24, 36, by = 1)) +
  geom_point(col ='darkblue', size = 2, shape = 18, alpha = 0.3) +
  labs(y = 'Temperatura Máxima (ºC)') +
  theme_bw()

## Análise das temperaturas médias mensais (máxima, média e mínima):
Tmed_m <- 
  Tmensal %>%
  dplyr::select(!ends_with('mediana')) %>% 
  tidyr::pivot_longer(
    cols = c('Tmed_media', 'Tmax_media', 'Tmin_media'),   # Colunas a serem agrupadas.
    names_to = 'Tipo',                  # Nome da nova coluna categórica. 
    values_to = 'Tmed') %>%             # Nome da nova coluna com os valores.
  dplyr::mutate(
      Tipo = 
        dplyr::case_when(
          Tipo == 'Tmax_media' ~ 'Tmax',
          Tipo == 'Tmed_media' ~ 'Tmed',
          Tipo == 'Tmin_media' ~ 'Tmin')) %>% 
  print()
  
### A função 'pivot_longer()' transforma as tabelas amplas em estreitas e mais longas.
### Serve para agrupar duas ou mais colunas e seus respectivos valores em pares.

### função `case_when()` permite criar e/ou modificar variáveis a partir de uma 
### sequência de condições que devem ser respeitadas.

### Gráfico de linha das temperaturas médias mensais (máxima, média e mínima):
Tmed_m %>% 
  ggplot2::ggplot() +
    aes(x = Data, y = Tmed, color = Tipo) +
    geom_line(wd = 0.5) + 
    scale_x_date(date_breaks = '1 year',
                 date_labels = '%Y') +
  scale_color_manual(values = c('#D14222', '#D1A821', '#4777E6')) +
  theme_minimal(base_size = 12) +
  theme(legend.position = c(0.85, 0.96),
        legend.direction='horizontal') +
  labs(y = 'Temperatura (ºC)', 
       x = NULL,
       color = NULL,)

### Histograma das temperaturas médias mensais (máxima, média e mínima):
Tmed_m %>% 
  ggplot2::ggplot() +
  aes(x = Tmed) +
  geom_histogram(aes(y = ..density.., fill = Tipo))+
  geom_density(aes(color = Tipo))+
  facet_wrap(~Tipo)+
  scale_fill_manual(values = c('#D14222', '#D1A821', '#4777E6'))+
  scale_color_manual(values = c('#D14222', '#D1A821', '#4777E6'))+
  theme_minimal()+
  labs(y = 'Densidade', 
       x = 'Temperatura (ºC)')

# ANÁLISE DA SÉRIE TEMPORAL DE ITAPERUNA (RJ)----------------------------------#
## Agora vamos baixar os dados mensais de Itaperuna (RJ).
## Esses dados foram obtidos do INMET (https://bdmep.inmet.gov.br/) e estão 
## disponíveis no GitHub do PExCCA-UENF:
url_dados2 <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/An%C3%A1lise%20de%20S%C3%A9ries%20Temporais/dados_83695_M_1993-01-01_2022-12-31.csv'

dados_itaperuna <-
  readr::read_delim(url_dados2, 
                    skip = 10, 
                    na = 'null', 
                    delim = ';', 
                    col_names = T,
                    locale = locale(decimal_mark = ',')) %>% 
  dplyr::rename(Data = `Data Medicao`,
                Prec = `PRECIPITACAO TOTAL, MENSAL(mm)`,
                Tmed = `TEMPERATURA MEDIA COMPENSADA, MENSAL(°C)`,
                Tmin = `TEMPERATURA MINIMA MEDIA, MENSAL(°C)`,
                Tmax = `TEMPERATURA MAXIMA MEDIA, MENSAL(°C)`) %>%
  dplyr::mutate(Codigo = 83695, .before = Data) %>% 
  tidyr::separate(
    col = 'Data',
    into = c('Ano', 'Mes', 'Dia'),
    sep = '-', remove = F) %>%
  dplyr::select(!ends_with(c('6', 'Dia'))) %>%
  print()

write.table(x = dados_itaperuna, 
            file = 'dados_itaperuna.csv',
            sep = ';', dec = ',', quote = FALSE, row.names = F)

### Anomalia da temperatura média mensal de Itaperuna (RJ).
### Para calcular as anomalias será utilizado como referência a média do período
# total dos dados (1993-2022).

dados_anom <- 
  dados_itaperuna %>%
  dplyr::group_by(Mes) %>%
  dplyr::mutate(
    Med_clim = mean(Tmed, na.rm = T),
    Anomalias = Tmed - Med_clim,
    Anom_class = case_when(
      Anomalias < 0 ~ 'Negativa',
      Anomalias > 0 ~ 'Positiva',
      .default = 'Neutro')) %>% 
  print()

plot_anom <-  
dados_anom %>% 
  ggplot2::ggplot() +
  aes(x = Data, y = Anomalias, fill = Anom_class) +
  geom_col() +
  scale_fill_manual(values = c('red', 'blue')) +
  scale_x_date(date_breaks = '2 years',
               date_labels = '%Y') +
  theme_minimal(base_size = 10) +
  labs(y = 'Anomalias de Temperatura (ºC)', 
       x = NULL,
       fill = 'Anomalia',)+
  theme(legend.position = c(0.85, 0.05),
        legend.direction='horizontal')
plot_anom

ggplot2::ggsave(plot = plot_anom, 
                filename = 'anom_temp.png',
                width = 9, height = 5, units = 'in', bg = '#FCF9F7')

### A função `ggsave()` permite salvar gráficos criados em arquivos externos em
### diversos formatos, como PNG, JPEG, PDF, SVG e outros.

#------------------------https://linktr.ee/pexcca.lamet------------------------#
