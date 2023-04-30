#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 29/04/2023                        #
#==============================================================================#

#                   LINGUAGEM R: CONCEITOS BÁSICOS (PARTE 1)                   # 

#-------------------------------------------------------------------------------
# TÓPICOS ABORDADOS:
# 1. INTRODUÇÃO
# 2. DIRETÓRIO DE TRABALHO
# 3. AJUDA DO R
# 4. VARIÁVEIS E ATRIBUIÇÕES
# 5. OPERAÇÕES BÁSICAS
# 6. OPERADORES RELACIONAIS
# 7. FUNÇÕES BÁSICAS
# 8. TIPOS E ESTRUTURAS DE DADOS

# 1. INTRODUÇÃO ----------------------------------------------------------------
# R é uma linguagem de programação e ambiente de software gratuito, livre e código 
# aberto (open source). 

# O RStudio é um ambiente de desenvolvimento integrado, que fornece uma interface,
# gráfica mais amigável para programação em linguagem R.

# INFORMAÇÕES IMPORTANTES ------------------------------------------------------
# a) A interface do RStudio é dividida, inicialmente, em 3 partes:
## 1° - Console
## 2° - Environment, History...
## 3° - Files, Plots, Packages, Help...

# b) O console fica do lado esquerdo, onde os comandos podem ser digitados e onde
## ficam os outputs. O sinal > no canto esquerdo do console significa que o software
## está pronto para receber os comandos.
## No console, depois de escrever cada linha de comando, clique em ENTER.

# c) Inserindo os comandos direto no console, cada vez que você precisar executar 
## um conjunto de comandos, terá que digitá-los novamente no console. 
## Para esse problema, a solução é usar o script R.

# d) O script R é um editor de texto. 
## Ao usar um script você pode fazer alterações e correções em seus comandos.

# e) No RStudio, podemos abrir um script:
## Manualmente:
### Clique em File > New File > R Script. 

## Por atalho de teclado: 
### Ctrl + Shift + N.

# f) No script, para executar um comando, devemos colocar o cursor na linha do
## comando ou selecioná-lo e pressionar Ctrl + Enter (Para o RStudio) e o resultado 
## será mostrado no console.

# g) No script, é possível fazer comentários usando o caracter #.

# h) Para salvar o script, clique em File > Save As..., dê um nome ao arquivo e
# inclua a extensão .R (editor de texto do R).

# 2. DIRETÓRIO DE TRABALHO -----------------------------------------------------
# O diretório de trabalho é uma pasta no seu computador que interage com o R/RStudio.

# 2. Definindo o diretório de trabalho.
# 2.1 Manualmente: 
## Session > Set Working Directory > Choose Directory

# 2.2 Por atalho de teclado:
## Ctrl + Shift + H

# 2.3 Com funções:
getwd() # Informa o diretório de trabalho atual.
setwd() # Seta um local como novo diretório.
dir()   # Lista os arquivos dentro do diretório de trabalho.

## Nota: Na função setwd(), devemos usar a barra oblíqua (/) para definir o caminho.
## Exemplo: setwd("C:/Users/Documentos/R")

# 3. AJUDA DO R ----------------------------------------------------------------
# Para descobrir o nome de uma função que faça aquilo que você deseja, use a 
# a função help.search() e pesquise usando palavras-chave em inglês, pois o R é
# desenvolvido em língua inglesa.

## Exemplo:
help.search("arithmetic mean")

## O help.search() irá procurar, dentro dos arquivos de help, possíveis funções 
## para calcular a média. O resultado será mostrado no quadrante "Help".

##  A função help.search() pode ser substituída por duas interrogações (??).
??"arithmetic mean"

# Para buscar ajuda na internet, use a função RSiteSearch():
RSiteSearch("arithmetic mean")

# Para ver os arquivos de ajuda do R, use o help(nome_da_função) ou ?nome_da_funcão.
## Exemplo:
help(mean)
??mean

# Nota: Se o cursor do mouse estiver no nome da função e pressionarmos F1, a 
# página de ajuda da função vai abrir no quadrante "Help"".

## Os arquivos de ajuda, geralmente, apresentam os seguintes tópicos:
# a) Description - resumo geral sobre o uso da função;
# b) Usage - mostra como a função deve ser usada e quais argumentos podem ser especificados;
# c) Arguments - descrição dos argumentos;
# d) Details - alguns detalhes sobre o uso e aplicação da função;
# e) Value - explica o que sai no output após usar a função (os resultados);
# f) Note - notas sobre a função;
# g) Authors - lista os autores da função (quem escreveu os códigos R);
# h) References - referências utilizadas;
# i) See also - mostra outras funções relacionadas que podem ser consultadas;
# j ) Examples - exemplos do uso da função. 
### Dica: Copie e cole os exemplos no R/RStudio para ver como funciona.

# 4. VARIÁVEIS E ATRIBUIÇÕES ---------------------------------------------------
# As variáveis permitem armazenar valores, incluindo objetos, em um local da 
# memória do software. Para acessar a informação armazenada, basta usar o nome da 
# variável que a contém. 

# Para declarar uma variável e atribuir-lhe um valor/objeto podemos usar três métodos:
## Símbolo de atribuição <-
Temp1 <- 25.5
26.8 -> Temp2 #A ponta da seta está sempre voltada para o nome da variável.

## Símbolo de atribuição =
Temp2 = 30.2

## Função assign()
assign("Temp3", 29.5)

# Visualizar o conteúdo armazenado na variável:
## Coloque os comandos entre parênteses para executar e visualizar o resultado:
(Temp4 <- 19.6)

## Digite o nome da variável: 
Temp1

## Use a função print():
print(Temp1)

## Exibição concomitante:
Temp1; Temp2; Temp3; Temp4

# Regras para nomear variáveis na linguagem R:
## a) Devem sempre começar com uma letra ou um ponto. 
## b) Se iniciar com ponto, não pode ser seguido de um número.
## c) Os nomes das variáveis não podem conter espaços em branco. Para separar 
## palavras, utiliza-se o underline (_). 
## d) Não usar palavras reservadas da linguagem, como if, for, while, entre outras.

# Nota: 
## a) O R/RStudio diferencia letras maiúsculas de letras minúsculas.
## b) Por padrão, o separador decimal utilizado é o ponto (.). 
## c) A vírgula (,) é reservada para separar diferentes objetos dentro de uma função.

# Listagem e remoção de variáveis (e outros objetos):
ls()                # Lista todas as variáveis (e outros objetos) armazenadas.
remove(Temp1)       # Remove variável(eis) ou objeto(s) especificado(s). 
rm(Temp2)           # Também remove variável(eis) ou objeto(s) especificado(s).                
rm(Temp3, Temp4)                 
remove(list = ls()) # Remove todas as variáveis (e outros objetos) criadas na sessão.

# 5. OPERAÇÕES BÁSICAS ---------------------------------------------------------
# Os símbolos da linguagem R para realizar as operações matemáticas básicas são os
# mesmos das calculadoras científicas: + (adição), * (multiplização), / (divisão) e - (subtração).
100 + 50    # Soma
100 - 50    # Subtração
100 * 50    # Multiplicação
100 / 50    # Divisão
2 ^ 4       # Potenciação
2 ** 4      # Potenciação
sqrt(9)     # Raiz quadrada
log(4)      # Função logarítmica

# Nota: log() e sqrt() são funções do R.

# 6. OPERADORES RELACIONAIS ----------------------------------------------------
# Os operadores relacionais relacionam dois elementos e retorna um valor lógico.
# Valores lógicos: TRUE(verdadeiro) e FALSE(falso).
# Frequentemente utilizados para testar condições e criar expressões condicionais.

# <   Menor que
# <=  Menor ou igual a
# >   Maior que
# >=  Maior ou igual a
# ==  Igual a
# !   Negação
# !=  Diferente de

3 < 6   # 3 é menor que 6?
3 <= 0  # 3 é menor ou igual a 0?
0 > 6   # 0 é maior que 6?
3 >= 3  # 3 é maior ou igual a 3?
3 == 6  # 3 é igual a 6?
6 == 6  # 6 é igual a 6?
3 != 6  # 3 é diferente de 6?
0 != 0  # 0 é diferente de 0?

# 7. FUNÇÕES BÁSICAS ---------------------------------------------------------
# As funções são blocos de códigos que executam tarefas específicas, sejam elas 
# de matemática, estatística, para leitura e manipulação de dados ou arquivos, etc.

# Algumas funções básicas do R:
# mean()    Retorna a média.
# sum()     Retorna a soma.
# min()     Retorna o mínimo.
# max()     Retorna o máximo.
# range()   Retorna o mínimo e o máximo.
# median()  Retorna a mediana.
# sd()      Retorna o desvio padrão.
# var()     Retorna a variância.
# round()   Retorna o valor arredondado.
# summary() Retorna um resumo estatístico dos dados.
# seq()     Retorna uma sequência, sendo possível controlar a que passo a sequência cresce.
# rep()     Retorna uma sequencia de repetições. 

# As funções podem receber argumentos, que são usados para passar dados para a função. 

# Exemplos: 
seq(from = 1, to = 10)            # Sequência que vai do nº 1 ao número 10.
seq(from = 0, to = 100, by = 10)  # Sequência que vai de 10 em 10 do 0 ao 100.
seq(from = 10, to = 1, by = -1)   # Sequência decrescente do 10 ao 1.

rep(x = 2, times = 10)            # Repete o nº 2 dez vezes.
rep(x = 1:5, times = 3)           # Repete 3 vezes os valores de 1 a 5.
rep(x = 1:5, each = 3)            # Repete 3 vezes cada valor do intervalo 1:5.
rep(x = 1:3, times = 1:3)         # Repete o 1º valor do intervalo uma vez, o 2º duas vezes e o 3º três vezes.
rep(FALSE, 3)                     # Repete o valor lógico "FALSE" três vezes.
rep(seq(0, 10, 2), 3)             # Repete a sequência de 0 a 10 com passo 2 três vezes.

# Nota: Os argumentos de uma função são sempre separados por vírgulas.

# 8. TIPOS E ESTRUTURAS DE DADOS -----------------------------------------------
# 8.1 Vetor (vector): sequência de dados de um mesmo tipo.
# Para criarmos um vetor no R a função utilizada é c().
# Função "c()" (concatenar ou combinar).

(vn <- c(2, 3, 6, 9)) # Vetor numérico.
is.vector(vn)   # Verifica se é vetor e retorna TRUE ou FALSE.
class(vn)       # Retorna o tipo de dado.
length(vn)      # Retorna o tamanho do vetor.

(vc <- c('a', 'b', 'c', 'd')) # Vetor de characters.    
is.vector(vc)  
class(vc)     
length(vc)     

# Nota: Os caracteres ou cadeias de texto devem ser colocados entre aspas 
# simples ' ' ou duplas " ".

# 8.2 Matriz (matrix): é uma tabela organizada em linhas e colunas no formato m x n,
# com uma estrutura de dados homogêneas (armazenam o mesmo tipo de dados).

# Para criarmos uma matriz no R a função utilizada é matrix().

mtx <-                         
  matrix(                     
    c(2, 3, 6, 9, 10, 12), # Vetor com os valores usados para preencher a matriz.
    nrow = 3,              # Define a quantidade de linhas.
    ncol = 2,              # Define a quantidade de colunas.
    byrow = TRUE           # Se FALSE (o padrão) a matriz é preenchida por colunas, TRUE a matriz é preenchida por linhas.
  )
mtx

dim(mtx)        # Retorna a dimensão da matriz (Nº Linhas, Nº Colunas).
is.matrix(mtx)  # Verifica se é uma matriz e retorna TRUE ou FALSE.

# 8.3 Data frames: são tabelas em que cada coluna pode armazenar um tipo de dado diferente.

# É possível criar um data frame com a função data.frame():
(df <- data.frame(vn, vc))
is.data.frame(df)   # Verifica se é um data frame e retorna TRUE ou FALSE.

dim(df)   # Retorna a dimensão da matriz (Nº Linhas, Nº Colunas).
ncol(df)  # Retorna o númuro de colunas do data frame.
nrow(df)  # Retorna o númuro de linhas do data frame.
names(df) # Retorna os nomes das colunas.
str(df)   # Retorna uma síntese da estrutura da base de dados.

#------------------------https://linktr.ee/pexcca.lamet------------------------#
