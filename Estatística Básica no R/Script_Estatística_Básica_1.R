#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 22/07/2024                        #
#==============================================================================#

#                            ESTATÍSTICA BÁSICA NO R                           #

# 1. INTRODUÇÃO----------------------------------------------------------------#

# A estatística básica consiste em técnicas que são usadas para coleta, organização,
# análise, interpretação e apresentação de dados. Ela inclui cálculos como média aritmética 
# e frequência absoluta, além de medidas dispersão, variabilidade e medidas de tendência central.

# Após a coleta dos dados, o passo seguinte é a sua organização. Para organização,
# exploração e visualização de dados, vamos usar o 'tidyverse', que é uma coletânea
# de pacotes da linguagem R construídos para a ciência de dados. Todos os pacotes
# compartilham uma mesma filosofia de design, gramática e estrutura de dados,
# facilitando a programação.

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

## Neste minicurso vamos usar o operador pipe nativo `|>` para o encadeamento de 
# funções, que está disponível a partir da versão 4.1 do R. 

## Para ativar o atalho Ctrl + Shift + M para o operador pipe nativo (|>), no Windows,
## basta irmos no menu Tools → Global Options → Code e ativar a caixa 'Use native pipe operator, |> (requires R.4.1+)'.

# 2. IMPORTAÇÃO E ORGANIZAÇÃO DOS DADOS----------------------------------------#
# Vamos usar um conjunto de dados do Instituto Nacional de Meteorologia (INMET).
# Esses dados podem ser baixados do site: https://bdmep.inmet.gov.br/

# Para facilitar a importação, disponibilizamos os dados no GitHub do PExCCA-UENF:
url_dados <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Estat%C3%ADstica%20B%C3%A1sica%20no%20R/dados_83587_D_1990-01-01_2020-12-31.csv'

# Esse arquivo possui dados diários de variáveis meteorológicas de Belo Horizonte-MG,
# para o período de Janeiro de 1991 a Dezembro de 2020.

dados <-
  read_delim(
    file = url_dados,
    skip = 10,
    na = 'null',
    delim = ';',
    col_names = T,
    locale = locale(decimal_mark = ',')) |> 
  rename(
    Data = `Data Medicao`,
    Evap = `EVAPORACAO DO PICHE, DIARIA(mm)`,
    Inso = `INSOLACAO TOTAL, DIARIO(h)`,
    Prec = `PRECIPITACAO TOTAL, DIARIO(mm)`,
    Tmax = `TEMPERATURA MAXIMA, DIARIA(°C)`,
    Tmed = `TEMPERATURA MEDIA COMPENSADA, DIARIA(°C)`,
    Tmin = `TEMPERATURA MINIMA, DIARIA(°C)`,
    UmMe = `UMIDADE RELATIVA DO AR, MEDIA DIARIA(%)`,
    UmMi = `UMIDADE RELATIVA DO AR, MINIMA DIARIA(%)`,
    Vmed = `VENTO, VELOCIDADE MEDIA DIARIA(m/s)`,
    Arte = `...11`) |> 
  separate(
    col = Data,
    into = c('Ano', 'Mes', 'Dia'),
    sep = '-', remove = F) |> 
  mutate(
    Dia = as.numeric(Dia),
    Mes = as.numeric(Mes),
    Ano = as.numeric(Ano),
    Inso = NULL,
    Arte = NULL 
  ) |> 
  print()

# Vamos verificar a natureza de cada variável do conjunto de dados:
dplyr::glimpse(dados)

# 3. MEDIDAS DE TENDÊNCIA CENTRAL, SEPARATRIZES E DISPERSÃO--------------------#

# A linguagem R possui uma série de funções já construídas para cálculo de estatísticas
# descritivas básicas. Abaixo listamos alguns pontos de destaque:
# mean()      Retorna a média.
# median()    Retorna a mediana.
# min()       Retorna o mínimo.
# max()       Retorna o máximo.
# range()     Retorna o mínimo e o máximo.
# quantile()  Retorna os quantis teóricos.
# IQR()       Intervalo interquartil
# sd()        Retorna o desvio padrão.
# var()       Retorna a variância.
# sum()       Retorna o somatório de um vetor
# length()    Retorna o tamanho de um vetor
# summary()   Retorna um sumário geral dos dados

# A operação com tais funções é simples, devemos apenas informar o vetor de dados 
# que desejamos calcular a operação.

## 3.1 Medidas de tendência central: média, mediana e moda ----

# Média aritmética: soma de todos os elementos dividida pela quantidade deles.
dados |> 
  pull(Tmed) |> 
  mean(na.rm = TRUE)

# Nota: Se existir dados ausentes (NA) no conjunto de dados, ao calcular estatísticas 
# descritivas, # o resultado será NA. Para realizar o cálculo, precisamos definir na.rm = TRUE.

# Mediana: valor que separa os dados em duas partes iguais.
# 50% dos dados estão abaixo da mediana e 50% acima.
dados |> 
  pull(Tmed) |> 
  median(na.rm = TRUE)

# Moda: é o valor de maior ocorrência dentre os valores observados.
Tmed_cont <-
  dados |> 
  pull(Tmed) |> 
  table() |>                 # Tabela com a contagem de cada item.
  print()

names(Tmed_cont)[Tmed_cont == max(Tmed_cont)]  # Valores da variável com a maior ocorrência.

## 3.2 Medidas de posição (Quantis ou Separatrizes) ----

# Assim como a mediana, existem outras medidas que separam os dados em partes iguais,
# denominados genericamente de quantis.

# Os quantis mais usados são:
# Quartis: dividem os dados em 4 partes (cada parte tem 25% dos dados).
dados |> 
  pull(Tmed) |> 
  quantile(na.rm = TRUE)

# Decis: dividem os dados em 10 partes iguais (cada parte tem 10% dos dados).
dados |> 
  pull(Tmed) |> 
  quantile(probs = seq(from = 0, to = 1, by = 0.1),
           na.rm = TRUE)

# Percentis: dividem os dados em 100 partes iguais (cada parte tem 1% dos dados).
dados |> 
  pull(Tmed) |> 
  quantile(probs = seq(from = 0, to = 1, by = 0.01),
           na.rm = TRUE)

dados |> 
  pull(Tmed) |> 
  quantile(probs = 0.95,
           na.rm = TRUE)

## 3.3 Medidas de dispersão: variância, desvio-padrão e coeficiente de variação. ----

# Variância: é a soma dos desvios quadrados da média dividida pelo tamanho da amostra (menos um).

# Como utilizamos a soma dos desvios quadráticos, esta terá unidade de medida quadrática,
# o que pode ser de difícil interpretação.
dados |> 
  pull(Tmed) |> 
  var(na.rm = TRUE)

# Desvio padrão: é a raiz quadrada da variância.
# O desvio-padrão demonstra a distância dos valores em relação à média dos dados,
# quanto mais próximo de 0 for o desvio-padrão, menos dispersos são os dados.
dados |> 
  pull(Tmed) |> 
  sd(na.rm = TRUE)

# Coeficiente de variação (CV): fornece uma medida relativa da variabilidade dos dados
# em relação à média, permitindo comparações entre diferentes conjuntos de dados.
#  Quanto menor for o seu valor, mais homogêneos serão os dados.

# Não há funções nativas do R para realizar o cálculo do CV.
# Vamos criar uma função para realizar o cálculo:
cv <-
  function(x, na.rm = F){
    desvio <- sd(x, na.rm = na.rm)
    media <- mean(x, na.rm = na.rm)
    
    coeficiente <- (desvio / media) * 100
    
    return(coeficiente)
  }

dados |> 
  pull(Tmed) |> 
  cv(na.rm = T)

## O coeficiente de variação é dado em %, por isso a fórmula é multiplicada por 100.
## O fato do coeficiente de variação ser dado em termos relativos nos permite comparar
## séries de valores que apresentam unidades de medida distintas.

## Importante: Porcentagem de NAs ----

# Note que em todos os exemplos até agora, acrescentamos "na.rm = T" às funções estatísticas.
# Neste sentido, pode ser interessante conhecer qual a porcentagem de NAs estão presentes
# em nossos dados. Para isso, podemos criar uma função para realizar o cálculo.

pna <-
  function(x){
    Soma_NAs <- sum( is.na(x) )
    N <- length(x)
    
    Resultado <- (Soma_NAs / N ) * 100
    
    return(Resultado)
  }

dados |> 
  pull(Tmed) |> 
  pna()

## 3.4 Cálculo de estatísticas simultâneas e agrupadas ----

# Até o momento, realizamos apenas cálculos das estatísticas de interesse individualmente.
# Contudo, por vezes, pode ser interessante aplicar mais de um cálculo simultâneo. Para isso,
# podemos utilizar as funções dos pacotes do 'tidyverse'. O pacote 'dplyr' possui uma função
# construída justamente para essas operações: a função 'summarise()'!

# Sintaxe da função:
# dados |> 
# summarise(NOME_ESTATÍSTICA = FUNÇÃO)

# Exemplo:
dados |> 
  summarise(
    Média = mean(Tmed, na.rm = T)
  )

# Múltiplos   cálculos simultâneos:
dados |> 
  summarise(
    Média = mean(Tmed, na.rm = T),
    DesvioPad = sd(Tmed, na.rm = T),
    CoefVar = cv(Tmed, na.rm = T)
  )

# Um segundo caso de interesse é aplicar múltiplos cálculos simultâneos, contudo, agrupando
# os dados. Para isso, podemos adicionar ao 'pipeline' a função group_by() e informar uma
# variável categórica de agrupamento.

dados |> 
  group_by(Ano) |> 
  summarise(
    Média = mean(Tmed, na.rm = T)
  )

# # Podemos ainda, aplicar múltiplos agrupamentos simultâneos.

dados |> 
  group_by(Ano, Mes) |> 
  summarise(
    Média = mean(Tmed, na.rm = T)
  )

# Avançando no processo de manipulação, podemos ainda aplicar as estatísticas em
# multiplas variáveis.

dados |> 
  summarise(
    Média_Tmin = mean(Tmin, na.rm = T),
    Média_Tmed = mean(Tmed, na.rm = T),
    Média_Tmax = mean(Tmax, na.rm = T),
  )

# Contudo, para realizar essa operação, precisamos escrever  múltiplas linhas.
# Para simplificar o processo, podemos usar a função 'across()'do 'dplyr'.

dados |> 
  summarise(
    across(
      .cols = c(Tmin, Tmed, Tmax),
      .fns = mean,
      na.rm = T
    )
  )

# Podemos ainda fornecer  múltiplas estatísticas para serem agrupadas, para isso, 
# basta fornecer uma lista de funções no argumento '.fns'.

dados |> 
  summarise(
    across(
      .cols = c(Tmin, Tmed, Tmax),
      .fns = list(media = mean, desvio = sd),
      na.rm = T
    )
  )

## Desafio: Calcule estatísticas ----

# Utilizando as funções de cálculo de estatísticas silmultâneas e agrupadas, compute
# as seguintes estatísticas mensais:
# -- A) Acumulado de Precipitação;
# -- B) Média e Mediana para Evap e UmMe;
# -- C) Desvio Padrão e Coeficiente de Variação para Evap e UmMe;
# -- D) Separatrizes de 05%, 25%, 75% e 95% para Evap e UmMe; (Essa tem um detalhe extra)

# 4. DISTRIBUIÇÃO DE FREQUÊNCIAS ----------------------------------------------#

# A distribuição de frequência é uma técnica descritiva que organiza dados de forma
# sistemática para facilitar a análise estatística. Ela permite uma visualização clara da
# distribuição dos valores de uma variável, revelando padrões que não seriam visíveis
# apenas olhando para os dados brutos.

# Escolha adequada do número de intervalos (classes)

# A escolha do número de intervalos é crucial para uma representação adequada da
# distribuição dos dados. Muitos intervalos podem resultar em uma tabela muito detalhada,
# dificultando a interpretação, enquanto poucos intervalos podem obscurecer a
# distribuição real dos dados. Métodos como regras de Sturges podem ser usados
# para determinar o número ideal de classes com base no tamanho da amostra.

## 4.1 Utilizando N intervalos ----

intervalos <-
  dados |> 
  pull(Tmed) |> 
  cut(breaks = 15)

(tabelaFreq <-
  table(intervalos))

(tabelaFreqRel <-
  table(intervalos) / nrow(dados)  * 100)

# Visualizando a tabela de frequências através de um histograma
ggplot(
  data = dados,
  mapping = aes(x = Tmed)
) +
  geom_histogram(
    color = "black",
    fill = "steelblue",
    bins = 15
  )

## 4.2 Utilizando o método de Sturges ----

# O método de Sturges pode ser utilizado para encontrar o número de classes adequado
# para nossa distribuição. Abaixo ilustramos como aplicá-lo.

(k <- ceiling(1 + 3.322 * log10(nrow(dados))))

intervalos_sturges <-
  dados |> 
  pull(Tmed) |> 
  cut(breaks = k)

(tabelaFreq_sturges <-
  table(intervalos_sturges))

(tabelaFreq_tabelaFreqRel <-
  table(intervalos_sturges) / nrow(dados)  * 100)

# Visualizando a tabela de  frequências através de um histograma:

ggplot(
  data = dados,
  mapping = aes(x = Tmed)
) +
  geom_histogram(
    color = "black",
    fill = "steelblue",
    bins = k)

# 5. TESTES DE NORMALIDADE DE DADOS -------------------------------------------#

# Testes de normalidade são métodos estatísticos usados para determinar se um conjunto
# de dados segue uma distribuição normal (ou gaussiana). 

## Teste de Shapiro-Wilk:

# Um dos testes mais poderosos para pequenas amostras.
# Compara os dados observados com os esperados de uma distribuição normal.

## Hipóteses:
#  Hipótese nula:  os dados seguem uma distribuição normal.
#  Hipótese alternativa: os dados não seguem uma distribuição normal.

stats::shapiro.test(dados$Tmed) 

## Teste de Anderson-Darling:

# Compara a distribuição empírica de um conjunto de dados com uma distribuição 
# teórica, dando mais peso às extremidades da distribuição.
# Teste potente para detectar desvios da normalidade em grandes amostras.
# Hipóteses semelhantes ao teste de Shapiro-Wilk.

nortest::ad.test(dados$Tmed)

# Também podemos fazer a verificação gráfica:
ggplot(
  data = dados,
  mapping = aes(x = Tmed)
) +
  geom_density(
    color = "black",
    fill = "steelblue") +
  geom_function(fun = dnorm, 
                args = list(mean = mean(dados$Tmed, na.rm = T), 
                            sd = sd(dados$Tmed, na.rm = T)), 
                color = "darkred", lwd = 2)

