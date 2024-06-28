#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 25/06/2024                        #
#==============================================================================#

#                     VISUALIZAÇÃO DE DADOS NO R - PARTE 1                     #

# 1. INTRODUÇÃO----------------------------------------------------------------#

# A visualização de dados desempenha um papel crucial na interpretação e comunicação 
# de *insights* a partir de conjuntos complexos de informações. Em um mundo cada vez 
# mais inundado por dados, a capacidade de criar visualizações claras e informativas 
# se tornou uma habilidade fundamental para profissionais de todas as áreas. 

## Como escolher um bom gráfico? ---

# Escolher um bom gráfico para visualizar dados envolve considerar diversos fatores, 
# incluindo o tipo e quantidade de dados, o objetivo da visualização e o público-alvo. 
# Por exemplo, ao ilustrar valores numéricos de múltiplas categorias, um gráfico 
# de barras pode ser uma escolha adequada. Se deseja ilustrar uma série temporal,
# talvez um gráfico de linha seja o mais apropriado. Ou ainda, se deseja correlacionar 
# duas variáveis, uma escolha eficiente é o gráfico de dispersão.

# Também devemos considerar questões como a simplicidade e clareza do gráfico, 
# além de fornecer o contexto necessário para que o mesmo seja compreendido.

## Ferramentas para criar gráficos: `tidyverse` ---

# Neste curso, vamos trabalhar com o `tidyverse`, que é uma coleção de pacotes da 
# linguagem R construídos para a ciência de dados, fornecendo ferramentas para manipulação, 
# visualização, processamento e limpeza de dados.

# Abaixo estão alguns dos principais pacotes do `tidyverse`, com foco especial no ´ggplot2´, 
# que é o principal pacote de visualização de dados dentro do `tidyverse`.

# - `dplyr`:    Oferece funções poderosas para manipulação de dados, como filtragem,
#               seleção, agrupamento e resumo.
# - `ggplot2`:  Uma das bibliotecas mais populares para criação de gráficos, baseada
#               na construção de gráficos através de camadas e uma gramática de gráficos
#               declarativa.
# - `tidyr`:    Concentra-se na organização e limpeza de dados, proporcionando funções
#               para remodelar conjuntos de dados.
# - `readr`:    Facilitam a leitura e importação de dados de diferentes formatos.
# - `purrr`:    Oferece ferramentas para programação funcional em R, útil para aplicar
#               funções de maneira eficiente em conjuntos de dados.

# O `tidyverse` adota uma filosofia única de design, promovendo a criação de código
# limpo e eficiente. Com foco na 'tidy data' (dados organizados), os pacotes `dplyr`,
# `ggplot2`, `tidyr`, `readr` e `purrr` proporcionam uma experiência coesa, desde a
# manipulação até a visualização de dados. 

# Vamos instalar e carregar o pacote:
if (!require('tidyverse')) install.packages('tidyverse')
library(tidyverse)

# 2. IMPORTAÇÃO E ORGANIZAÇÃO DOS DADOS ---------------------------------------#

# A importação de dados é o primeiro passo no processo de visualização de dados. 
# No R, especialmente com o uso do pacote `tidyverse`, esse processo é facilitado 
# por várias funções que permitem a leitura de diferentes formatos de arquivos.

# Para iniciar, a maneira mais simples de importar dados é utilizar a interface do
# RStudio. Na aba `Environment`, podemos acessar a função `Import Dataset`,
# escolher a extensão adequada e manualmente selecionar o arquivo a ser importado.

# Neste curso, vamos utilizar 4 (quarto) conjuntos de dados obtidos do Banco de Dados 
# Meteorológicos do Instituto Nacional de Meteorologia (INMET). 
# Os dados podem ser obtidos em seu formato original em <https://bdmep.inmet.gov.br/>.

# Os conjuntos de dados consistem em séries históricas de 1991 até 2020, para as 
# cidades de Belo Horizonte, Vitória, Rio de Janeiro e São Paulo.

# Para simplificar o processo, disponibilizamos os 4 (quarto) conjuntos de dados em 
# nossa página do GitHub:

URL_dados <- c(
  'Belo Horizonte' = 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Visualiza%C3%A7%C3%A3o%20de%20Dados%20no%20R/Dados/dados_83587_D_1991-01-01_2020-12-31.csv',
  'Vitória' = 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Visualiza%C3%A7%C3%A3o%20de%20Dados%20no%20R/Dados/dados_83648_D_1991-01-01_2020-12-31.csv',
  'Rio de Janeiro' = 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Visualiza%C3%A7%C3%A3o%20de%20Dados%20no%20R/Dados/dados_83743_D_1991-01-01_2017-04-04.csv',
  'São Paulo' = 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Visualiza%C3%A7%C3%A3o%20de%20Dados%20no%20R/Dados/dados_83781_D_1991-01-01_2020-12-31.csv'
)

dir.create('Dados/')

# Download dos arquivos por linha de comando:
for (i in seq_along(URL_dados)) {
  download.file(
    url = URL_dados[i],
    destfile = paste0('Dados/', names(URL_dados)[i], '.csv')
  )
  cat('Arquivo', i, 'baixado com sucesso!')
}

dir('Dados/')

# Agora vamos criar uma função para a leitura e organização dos dados:

Leitura_Personalizada <- function(Arquivo) {
  
  # Importar o conjunto:
  dados <-
    read_csv2(
      file = Arquivo,
      skip = 10,
      na = 'null') |>
    
    # Corrigir artefatos:
    select(!starts_with('...')) |>
    
    # Renomear colunas:
    rename_with(~c('Data', 'Evap', 'Prec', 'Temp', 'Umi', 'Vento')) |>
    
    # Identificar o conjunto adequadamente:
    mutate(ID = Arquivo |> str_remove_all('Dados/|\\.csv'))
  
  # Retorna o objeto importado:
  return(dados)
}

# Executando a função:
arq <- list.files(path = 'Dados/', pattern = '.csv', full.names = T)

df <- purrr::map_df(.x = arq, .f = ~Leitura_Personalizada(Arquivo = .x))

# Exploração inicial dos dados ----

# Antes de iniciar a visualização é importante conhecer a natureza dos dados.
# Podemos utilizar algumas funções do 'tidyverse' para realizar essa exploração 
# inicial e conhecer melhor o conjunto que vamos trabalhar

# Com a função `glimpse()` temos uma breve descrição da natureza de cada variável 
# de nosso conjunto de dados. Qual o formato dos dados? Numérico? Character? Lógico? 
# Data? Também podemos checar e conferir se a importação foi realizada da maneira adequada.

df |>
  glimpse()

# Podemos ainda obter algumas estatísticas descritivas rápidas com a função `summary()`.
summary(df)

# Outro ponto importante é verificar a % de NAs em nosso conjunto de dados.

# Função para calcular a porcentagem de NAs:
pna <- function(x){
  (sum(is.na(x))/length(x)) * 100
}

# Aplicando a função separando os dados pela cidade (ID):
df |>
  group_by(ID) |>
  summarise(
    across(
      .cols = Evap:Vento,
      .fns = pna
    )
  )

# 3. CONSTRUINDO GRÁFICOS COM O ‘GGPLOT2’ -------------------------------------#

# O `ggplot2` é um pacote de construção de gráficos pertencente ao `tidyverse`, 
# carregando uma filosofia de simplicidade e transparência nos códigos. O pacote 
# Opera em uma estrutura de camadas, onde cada elemento pode ser personalizado à vontade 
# do usuário. Assim, o pacote apresenta-se como uma ferramenta flexível capaz de 
# entender a diversas demandas. 

# As principais camadas do ‘ggplot2’ são:

# - Dados (data): Essa é uma camada fundamental, onde o usuário fornece os dados 
#   que deseja visualizar. Os dados são geralmente fornecidos como um dataframe do R.

# - Mapeamento Estético (Aesthetic Mapping): Nessa camada, o usuário associa variáveis 
#   do conjunto de dados às propriedades visuais do gráfico, como eixos, cor, forma, 
#   tamanho, etc. É importante destacar que o mapeamento pode operar em nível global,
#   afetando todas as camadas do gráfico, ou em nível local, afetando apenas uma camada. 

# - Geometria (Geometry): Essa camada determina o tipo de gráfico que se deseja criar, 
#   como pontos, linhas, barras, caixas, etc. Por exemplo, `geom_point()` cria um 
#   gráfico de pontos, `geom_col()` cria um gráfico de colunas, e assim por diante.

# - Escala (Scale): As escalas definem como os valores dos dados são mapeados para 
#   as propriedades visuais do gráfico. Por exemplo, pode-se ajustar a escala dos 
#   eixos x e y para se adaptar melhor aos dados.

# - Facetas (Facets): Essa camada é opcional e permite dividir o gráfico em várias 
#   facetas com base em uma ou mais variáveis. Isso é útil para comparar subgrupos 
#   de dados lado a lado.

# - Temas (Themes): Essa camada define o estilo geral do gráfico, incluindo aspectos 
#   como cores, fontes, tamanhos de texto, etc. O usuário pode utilizar os temas 
#   padrão fornecidos pelo `ggplot2`ou criar um tema personalizado.

# - Camadas Estatísticas (Statistical Layers): Em alguns casos, o usuário pode desejar 
#   adicionar camadas estatísticas aos gráficos, como linhas de regressão, intervalos 
#   de confiança, etc.

# Agora vamos criar nosso primeiro ggplot! 
# O 1º passo, é chamar a função ggplot e informar qual conjunto de dados vamos utilizar.

ggplot(data = df)

# Perceba que essa função gerou apenas o plano de fundo cinza. Por enquanto, ele 
# possui apenas uma camada contendo os dados, mas não apresenta mapeamento ou geometria.

# Agora vamos adicionar o mapeamento de variáveis:

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap)
  )

## A função `aes()` define o mapeamento dos elementos no plano cartesiano de nosso
## gráfico. O mapeamento pode ser definido em nível global (que se aplica a todo
## o gráfico) ou local (que se aplica apenas a uma camada). 

# Agora o gráfico apresenta eixos X e Y, sendo respectivamente a Temperatura e a
# Evapotranspiração..

# O próximo passo será adicionar uma camada de geometria para representar visualmente os dados. 

## - `geom_point()`:
ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap)
  ) +
  geom_point()

# Podemos produzir vários tipos de gráficos com o`ggplot2`. Exemplos:

# - geom_point() e geom_smooth():
# Usando a função geom_smooth() podemos adicionar aos gráficos de dispersão linhas suavizadas. 

ggplot(df, aes(x = Temp, y = Evap)) + 
  geom_point() + 
  geom_smooth()

# - geom_histogram(), geom_density() e geom_rug():
ggplot(df, aes(x = Temp)) + 
  geom_histogram() + 
  geom_rug()

ggplot(df, aes(x = Temp)) + 
  geom_density() + 
  geom_rug()

# - geom_boxplot() e geom_violin():
ggplot(df, aes(x = ID, y = Temp)) +
  geom_boxplot()

ggplot(df, aes(x = ID, y = Temp)) + 
  geom_violin()

# - geom_col() + geom_errorbar():
ggplot(data = tibble(x = 1:3, y = c(5, 6, 4)), 
       aes(x = x, y = y, ymin = y-1, ymax = y+1)) + 
  geom_col() + 
  geom_errorbar()

# - geom_tile() e geom_raster():
ggplot(data = tibble(x = rep(1:3, 3), y = rep(1:3, each = 3), z = rnorm(n = 9)), 
       aes(x = x, y = y, fill = z)) + 
  geom_tile()

# - geom_density_2d() e geom_hex():
ggplot(df, aes(x = Temp, y = Evap)) + 
  geom_point() + 
  geom_density_2d()

ggplot(df, aes(x = Temp, y = Evap)) + 
  geom_hex()

# - geom_map() e geom_sf():
if (!require('geobr')) install.packages('geobr')
library(geobr)

ggplot() +
  geom_sf(data = geobr::read_biomes(), 
          aes(fill = name_biome))

# 4. CONFIGURANDO COMPONENTES ESTÉTICOS DOS GRÁFICOS --------------------------#

# Configurar componentes estéticos dos gráficos no `ggplot2` é essencial para criar 
# visualizações de dados atraentes e informativas. Abaixo estão algumas das principais 
# maneiras de ajustar esses componentes estéticos.

## Título e rótulos dos eixos ----
## Para adicionar ou modificar o título do gráfico e os rótulos dos eixos, podemos 
## usar as funções ggtitle(), xlab(), e ylab() ou a função labs().

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap)
  ) +
  geom_point() +
  ggtitle('Temperatura do ar x Evapotranspiração') +
  xlab('Temperatura do ar') +
  ylab('Evapotranspiração')

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap)
  ) +
  geom_point() +
  labs(
    title = 'Título',
    subtitle = 'Subtítulo',
    caption = 'Rodapé',
    tag = 'TAG',
    x = 'Eixo X',
    y = 'Eixo Y',
    color = 'Legenda Cor',
    # fill = '',
    # shape = '',
    # ...
  )

## Cores, tamanho e formato dos pontos ----
## Podemos alterar as cores, o tamanho e o formato dos pontos utilizados nos gráficos.
## Também podemos personalizar as cores de diferentes elementos do gráfico utilizando 
## a função scale_color_manual() ou outras funções de escala.

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap)
  ) +
  geom_point(
    size = 2,              # Tamanho do ponto: 2 representa 200% do tamanho original
    color = 'steelblue',   # Cor dos pontos. Podemos utilizar um código hexadecimal ou cores nomeadas (veja: `colors()`).
    shape = 17             # Formato do ponto.
  )

ggplot(
  data = df, 
  aes(x = Temp, y = Evap, color = ID)
  ) +
  geom_point() +
  scale_color_manual(values = c('purple3', 'yellow3', 'blue3', 'red3')) 

# Podemos utilizar outros argumentos estéticos além das cores. 
# Exemplos: color, fill, group, shape, size, family (Para textos) e fontface (Para textos).

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap, color = ID, shape = ID)
  ) +
  geom_point()

ggplot(
  data = tibble(x = 1:3, 
                y = 1, 
                lab = c('a', 'b', 'c'),
                font = c('sans', 'mono', 'serif'),
                fontface = c('plain', 'bold', 'italic')),
  mapping = aes(x = x, y = y, label = fontface, font = font, fontface = fontface)
) +
  geom_text(size = 5)

## Escalas de posição para dados contínuos (x e y) ----
## scale_x_continuous() e scale_y_continuous() são as escalas padrão para estética x e y contínua.

ggplot(
  data = df, 
  aes(x = Temp, y = Evap, color = ID)
  ) +
  geom_point() +
  scale_y_continuous(limits = c(1, 20), breaks = seq(1, 20, 2)) +
  scale_x_continuous(limits = c(5, 35), breaks = seq(5, 35, 2))

## Facetas ----
## Podemos visualizar os dados em diferentes grupos em gráficos separados usando facetas.

ggplot(
  data = df, 
  aes(x = Temp, y = Evap, color = ID)
  ) +
  geom_point() +
  facet_wrap(~month(Data))

## Temas (Themes).
## Os temas alteram a aparência geral do gráfico, incluindo fontes, cores de fundo, 
## gridlines, etc. O ggplot2 oferece alguns temas prontos e também podemos personalizar
## o nosso próprio tema usando a função theme().

## Além dos temas já prontos disponíveis no pacote ´ggplot2´, também podemos usar 
## temas de outros pacotes como o ´ggthemes´.

if (!require('ggthemes')) install.packages('ggthemes')
library(ggthemes)

## Podemos conferir e ler sobre cada camada na documentação de ajuda: `help(theme)`.
## Cada argumento recebe funções de acordo com qual elemento ele modifica. 

## Alguns exemplos:
# - element_line()      - Utilizado para elementos com linhas.
# - element_rect()      - Utilizado para elementos com formas geométricas.
# - element_text()      - Utilizado para elementos com textos.
# - element_blank()     - Utilizado para remover/ocultar um elemento.
# - element_render()
# - element_grob()

gr <-
  ggplot(df, aes(x = Temp, y = Evap, color = ID)) +
  geom_point()
gr

gr + ggplot2::theme_bw()
gr + ggplot2::theme_classic()
gr + ggplot2::theme_dark()
gr + ggplot2::theme_gray()
gr + ggplot2::theme_light()
gr + ggplot2::theme_minimal()
gr + ggplot2::theme_void()

gr + ggthemes::theme_base()
gr + ggthemes::theme_calc()
gr + ggthemes::theme_clean()
gr + ggthemes::theme_economist()
gr + ggthemes::theme_economist_white()
gr + ggthemes::theme_excel()
gr + ggthemes::theme_excel_new()
gr + ggthemes::theme_few()
gr + ggthemes::theme_fivethirtyeight()
gr + ggthemes::theme_foundation()
gr + ggthemes::theme_gdocs()
gr + ggthemes::theme_hc()
gr + ggthemes::theme_igray()
gr + ggthemes::theme_map()
gr + ggthemes::theme_pander()
gr + ggthemes::theme_par()
gr + ggthemes::theme_solarized()
gr + ggthemes::theme_solarized_2()
gr + ggthemes::theme_solid()
gr + ggthemes::theme_stata()
gr + ggthemes::theme_tufte()
gr + ggthemes::theme_wsj()

## Estatísticas ----

ggplot(
  data = df, 
  aes(x = month(Data), y = Temp, fill = ID, group = month(Data))
) +
  stat_summary(fun = 'mean', geom = 'col') +
  stat_summary(fun.min = ~mean(.x)-sd(.x), 
               fun.max = ~mean(.x)+sd(.x), 
               geom = 'errorbar') +
  facet_grid(rows = vars(ID))

ggplot(data = df, aes(x = Temp, y = Evap, color = ID)) +
  geom_point() +
  geom_smooth(method = 'lm', color = 'black') +
  ggpmisc::stat_poly_eq(
    aes(label = paste(after_stat(eq.label), 
                      after_stat(rr.label),
                      after_stat(p.value.label),
                      sep = '*\'; \'*'))) +
  facet_wrap(~ID)

# 5. PRODUÇÃO DE GRÁFICOS -----------------------------------------------------#

# Agora que já discutimos a base do ggplot, podemos avançar na produção de alguns gráficos.
# Nesta etapa do curso, preparamos alguns exemplos de gráficos utilizando funções do
# `ggplot2` e de outros pacotes.

# O pacote `camcorder` é utilizado para plotar os gráficos já em sua resolução final,
# assim facilitando o processo de ajuste fino dos elementos gráficos.

if (!require(camcorder)) install.packages("camcorder")
library(camcorder)

gg_record(
  dir = "plots",
  width = 1000,
  height = 1000,
  device = "png",
  units = "px",
  bg = "white")

# O pacote `showtext` permite importar facilmente fontes extras para utilizar nos gráficos.
# Podemos buscar as fontes em <fonts.google.com>.

if (!require(showtext)) install.packages("showtext")
library(showtext)

font_add_google(name = "Montserrat", family = "Montserrat")
showtext_auto()

# O pacote `ggtext` adiciona algumas funções interessantes para trabalhar com textos
# nos gráficos, seja internamente, como geometrias, ou nos rótulos dos gráficos.

if (!require(ggtext)) install.packages("ggtext")
library(ggtext)

# Utilizaremos o pacote `ggdist` para adicionar geometrias que trabalham com densidade.

if (!require(ggdist)) install.packages("ggdist")
library(ggdist)

# O pacote `ggside` nos permite criar gráficos marginais com pouco trabalho.

if (!require(ggside)) install.packages("ggside")
library(ggside)

# Histograma ---

# Iniciando um Histograma:
df |>
  ggplot(aes(x = Temp)) +
  geom_histogram()

# Vamos adicionar as cores de acordo com a Capital:
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram()

# Agora, podemos quebrar em 4 gráficos com facet_grid():
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram() +
  facet_grid(rows = vars(ID), axes = "all")

# Para aprimorar a ilustração, podemos adicionar um boxplot junto do histograma:
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram() +
  geom_boxplot(aes(y = -100)) +
  facet_grid(rows = vars(ID), axes = "all")

# Vamos ajustar as cores e o tamanho de alguns elementos:
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram(aes(x = Temp), color = "black", bins = 50) +
  geom_boxplot(aes(x = Temp, y = -100), width = 100, outlier.size = 0.5, color = "black") +
  scale_fill_viridis_d() +
  facet_grid(rows = vars(ID), axes = "all")

# Corrigindo nomes dos eixos e adicionando um título:
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram(aes(x = Temp), color = "black", bins = 50) +
  geom_boxplot(aes(x = Temp, y = -100), width = 100, outlier.size = 0.5, color = "black") +
  scale_fill_viridis_d() +
  facet_grid(rows = vars(ID), axes = "all") +
  labs(
    title = "Distribuição das Temperaturas (°C) nas capitais do Sudeste de 1990 a 2020 ",
    x = "Temperatura (°C)",
    y = "Contagem",
    caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R")

# Alterações no tema:
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram(aes(x = Temp), color = "black", bins = 50) +
  geom_boxplot(aes(x = Temp, y = -100), width = 100, outlier.size = 0.5, color = "black") +
  scale_fill_viridis_d() +
  facet_grid(rows = vars(ID), axes = "all") +
  labs(
    title = "Distribuição das Temperaturas (°C) nas capitais do Sudeste de 1990 a 2020 ",
    x = "Temperatura (°C)",
    y = "Contagem",
    caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R") +
  theme_void() +
  theme(
    text = element_text(family = "Montserrat", margin = margin(1,1,1,1,"mm")),
    axis.title = element_text(size = 18),
    axis.text = element_text(size = 14),
    axis.title.y = element_text(angle = 90),
    axis.ticks = element_line(),
    axis.ticks.length = unit(0.5, "mm"),
    axis.line = element_line(linewidth = 0.5),
    legend.position = "none",
    plot.margin = margin(2,2,2,2,"mm"),
    plot.title = element_textbox_simple(size = 25, lineheight = 0.3, margin = margin(1,1,1,1,"mm") ),
    plot.caption = element_text(size = 12),
    panel.background = element_rect(fill = "gray95"),
    panel.grid.major.y = element_line(color = "gray70", linetype = "dotted"),
    panel.border = element_blank(),
    strip.text = element_text(angle = 270, size = 12)
  ) -> Histograma

# Gráficos de dispersão ---

gg_record(dir = "plots", 
          width = 1000, 
          height = 1000, 
          device = "png", 
          bg = "white", 
          units = "px")

# Iniciando o gráfico de dispersão:
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point()

# Alterando aspectos visuais dos pontos:
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point(shape = 21, fill = rgb(1, 1, 1, 0.2),
             color = "steelblue2", stroke = 1, alpha = 0.7)

# Adicionando um geom_density_2d():
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point(shape = 21, fill = rgb(1,1,1,0.2),
             color = "steelblue2", stroke = 1, alpha = 0.7) +
  geom_density_2d(color = "steelblue4", linewidth = 0.6)

# Adicionando boxplots marginais:
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point(shape = 21, fill = rgb(1,1,1,0.2),
             color = "steelblue2", stroke = 1, alpha = 0.7) +
  geom_density_2d(color = "steelblue4", linewidth = 0.6) +
  geom_xsideboxplot(orientation = "y", color = "steelblue2") +
  geom_ysideboxplot(orientation = "x", color = "steelblue2")

# Alterações de tema e rótulos:
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point(shape = 21, fill = rgb(1,1,1,0.2),
             color = "steelblue2", stroke = 1, alpha = 0.7) +
  geom_density_2d(color = "steelblue4", linewidth = 0.6) +
  geom_xsideboxplot(orientation = "y", color = "steelblue2") +
  geom_ysideboxplot(orientation = "x", color = "steelblue2") +
  labs(
    x = "Temperatura(°C)",
    y = "Umidade Relativa(%)",
    title = "Relação Entre Temperatura e Umidade Relativa em São Paulo-SP",
    caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = "Montserrat", size = 25),
    plot.title = element_textbox_simple(lineheight = 0.4, margin = margin(2,2,2,2,"mm")),
    plot.margin = margin(4,4,4,4, "mm"),
    ggside.axis.text = element_blank(),
    ggside.panel.grid = element_blank()
  ) -> Dispersao

# Gráficos de Série Temporal ---

gg_record(dir = "plots", 
          width = 2000, 
          height = 800, 
          device = "png", 
          bg = "white", 
          units = "px")

# Calculando médias mensais de Temperatura das cidades de interesse:
df_gr <-
  df |>
  filter(ID %in% c("Vitória", "Belo Horizonte")) |>
  group_by(Mês = month(Data), Ano = year(Data), ID) |>
  summarise(me = mean(Temp),
            sd = sd(Temp)) |>
  mutate(Data = ym(paste(Ano, Mês, sep = "-")))

# Iniciando o gráfico:
df_gr |>
  ggplot(
    aes(x = Data, y = me, color = ID)
  ) +
  geom_line() +
  geom_point()

# Alterando aspectos visuais dos pontos e escalas:
df_gr |>
  ggplot(
    mapping = aes(x = Data, y = me, color = ID)
  ) +
  geom_line(lwd = 1.1, alpha = 0.5) +
  geom_point(size = 1.5, alpha = 0.5) +
  scale_y_continuous(limits = c(17, 30), breaks = seq(16,30,2)) +
  scale_x_date(breaks = "5 years", date_labels = "%Y") +
  scale_color_manual(values = c("#ed2024", "#023a99"))

# Adicionando título e rótulo de eixos:
# Aqui utilizaremos uma tag HTML para utilizar o título como legenda do gráfico.
df_gr |>
  ggplot(
    mapping = aes(x = Data, y = me, color = ID)
  ) +
  geom_line(lwd = 1.1, alpha = 0.5) +
  geom_point(size = 1.5, alpha = 0.5) +
  scale_y_continuous(limits = c(17, 30), breaks = seq(16,30,2)) +
  scale_x_date(breaks = "5 years", date_labels = "%Y") +
  scale_color_manual(values = c("#ed2024", "#023a99")) +
  labs(x = "Data", y = "Temperatura (°C)",
       title = "Médias Mensais de Temperatura(°C) nas capitais <span style = color:#023a99>Vitória-ES</span> e <span style = color:#ed2024>Belo Horizonte-MG</span>",
       caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R", color = "")

# Adicionando tema:
df_gr |>
  ggplot(
    mapping = aes(x = Data, y = me, color = ID)
  ) +
  geom_line(lwd = 1.1, alpha = 0.5) +
  geom_point(size = 1.5, alpha = 0.5) +
  scale_y_continuous(limits = c(17, 30), breaks = seq(16,30,2)) +
  scale_x_date(breaks = "5 years", date_labels = "%Y") +
  scale_color_manual(values = c("#ed2024", "#023a99")) +
  labs(x = "Data", y = "Temperatura (°C)",
       title = "Médias Mensais de Temperatura(°C) nas capitais <span style = color:#023a99>Vitória-ES</span> e <span style = color:#ed2024>Belo Horizonte-MG</span>",
       caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R", color = "") +
  theme_minimal() +
  theme(
    text = element_text(family = "Montserrat", size = 30),
    legend.position = "none",
    plot.title = element_textbox_simple(lineheight = 0.3, size = 40, maxwidth = 0.8, hjust = 0),
    plot.margin = margin(5,5,5,5, "mm")
  ) -> SerieTemporal

# Boxplot ---

gg_record(dir = "plots", 
          width = 2000, 
          height = 800, 
          device = "png", 
          bg = "white", 
          units = "px")

# Iniciando o gráfico:
df |>
  mutate(Ano = year(Data)) |>
  ggplot(aes(y = Temp, x = Ano, fill = ID)) +
  geom_boxplot()

# Para aprimorar a visualização, podemos adicionar outros elementos, como os próprios 
# pontos ilustrados e uma curva de distribuição.
df |>
  ggplot(aes(y = Temp, x = ID, fill = ID)) +
  geom_boxplot(width = 0.2) +
  geom_point(shape = 95, size = 20, alpha = 0.006,
             position = position_nudge(x = -0.20)) +
  stat_halfeye(
    adjust = 0.9,
    width = .4,
    color = NA,
    position = position_nudge(x = .14)
  )

# Ajustes de cores:
df |>
  ggplot(aes(y = Temp, x = ID, fill = ID)) +
  geom_boxplot(width = 0.2) +
  geom_point(shape = 95, size = 20, alpha = 0.006,
             position = position_nudge(x = -0.20)) +
  stat_halfeye(
    adjust = 0.9,
    width = .4,
    color = NA,
    position = position_nudge(x = .14)
  ) +
  scale_fill_viridis_d()

# Adicionando legendas:
df |>
  ggplot(aes(y = Temp, x = ID, fill = ID)) +
  geom_boxplot(width = 0.2) +
  geom_point(shape = 95, size = 20, alpha = 0.006,
             position = position_nudge(x = -0.20)) +
  stat_halfeye(
    adjust = 0.9,
    width = .4,
    color = NA,
    position = position_nudge(x = .14)
  ) +
  scale_fill_viridis_d() +
  labs(
    x = "Capitais", y = "Temperatura (°C)",
    title = "Distribuição de Temperaturas nas Capitais do Sudeste",
    subtitle = "Intervalo 1991 a 2020",
    caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R"
  )

# Alterando tema:
df |>
  ggplot(aes(y = Temp, x = ID, fill = ID)) +
  geom_boxplot(width = 0.2) +
  geom_point(shape = 95, size = 20, alpha = 0.006,
             position = position_nudge(x = -0.20)) +
  stat_halfeye(
    adjust = 0.9,
    width = .4,
    color = NA,
    position = position_nudge(x = .14)
  ) +
  scale_fill_viridis_d() +
  labs(
    x = "Capitais", y = "Temperatura (°C)",
    title = "Distribuição de Temperaturas nas Capitais do Sudeste",
    subtitle = "Período de 1991 a 2020",
    caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = "Montserrat", size = 30),
    plot.caption = element_text(color = "gray40"),
    legend.position = "none"
  ) -> Boxplot

# Gráfico de Barras ---

gg_record(dir = "plots",
          width = 1200, 
          height = 1000, 
          device = "png", 
          bg = "white", 
          units = "px")

# Cálculo de precipitação acumulada anual em cada capital:
df_gr <-
  df |>
  group_by(Ano = year(Data), ID) |>
  summarise(
    Prec_Acc = sum(Prec)
  ) |>
  filter(ID != "Rio de Janeiro")

# Vamos quebrar o gráfico em facets:
df_gr |>
  ggplot(aes(x = Ano, y = Prec_Acc, fill = ID)) +
  geom_col() +
  facet_grid(rows = vars(ID), axes = "all")

# Agora, podemos adicionar o valor de precipitação calculado:
df_gr |>
  ggplot(aes(x = Ano, y = Prec_Acc, fill = ID)) +
  geom_col() +
  geom_text(
    aes(label = paste(round(Prec_Acc), "mm"), family = "Montserrat"),
    nudge_y = -390, angle = 90, size = 4.5) +
  facet_grid(rows = vars(ID), axes = "all")

# Vamos alterar as cores e as quebras na escala do Ano
df_gr |>
  ggplot(aes(x = Ano, y = Prec_Acc, fill = ID)) +
  geom_col() +
  geom_text(
    aes(label = paste(round(Prec_Acc), "mm"), family = "Montserrat"),
    nudge_y = -450, angle = 90, size = 5) +
  facet_grid(rows = vars(ID), axes = "all") +
  scale_x_continuous(breaks = seq(1991, 2020, 2)) +
  scale_fill_brewer(type = "qual")

# O próximo passo é inserir rótulos e alterações estéticas do tema:
df_gr |>
  ggplot(aes(x = Ano, y = Prec_Acc, fill = ID)) +
  geom_col() +
  geom_text(
    aes(label = paste(round(Prec_Acc), "mm"), family = "Montserrat"),
    nudge_y = -490, angle = 270, size = 5) +
  facet_grid(rows = vars(ID)) +
  scale_x_continuous(breaks = seq(1991, 2020, 3)) +
  scale_fill_brewer(type = "qual") +
  labs(x = "Ano", y = "Precipitação Acumulada (mm)", title = "Precipitação Anual Acumulada em Capitais do Sudeste",
       caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R") +
  theme_light() +
  theme(
    legend.position = "none",
    text = element_text(family = "Montserrat", size = 25),
    plot.title = element_textbox_simple(lineheight = 0.3, size = 30, margin = margin(2,0,2,0, "mm")),# maxwidth = 0.8, hjust = 0),
  ) -> Barras

# Heatmap ---

gg_record(dir = "plots", 
          width = 1000, 
          height = 1000, 
          device = "png", 
          bg = "white", 
          units = "px")

# Calculando médias mensais de Temperatura:
df_gr <-
  df |>
  filter(ID == "Vitória") |>
  group_by(Ano = year(Data), Mês = month(Data)) |>
  summarise(
    me = mean(Temp)
  )

# Iniciando o gráfico:
df_gr |>
  ggplot(aes(x = Mês, y = Ano, fill = me)) +
  geom_tile()

# Vamos alterar a escala de cores:
df_gr |>
  ggplot(aes(x = Mês, y = Ano, fill = me)) +
  geom_tile() +
  scale_fill_viridis_c(option = "turbo")

# Aplicando alterações estéticas no geom_tile() e adicionando geom_text().
# Para escrever a temperatura e o símbolo °, utilizaremos a função paste0(). Contudo, 
# caso a temperatura informada seja "NA", a função escreverá "NA°". Para evitar isso, 
# utilizaremos um case_when() para criar uma nova coluna contendo o que será passado à geom_text().

df_gr |>
  mutate(lab = case_when(
    !is.na(me) ~ paste0(round(me, 1), "°")
  )) |>
  ggplot(aes(x = Mês, y = Ano, fill = me)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = lab, family = "Montserrat", fontface = "bold"), size = 4.5, color = "gray95") +
  scale_fill_viridis_c(option = "turbo")

# Agora, devemos inverter a escala de y para que 2020 fique no final do gráfico.
df_gr |>
  mutate(lab = case_when(
    !is.na(me) ~ paste0(round(me, 1), "°")
  )) |>
  ggplot(aes(x = Mês, y = Ano, fill = me)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = lab, family = "Montserrat", fontface = "bold"), size = 4.5, color = "gray95") +
  scale_fill_viridis_c(option = "turbo") +
  scale_y_continuous(transform = "reverse", breaks = seq(1991, 2020, 3)) +
  scale_x_continuous(breaks = 1:12,
                     labels = month(1:12, label = T))

# Agora, vamos adicionar rótulos e alterar aspéctos do tema:
df_gr |>
  mutate(lab = case_when(
    !is.na(me) ~ paste0(round(me, 1), "°")
  )) |>
  ggplot(aes(x = Mês, y = Ano, fill = me)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = lab, family = "Montserrat", fontface = "bold"), size = 4.5, color = "gray95") +
  scale_fill_viridis_c(option = "turbo", breaks = seq(22, 30, 2), label = ~paste0(.x, "°")) +
  scale_y_continuous(transform = "reverse", breaks = seq(1991, 2020, 3)) +
  scale_x_continuous(breaks = 1:12,
                     labels = month(1:12, label = T)) +
  labs(x = "Mêses", y = "Ano", caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R",
       title = "Temperaturas Médias Mensais em Vitória-ES",
       fill = "Temperatura (°C)") +
  theme_minimal() +
  theme(
    text = element_text(family = "Montserrat", size = 15),
    panel.grid.minor = element_blank(),
    legend.margin = margin(0,0,0,0,"mm"),
    legend.position = "bottom",
    legend.key.size = unit(3, "mm"),
    legend.key.height = unit(1, "mm"),
    legend.title.position = "top",
  ) -> Heatmap

# Exportando Gráficos ---
# A função `ggsave()` permite salvar gráficos criados em arquivos externos em
# diversos formatos, como PNG, JPEG, PDF, SVG e outros.

# Alguns argumentos da função `ggsave()`:
# plot:           O gráfico que será salvo. Por padrão, vai salvar o último gráfico plotado.
# filename:       O nome do arquivo/gráfico que será salvo, com a extensão (ex: .png).
# width e height: Largura e altura do gráfico em unidades especificadas pelo argumento units.
# units:          Unidades para largura e altura do gráfico, que podem ser:
#                 'in' (polegadas), 'cm' (centímetros), 'mm' (milímetros) e 'px' (pixels).

# Salvando os gráficos:
ggsave(
  plot = Histograma,
  filename = "GrHistograma.png",
  device = "png",
  width = 1000,
  height = 1000,
  units = "px",
  bg = "white"
)
ggsave(
  plot = Dispersao,
  filename = "GrDispersao.png",
  device = "png",
  width = 1000,
  height = 1000,
  units = "px",
  bg = "white"
)
ggsave(
  plot = Barras,
  filename = "GrBarras.png",
  device = "png",
  width = 1200,
  height = 1000,
  units = "px",
  bg = "white"
)
ggsave(
  plot = SerieTemporal,
  filename = "GrSerieTemporal.png",
  device = "png",
  width = 2000,
  height = 800,
  units = "px",
  bg = "white"
)
ggsave(
  plot = Heatmap,
  filename = "GrHeatmap.png",
  device = "png",
  width = 1000,
  height = 1000,
  units = "px",
  bg = "white"
)
ggsave(
  plot = Boxplot,
  filename = "GrBoxplot.png",
  device = "png",
  width = 2000,
  height = 800,
  units = "px",
  bg = "white"
)
