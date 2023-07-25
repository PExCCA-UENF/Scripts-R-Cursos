#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 25/07/2023                        #
#==============================================================================#

#                   MANIPULAÇÃO E VISUALIZAÇÃO DE DADOS NO R                   #
#                         PROGRAMANDO COM O TIDYVERSE                          #

#------------------------------------------------------------------------------#
# TÓPICOS ABORDADOS:
# ✓ Introdução;
# ✓ Projetos no RStudio (.RProj);
# ✓ Operador pipe (%>%);
# ✓ Manipulando dados com ‘dplyr’ e ‘tidyr’;
# ✓ Visualização gráfica com ‘ggplot2’;
# ✓ Extensões do ‘ggplot2’.

# 1. INTRODUÇÃO ---------------------------------------------------------------#
# A manipulação de dados é o processo de coleta, limpeza, processamento, seleção, 
# agregação e síntese dos dados.

# Em geral, a manipulação e a visualização de dados podem ser feita com o R base, 
# mas o 'tidyverse' facilita as tarefas de análise de dados, além de ter melhor 
# performance computacional. 

# O `tidyverse` é uma coleção de pacotes da linguagem R construídos para a ciência 
# de dados. Todos os pacotes compartilham uma mesma filosofia de design, gramática 
# e estrutura de dados, facilitando a programação.

# Neste curso, vamos usar os pacotes: ‘dplyr’, 'tidyr’ e ‘ggplot2’. 

### Nota: Recomendados a leitura do livro "R for Data Science" dos autores Hadley 
### Wickham e Garrett Grolemund, disponível em: r4ds.had.co.nz/.

# 2. PROJETOS NO RSTUDIO (.RPROJ)----------------------------------------------#
# Uma funcionalidade muito útil do RStudio é a possibilidade de criar projetos (Rproject).
# O Rproject nada mais é do que uma pasta no seu computador. Seu uso traz uma série 
# de benefícios na organização e reprodução de análises. 

# Alguns dos principais benefícios do Rproject:
# 1. Organização de arquivos: Você pode organizar todos os arquivos relacionados 
#    a um projeto em um único diretório, facilitando a localização e o gerenciamento
#    de scripts, dados, gráficos, relatórios e outros arquivos associados.

# 2. Independência de diretórios: Cada projeto R possui seu próprio diretório de
#    trabalho, o que significa que os caminhos para arquivos e pacotes são
#    relativos ao diretório do projeto. Isso evita conflitos entre projetos e
#    permite que você alterne facilmente entre projetos sem precisar reconfigurar
#    caminhos e configurações.

# 3. Controle de versão: Você pode integrar o projeto R com sistemas de controle 
#    de versão, como o Git, para rastrear alterações, colaborar com outros usuários 
#    e recuperar versões anteriores do código.

# 4. Facilidade de compartilhamento: Ao compartilhar um projeto R, você pode
#    incluir todos os arquivos e configurações necessários para que outras
#    pessoas reproduzam sua análise. Isso torna mais fácil colaborar em
#    projetos, compartilhar código e resultados, e garantir que todos estejam
#    trabalhando no mesmo contexto.

# 5. Automatização: Você pode automatizar tarefas e análises por meio de scripts
#    e funções. Isso permite que você crie fluxos de trabalho reprodutíveis e 
#    repetíveis, economizando tempo e minimizando erros.

# Em resumo, o uso de um projeto R ajuda na organização, reprodutibilidade,
# compartilhamento e controle de versão, tornando suas análises mais eficientes,
# colaborativas e confiáveis.

# 3. OPERADOR PIPE (%>%)-------------------------------------------------------#
# O operador pipe é uma das funcionalidades mais populares na comunidade R. 
# Ele foi introduzido pelo pacote 'magrittr', criado por Stefan Milton Bache e 
# Hadley Wickham. Pouco tempo depois foi incorporado ao `dplyr`, onde segue como 
# parte do `tidyverse`.

# O operador pipe do pacote 'magrittr' é representado por '%>%'. 
# A ideia principal é facilitar o processo de manipulação e transformação de dados, 
# proporcionando uma sintaxe fluida e orientada a ações através do encadeamento
# de funções, evitando a criação de objetos intermediários.

# Devido o grande sucesso do operador pipe, a equipe principal da linguagem R 
# implementou na linguagem uma versão do pipe nativo com a sintaxe '|>', que está
# disponível à partir da versão 4.1 do R. Apesar disso, neste curso vamos usar o `%>%`.

# A ideia do operador pipe é usar o valor resultante de uma expressão como 
# primeiro argumento da próxima função, possibilitando o encadeamento de funções.

# Atalho de teclado do pipe (%>%): Ctrl + Shift + M

# Exemplo 1: Calcule a raiz quadrada da soma dos valores de 1 a 9 com 2 casas decimais.

## Primeiro, sem o pipe:
x <- sqrt(sum(1:9))
round(x, digits = 2)

## Agora com o pipe.
1:9 %>% sum() %>% sqrt() %>% round(digits = 2)

# Exemplo 2: Fazer a importação dos arquivos que serão utilizados neste curso.
# Vamos usar dados do Instituto Nacional de Meteorologia (INMET), mas vamos baixar 
# os dados do GitHub do PExCCA-UENF:

url_A607 <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Manipula%C3%A7%C3%A3o%20e%20Visualiza%C3%A7%C3%A3o%20de%20Dados/dados_A607_D_2012-01-01_2022-12-31.csv'
url_A620 <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Manipula%C3%A7%C3%A3o%20e%20Visualiza%C3%A7%C3%A3o%20de%20Dados/dados_A620_D_2012-01-01_2022-12-31.csv'

## Para realizar a importação de maneira adequada, devemos conhecer os dados.
## O formato dos arquivos é CSV, utiliza como separador de colunas o ';' e como 
## separador decimal o ','. Também precisamos verificar se o arquivo tem cabeçalho 
## e identificar como os dados ausentes estão representados. Neses arquivos, 
## as 10 primeiras linhas correspondem ao cabeçalho e os valores ausentes estão 
## representados por 'null'. Assim, podemos usar a função `read_csv2` para realizar 
## a importação, configurando os argumentos 'skip' e 'na'.

## Vamos importar os dados da estação A607 sem o pipe:
dados_A607 <- read_csv2(url_A607, skip = 10, na = 'null')

## Agora vamos importar os dados da estação A620 com o pipe:
dados_A620 <- 
  url_A620 %>% 
  read_csv2(skip = 10, na = 'null')

## Esse arquivo possui dados diários de variáveis meteorológicas do município de 
## Campos dos Goytacazes (RJ), para o período de 2012 a 2022. 

# 4. MANIPULANDO DADOS COM ‘DPLYR’ E ‘TIDYR’-----------------------------------#

# install.packages('tidyverse')
library(tidyverse)

## Pacote `dplyr` -------------------------------------------------------------#
## O pacote 'dplyr' é uma parte fundamental do `tidyverse`. Ele nos oferece um
## conjunto de ferramentas para manipulação e transformação de dados de forma eficiente.

### Função `mutate()` ---
### A função `mutate()` permite criar novas colunas ou modificar existentes com
### base em expressões. Também pode servir para excluir colunas, basta atribuir
# NULL à coluna que deseja excluir.

est_1 <- 
  dados_A607 %>%
  mutate(Estação = 'A607', .before = 'Data Medicao', ...7 = NULL)
View(est_1)

est_2 <- 
  dados_A620 %>%
  mutate(Estação = 'A620', .before = 'Data Medicao', ...7 = NULL)
View(est_2)

### Função 'bind_rows()'---
### A função 'bind_rows()' permite unir dois conjuntos de dados, basta ter a mesma 
# quantidade de campos e que estejam “alinhados.” 

dados_campos <- bind_rows(est_1, est_2)
View(dados_campos)

### Função `rename()`---
### A função `rename()` permite modificar os nomes das colunas.

dados_campos <- 
  dados_campos %>%
  rename(Data = `Data Medicao`,
         Prec = `PRECIPITACAO TOTAL, DIARIO (AUT)(mm)`,
         Tmax = `TEMPERATURA MAXIMA, DIARIA (AUT)(°C)`,
         Tmed = `TEMPERATURA MEDIA, DIARIA (AUT)(°C)`,
         Tmin = `TEMPERATURA MINIMA, DIARIA (AUT)(°C)`,
         UR = `UMIDADE RELATIVA DO AR, MEDIA DIARIA (AUT)(%)`)
print(dados_campos)

### Função `filter()` ---
### A função `filter()` permite filtrar linhas com base em critérios lógicos e 
### outras funções. Exemplo: `==`, `>`, `<`, `!`, `|`,`is.na()`, `between(), etc.

dados_campos %>%
  filter(UR > 90)

dados_campos %>%
  filter(is.na(Prec))

dados_campos %>%
  filter(!is.na(Prec))

dados_campos %>%
  filter(between(Prec, 10, 20))

### Função `arrange()` ---
### A função `arrange()` permite ordenar as linhas de um conjunto de dados com 
### base em uma ou mais colunas. 

dados_campos %>%
  arrange(Tmax)

# Para inverter a ordem para decrescente, basta agrupar com `desc()`:
dados_campos %>%
  arrange(desc(Tmax))

### Função `select()` ---
### A função `select()` permite selecionar colunas específicas do conjunto de dados.
### Para operá-la, basta informar como primeiro argumento o objeto, e logo em
### seguida, as colunas que desejamos selecionar.

dados_prec <- 
  dados_campos %>%
  select(Estação, Data, Prec)
print(dados_prec)

dados_temp <- 
  dados_campos %>%
  select(Estação, Data, Tmax:Tmin)
print(dados_temp)

### Pareando `select()` com outras funções, podemos selecionar variáveis com base 
### em padrões presentes em seus nomes. Podemos usar, por exemplo, as funções:
### ✓'starts_with()': Começa com um prefixo exato.
### ✓'ends_with()': Termina com um prefixo exato.
### ✓'contains()': Contém uma string literal.

dados_campos %>%
  select(
    starts_with('Tm'),
  )

### Funções `separete()` e `unite()` ---
### As funções `separate()` e `unite()` permitem separar variáveis concatenadas 
### em uma única coluna ou uni-las, respectivamente.

### Vamos separar a coluna 'Data' em 'Ano', 'Mes', 'Dia':
prec_campos <- 
  dados_prec %>%
  separate(
    col = 'Data',
    into = c('Ano', 'Mes', 'Dia'),
    sep = '-'
  )
print(prec_campos)

### Para a unir as colunas 'Ano', 'Mes', 'Dia', podemos usar a função `unite()`:
prec_campos %>%
  unite(
    col = 'Data',
    c(Ano, Mes, Dia),
    sep = '-',
    remove = F)

# Podemos usar a função 'parse_number()' do pacote 'readr' para extrair a 
# informação numérica da coluna Dia:

prec_campos$Dia <-
  parse_number(prec_campos$Dia)

## Pacote `tidyr` -------------------------------------------------------------#
## O pacote `tidyr` possui funções voltadas para limpeza e organização de dados. 

### Função `pivot_wider()` ---
### A função `pivot_wider()` transforma as tabelas longas em curtas e amplas.
### Pode transformar as linhas repetidas em colunas. Para isso, precisamos informar:
### a coluna da qual obter os nomes das variáveis e a coluna da qual obter valores. 

prec_campos_2 <- 
prec_campos %>%
  pivot_wider(
    names_from = 'Dia',
    values_from = 'Prec' 
  )
print(prec_campos_2)

### Função `pivot_longer()` ---
### A função pivot_longer() transforma as tabelas amplas em estreitas e mais longas.
### Serve para agrupar duas ou mais colunas e seus respectivos valores em pares.

prec_campos_2 %>%
  pivot_longer(
    cols = `1`:`31`,             # Seleciona as colunas a serem agrupadas.
    names_to = 'Dia',            # Nome da coluna categórica. 
    values_to = 'Precipitação'   # Nome da coluna com os valores.
  )

### Função `drop_na()` ---
### Antes de introduzir a função `drop_na()`, é importante entender o conceito
### de `NA`, que significa 'Not Available' (não disponível). O`NA` é utilizado 
### para representar dados faltantes ou ausentes em um conjunto de dados. 
### Atenção! Os `NA` não devem ser confundidas com o valor zero. 

### Existem várias razões pelas quais podem ocorrer dados faltantes em conjuntos
### de dados reais. Isso pode ser resultado de falhas em equipamentos de
### medição, erros de entrada de dados, problemas técnicos, interrupções de energia
### ou até mesmo a ausência de informações em determinado momento. É fundamental 
### reconhecer que a presença de `NA` pode afetar diretamente as análises dos 
### dados, uma vez que eles podem introduzir viés e distorcer os resultados.

### A função `drop_na()` permite remover as linhas que contêm 'NA' em um conjunto de dados.

tail(dados_campos, n = 12)

dados_campos %>%
  drop_na(Tmed) %>% 
  tail(n = 12)

#------------------------https://linktr.ee/pexcca.lamet------------------------#
