#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 15/12/2023                        #
#==============================================================================#

#                            ESTATÍSTICA BÁSICA NO R                           #

#------------------------------------------------------------------------------#
###  TÓPICOS QUE SERÃO ABORDADOS:
# 1. Introdução e conceitos básicos;
# 2. Importação e organização dos dados;
# 3. Estatística descritiva;
# 4. Probabilidade e testes de hipóteses;
# 5. Visualização e exportação dos resultados.

# 1. Introdução e conceitos básicos ----

# A estatística básica consiste na coleta, organização, análise, interpretação e 
# apresentação de dados. Inclui cálculos como média aritmética e frequência absoluta, 
# além de medidas dispersão, variabilidade e medidas de tendência central.

# Após a coleta dos dados, o passo seguinte é a sua organização. Para organização, 
# exploração e visualização de dados, vamos usar o 'tidyverse', que é uma coletânea 
# de pacotes da linguagem R construídos para a ciência de dados. Todos os pacotes 
# compartilham uma mesma filosofia de design, gramática e estrutura de dados, facilitando a programação.

# Instalando e carregando o 'tidyverse':
if (!require('tidyverse')) install.packages('tidyverse')
library(tidyverse)

# Carregar o 'tidyverse' é o mesmo que carregar os seguintes pacotes:
# 'tibble': para data frames repaginados;
# 'readr': para importarmos bases para o R;
# 'tidyr' e dplyr: para arrumação e manipulação de dados;
# 'stringr': para trabalharmos com textos;
# 'forcats': para trabalharmos com fatores;
# 'ggplot2': para visualização de dados;
# 'purrr': para programação funcional.

## Neste minicurso vamos usar o operador pipe '%>%' para o encadeamento de funções.
## O operador pipe '%>%' foi introduzido pelo pacote 'magrittr' e pouco tempo depois 
## foi incorporado ao `dplyr`, onde segue como parte do `tidyverse`.

# 2. Importação e organização dos dados ----
# Vamos usar um conjunto de dados do Instituto Nacional de Meteorologia (INMET). 
# Esses dados podem ser baixados do site: https://bdmep.inmet.gov.br/

# Para facilitar a importação, disponibilizamos os dados no GitHub do PExCCA-UENF:
url_dados <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Estat%C3%ADstica%20B%C3%A1sica%20no%20R/dados_83698_M_1961-01-01_2023-11-30.csv'

## Esse arquivo possui dados mensais de variáveis meteorológicas do município de 
## Campos dos Goytacazes (RJ), para o período de janeiro de 1961 a novembro de 2023.

dados_campos <-
  readr::read_delim(
    file = url_dados,
    skip = 10, 
    na = 'null', 
    delim = ';', 
    col_names = T,
    locale = locale(decimal_mark = ',')) %>% 
  tidyr::separate(
    col = `Data Medicao`,
    into = c('Ano', 'Mes', 'Dia'),
    sep = '-', remove = F) %>% 
  dplyr::select(!'Dia' & !ends_with('7')) %>%   # Excluindo as colunas 'Dia' e a que termina com o prefixo 7.
  dplyr::rename(
    Data = `Data Medicao`,
    Prec = `PRECIPITACAO TOTAL, MENSAL(mm)`,
    Tmed = `TEMPERATURA MEDIA COMPENSADA, MENSAL(°C)`,
    Tmin = `TEMPERATURA MINIMA MEDIA, MENSAL(°C)`,
    Tmax = `TEMPERATURA MAXIMA MEDIA, MENSAL(°C)`,
    Vmed = `VENTO, VELOCIDADE MEDIA MENSAL(m/s)`) %>% 
  dplyr::mutate(
    Ano = as.numeric(Ano),
    Mes = as.numeric(Mes)
  ) %>% 
  print()

# Vamos verificar a natureza de cada variável do conjunto de dados:
dplyr::glimpse(dados_campos)

# Agora vamos calcular a porcentagem de NA (dados ausentes) por coluna/variável:
colSums(is.na(dados_campos))*100/nrow(dados_campos)

# 3. Estatísticas descritivas básicas ----

## Algumas estatísticas descritivas podem ser obtidas com a função summary() do R base:
summary(dados_campos)

## Podemos usar as funções by() e tapply() do R base para agrupar os dados de acordo  
# com uma variável a partir de uma função:
dados_campos$Tmed %>%                # Variável a ser aplicada a função.
  by(INDICES = dados_campos$Ano,     # Fator/categoria para agrupar os dados.
     FUN = summary)                  # A função a ser aplicada.

dados_campos$Tmed %>%                # Variável a ser aplicada a função.
  tapply(INDEX = dados_campos$Ano,   # Fator/categoria para agrupar os dados.
         FUN = summary)              # A função a ser aplicada.

## Medidas de tendência central: média, mediana e moda.
## Média aritmética: soma de todos os elementos dividida pela quantidade deles.
dados_campos$Tmed %>% 
  mean(na.rm = TRUE)

# Nota: Se existir dados ausentes (NA) no conjunto de dados, ao calcular estatísticas descritivas, 
# o resultado será NA. Para realizar o cálculo, precisamos definir na.rm = TRUE.

## Mediana: valor que separa os dados em duas partes iguais.
## 50% dos dados estão abaixo da mediana e 50% acima.
dados_campos$Tmed %>% 
  median(na.rm = TRUE)

## Moda: é o valor de maior ocorrência dentre os valores observados.
Tmed_cont <- 
  dados_campos$Tmed %>% 
  table() %>%                # Tabela com a contagem de cada item.
  print()

names(Tmed_cont)[Tmed_cont == max(Tmed_cont)]  # Valores da variável com a maior ocorrência. 

## Medidas de Posição (Quantis ou Separatrizes).
# Assim como a mediana, existem outras medidas que separam os dados em partes iguais, 
# denominados genericamente de quantis.

# Os quantis mais usados são:
# Quartis: dividem os dados em 4 partes (cada parte tem 25% dos dados).
dados_campos$Tmed %>% 
  quantile(na.rm = TRUE)

# Decis: dividem os dados em 10 partes iguais (cada parte tem 10% dos dados).
dados_campos$Tmed %>% 
  quantile(probs = seq(from = 0, to = 1, by = 0.1), 
           na.rm = TRUE)

# Percentis: dividem os dados em 100 partes iguais (cada parte tem 1% dos dados).
dados_campos$Tmed %>% 
  quantile(probs = seq(from = 0, to = 1, by = 0.01), 
           na.rm = TRUE)

dados_campos$Tmed %>% 
  quantile(probs = 0.95, 
           na.rm = TRUE)

## Medidas de dispersão: variância, desvio-padrão e coeficiente de variação.
## Variância: é a soma dos desvios quadrados da média dividida pelo tamanho da amostra (menos um).

## Como utilizamos a soma dos desvios quadráticos, esta terá unidade de medida quadrática, 
## o que pode ser de difícil interpretação.
dados_campos$Tmed %>% 
  var(na.rm = TRUE)

## Desvio padrão: é a raiz quadrada da variância.
## O desvio-padrão demonstra a distância dos valores em relação à média dos dados,
## quanto mais próximo de 0 for o desvio-padrão, menos dispersos são os dados.
dados_campos$Tmed %>% 
  sd(na.rm = TRUE)

## Coeficiente de variação (CV): fornece uma medida relativa da variabilidade dos dados 
## em relação à média, permitindo comparações entre diferentes conjuntos de dados. 
##  Quanto menor for o seu valor, mais homogêneos serão os dados.

## Não há funções nativas do R para realizar o cálculo do CV. 
## Vamos criar uma função para realizar o cálculo:
cv <- 
  function(x){
    coeficiente <- ( sd(x, na.rm = T)/mean(x, na.rm = T) ) * 100
    return(coeficiente)
  }

cv(dados_campos$Tmed)

## O coeficiente de variação é dado em %, por isso a fórmula é multiplicada por 100.
## O fato do coeficiente de variação ser dado em termos relativos nos permite comparar
## séries de valores que apresentam unidades de medida distintas.

## Agora, vamos calcular as medidas descritivas usando a função summarise() do pacote 'dplyr' (da coleção 'tidyverse').
## A função summarise() agrega sumarizações unindo diversos cálculos ao longo de uma base de dados.

## Calculando a média (mean):
dados_campos %>% 
  dplyr::summarise(Tmed_média = mean(Tmed, na.rm = T))

## Se na.rm é TRUE, a função ignora os NA. Se na.rm é FALSE, ele retorna NA no cálculo feito. 

dados_campos %>% 
  dplyr::summarise(Tmed_média = mean(Tmed, na.rm = T),
            Tmax_média = mean(Tmax, na.rm = T),
            Tmin_média = mean(Tmin, na.rm = T))

## Use a função across() com a função summarise() para facilitar a execução da mesma operação em várias colunas.
dados_campos %>% 
  dplyr::summarise(across(
    .cols = 4:6,             # Selecionando as colunas 4 a 6.
    .fns = sd, na.rm = T))

# Com o auxílio do comando groupy_by() podemos ainda agrupar os dados para a sumarização.
dados_campos %>% 
  dplyr::group_by(Mes) %>%
  dplyr::summarise(across(
    .cols = 3:5,
    .fns = median, na.rm = T)) 

# Calculando a média (mean), mediana (median) e desvio padrão (sd) das variáveis: Tmax, Tmed e Tmin.
Temp_md <- 
  dados_campos %>% 
  dplyr::group_by(Mes) %>%
  dplyr::summarise(across(
    .cols = 3:5, 
    .fns = list(Média = mean, 
                Mediana = median,
                DP = sd), na.rm = T))
View(Temp_md)

# 4. Probabilidade e testes de hipóteses ----

## Probabilidade é um ramo da Matemática em que as chances de ocorrência de experimentos 
## são calculadas, permitindo avaliar a incerteza associada aos resultados de um 
## experimento ou de uma amostra de dados.
.
## Já os testes de hipóteses são ferramentas estatísticas usadas para tomar decisões 
## sobre as características de uma população com base em amostras dos dados de uma população.

## Uma hipótese estatística é uma suposição ou afirmação que pode ou não ser verdadeira, 
## relativa a uma ou mais populações. 

## Os testes de hipóteses envolvem a formulação de uma hipótese nula (H0), que 
## geralmente assume que não há efeito, diferença ou relação entre variáveis, e uma 
## hipótese alternativa (H1), que contradiz a hipótese nula (H0).

## A probabilidade entra nos testes de hipóteses ao calcular a probabilidade de observar 
## os resultados da amostra, assumindo que a hipótese nula (H0) é verdadeira, ou seja, 
## é a probabilidade de rejeição da hipótese nula (H0) quando ela é verdadeira.
## Essa probabilidade é chamada de valor-p. O valor-p ajuda a tomar decisões estatísticas 
## sobre rejeitar ou não a hipótese nula (H0) e, por extensão, se aceitamos ou não a hipótese alternativa.

## Antes de encontrarmos o valor-p precisamos definir o nível de significância, que
## é uma medida do grau de certeza que queremos ter de nossos resultados.
## Valores baixos de significância correspondem a uma baixa probabilidade de que 
## os resultados experimentais ocorreram por acaso e vice-versa. 
## O nível de significância mais comumente utilizado é o de 5% (0,05).

# Teste de Shapiro–Wilk: teste de normalidade ----

## Hipóteses do teste:
##  H0 (hipótese nula): os dados seguem uma distribuição normal.
##  H1 (hipótese alternativa): os dados não seguem uma distribuição normal.

## Aplicando o teste de Shapiro-Wilk para verificar se a variável 'Tmed' segue uma distribuição normal:
shapiro_test <- 
  stats::shapiro.test(dados_campos$Tmed) %>%
  print()

## Quando o valor-p é menor ou igual ao nível de significância, você deve rejeitar a hipótese nula e vice-versa. 

# Teste t de Student: teste de Médias ----

## Hipótese do teste:
##  H0 (hipótese nula): Não há diferença entre as médias dos grupos.
##  H1 (hipótese alternativa): Há diferença entre as médias dos grupos.

## Há três principais tipos de testes-t: 
##  Teste-t para uma amostra: Compara a média de uma amostra com uma média padrão ou já conhecida.
##  Teste-t para duas amostras independentes: Compara as médias de duas amostras independentes.
##  Teste-t para duas amostras pareadas: Compara as médias de duas amostras dependentes.  

## Nota: ## Os dados são independentes quando o valor de uma observação não influencia ou afeta o valor de outras observações.

## O teste t de Student assume os seguintes pressupostos com relação aos dados:
## - Normalidade;
## - Homocedasticidade (homogeneidade de variância);

## Nota: Se o pressuposto da normalidade não for atendido, o teste adequado para ser
## aplicado é um não-paramétrico como, por exemplo, o test de Wilcoxon.

## Exemplo: 
## Preparando o conjunto de dados: vamos calcular as médias anuais da variáveis 'Tmin' e 'Tmax'.
Tmin_anual <- 
  dados_campos %>% 
  group_by(Ano) %>%
  summarise(Tmin_a = mean(Tmin, na.rm = T)) %>% 
  print()

Tmax_anual <- 
  dados_campos %>% 
  group_by(Ano) %>%
  summarise(Tmax_a = mean(Tmax, na.rm = T)) %>% 
  print()

## Avaliando os pressupostos do teste-t: Teste de Normalidade.
Tmin_anual$Tmin_a %>% 
  stats::shapiro.test()

Tmax_anual$Tmax_a %>% 
  stats::shapiro.test()

## Avaliando os pressupostos do teste-t: Homocedasticidade.
## Hipótese do teste:
##  H0 (hipótese nula): as variâncias são iguais.
##  H1 (hipótese alternativa): as variâncias não são iguais.

stats::var.test(x = Tmin_anual$Tmin_a,
                y = Tmax_anual$Tmax_a)

## Aplicação do teste-t para duas amostras independentes:
stats::t.test(x = Tmin_anual$Tmin_a, 
       y = Tmax_anual$Tmax_a,
       paired = F,
       var.equal = T, )

# Correlação Linear ----
## Correlação: é uma medida que permite mensurar a relação entre duas variáveis.

## Para calcular o coeficiente de correlação de Pearson podemos usar a função cor():
stats::cor(
  x = Tmin_anual$Tmin_a, 
  y = Tmax_anual$Tmax_a,
  method = 'pearson')         #c('pearson', 'kendall', 'spearman')

## O Coeficiente de correlação de Pearson (r) é uma medida adimensional que pode 
## assumir valores entre -1 e +1. Quanto mais próximo dos extremos (-1 e +1) mais 
## forte é a correlação. Quanto mais próximo de zero, mas fraca é a correlação linear.
## Correlação positiva (r>0) indica que uma variável tende a aumentar quando a outra aumenta.
## Correlação negativa (r<0) indica que uma variável tende a diminuir quando a outra aumenta.

## Agora, para determinar se a correlação é estatisticamente significativa, podemos 
## realizar um teste de hipótese.

## Hipótese do teste:
##  H0 (hipótese nula): a correlação entre as variáveis é igual a zero.
##  H1 (hipótese alternativa): a correlação entre as variáveis não é igual a zero.

stats::cor.test(
  x = Tmin_anual$Tmin_a, 
  y = Tmax_anual$Tmax_a,
  method = 'pearson',
  conf.level = 0.95) 

## Matrizes de Correlação ---
## Podemos gerar matrizes de correlação com múltiplas variáveis para uma análise exploratória.

cor.dados <- 
  stats::cor(dados_campos[, 4:8],
      use = 'complete.obs',   # use = 'complete.obs': removendo todos os casos com valores omissos (dados ausentes).
      method = 'pearson') %>%
  print()

# Visualização de uma matriz de correlação.
# O pacote 'ggcorrplot' pode ser usado para visualizar uma matriz de correlação usando 'ggplot2'.

# Instalando e carregando o pacote 'ggcorrplot':
if (!require('ggcorrplot')) install.packages('ggcorrplot')
library(ggcorrplot)

ggcorrplot::ggcorrplot(cor.dados)

ggcorrplot::ggcorrplot(cor.dados,
           method = 'circle',   # Alterando o método de visualização da matriz de correlação.
           type = 'lower')      # Exibição da parte inferior da matriz.

# Adicionando p-valores e ordenando com base na semelhança.
# A função cor_pmat() Calcula os valores p de uma matriz de correlação.

co_p <- 
  ggcorrplot::cor_pmat(dados_campos[, 4:8], 
             use = 'complete.obs') %>% 
  print()

ggcorrplot::ggcorrplot(cor.dados,
                       method = 'circle',
                       type = 'lower',
                       hc.order = TRUE,  # Se TRUE, a matriz de correlação será ordenada usando a função hclust.
                       p.mat = co_p,     # Matriz de p-valor.
                       colors = c('gold2', 'white', 'blue2'),  # Vetor de 3 cores para valores de correlação baixo, médio e alto.
                       lab = TRUE)       # Se TRUE, adicione o coeficiente de correlação no gráfico.      

# Teste de Mann Kendall ----
# Hipóteses do teste
# H0 (hipótese nula):  Não há tendência presente nos dados.
# H1 (hipótese alternativa):  Há tendência nos dados. A tendência pode ser positiva ou negativa.

# Instalando e carregando o pacote 'trend':
if (!require('trend')) install.packages('trend')
library(trend)

# Vamos usar a função mk.test() do pacote trend:
MannKendall <- 
  trend::mk.test(dados_anual$Tmin_M) %>%
  print()

## Quando o valor-p é menor ou igual ao nível de significância, você deve rejeitar a hipótese nula e vice-versa. 

# Estimator de Sen: para estimar a magnitude da tendência. 
TendSen <-
  trend::sens.slope(dados_anual$Tmin_M, 
             conf.level = 0.95) %>%
  print()

## Teste de Pettitt: para identificar se há mudança brusca nos dados, ou seja, um ponto de descontinuidade na série.

## Hipóteses do teste
## H0: Não há mundança (um ponto de descontinuidade) na série.
## H1: Há mundança (um ponto de descontinuidade) da série.

# Verificando quebra estrutura na série temporal:
Pett.Tmin <- 
  trend::pettitt.test(dados_anual$Tmin_M) %>%
  print()

## Observando em que ano se encontra a quebra estrutural:
dados_anual$Ano[Pett.Tmin$estimate] 

# 5. Visualização e exportação dos resultados ----

## Gráfico de linha da temperatura mínima média anual----
gr_st <-
  ggplot(
    data = dados_anual, 
    mapping = aes(x = Ano, y = Tmin_M)
  ) +
  geom_line(color = 'steelblue') +
  geom_point(
    size = 1.5, 
    shape = 21, fill = 'white',
    color = 'red3')
gr_st

## Inserindo no gráfico a linha de tendência (reta de regressão linear) e a equação da reta.

# Instalando e carregando o pacote 'ggpmisc':
if (!require('ggpmisc')) install.packages('ggpmisc')
library(ggpmisc)

gr_st2 <-
  gr_st +
  geom_smooth(
    method = 'lm',  # Para method = lm estamos definindo que queremos uma reta de regressão linear. 
    alpha = 0.2, 
    color = rgb(r = 0.8, g = 0, b = 0, alpha = 0.6)
  ) +
  ggpmisc::stat_poly_eq(
    mapping = 
      aes(
        label = 
          paste(
            after_stat(eq.label), 
            after_stat(rr.label),
            sep = '*\'; \'*'
          )
      ),
    label.x = 0.05, label.y = 0.95
  )
gr_st2

# ---
gr_st_f <-
  gr_st2 +
  labs(x = 'Ano', y = 'Temperatura (°C)', caption = 'Elaborado por @proamb.r',
       title = 'Temperatura Mínima Média Anual de Campos - RJ') +
  theme_light()
gr_st_f

# Histograma ----
## Histograma sumariza uma variável a dividindo em intervalos e contando quantas
## observações estão presentes em cada intervalo.

gr_hist <-
  ggplot(
    data = dados_campos,
    mapping = aes(x = Tmed)
  ) +
  geom_histogram(
    fill = 'steelblue',
    color = 'black'
  ) +
  geom_boxplot(
    mapping = aes(y = -2), width = 1.4, 
    fill = 'steelblue')
gr_hist

# ---
shapiro.test(dados_campos$Tmed)

gr_hist2 <-
  gr_hist +
  geom_vline(xintercept = mean(dados_campos$Tmed, na.rm = T),
             color = 'red3', alpha = 0.3, linetype = 'dashed') +
  geom_text(
    aes(
      x = 21, y = 44, 
      label = 'Shapiro-Wilk (W = 0.972; p-valor = 1e-09)')
  ) 
gr_hist2

# ---
gr_hist_f <-
  gr_hist2 +
  labs(x = 'Temperatura (°C)', y = 'Frequência',
       caption = 'Elaborado por ...', 
       title = 'Histograma da Temperatura Média de Campos - RJ') + 
  theme_light()
gr_hist_f

# Boxplot ----
## O boxplot é um gráfico utilizado para avaliar a distribuição dos dados.

gr_boxplot <-
  ggplot(
    data = dados_campos,
    aes(x = Mes, y = Tmed, group = Mes)) +
  geom_boxplot(fill = 'steelblue', color = 'navy')
gr_boxplot

#---
gr_boxplot_f <-
  gr_boxplot +
  scale_x_continuous(
    breaks = 1:12,
    labels = c('Jan', 'Fev', 'Mar',
               'Abr', 'Mai', 'Jun',
               'Jul', 'Ago', 'Set',
               'Out', 'Nov', 'Dez')) +
  labs(x = 'Meses', y = 'Temperatura (°C)',
       title = 'Temperaturas Mensais de Campos-RJ',
       caption = 'Elaborado por @proamb.r') +
  theme_light()
gr_boxplot_f

# Barras de Médias com Desvio Padrão ----

dados_t_sum <-
  dados_campos %>%
  group_by(Mes) %>%
  summarise(
    me = mean(Tmed, na.rm = T),
    sd = sd(Tmed, na.rm = T)
  )

gr_barras <-
  ggplot(data = dados_t_sum,
         aes(x = Mes, y = me, 
             ymin = me-sd, ymax = me+sd)) +
  geom_col(fill = "steelblue", width = 0.7) +
  geom_errorbar(width = 0.2)
gr_barras

# ---
gr_barras_f <-
  gr_barras +
  scale_x_continuous(
    breaks = 1:12,
    labels = c('Jan', 'Fev', 'Mar',
               'Abr', 'Mai', 'Jun',
               'Jul', 'Ago', 'Set',
               'Out', 'Nov', 'Dez'))+
  labs(x = "Meses", y = "Temperatura (°C)",
       caption = "Elaborado por @proamb.r",
       title = "Temperatura Média Mensal de Campos-RJ")+
  theme_light()
gr_barras_f

# Salvando Gráficos ----

ggsave(filename = 'plot1.png',
       plot = gr_st_f,
       device = 'png',
       width = 2000, height = 1000,
       units = 'px')

ggsave(filename = 'plot2.png',
       plot = gr_hist_f,
       device = 'png',
       width = 2000, height = 1000,
       units = 'px')

ggsave(filename = 'plot3.png',
       plot = gr_boxplot_f,
       device = 'png',
       width = 2000, height = 1000,
       units = 'px')

ggsave(filename = 'plot4.png',
       plot = gr_barras_f,
       device = 'png',
       width = 2000, height = 1000,
       units = 'px')

#------------------------https://linktr.ee/pexcca.lamet------------------------#
