#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#==============================================================================#

#                      INTRODUÇÃO À LINGUAGEM R - PARTE 1                      
#                        Script atualizado em 15/11/2025

#==============================================================================#

# 1. INTRODUÇÃO AO R E RSTUDIO ------------------------------------------------#

# - R é uma linguagem de programação e ambiente de software gratuito, livre e código
#   aberto (open source).
# - O RStudio é um ambiente de desenvolvimento integrado, que fornece uma interface,
#   gráfica mais amigável para programação em linguagem R.

# Interface inicial do RStudio:
# - Console (lado esquerdo, onde digitamos comandos).
# - Environment/History (objetos e histórico).
# - Files/Plots/Packages/Help (arquivos, gráficos, pacotes e ajuda).

# Exemplos básicos:
5 + 4        # Adição.
9 ^ 2        # Potenciação.
sum(1, 2, 3) # Soma de vários valores.

## Nota:
# - Inserindo os comandos direto no console, cada vez que você precisar executar
#   um conjunto de comandos, terá que digitá-los novamente no console.
# - Para esse problema, a solução é usar o script R, que é um editor de texto.

## Dica: Use Ctrl + Shift + N para abrir um novo script no RStudio.

#==============================================================================#
# 2. OBJETOS NO R -------------------------------------------------------------#

# Objetos armazenam valores, funções ou resultados.
Temp1 <- 25.5   # Atribuição com "<-".
26.8 -> Temp2   # Atribuição invertida.
Temp1           # Exibe o conteúdo.

## Listagem e remoção de objetos:
ls()                # Lista todos os objetos armazenados.
remove(Temp1)       # Remove o objeto especificado. 
rm(Temp2)           # Remove o objeto especificado. 
rm(impar, par)      # Remove os objetos especificados.           
remove(list = ls()) # Remove todos os objetos criados na sessão.

## Nota:
# - A linguagem R diferencia letras maiúsculas de letras minúsculas.
# - Por padrão, o separador decimal utilizado é o ponto (.).
# - A vírgula (,) é reservada para separar diferentes objetos dentro de uma função.

#==============================================================================#
# 3. FUNÇÕES ------------------------------------------------------------------#

# Estrutura geral: nome_da_função(argumentos)

# Exemplo 1: soma de valores.
sum(1, 2, 3)   # Soma os três números.

sum(1, 2, NA)                 # Retorna NA porque há um valor ausente (NA).
sum(1, 2, NA, na.rm = TRUE)   # Soma ignorando o NA.

# Nota:
# - NA significa "Not Available" (valor ausente).
# - Muitas funções retornam NA se houver valores ausentes.
# - Para ignorar os NAs, usamos o argumento na.rm = TRUE.

# Exemplo 2: arredondamento
round(1.23963, digits = 2)    # Arredonda para 2 casas decimais.

# Operadores também são funções:
9 + 2                         # Soma tradicional.
`+`(9, 2)                     # Soma escrita como função.

#------------------------------------------------------------------------------#
# Exercício:
# 1) Calcule a soma dos números 15, 20 e 25.
# 2) Calcule a soma dos números 10, NA e 30:
#    a) sem ignorar o NA.
#    b) ignorando o NA.
# 3) Arredonde o número 7.456 para:
#    a) nenhuma casa decimal.
#    b) duas casas decimais.

#==============================================================================#
# 4. AJUDA NO R ---------------------------------------------------------------#

## Para ver os arquivos de ajuda do R, use o help(nome_da_função) ou ?nome_da_funcão.
help(mean)
?mean

## Para descobrir o nome de uma função que faça aquilo que você deseja, use a
## a função help.search() e pesquise usando palavras-chave em inglês, pois o R é
## desenvolvido em língua inglesa.

## Exemplo:
help.search("arithmetic mean")

##  A função help.search() pode ser substituída por duas interrogações (??).
??"arithmetic mean"

# Para buscar ajuda na internet, use a função RSiteSearch():
RSiteSearch("arithmetic mean")

#==============================================================================#
# 5. ESTRUTURAS DE DADOS ------------------------------------------------------#

# 5.1 Vetores:
# - São sequências de dados de um mesmo tipo. Para criarmos um vetor no R a função
#   utilizada é c().

## Função "c()" (concatenar ou combinar).

vn <- c(2, 3, 6, 9)       # Vetor numérico.
vc <- c("a", "b", "c", "d")    # Vetor de caracteres.

## Nota: Os caracteres ou cadeias de texto devem ser colocados entre aspas simples ' ' ou duplas " ".

seq(from = 1, to = 10))   # Sequência que vai do nº 1 ao número 10.
seq(from = 13, to = 1, by = -1))   # Sequência decrescente do 13 ao 1.
rep(1:5, times = 3)       # Repetição.
rep(x = 1:5, times = 3))  # Repete 3 vezes os valores de 1 a 5.
rep(x = 1:3, times = 1:3))   # Repete o 1º valor do intervalo uma vez, o 2º duas vezes e o 3º três vezes.

# 5.2 Matrizes:
# - Matrizes são tabelas organizadas em linhas e colunas no formato m x n, com uma 
#   estrutura de dados homogêneas (armazenam o mesmo tipo de dados).

mtx <- matrix(
  rep(1:6, 3),   # Vetor de entrada: sequência de 1 a 6 repetida 3 vezes.
  nrow = 3,      # Número de linhas da matriz (3 linhas).
  ncol = 6,      # Número de colunas da matriz (6 colunas).
  byrow = TRUE   # Preenchimento por linhas (TRUE = linha a linha; FALSE = coluna a coluna).
)

print(mtx)  # Visualizando a matriz criada.

# Verificando as dimensões da matriz:
dim(mtx)         # Retorna (linhas, colunas).

# Conferindo se o objeto é realmente uma matriz
is.matrix(mtx)   # Retorna TRUE.

# 5.3 Data Frames:
# - Data frames são tabelas em que cada coluna pode armazenar um tipo de dado diferente.

df <- data.frame(vn, vc)
# vn : vetor numérico (coluna de números).
# vc : vetor de caracteres (coluna de texto).

# Verificando os nomes das colunas do data frame.
names(df)   # Retorna "vn" e "vc".

# Estrutura interna do data frame.
str(df)     # Mostra o tipo de objeto, número de linhas/colunas e tipo de cada coluna.

# Acessando uma coluna específica.
df$vn       # Retorna todos os valores da coluna "vn".

## Também podemos acessar os elementos usando o operador de indexação [Linhas, Colunas].
df[ ,1]        # Retorna a primeira coluna do conjunto de dados.
df[, -1]       # Retorna todos os dados, exceto os da coluna 1.
df[1:3, ]      # Retorna os dados da linha 1 até a linha 3.
df[c(2,4), ]   # Retorna os dados das linhas 2 e 4.

# Dataset exemplo.
# O R já vem com diversos conjuntos de dados prontos para uso.
# Um exemplo é o "airquality", que contém informações sobre qualidade do ar em Nova York.

# Acessando informações de ajuda sobre o conjunto "airquality":
?airquality

# Explorando a estrutura interna do conjunto:
str(airquality)             # Mostra variáveis, tipos de dados e número de observações.

# Visualizando os dados:
print(airquality)           # Imprime todo o conjunto no console.
head(airquality, n = 3)     # Retorna as 3 primeiras linhas (por padrão são 6).
tail(airquality, n = 3)     # Retorna as 3 últimas linhas (por padrão são 6).

#------------------------------------------------------------------------------#
# Exercício - Usando o conjunto de dados "airquality".
# 1) Calcule os valores médios, máximos e mínimos da variável radiação solar (Solar.R).

# 2) Usando a indexação [Linhas, Colunas], selecione apenas as colunas referentes à 
#    temperatura (Temp) e à quantidade de ozônio (Ozone). Armazene o resultado em um 
#    novo objeto chamado dados_sel. 

#==============================================================================#
# 6. PACOTES ------------------------------------------------------------------#
# - A linguagem R é composta por um conjunto de pacotes que oferecem as funcionalidades 
#   básicas da linguagem. Alguns desses pacotes são base (funções de uso geral) e 
#   stats (funções para análises e operações estatísticas).
# - Esses pacotes fazem parte da instalação básica do R e estão disponíveis através
#   do Comprehensive R Archive Network (CRAN R).
# - Além dos pacotes da base do R, podemos instalar pacotes (packages) com funcionalidades 
#   específicas criadas por colaboradores. A grande maioria desses pacotes também estão
#   disponíveis através do CRAN R, mas alguns estão disponíveis em outras plataformas, como o GitHub.

# Para instalar um pacote do R, podemos usar a função install. packages("nome_do_pacote").
install.packages("tidyverse")   # Instala o pacote "tidyverse".

# Nota: O pacote pode ser desinstalado com a função remove.packages("nome_do_pacote").

# Após a instalação, o pacote deve ser carregado.
# Podemos usar a função library(nome_do_pacote) ou require(nome_do_pacote).
library(tidyverse)   # Carrega o pacote.
require(tidyverse)   # Carrega o pacote.

# A função library(), por padrão, retorna um erro quando o pacote não está instalado.
# A função require() retorna um warning caso o pacote não esteja instalado.

search()   # Retorna todos os pacotes carregados.
ls("package:tidyverse")   # Lista os comandos do pacote.

ls("package:tidyverse")   # Lista as funções do pacote.

#==============================================================================#
# 7. ORGANIZAÇÃO NO R ---------------------------------------------------------#

# Trabalhar com programação exige organização para garantir eficiência e reprodutibilidade.
# No R, isso pode ser feito de duas formas principais:
# 1) Definindo o diretório de trabalho.
# 2) Criando projetos (RProject).

# Diretório de trabalho:
# É a pasta onde o R procura arquivos para leitura e grava os resultados.
# Definir o diretório evita ter que escrever caminhos longos em cada comando.

getwd()                     # Mostra o diretório de trabalho atual
setwd("C:/Users/Documentos/R") # Define um novo diretório de trabalho
# Obs.: use sempre "/" em vez de "\" no caminho.

# No RStudio, também é possível definir manualmente:
# Session > Set Working Directory > Choose Directory
# Atalho: Ctrl + Shift + H

# Projetos (RProject):
# Um projeto é uma pasta dedicada a uma análise específica.
# Benefícios:
# - Organização: scripts, dados e relatórios ficam juntos.
# - Independência: cada projeto tem seu próprio diretório de trabalho.
# - Compartilhamento: facilita enviar o projeto completo para outra pessoa.
# - Controle de versão: pode ser integrado ao Git/GitHub.
# - Reprodutibilidade: garante que tudo seja executado no mesmo ambiente.

# Criando um projeto:
# File > New Project > New Directory > New R Project
# - Em "Directory name", escolha o nome da pasta.
# - Em "Browse", selecione onde ela será criada.
# - Se desejar, use "Version Control" para conectar ao Git/GitHub.

#------------------------https://linktr.ee/pexcca.lamet------------------------#
