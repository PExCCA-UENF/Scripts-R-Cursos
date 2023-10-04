#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 03/10/2023                        #
#==============================================================================#

#             PROCESSAMENTO E ANÁLISE DE DADOS METEOROLÓGICOS NO R             #

# INTRODUÇÃO-------------------------------------------------------------------#
# Os dados meteorológicos são de grande importância, pois auxiliam a tomada de 
# decisão em diferentes áreas do conhecimento, seja na própria meteorologia, na 
# defesa civil, na agricultura, na engenharia, na construção civil, entre outras.

# Neste curso, vamos utilizar dados meteorológicos do Instituto Nacional de Meteorologia (INMET).
## 1. Normais Climatológicas de Temperatura Média Compensada Mensal e Anual (°C).
##    Link: https://portal.inmet.gov.br/normais

## 2. Tabela de Dados da Estação Automática MACAE A608.
##    Link: https://tempo.inmet.gov.br/TabelaEstacoes

# DOWNLOAD E IMPORTAÇÃO DOS DADOS ----------------------------------------------#

# Primeiro, vamor criar uma pasta denominada 'Dados_INMET':
if(!dir.exists('Dados_INMET/')){
  dir.create('Dados_INMET')
}

# Agora vamos fazer download das Normais Climatológicas de Temperatura Média 
# Compensada Mensal e Anual (°C) do INMET. 

# Link para baixar os dados:
url.tmed <- 'https://portal.inmet.gov.br/uploads/normais/Normal-Climatologica-TMEDSECA.xlsx'

# Use a função download.file() para baixar o arquivo conforme descrito por url da Internet.
download.file(url.tmed,                    # URL do arquivo a ser baixado.
              './Dados_INMET/Tmed.xlsx',   # Caminho e Nome do arquivo que será gerado.
              mode = 'wb')                 # Modo de gravação do arquivo: 'wb' para Windows.

dir("./Dados_INMET")   # Verifique se o arquivo foi salvo na pasta 'Dados_INMET/'.

##	Importação de dados em .xlsx e .xls
#	Como não tem a função no R básico, será necessário instalar e carregar o pacote readxl.
# install.packages('readxl')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.
library(readxl)

TMED <- read_excel(
  path = './Dados_INMET/Tmed.xlsx',   # Caminho e nome do arquivo que será importado.
  sheet = 1,                          # Planilha de interesse.
  na = '-',                           # Identificação dos valores ausentes.
  skip = 2) %>%                       # Número de linhas a serem ignoradas antes de ler os dados. 
  print()

# Importação da tabela de dados da estação automática MACAE A608.
library(readr)
MACAE <- read_delim(file = "./Dados_INMET/generatedBy_react-csv.csv",       # Caminho e nome do arquivo que será importado.
                   delim = ";",                                             # Indicar qual caracter separa cada coluna no arquivo de texto.
                   col_types = cols(Data = col_date(format = "%d/%m/%Y"),   # Transformar a coluna 'Data' no formato data dd/mm/aa. 
                                    `Hora (UTC)` = col_time(format = "%H%M")),     # Transformar a coluna 'Hora (UTC)' no formato time hhmm.
                   locale = locale(decimal_mark = ",", grouping_mark = ".")) %>%   # Definindo a parte decimal dos números.
  print()

# MANIPULAÇÃO E ANÁLISE EXPLORATÓRIA DOS DADOS---------------------------------#

## Operador pipe: O operador pipe facilita a construção e leitura de uma série de 
## comandos interligados, o que será essencial para o processamento e análise de dados.

# O operador pipe do pacote 'magrittr' é representado por %>%. 
# Apesar de sua origem ser o pacote 'magrittr', o pipe é carregado automaticamente 
# pelo 'tidyverse', que é um conjunto de pacotes de R desenvolvidos para a ciência de dados.

# A ideia do operador pipe %>% é usar o valor resultante da expressão do lado esquerdo 
# como primeiro argumento da função do lado direito. 
# Ele recebe o resultado de uma expressão e passa ele adiante.
# Para o atalho de teclado do pipe, tecle ctrl + shift + m.

# install.packages('tidyverse')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.
library(tidyverse)

TMED %>% 
  View()   # Apresenta o conteúdo completo da base de dados em uma nova aba.

TMED %>% 
  str()    # Retorna uma síntese da estrutura da base de dados.

# Obs.:
# 1. Os dados estão no formato tibble.
# 2. Tibbles são similares aos data frames, mas são diferentes em dois aspectos: impressão e indexação.
#	3. Por padrão, apenas as dez primeiras linhas da base são apresentadas.
#	4. Também são apresentadas a dimensão da tabela e as classes de cada coluna.
#	5. dbl (double): com precisão dupla, que armazena a parte fracionária com maior precisão.

TMED %>% 
  head(n = 5)   # Retorna as primeiras n linhas (por padrão 6 linhas). 

TMED %>% 
  tail(n = 5)   # Retorna as últimas n linhas (por padrão 6 linhas). 

# Podemos acessar as colunas/variáveis usando o $.
TMED$UF   # Retorna os dados da coluna UF.

TMED %>% 
  attach()  # Permite acessar as colunas/variáveis individualmente (sem necessidade de $).

TMED %>% 
  colnames()   # Lista os nomes das colunas.

TMED %>% 
  summary()   # Retorna um resumo estatístico dos dados.

## Função by e tapply: agrupa os dados de acordo uma variável a partir de uma função.

# Sumários por 'UF' usando a função by():
TMED$Ano %>%                # Variável a ser aplicada a função.
  by(INDICES = TMED$UF,     # Fator/categoria para agrupar os dados.
     FUN = summary)         # A função a ser aplicada.

# Sumários por 'UF' usando a função tapply():
TMED$Ano %>%                # Variável a ser aplicada a função.
  tapply(INDEX = TMED$UF,   # Fator/categoria para agrupar os dados.
         FUN = summary)     # A função a ser aplicada.

# Função subset: cria um subconjunto de dados de acordo com determinada condição.
RJ <-
  TMED %>%                           # Objeto a ser filtrado.
  subset(subset = UF == 'RJ') %>%    # Condição que será aplicada.
  print()

## Medidas de tendência central: média e mediana 
## Média aritmética: soma de todos os elementos dividida pela quantidade deles.
TMED$Janeiro %>% 
  mean(na.rm = TRUE)

# Nota: Se existir dados ausentes (NA) no conjunto de dados, ao calcular estatísticas descritivas, 
# o resultado será NA. Para realizar o cálculo, precisamos definir na.rm = TRUE.

## Mediana: valor que separa os dados em duas partes iguais.
## 50% dos dados estão abaixo da mediana e 50% acima.
TMED$Janeiro %>% 
  median(na.rm = TRUE)

## Medidas de dispersão: variância e desvio-padrão.
## Variância: é a soma dos desvios quadrados da média dividida pelo tamanho da amostra (menos um).
## Como utilizamos a soma dos desvios quadráticos, esta terá unidade de medida quadrática, 
## o que pode ser de difícil interpretação.
TMED$Janeiro %>% 
  var(na.rm = TRUE)

## Desvio padrão: é a raiz quadrada da variância.
## O desvio-padrão demonstra a distância dos valores em relação à média dos dados,
## quanto mais próximo de 0 for o desvio-padrão, menos dispersos são os dados
TMED$Janeiro %>% 
  sd(na.rm = TRUE)

# Vamos calcular as medidas descritivas usando a função summarise() do pacote 'dplyr' (da coleção 'tidyverse').
# A função summarise() agrega sumarizações unindo diversos cálculos ao longo de uma base de dados.

# Calculando a média (mean):
TMED %>% 
  summarise(Tjan = mean(Janeiro, na.rm = T),
            Tfev = mean(Fevereiro, na.rm = T))

## Se na.rm é TRUE, a função ignora os NA. Se na.rm é FALSE, ele retorna NA no cálculo feito. 

# Use a função across() com a função summarise() para facilitar a execução da mesma operação em várias colunas.
DP <- 
  TMED %>% 
  summarise(across(4:15,             # Selecionando as colunas 4 a 15.
                   sd, na.rm = T)) %>% 
  print()

# Com o auxílio do comando groupy_by() podemos ainda agrupar os dados para a sumarização.
DP.UF <- 
  TMED %>% 
  group_by(UF) %>%
  summarise(across(4:15,             # Selecionando as colunas 4 a 15.
                   sd, na.rm = T)) %>% 
print()

# Calculando a média (mean), mediana (median) e desvio padrão (sd):
T.md <- 
  TMED %>% 
  group_by(UF) %>%
  summarise(across(4:15, 
                   list(Média = mean, 
                        Mediana = median,
                        DP = sd), na.rm = T))
View(T.md)

# APRESENTAÇÃO E VISUALIZAÇÃO DE DADOS-----------------------------------------#

RJ %>% 
  View()

# Pivotando os dados para obter três colunas: Estações, Meses e Temperatura.
# Vamos usar a função pivot_longer() do pacote 'tidyr' (da coleção 'tidyverse').

RJmensal <- 
  RJ %>% 
  select(`Nome da Estação`, Janeiro:Dezembro) %>% 
  pivot_longer(cols = 2:13,               # Definindo as colunas.
               names_to = 'Mês',          # Nome da coluna com os meses.
               values_to = 'Tmed') %>%    # Nome da coluna com os valores de temperatura.
  print()

# Visualização de dados usando o 'ggplot2' (da coleção 'tidyverse').
# No ggplot2, os gráficos são construídos camada por camada.
# A camada base é dada pela função ggplot(), que recebe o conjunto de dados.

RJmensal %>%
  ggplot()

# É necessário especificar como as observações serão mapeadas nos aspectos visuais  
# do gráfico e quais formas geométricas serão utilizadas.

# Para definir o tipo de gráfico (barras, linha etc), usamos a função geom_<FUNCTIONS>().
# Os mapeamentos estéticos são especificados por aes().

# O ggplot2 possui mais de 30 funções geom_<FUNCTIONS>(), veja a lista no link:
# https://ggplot2.tidyverse.org/reference

#------------------------------------------------------------------------------#
# Mapeamento Estético:
# x e y: observações que serão mapeadas;
# color: define a cor de pontos e retas;
# fill: define a cor dos preenchimentos das formas com área;
# size: altera o tamanho das formas;
# alpha: altera a transparência das formas;
# shape: altera o estilo das formas;
# labels: altera o nome das observações.

# Os aspectos que podem ou devem ser mapeados dependem do tipo de gráfico que você está construindo.
#------------------------------------------------------------------------------#
RJmensal %>% 
  filter(`Nome da Estação` == 'CAMPOS') %>% 
  ggplot() +
  aes(x = Mês, y = Tmed)+
  geom_col(fill = 'lightblue') +
  labs(x = NULL, y = 'Temperatura (ºC)',
       subtitle = "Temperatura Mensal Média (1991-2020) de Campos/RJ")+
  theme_minimal()

#------------------------------------------------------------------------------#
MACAE %>% 
  View()

MACAE2 <- 
  MACAE %>%
  mutate(Data_Hora = ymd_hms(paste(Data, `Hora (UTC)`, sep = " ")),   # Criando uma coluna com as informações da data e hora. 
         .before = Data) %>% 
  print()

# Vamos instalar e carregar o pacote 'ggtext' que tem suporte aprimorado à renderização de texto para 'ggplot2'.
# install.packages('ggtext')
library(ggtext)

# Gráfico de Precipitação
gr1 <-
  MACAE2 %>%
  group_by(Data) %>%
  mutate(Chuva_acum = cumsum(`Chuva (mm)`)) %>%   # Calcular a precipitação acumulada diária.
  ggplot(aes(x = Data_Hora)) +
  geom_col(aes(y = `Chuva (mm)`, 
               fill = "Taxa de Precipitação (mm)")) +
  scale_fill_manual(values = "steelblue") +
  geom_line(aes(y = Chuva_acum, color = "Precipitação Acumulada Diária (mm)"), 
            linewidth = 1) +
  scale_color_manual(values = "red3") +
  scale_x_datetime(breaks = "1 day", 
                   date_labels = "%d/%m") +
  labs(x = "", y = "Precipitação (mm)", 
       title = "Precipitação: <span style='color:#4682B4;'>Taxa Precipitação(mm)</span>; <span style='color:#CD0000;'>Acumulada Diária (mm)</span>", 
       color = "", fill = "") +
  theme_minimal() +
  theme(
    plot.title = element_markdown(),
    legend.position = "bottom",
    axis.text.x = element_text(size = 9, angle = 90))
gr1

# Gráfico de Temperatura

# Primeiro vamos pivotar os dados para agrupar os valores de temperatura (Max., Min. e Ins.) em uma única coluna.
MACAE3 <- 
  MACAE2 %>% 
  select(Data_Hora:`Temp. Min. (C)`) %>%             # Selecionando as colunas da "Data_Hora" até "Temp. Min. (C)".
  pivot_longer(`Temp. Ins. (C)`:`Temp. Min. (C)`,    # Pivotando os dados.
               names_to = "Var", 
               values_to = "Temp") %>% 
  print()

gr2 <-
  MACAE3 %>%
  ggplot() +
  aes(x = Data_Hora, y = Temp, color = Var)+
  geom_line(linewidth = 1) +
  scale_color_manual(values = c("red3", "orange3" ,"steelblue")) +
  scale_x_datetime(breaks = "1 day", 
                   date_labels = "%d/%m") +
  labs(x = "", y = "Temperatura (ºC)", 
       title = "Temperatura: <span style='color:#cd0000;'>Máx (ºC)</span>, <span style='color:#cd8500;'>Ins (ºC)</span>, <span style='color:#4682b4;'>Min (ºC)</span>", color = "") +
  theme_minimal() +
  theme(
    plot.title = element_markdown(),
    legend.position = "bottom",
    axis.text.x = element_text(size = 9, angle = 90))
gr2

## A função `ggsave()` permite salvar gráficos criados em arquivos externos em
## diversos formatos, como PNG, JPEG, PDF, SVG e outros.

ggsave(plot = gr2, 
       filename = 'Temp.png',
       width = 9, height = 5, units = 'in', bg = '#FCF9F7')

#------------------------https://linktr.ee/pexcca.lamet------------------------#
