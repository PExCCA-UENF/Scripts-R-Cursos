#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 27/07/2023                        #
#==============================================================================#

#             MANIPULAÇÃO E VISUALIZAÇÃO DE DADOS NO R - PARTE 2               #
#                         PROGRAMANDO COM O TIDYVERSE                          #

#------------------------------------------------------------------------------#
# Atenção! A primeira parte do curso está disponível no GitHub.
#          Link: https://github.com/PExCCA-UENF

# 4. MANIPULANDO DADOS COM ‘DPLYR’ E ‘TIDYR (CONTINUAÇÃO) ---------------------#
# install.packages('tidyverse')
library(tidyverse)

# Primeiro, vamos fazer a importação dos dados:
url_dados <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Manipula%C3%A7%C3%A3o%20e%20Visualiza%C3%A7%C3%A3o%20de%20Dados/Dados_Campos.csv'

dados <-
  url_dados %>% 
  read_csv2(na = 'NA') 
print(dados)

# Convertendo os dados diários em mensais -------------------------------------#
## Acumulando Mensal de Precipitação:
Prec_Mensal <-
  dados %>%
  group_by(Estacao, Ano, Mes) %>%
  summarise(
    Prec_m = sum(Prec, na.rm = F)
  )
print(Prec_Mensal)

### Função `group_by()` ---
### A função `group_by()` do pacote 'dplyr' agrupa os dados com base em uma  
### variável categórica, criando grupos que são salvos nos metadados de um objeto.  
### Desta forma, podemos aplicar funções nesses grupos dentro do conjunto de dados. 

### Função `summarise()` ---
### A função 'summarise()' do pacote 'dplyr' permite agregar sumarizações unindo  
### diversos cálculos ao longo de uma base de dados. Normalmente ela é usada 
### junto com a função 'group_by()'. 

## Usando os dados 'Prec_Mensal', vamos classificar os meses em: 
## Muito seco: 0 a 15% dos dados 
## Seco: 15 a 35% dos dados 
## Normal: 35 a 65% dos dados 
## Chuvoso: 65 a 85% dos dados 
## Muito chuvoso: 85 a 100% dos dados

## Vamos precisar calcular os quantis 15%, 35%, 65% e 85%:
PrecM_quantil <- 
  Prec_Mensal$Prec_m %>% 
  quantile(probs = c(0.15, 0.35, 0.65, 0.85), na.rm = T)
print(PrecM_quantil)

Prec_Mensal <-
  Prec_Mensal %>%
  mutate(
    Classificação =
      case_when(
        Prec_m <= PrecM_quantil[1] ~ 'Muito Seco',
        between(Prec_m, PrecM_quantil[1], PrecM_quantil[2]) ~ 'Seco',
        between(Prec_m, PrecM_quantil[2], PrecM_quantil[3]) ~ 'Normal',
        between(Prec_m, PrecM_quantil[3], PrecM_quantil[4]) ~ 'Chuvoso',
        Prec_m >= PrecM_quantil[4] ~ 'Muito Chuvoso'
      ) %>% 
      factor(levels = c('Muito Seco', 'Seco', 'Normal', 'Chuvoso', 'Muito Chuvoso'))
  )
print(Prec_Mensal)

### Função 'case_when()' ---
### A função `case_when()` do pacote 'dplyr' permite criar e/ou modificar variáveis 
### a partir de uma sequência de condições que devem ser respeitadas.

## Temperatura Média, Máxima e Mínima Mensal:
Temp_Mensal <-
  dados %>%
  group_by(Estacao, Ano, Mes) %>%
  summarise(
    across(
      .cols = c(`Tmed`, `Tmax`, `Tmin`),
      .fns = list(Media = mean, Desvio = sd)
    )
  ) %>%
  mutate(.before = Ano,
    Data = paste(Ano, Mes, sep = '-') %>% ym()
  )
print(Temp_Mensal)

### Função `across()` ---
### A função `across()` do pacote 'dplyr' permite a aplicação de uma lista de 
### funções a múltiplas colunas/variáveis. 

# 5. VISUALIZAÇÃO GRÁFICA COM ‘GGPLOT2’ ---------------------------------------#
# O 'ggplot2' é um pacote de visualização de dados que foi criado por Hadley Wickham 
# baseado em um conceito denominado “Gramática de Gráficos”. 

# No ggplot2, os gráficos são construídos camada por camada. Iniciamos chamando 
# a função `ggplot()`. Devemos passar para essa função a base de dados que será 
# usada para criar o gráfico.

ggplot(data = Temp_Mensal)

# Perceba que essa função gerou apenas o plano de fundo cinza. 
# Agora vamos especificar como as observações serão mapeadas nos aspectos visuais  
# do gráfico e quais formas geométricas serão utilizadas.

ggplot(
  data = Temp_Mensal,
  mapping = aes(x = Tmin_Media, y = Tmax_Media)
)

### Função `aes()` ---
### A função `aes()` define o mapeamento dos elementos no plano cartesiano de
### nosso gráfico. Destacamos também que o mapeamento pode ser definido em
### diferentes níveis, global (que se aplica a todo o gráfico) ou local (que se
### aplica apenas a uma camada). 

# Os aspectos que podem ou devem ser mapeados dependem do tipo de gráfico que 
# será construindo.

## Conjunto de mapeamentos estéticos (aesthetics) 'aes()':
## x e y: observações que serão mapeadas;
## color: define a cor de pontos e retas;
## fill: define a cor dos preenchimentos das formas com área;
## size: altera o tamanho das formas;
## alpha: altera a transparência das formas;
## shape: altera o estilo das formas;
## labels: altera o nome das observações.

# O mapeamentos estético 'aes()' pode ser usado dentro ou fora da função `ggplot()`.
ggplot(Temp_Mensal) +
  aes(x = Tmin_Media, y = Tmax_Media)

# Para definir o tipo de gráfico ou objeto geométrico, usamos a função 'geom_...()'.
## Gráfico de dispersão: 'geom_point()'
ggplot(Temp_Mensal) +
  aes(x = Tmin_Media, y = Tmax_Media) +
  geom_point()

# O mapeamentos estético 'aes()' também podem ser incluído no objeto geométrico.
ggplot(Temp_Mensal) +
  geom_point(
    mapping = aes(x = Tmin_Media, y = Tmax_Media))

# Usando o argumento 'color' na função `aes()` podemos constuir um gráfico por,
# categorias, basta usar alguma variável categórica.
ggplot(Temp_Mensal) +
  geom_point(
    mapping = aes(x = Tmin_Media, y = Tmax_Media, color = Estacao))

# Também podemos personalizar o `geom_point()` com alguns parâmetros gráficos
# como `size`, `shape`, `alpha`, entre outros.
ggplot(Temp_Mensal) +
  geom_point(
    mapping = aes(x = Tmin_Media, y = Tmax_Media, color = Estacao),
    size = 2.2, shape = 18, alpha = 0.3)

# O ggplot2 possui mais de 30 funções 'geom_...()', veja a lista no link:
# https://ggplot2.tidyverse.org/reference

## Gráficos de distribuição: 'geom_boxplot()' e 'geom_violin()'
ggplot(Temp_Mensal) +
  aes(x = Estacao, y = Tmed_Media) +
  geom_boxplot()

ggplot(Temp_Mensal) +
  aes(x = Estacao, y = Tmed_Media) +
  geom_violin()

# Também podemos criar um gráfico com mais de uma função 'geom_...()'.
ggplot(Temp_Mensal) +
  aes(x = Estacao, y = Tmed_Media) +
  geom_violin(bw = 0.3)+
  geom_boxplot(width = 0.1)

## Gráficos de histograma e densidade: 'geom_histogram()' e 'geom_density()'
Temp_Mensal %>%
  filter(Estacao == 'A607') %>%
  ggplot(aes(x = Tmed_Media)) +
  geom_histogram()

Temp_Mensal %>%
  filter(Estacao == 'A607') %>%
  ggplot(aes(x = Tmed_Media)) +
  geom_histogram(aes(y = ..density..))+
  geom_density()

## Personalizando os gráficos -------------------------------------------------#
## Exemplo 1:
ggplot(Temp_Mensal) +
  aes(x = Data, y = Tmed_Media, color = Estacao) +
  geom_point(alpha = 0.3) +
  geom_line() +
  scale_y_continuous(name = 'Temperatura (ºC)', 
                     limits = c(19, 28), 
                     breaks = seq(19, 28, 1))+
  scale_color_manual(values = c('darkred', 'darkblue'))

### Funções 'scale_...()' ---
### As funções dessa família são usadas para personalizar as escalas e outras
### características visuais dos gráficos criados com o `ggplot2`. Elas permitem
### ajustar estéticas como cores, tamanhos, formas e rótulos dos eixos.

#### `scale_x_...()` e `scale_y_...()`:
#### Essas funções permitem ajustar a escala dos eixos x e y, respectivamente.
#### Elas possuem subvariações como `...continous()`,`...discrete()`, entre outras. 
#### Devemos escolher uma subvariação de acordo com a natureza da variável. 
#### Com essas funções podemos definir os limites, os rótulos dos eixos, os 
#### intervalos e outros parâmetros de personalização do gráfico.

#### 'scale_color_...()':
#### Essa função permite alterar a escala de cores dos pontos e retas do gráfico.
#### Podemos definir cores específicas, gradientes de cores ou paletas de cores.

## Exemplo 2:
ggplot(Temp_Mensal) +
  aes(x = Tmed_Media, y = Tmax_Media, color = Estacao) +
  geom_point(alpha = 0.5, shape = 16, size = 3) +
  scale_x_continuous(name = 'Temperatura Média (ºC)',
                     breaks = seq(20, 28, 2)) +
  scale_y_continuous(name = 'Temperatura Máxima (ºC)',
                     breaks = seq(24, 34, 2)) +
  scale_color_viridis_d(option = 'D', begin = 0.2, end = 0.8)

## Exemplo 3:
ggplot(Temp_Mensal) +
  aes(x = Tmed_Media, y = Tmax_Media, color = Estacao) +
  geom_point(alpha = 0.5, shape = 16, size = 3) +
  geom_line() +
  scale_color_viridis_d(option = 'D', begin = 0.2, end = 0.8) +
  facet_wrap(~Ano)

## Exemplo 4:
ggplot(Temp_Mensal) +
  aes(x = Tmed_Media, y = Tmax_Media, color = Estacao) +
  geom_point(alpha = 0.5, shape = 16, size = 3) +
  geom_line() +
  scale_color_viridis_d(option = 'D', begin = 0.2, end = 0.8) +
  facet_grid(cols = vars(Ano))

### Funções 'facet_...()' ---
### As funções da família `facet_...()` são usadas para criar gráficos facetados,
### ou seja, divididos em subgráficos com base em uma ou mais variáveis categóricas.
### As principais funções de faceting são `facet_grid()` e `facet_wrap()`.

## Exemplo 5:
gr <- ggplot(Temp_Mensal) +
  aes(x = Data, y = Tmed_Media, color = Estacao) +
  geom_point(alpha = 0.5, shape = 16, size = 3) +
  geom_line() +
  scale_color_viridis_d(option = 'D', begin = 0.2, end = 0.8) +
  facet_wrap(~Estacao, nrow = 2) +
  labs(title = '<título>',
       x = '<eixoX>', y = '<eixoY>',
       color = '<color>', subtitle = '<subtítulo>',
       tag = '<tag>', caption = '<caption>')
gr

### Função 'labs()' ---
### A função `labs()` nos permite personalizar os rótulos e títulos de um gráfico.
### Ela permite que você altere o texto dos rótulos dos eixos `x` e `y`, o título 
### principal do gráfico, os rótulos da legenda, além de outras informações. 

#### Principais argumentos que podem ser usados na função `labs()`:
#    title:    Permite definir o título principal do gráfico.
#    subtitle: Permite adicionar um subtítulo abaixo do título principal.
#    x:        Permite definir o rótulo do eixo x.
#    y:        Permite definir o rótulo do eixo y.
#    caption:  Permite adicionar informação no rodapé do gráfico.
#    tag:      Permite adicionar uma etiqueta ao gráfico.
#    color:    Permite alterar o título da legenda do mapeamento `color`.
#    fill:     Permite alterar o título da legenda do mapeamento `fill`.
#    shape:    Permite alterar o título da legenda do mapeamento `shape`.

### Funções 'theme_...()' ---
### As funções `theme_...()` nos permitem alterar quase todos os aspectos visuais 
### do gráfico. 

gr + theme_minimal()
gr + theme_classic()
gr + theme_light()

#### Podemos alterar alguns argumentos das funções `theme_...()` como o tamanho da 
#### fonte do texto:
gr + theme_classic(base_size = 14)

# Para personalizar as fontes do texto, usando o pacote 'showtext', vamos importar 
# fontes da biblioteca online do Google.
# install.packages('showtext')
library(showtext)

# Acesse <https://fonts.google.com/> para verificar as fontes disponíveis.
font_add_google(name = 'Comfortaa', family = 'Comfortaa')   # Carregando a fonte escolhida.
showtext_auto()

gr + theme_classic(base_family = 'Comfortaa')

# 6. EXTENSÕES DO ‘GGPLOT2’ ---------------------------------------------------#
# Um conjunto de pacotes fornece extensões ao ggplot2, com funcionalidades não 
# existentes no pacote original.

## Pacote 'ggthemes' ----------------------------------------------------------#
## Uma das primeiras extensões criadas foi o 'ggthemes', que disponibiliza novos temas.
# install.packages('ggthemes')
library(ggthemes)

gr + ggthemes::theme_base(base_size = 10)
gr + ggthemes::theme_tufte(base_size = 10)
gr + ggthemes::theme_solarized(base_size = 10)

## Pacote 'ggtext' ------------------------------------------------------------#
## O pacote 'ggtext' também é uma extensão 'ggplot2' que permite a renderização de 
## rótulos de gráficos (títulos, subtítulos, rótulos de faceta, rótulos de eixo, etc.).
# install.packages('ggtext')
library(ggtext)

# Rótulos podem ser criados ou alterados com a função element_markdown() do pacote 'ggtext'.
gr +
  labs(title = 'Este é o título com **negrito** e *itálico*') + 
  theme(plot.title = element_markdown())

gr +
  labs(
    x = 'Modificando a cor do texto do eixo **x**',
    y = 'Modificando o tamanho do texto do eixo **y**'
  ) +
  theme(
    axis.title.x = element_markdown(color = 'blue'),
    axis.title.y = element_markdown(size = rel(2))
  )

## Pacote `ggdist` ------------------------------------------------------------#
## o 'ggdist', que também é uma extensão 'ggplot2', é um pacote que fornece um 
## conjunto flexível de geoms e estatísticas projetado especialmente para visualizar 
## distribuições e incertezas.

# install.packages('ggdist')
library(ggdist)

# Exemplos:
ggplot(Temp_Mensal) +
  aes(x = Estacao, y = Tmed_Media) +
  ggdist::geom_dots()

ggplot(Temp_Mensal) +
  aes(x = Estacao, y = Tmed_Media) +
  ggdist::geom_swarm()

# PERSONALIZANDO E SALVANDO OS GRÁFICOS ---------------------------------------#
# Exemplo 1:
ggplot(dados) +
  aes(x = Estacao, y = Tmed, fill = Estacao) + 
  geom_violin(color = NA, alpha = 0.3, show.legend = F) +
  geom_boxplot(
    color = c('#c45d56', '#008d91'),
    fill = c('#c45d56', '#008d91'),
    width = 0.1, 
    show.legend = F) +
  stat_summary(
    geom = 'point',
    fun = median,
    color = 'white', 
    show.legend = F
  ) +
  labs(title = 'Temperatura Média Diária em Campos-RJ',
       y = 'Temperatura (ºC)', x = NULL) +
  theme_minimal(base_family = 'Comfortaa', base_size = 14)
ggsave(filename = 'Plot1.png', 
       width = 1000, height = 1000, units = 'px', bg = 'white')

### Função `ggsave()` ---
### A função `ggsave()` permite salvar gráficos criados em arquivos externos em
### diversos formatos, como PNG, JPEG, PDF, SVG e outros.

### Alguns argumentos da função `ggsave()`:
# plot:           O gráfico que será salvo. Por padrão, vai salvar o último gráfico plotado.
# filename:       O nome do arquivo/gráfico que será salvo, com a extensão (ex: .png).
# width e height: Largura e altura do gráfico em unidades especificadas pelo argumento units.
# units:          Unidades para largura e altura do gráfico, que podem ser: 
#                 'in' (polegadas), 'cm' (centímetros), 'mm' (milímetros) e 'px' (pixels).

# Exemplo 2:
ggplot(Temp_Mensal) +
  aes(x = Ano, y = fct_rev(as.factor(Mes)), fill = Tmed_Media) + 
  geom_tile(color = 'white', linewidth = 1.5) +
  scale_fill_viridis_c(option = 'H') +
  scale_y_discrete(labels = c('Dez', 'Nov', 'Out',
                              'Set', 'Ago', 'Jul',
                              'Jun', 'Mai', 'Abr',
                              'Mar', 'Fev', 'Jan')) +
  scale_x_continuous(breaks = seq(2012, 2022, 1))+
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(size = 18, face = 'bold', hjust = 0.5),
        legend.position = 'bottom') +
  coord_fixed() +
  facet_grid(cols = vars(Estacao)) +
  labs(y = 'Mêses', fill = 'Temperatura (ºC)',
       title = 'Mapa de Calor da Temperatura Média Mensal de Campos dos Goytacazes-RJ')
ggsave(filename = 'Plot2.png', 
       width = 1500, height = 1100, units = 'px', bg = 'white')

# Exemplo 3:
font_add_google(name = 'Raleway', family = 'Raleway')
showtext_auto()

Prec_Mensal %>%
  mutate(Data = paste(Ano, Mes, 1, sep = '-') %>% ymd()) %>%
  ggplot() +
  aes(x = Data, y = Prec_m, fill = Classificação) +
  geom_col() +
  scale_fill_viridis_d(option = 'H', begin = 0.1, end = 0.9) +
  labs(fill = 'Classificação:', y = 'Precipitação (mm/mês)', x = NULL,
       title = 'Acumulado Mensal de Precipitação de Campos dos Goytacazes - RJ (2012 - 2022)') +
  facet_grid(rows = vars(Estacao)) +
  ggthemes::theme_fivethirtyeight(base_family = 'Raleway') +
  theme(
    plot.title = element_text(size = 18, hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.key.size = unit(3, 'mm'),
    legend.position = 'bottom')
ggsave(filename = 'Plot3.png', width = 1500, height = 1000, units = 'px')

#------------------------https://linktr.ee/pexcca.lamet------------------------#

