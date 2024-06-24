#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 21/06/2024                        #
#==============================================================================#

#                          VISUALIZAÇÃO DE DADOS NO R                          #

# Tópicos Abordados no Curso ----

# Introdução à Visualização de Dados
# Importação e organização dos dados;
# Construindo gráficos com o `ggplot2`;
# Configurando componentes estéticos dos gráficos;
# Histogramas e gráficos de densidade;
# Gráficos de dispersão e gráficos de linha;
# Diagramas de pontos e gráficos de caixa;
# Gráficos de barras e colunas;
# Gráficos de mapa de calor;
# Extensões do pacote `ggplot2`;
# Exportaçdo dos gráficos.

# Introdução ----

# Bem-vindo ao curso de Visualização de Dados com R! Este curso foi cuidadosamente
# desenvolvido para capacitar estudantes e profissionais a dominar as habilidades
# essenciais de visualização de dados e aplicá-las de forma eficaz em suas carreiras.
# Ao longo deste curso, você irá aprender a explorar, analisar e comunicar dados de
# maneira impactante, utilizando as ferramentas poderosas do metapacote tidyverse na
# linguagem R.

## O que é visualização de dados? ----

# A visualização de dados desempenha um papel crucial na interpretação e comunicação de
# *insights* a partir de conjuntos complexos de informações. Em um mundo cada vez mais
# inundado por dados, a capacidade de criar visualizações claras e informativas se tornou
# uma habilidade fundamental para profissionais de todas as áreas. Entretanto, pouco é
# discutido sobre como bons gráficos são criados, como contar boas histórias com dados
# ou como apresentar as informações de maneira coerente e precisa. De fato encontramos
# representações ruins em toda parte, e esperamos que neste curso possamos discutir erros
# comuns e aprimorar suas habilidades.

# Para isso, vamos trabalhar com as ferramentas do metapacote de Hardley Wickham e
# colaboradores conhecido como `tidyverse`. Dentro da comunidade do R, talvez seja o
# pacote mais influente, fornecendo ferramentas para manipulação, visualização,
# processamento e limpeza de dados.

## Como escolher um bom gráfico? ----

# O primeiro passo para construir uma visualização adequada é se questionar como
# apresentar as informações. Isso envolve conhecer os dados, seu público alvo e
# o objetivo de sua visualização. Por exemplo, ao ilustrar valores numéricos de
# múltiplas categorias, um gráfico de barras pode ser uma escolha adequada.
# Se deseja ilustrar uma série temporal, talvez um gráfico de linhas seja o mais
# apropriado. Ou ainda, se deseja correlacionar duas variáveis, uma escolha eficiente
# é o gráfico de dispersão.

# Além disso, devemos considerar questões como a simplicidade e clareza do gráfico.
# A grosso modo, a saturação é nociva para a visualização, onde cada elemento que
# é adicionado ao gráfico impede que o leitor assimile os pontos principais. O que
# destacamos aqui é, ao implementar algum elemento visual novo em seu gráfico,
# reflita sobre ele. Não implemente-o só por fazê-lo, questione se é realmente
# necessário.

# Outro ponto crucial em nossos trabalhos é a honestidade. Como ilustradores de dados,
# temos a responsabilidade de fornecer *insights* transparentes e honestos. Ao construir
# gráficos e apresentar estatísticas, possuímos o poder de influenciar o interlocutor
# em sua tomada de decisão. Assim, é importante fornecer o contexto necessário para que
# o mesmo compreenda a informação.

## O que `tidyverse` oferece? ----

# O `tidyverse` adota uma filosofia única de design, promovendo a criação de código
# limpo e eficiente. Com foco na "tidy data" (dados organizados), os pacotes `dplyr`,
# `ggplot2`, `tidyr`, `readr` e `purrr` proporcionam uma experiência coesa, desde a
# manipulação até a visualização de dados. Abaixo elaboramos brevemente sobre alguns
# destes pacotes.

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

# Dito isto, vamos instalar e carregar o pacote:

if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

# Importando dados ----

# O primeiro passo para gerar análises a partir da visualização de dados é a
# **importação** destes para o ambiente R. O foco deste curso não é nesta etapa, mas
# iremos relembrar pontos importantes do tópico.

# Alguns dos principais formatos utilizados em bases de dados são **xlsx**, **csv** e
# **txt**, contudo, o R não está limitado a estes formatos. Um bom exemplo é a utilização
# de formato **.bib** para análises bibliométricas, ou **.sh** em arquivos com geometrias
# de mapas. A leitura de diferentes formatos de arquivos no R é possível devido a criação
# de pacotes de funções pela comunidade, possibilitando o desenvolvimento de nichos da
# linguagem dentro das diferentes áreas do conhecimento.

# Para iniciar, a maneira mais simples de importar dados é utilizar a interface do
# RStudio. Na aba `Environment`, podemos acessar a função `Import Dataset`,
# escolher a extensão adequada e manualmente selecionar o arquivo a ser importado.
# Como alternativa, podemos utilizar funções como `read_csv()` do pacote `readr` ou
# `read_xlsx()` do pacote `readxl` (não presente no `tidyverse`).

# Contudo, neste curso, utilizaremos três conjuntos de dados recuperados do Instituto
# Nacional de Meteorologia (INMET) no Banco de Dados Meteorológicos do INMET. Os dados
# podem ser obtidos em seu formato original em <https://bdmep.inmet.gov.br/#>.

# Os conjuntos de dados utilizados consistem em três séries históricas de 1991 até 2020,
# para as cidades de Itaperuna, Rio de Janeiro e Campos dos Goytacazes. Nosso objetivo
# ao final da importação é possuir um único objeto contendo as informações dos três conjuntos.

# O primeiro passo será realizar o download dos dados. Para simplificar o processo,
# disponibilizamos os três conjuntos de hoje em nossa página do GitHub. Abaixo, os links
# para a importação.

endereço <- c(
  "Belo Horizonte" = "https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Visualizacao%20de%20dados%20com%20R/dados/dados_83587_D_1991-01-01_2020-12-31.csv",
  "Vitória" = "https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Visualizacao%20de%20dados%20com%20R/dados/dados_83648_D_1991-01-01_2020-12-31.csv",
  "Rio de Janeiro" = "https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Visualizacao%20de%20dados%20com%20R/dados/dados_83743_D_1991-01-01_2017-04-04.csv",
  "São Paulo" = "https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Visualizacao%20de%20dados%20com%20R/dados/dados_83781_D_1991-01-01_2020-12-31.csv"
  )

# Download dos arquivos pela linha de comando

dir.create("dados/")

for (i in seq_along(endereço)) {
  download.file(
    url = endereço[i],
    destfile = paste0("dados/", names(endereço)[i], ".csv")
  )
  cat("Arquivo", i, "baixado com sucesso!")
}

#   - Construir uma função para a leitura dos dados que realize:
#   # --- > Importar o conjunto adequadamente
#   # --- > Corrigir artefatos presentes no objeto
#   # --- > Renomear colunas
#   # --- > Identificar o conjunto adequadamente
#   # --- > Retorna o objeto importado

# Importando dados originais ----
Leitura_Personalizada <- function(Arquivo) {

  # Bibliotecas para a função
  if (!require("tidyverse")) install.packages("tidyverse")
  library(tidyverse)

  # Importar o conjunto adequadamente
  dados <-
    read_csv2(
      file = Arquivo,
      skip = 10,
      na = "null") |>

    # Corrigir artefatos presentes no objeto
    select(!starts_with("...")) |>

    # Renomear colunas
    rename_with(~c('Data', 'Evap', 'Prec', 'Temp', 'Umi', 'Vento')) |>

    # Identificar o conjunto adequadamente
    mutate(ID = Arquivo |> str_remove_all("dados/|\\.csv"))

    # Retorna o objeto importado
    return(dados)
}

# Executando a função
arq <- list.files(path = "dados/", pattern = ".csv", full.names = T)

df <- map_df(.x = arq, .f = ~Leitura_Personalizada(Arquivo = .x))

# Exploração inicial ----

# Antes de iniciar a visualização, é importante conhecer a natureza dos dados que estamos
# utilizando. Podemos utilziar algumas funções do tidyverse para realizar essa exploração
# inicial e conhecer melhor o conjunto que estamos trabalhando.

# Com a função `glimpse()` temos uma breve descrição da natureza de cada variável de nosso
# conjunto. Qual o formato do dado? Númerico? Character? Lógico? Data? Aqui podemos checar e
# conferir se a importação foi realizada da maneira adequada.

df |>
  glimpse()

# Podemos ainda obter algumas estatísticas descritivas rápidas com a função `summary()`.
# Vamos estudar o conjunto, separando-o com base na cidade.

summary(df)

# Outro ponto importante é verificar a % de NAs em nossa tabela. Algumas análises não podem
# ser feitas caso esse valor seja elevado. Vamos verificar em nosso conjunto.

# Função para calcular a porcentagem de NAs
pna <- function(x){
    (sum(is.na(x))/length(x)) * 100
}

# Aplicando a função
df |>
  group_by(ID) |>
  summarise(
    across(
      .cols = Evap:Vento,
      .fns = pna
    )
  )

# Introdução ao `ggplot2` ----

# O `ggplot2` é um pacote de construção de gráficos pertencente ao `tidyverse`, carregando
# assim uma filosofia de simplicidade e transparência nos códigos. O pacote opera em uma
# estrura de camadas, onde cada elemento pode ser personalizado à vontade do usuário.
# Assim, o pacote apresenta-se como uma ferramenta flexivel capaz de antender a diversas
# demandas. Suas principais camadas são:

# Dados (data):
# Esta é a camada mais fundamental, onde o usuário fornece os dados que deseja visualizar.
#  Os dados são geralmente fornecidos como um dataframe do R.

# Mapeamento Estético (Aesthetic Mapping):
# Nesta camada, o usuário associa variáveis do conjunto de dados às propriedades visuais
# do gráfico, como eixos, cor, forma, tamanho, etc. Por exemplo, pode-se mapear uma
# variável para a cor dos pontos em um gráfico de dispersão. É importante destacar que
# o mapeamento pode operar em nível global, afetando todas as camadas do gráfico, ou
# em nível local, afetando apenas uma. Este assunto será abordado em mais detalhes
# posteriormente.

# Geometria (Geometry):
# Esta camada determina o tipo de gráfico que se deseja criar, como pontos, linhas,
# barras, caixas, etc. Por exemplo, `geom_point()` cria um gráfico de pontos, `geom_col()`
# cria um gráfico de colunas, e assim por diante.

# Escala (Scale):
# As escalas definem como os valores dos dados são mapeados para as propriedades visuais
# do gráfico. Por exemplo, pode-se ajustar a escala dos eixos x e y para se adaptar melhor
# aos dados.

# Facetas (Facets):
# Esta camada é opcional e permite dividir o gráfico em várias facetas com base em uma
# ou mais variáveis. Isso é útil para comparar subgrupos de dados lado a lado.

# Camadas Estatísticas (Statistical Layers):
# Em alguns casos, o usuário pode desejar adicionar camadas estatísticas aos gráficos,
# como linhas de regressão, intervalos de confiança, etc.

# Temas (Themes):
# Esta camada define o estilo geral do gráfico, incluindo aspectos como cores, fontes,
# tamanhos de texto, etc. O usuário pode utilizar os temas padrão fornecidos pelo `ggplot2`
# ou criar um tema personalizado.

# Vamos criar nosso primeiro ggplot! O primeiro passo, é chamar a função ggplot e informar
# qual conjunto de dados deseja utilziar.

ggplot(data = df)

# Perceba que uma janela branca foi criada na aba "Plots". Este é o nosso ggplot.
# Por enquanto, ele possui apenas uma camada contendo os dados, mas não apresenta
# mapeamento ou geometria.

# Vamos adicionar mapeamento de variáveis

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap)
)

# Agora o gráfico apresenta eixos X e Y, sendo respectivamente a Temperatura e a
# Evapotranpiração.

# O próximo passo será adicionar uma camada de geometrias para representar visualmente as
# variáveis. Neste caso, iremos utilziar um `geom_point()` que irá criar gráficos de pontos.

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap)
) +
  geom_point()

# Podemos aplicar personalizações estéticas ao adicionar argumentos dentro da função `geom_point()`.
# Por exemplo, podemos alterar o tamanho, as cores e o formato dos pontos utilziados no gráfico.

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap)
) +
  geom_point(
    size = 2, # Tamanho do ponto: 2 representa 200% do tamanho original
    color = "steelblue", # Cor dos pontos. Podemos utilizar um código hexadecimal ou cores nomeadas (veja: `colors()`)
    shape = 17 # Formato do ponto.
  )

# Exemplos práticos: Mapeamento ----
# Como mencionado anteriormente, a camada do mapeamento pode receber multiplos argumentos,
# criando assim gráficos com elementos visuais agrupados. Por exemplo, podemos solicitar um gráfico
# de pontos, onde cada cor representa uma das cidades de nossa base de dados.

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap, color = ID)
) +
  geom_point(
    size = 1.3,
    alpha = 0.3
  )

# Podemos utilizar outros argumentos estéticos além das cores. Alguns bons exemplos são:
# - color
# - fill
# - group
# - shape
# - size
# - family       (Para textos)
# - fontface     (Para textos)

# Exemplos:

ggplot(
  data = df,
  mapping = aes(x = Temp, y = Evap, color = ID, shape = ID) # Note que podemos utilizar mais de um
) +
  geom_point()

ggplot(
  data =
    tibble(
      x = 1:3,
      y = 1,
      lab = c("a", "b", "c"),
      font = c("sans", "mono", "serif"),
      fontface = c("plain", "bold", "italic")),
  mapping = aes(
    x = x, y = y,
    label = fontface,
    font = font,
    fontface = fontface)
) +
  geom_text(size = 5)

# Exemplos práticos: Tipos de Geomerias ----
# Além dos gráficos de dispersão mostrados anteriormente, o ggplot é capaz de produzir uma
# alta variedade de tipos gráficos. Alguns exemplos são:
# - geom_point() e geom_smooth():
    ggplot(df, aes(x = Temp, y = Evap)) + geom_point() + geom_smooth()

# - geom_histogram() , geom_density() e geom_rug():
    ggplot(df, aes(x = Temp)) + geom_histogram() + geom_rug()
    ggplot(df, aes(x = Temp)) + geom_density() + geom_rug()

# - geom_boxplot() e geom_violin()
    ggplot(df, aes(x = ID, y = Temp)) + geom_boxplot()
    ggplot(df, aes(x = ID, y = Temp)) + geom_violin()

# - geom_col() + geom_errorbar()
    ggplot(tibble(x = 1:3, y = c(5, 6, 4)), aes(x = x, y = y, ymin = y-1, ymax = y+1)) + geom_col() + geom_errorbar()

# - geom_tile() e geom_raster()
    ggplot(tibble(x = rep(1:3, 3), y = rep(1:3, each = 3), z = rnorm(n = 9)), aes(x = x, y = y, fill = z)) + geom_tile()

# - geom_density_2d() e geom_hex()
    ggplot(df, aes(x = Temp, y = Evap)) + geom_point() + geom_density_2d()
    ggplot(df, aes(x = Temp, y = Evap)) + geom_hex()

# - geom_map() e geom_sf()
if (!require("geobr")) install.packages("geobr")
library(geobr)

ggplot() +
  geom_sf(data = geobr::read_biomes(), aes(fill = name_biome))

# Exemplos práticos: Escalas ----
# As principais alterações na camada scales giram em torno de alterar escalas com funções e/ou alterar valores
# de cores caso seja necessário nos gráficos. Vejamos alguns exemplos:

ggplot(df, aes(x = Temp, y = Evap, color = ID)) +
  geom_point() +
  scale_color_manual(values = c('purple3', 'yellow3', 'blue3', 'red3')) # Alterando cores

ggplot(df, aes(x = Temp, y = Evap, color = ID)) +
  geom_point() +
  scale_y_continuous(transform ='log10', limits = c(1, 100)) # Alterando limites e escalas

# Exemplos práticos: Facetas ----
# O conceito de facetas no ggplot trabalha com quebras de um gráfico em vários. Vejamos alguns exemplos:


ggplot(df, aes(x = Temp, y = Evap, color = ID)) +
  geom_point() +
  facet_wrap(~month(Data))

# Exemplos práticos: Estatísticas ----

ggplot(df, aes(x = month(Data), y = Temp, fill = ID, group = month(Data))) +
  stat_summary(fun = "mean", geom = "col") +
  stat_summary(fun.min = ~mean(.x)-sd(.x), fun.max = ~mean(.x)+sd(.x), geom = "errorbar") +
  facet_grid(rows = vars(ID))

ggplot(df, aes(x = Temp, y = Evap, color = ID)) +
  geom_point() +
  geom_smooth(method = "lm", color = "black") +
  ggpmisc::stat_poly_eq(aes(label = paste(after_stat(eq.label), after_stat(rr.label), after_stat(p.value.label), sep = "*\"; \"*"))) +
  facet_wrap(~ID)

# Exemplos práticos: Temas ----
# A cama de temas é certamente a mais complexa de todo o ggplot. A função `theme()` possui 138 argumentos nomeados que podem ser indexados
# para construir ajustes específicos em um gráfico. Você pode conferir e ler sobre cada camada na documentação de ajuda: `help(theme)`.
# Cada argumento recebe funções de acordo com qual elemento ele modifica. Alguns exemplos são:

# - element_line()      - Utilizado para elementos com linhas
# - element_rect()      - Utilizado para elementos com formas geométricas
# - element_text()      - Utilizado para elementos com textos
# - element_blank()     - Utilizado para remover/ocultar um elemento
# - element_render()
# - element_grob()

# Contudo, não precisamos formatar cada argumento da função para atingir um gráfico visualmente agradável. Podemos utilizar temas
# já prontos disponíveis no pacote ggplot2 ou em outros como o ggthemes.

if (!require("ggthemes")) install.packages("ggthemes")
library(ggthemes)

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

# Outro aspécto sobre a aparencia do gráfico que é de grande interesse personalziar são títulos de rótulos do gráfico.
# Podemos realizar essas alterações com a função `labs()`

ggplot(df, aes(x = Temp, y = Evap, color = ID)) +
  geom_point() +
  labs(
    title = "Título",
    subtitle = "Subtítulo",
    caption = "Rodapé",
    tag = "TAG",
    x = 'Eixo X',
    y = 'Eixo Y',
    color = 'Legenda Cor',
    # fill = '',
    # shape = '',
    # ...
  )

# Produção de gráficos ----

# Agora que já discutimos as bases do ggplot, podemos avanças na produção de alguns gráficos.
# Nesta etapa do curso, preparamos alguns exemplos já estruturados e discutimos o passo a passo
# de como alcançar um resultado final em um gráfico. Para isso, utilizaremos alguns pacotes além
# do ggplot2, seja adicionando funcionalidades gráficas a ele ou apenas fornecendo ferramentas extras
# de qualidade de vida ao usuário.

# O pacote camcorder é utilizado para plotar os gráficos já em sua resolução final,
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

# O pacote showtext nos permite importar facilmente fontes extras para utilizar nos gráficos
# Podemos buscar as fontes em <fonts.google.com>.

if (!require(showtext)) install.packages("showtext")
library(showtext)

font_add_google(name = "Montserrat", family = "Montserrat")
showtext_auto()

# O pacote ggtext adiciona algumas funções interessantes para trabalhar com textos
# nos gráficos, seja internamente, como geometrias, ou nos rótulos dos gráficos.
if (!require(ggtext)) install.packages("ggtext")
library(ggtext)

# Utilizaremos o ggdist para adicionar geometrias que trabalham com densidade
if (!require(ggdist)) install.packages("ggdist")
library(ggdist)

# O ggside nos permite criar gráficos marginais com pouco trabalho.
if (!require(ggside)) install.packages("ggside")
library(ggside)

# Histograma ----

# Iniciando um Histograma
df |>
  ggplot(aes(x = Temp)) +
  geom_histogram()

# Vamos adicionar as cores de acordo com a Capital
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram()

# Agora, podemos quebrar em 4 gráficos com facet_grid()
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram() +
  facet_grid(rows = vars(ID), axes = "all")

# Para aprimorar a ilustração, podemos adicionar um boxplot junto do
# histograma
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram() +
  geom_boxplot(aes(y = -100)) +
  facet_grid(rows = vars(ID), axes = "all")

# Vamos ajustar as cores e o tamanho de alguns elementos
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram(aes(x = Temp), color = "black", bins = 50) +
  geom_boxplot(aes(x = Temp, y = -100), width = 100, outlier.size = 0.5, color = "black") +
  scale_fill_viridis_d() +
  facet_grid(rows = vars(ID), axes = "all")

# Corrigindo nomes dos eixos e adicionando um título
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram(aes(x = Temp), color = "black", bins = 50) +
  geom_boxplot(aes(x = Temp, y = -100), width = 100, outlier.size = 0.5, color = "black") +
  scale_fill_viridis_d() +
  facet_grid(rows = vars(ID), axes = "all") +
  labs(
    title = "Distribuição de Temperaturas (°C) nas capitais do Sudeste de 1990 a 2020 ",
    x = "Temperatura (°C)",
    y = "Contagem",
    caption = "Fonte dos dados: INMET • Elaborado por @Proamb.R")

# Alterações no tema
df |>
  ggplot(aes(x = Temp, fill = ID)) +
  geom_histogram(aes(x = Temp), color = "black", bins = 50) +
  geom_boxplot(aes(x = Temp, y = -100), width = 100, outlier.size = 0.5, color = "black") +
  scale_fill_viridis_d() +
  facet_grid(rows = vars(ID), axes = "all") +
  labs(
    title = "Distribuição de Temperaturas (°C) nas capitais do Sudeste de 1990 a 2020 ",
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

# Gráficos de dispersão ----

gg_record(dir = "plots", width = 1000, height = 1000, device = "png", bg = "white", units = "px")

# Iniciando o gráfico de dispersão
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point()

# Alterando aspectos visuais dos pontos
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point(shape = 21, fill = rgb(1,1,1,0.2),
             color = "steelblue2", stroke = 1, alpha = 0.7)

# Adicionando um geom_density_2d()
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point(shape = 21, fill = rgb(1,1,1,0.2),
             color = "steelblue2", stroke = 1, alpha = 0.7) +
  geom_density_2d(color = "steelblue4", linewidth = 0.6)

# Adicionando boxplots marginais
df |>
  filter(ID == "São Paulo") |>
  ggplot(aes(x = Temp, y = Umi)) +
  geom_point(shape = 21, fill = rgb(1,1,1,0.2),
             color = "steelblue2", stroke = 1, alpha = 0.7) +
  geom_density_2d(color = "steelblue4", linewidth = 0.6) +
  geom_xsideboxplot(orientation = "y", color = "steelblue2") +
  geom_ysideboxplot(orientation = "x", color = "steelblue2")

# Alterações de tema e rótulos
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

# Gráficos de Série Temporal ----

gg_record(dir = "plots", width = 2000, height = 800, device = "png", bg = "white", units = "px")

# Iniciando o gráfico
# Calculando médias mensais de Temperatura das cidades de interesse

df_gr <-
  df |>
  filter(ID %in% c("Vitória", "Belo Horizonte")) |>
  group_by(Mês = month(Data), Ano = year(Data), ID) |>
  summarise(me = mean(Temp),
            sd = sd(Temp)) |>
  mutate(Data = ym(paste(Ano, Mês, sep = "-")))

# Iniciando o gráfico
df_gr |>
  ggplot(
    aes(x = Data, y = me, color = ID)
  ) +
  geom_line() +
  geom_point()

# Alterando aspectos visuais dos pontos e escalas

df_gr |>
  ggplot(
    mapping = aes(x = Data, y = me, color = ID)
  ) +
  geom_line(lwd = 1.1, alpha = 0.5) +
  geom_point(size = 1.5, alpha = 0.5) +
  scale_y_continuous(limits = c(17, 30), breaks = seq(16,30,2)) +
  scale_x_date(breaks = "5 years", date_labels = "%Y") +
  scale_color_manual(values = c("#ed2024", "#023a99"))

# Adicionando título e rótulo de eixos
# Aqui utilizaremos uma tag HTML para utilizar o título como legenda do gráfico

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

# Adicionando tema
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

# Boxplot ----

gg_record(dir = "plots", width = 2000, height = 800, device = "png", bg = "white", units = "px")

# Iniciando o gráfico
df |>
  mutate(Ano = year(Data)) |>
  ggplot(aes(y = Temp, x = Ano, fill = ID)) +
  geom_boxplot()

# Para aprimorar a visualização, podemos adicionar alguns outros elementos
# como os próprios pontos ilustrados e uma curva de distribuição

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

# Ajustes de cores

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

# Adicionando legendas

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

# Alterando tema

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

# Gráfico de Barras ----

gg_record(dir = "plots", width = 1200, height = 1000, device = "png", bg = "white", units = "px")

# Cálculo de precipitação Acumulada anual em cada capital

df_gr <-
  df |>
  group_by(Ano = year(Data), ID) |>
  summarise(
    Prec_Acc = sum(Prec)
  ) |>
  filter(ID != "Rio de Janeiro")

# Vamos quebrar o gráfico em 4 facets

df_gr |>
  ggplot(aes(x = Ano, y = Prec_Acc, fill = ID)) +
  geom_col() +
  facet_grid(rows = vars(ID), axes = "all")

# Agora, podemos adicionar o valor de precipitação calculado

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

# O próximo passo é inserir rótulos e alterações estéticas do tema

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

# Heatmap ----

gg_record(dir = "plots", width = 1000, height = 1000, device = "png", bg = "white", units = "px")

# Calculando médias mensais de Temperatura
df_gr <-
  df |>
  filter(ID == "Vitória") |>
  group_by(Ano = year(Data), Mês = month(Data)) |>
  summarise(
    me = mean(Temp)
  )

# Plotando gráfico inicial

df_gr |>
  ggplot(aes(x = Mês, y = Ano, fill = me)) +
  geom_tile()

# Vamos alterar a escala de cores

df_gr |>
  ggplot(aes(x = Mês, y = Ano, fill = me)) +
  geom_tile() +
  scale_fill_viridis_c(option = "turbo")

# Aplicando alterações estéticas no geom_tile e adicionando geom_text com temperaturas
# Para escrever a temperatura e o símbolo °, utilizaremos a função paste0(),
# Contudo, caso a temperatura informada seja "NA", a função escreverá "NA°".
# Para evitar a questão, utilizaremos um case_when() para criar uma nova coluna
# contendo o que será passado à geom_text()

df_gr |>
  mutate(lab = case_when(
    !is.na(me) ~ paste0(round(me, 1), "°")
  )) |>
  ggplot(aes(x = Mês, y = Ano, fill = me)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = lab, family = "Montserrat", fontface = "bold"), size = 4.5, color = "gray95") +
  scale_fill_viridis_c(option = "turbo")

# Agora, devemos inverter a escala de y para que 2020 fique no final do gráfico

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

  # Agora adicionamos rótulos e alteramos aspéctos do tema

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

# Exportando Gráficos ----
# A função `ggsave()` permite salvar gráficos criados em arquivos externos em
# diversos formatos, como PNG, JPEG, PDF, SVG e outros.

# Alguns argumentos da função `ggsave()`:
# plot:           O gráfico que será salvo. Por padrão, vai salvar o último gráfico plotado.
# filename:       O nome do arquivo/gráfico que será salvo, com a extensão (ex: .png).
# width e height: Largura e altura do gráfico em unidades especificadas pelo argumento units.
# units:          Unidades para largura e altura do gráfico, que podem ser:
#                 'in' (polegadas), 'cm' (centímetros), 'mm' (milímetros) e 'px' (pixels).

# Salvando o ultimo gráfico

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

