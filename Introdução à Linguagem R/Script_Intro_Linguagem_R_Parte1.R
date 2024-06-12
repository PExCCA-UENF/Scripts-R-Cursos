#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 10/06/2024                        #
#==============================================================================#

#                           INTRODUÇÃO À LINGUAGEM R                           #

#------------------------------------------------------------------------------#
# TÓPICOS ABORDADOS:
# 1. INTRODUÇÃO: R E RSTUDIO;
# 2. ESTRUTURAS BÁSICAS DA LINGUAGEM R;
# 3. CRIANDO PROJETOS NO RSTUDIO (.RPROJ);
# 4. IMPORTAÇÃO E EXPORTAÇÃO DE DADOS;
# 5. MANIPULAÇÃO E PROCESSAMENTO DE DADOS COM OS PACOTES ‘DPLYR’ E ‘TIDYR’;
# 6. TRABALHANDO COM DATAS COM O PACOTE ‘LUBRIDATE’;
# 7. VISUALIZAÇÃO DE DADOS COM O PACOTE ‘GGPLOT2’;
# 8. EXPORTAÇÃO DOS RESULTADOS.

# 1. INTRODUÇÃO: R E RSTUDIO --------------------------------------------------#
# R é uma linguagem de programação e ambiente de software gratuito, livre e código
# aberto (open source).

# O RStudio é um ambiente de desenvolvimento integrado, que fornece uma interface,
# gráfica mais amigável para programação em linguagem R.

# O RStudio oferece um ambiente com diversas ferramentas que facilitam o trabalho 
# com o R: independência automática, realces de códigos, menus rápidos para importação
# e exportação de dados, além de diversos atalhos de teclado úteis.

# INFORMAÇÕES IMPORTANTES
# a) A interface do RStudio é dividida, inicialmente, em 3 partes:
 # 1° - Console
 # 2° - Environment, History...
 # 3° - Files, Plots, Packages, Help...

# b) O console fica do lado esquerdo, onde os comandos podem ser digitados e onde
# ficam os outputs. O símbolo > no canto esquerdo do console significa que o software
# está pronto para receber os comandos.
# No console, depois de escrever cada linha de comando, clique em ENTER.

## Exemplo: Podemos usar o R como uma calculadora, ao escrever o comando 5+4 no console 
## e apertar a tecla ENTER, o console me mostra automaticamente o resultado dessa operação. 

## Atenção! Se você escrever algum comando incompleto como, por exemplo, faltando 
## um par de parênteses ou uma virgula, e apertar ENTER para ser executado, o símbolo >
## do console será substituído por +, indicando que falta algo no seu comando.  

# c) Inserindo os comandos direto no console, cada vez que você precisar executar
# um conjunto de comandos, terá que digitá-los novamente no console.
# Para esse problema, a solução é usar o script R.

# d) O script R é um editor de texto.
# Ao usar um script você pode fazer alterações e correções em seus comandos.

# e) No RStudio, podemos abrir um script:
# Manualmente: Clique em File > New File > R Script.

## Por atalho de teclado: Ctrl + Shift + N.

# f) No script, para executar um comando, devemos colocar o cursor na linha do
# comando ou selecioná-lo e pressionar Ctrl + Enter (Para o RStudio) e o resultado
# será mostrado no console.

# g) No script, é possível fazer comentários usando o caractere.

# h) Para salvar o script, clique em File > Save As..., dê um nome ao arquivo e
# inclua a extensão .R (editor de texto do R).

# 2. ESTRUTURAS BÁSICAS DA LINGUAGEM R ----------------------------------------#

## 2.1 Objetos no R ---#

## Uma das principais características do R, é que ele é uma linguagem orientada a objeto.
## Os objetos permitem armazenar os valores, funções e resultados que você produz, 
## que pode posteriormente ser manipulado. Para isso, usamos a expressão de atribuição “<-”.

## Em suma, os nomes dos objetos podem conter os seguintes tipos de caracteres: 
 # Letras;
 # Números;
 # _(underline);
 # •(ponto).

## O nome de um objeto deve sempre começar com uma letra ou um ponto (desde que não seja seguido por um número).
## O nome de um objeto não deve começar por: _(underline), número ou ponto seguido de um número.

## Exemplo: 
  Temp1 <- 25.5   # lê-se "Temp1 recebe 25.5"
  
## Ao executarmos o comando acima, o resultado não será mostrado na tela, mas o objeto Temp1 
## foi criado na memória do computador. Para exibirmos o conteúdo de Temp1, basta digitar o 
## nome do objeto na linha de comando e pressionar Enter.

## Também podemos utilizar a seta invertida, mas a ponta dela deve sempre estar apontada
## para o nome do objeto.
  26.8 -> Temp2

## O "=" também pode ser utilizado para atribuição dos objetos, mas desencorajamos 
## seu uso para evitar ambiguidade com outros termos da linguagem R.
  
## Para utilizar os valores que estão armazenados em algum objeto, você precisa apenas 
## utilizar o nome que você deu a esse objeto.
  
# Nota:
## a) A linguagem R diferencia letras maiúsculas de letras minúsculas.
## b) Por padrão, o separador decimal utilizado é o ponto (.).
## c) A vírgula (,) é reservada para separar diferentes objetos dentro de uma função.

## Listagem e remoção de objetos:
ls()                # Lista todos os objetos armazenadas.
remove(Temp1)       # Remove o objeto especificado. 
rm(Temp2)           # Também remove o objeto especificado. 
rm(impar, par)      # Remove os objetos especificados.           
remove(list = ls()) # Remove todos os objetos criados na sessão.

## 2.2 Funções (noções básicas) ---#

## As funções são blocos de códigos que executam tarefas específicas, sejam elas
## de matemática, estatística, para leitura e manipulação de dados ou arquivos, etc.

## A grande maioria das funções são escritas no seguinte formato: nome_da_função(lista_de_argumentos).

## Exemplo 1: sum(..., na.rm = FALSE)
## Retorna a soma de todos os valores presentes em seus argumentos.
  sum(1, 2, 3, 4, 5)
  sum(1, 2, NA) 
  sum(1, 2, NA, na.rm = TRUE)

## Por padrão, se houver valores ausentes (NA), ao calcular estatísticas básicas, o resultado será NA.
## Para realizar o cálculo, precisamos definir na.rm = TRUE. 
  
## Exemplo 2: round(x, digits = 0, ...)
## Arredonda valores numéricos de acordo com um número de casas decimais.
  round(1.23163)
  round(1.23963, digits = 2)

## Exemplos de outras funções do R:
  # mean()    Retorna a média.
  # min()     Retorna o mínimo.
  # max()     Retorna o máximo.
  # range()   Retorna o mínimo e o máximo.
  # median()  Retorna a mediana.
  # sd()      Retorna o desvio padrão.
  # var()     Retorna a variância.
  # ceiling() Arredonda para um número inteiro seguinte.
  # floor()   Arredonda para um número inteiro para baixo.
  # summary() Retorna um resumo estatístico dos dados.
  # seq()     Retorna uma sequência, sendo possível controlar a que passo a sequência cresce.
  # rep()     Retorna uma sequência de repetições.

## No R, os operadores aritméticos também são funções, mas, eles representam um tipo especial de função.
## Podemos escrever esses operadores da forma “tradicional” ou como as demais funções no R são escritas.
## Exemplos:
`+`(2, 3)

## 2.3 Ajuda do R ---#  

## Para ver os arquivos de ajuda do R, use o help(nome_da_função) ou ?nome_da_funcão.
## Exemplo:
help(mean)
?mean
  
## Nota: Se o cursor do mouse estiver no nome da função e pressionarmos F1, a página 
## de ajuda da função vai abrir no quadrante "Help"".
  
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

## Para descobrir o nome de uma função que faça aquilo que você deseja, use a
## a função help.search() e pesquise usando palavras-chave em inglês, pois o R é
## desenvolvido em língua inglesa.

## Exemplo:
help.search("arithmetic mean")

## O help.search() irá procurar, dentro dos arquivos de help, possíveis funções
## para calcular a média. O resultado será mostrado no quadrante "Help".

##  A função help.search() pode ser substituída por duas interrogações (??).
??"arithmetic mean"

# Para buscar ajuda na internet, use a função RSiteSearch():
RSiteSearch("arithmetic mean")

## 2.4 Tipos e Estruturas de Dados ---#

## 2.4.1 Vetores ---#
## São sequências de dados de um mesmo tipo. Para criarmos um vetor no R a função
## utilizada é c().

## Função "c()" (concatenar ou combinar).

(vn <- c(2, 3, 6, 9))   # Vetor numérico.
is.vector(vn)           # Verifica se é vetor e retorna TRUE ou FALSE.
class(vn)               # Retorna o tipo de dado.
length(vn)              # Retorna o tamanho do vetor.

(vc <- c('a', 'b', 'c', 'd'))   # Vetor de characters.
is.vector(vc); class(vc); length(vc)

## Nota: Os caracteres ou cadeias de texto devem ser colocados entre aspas simples ' ' ou duplas " ".

(vetor <- c(1, 2, 3, "a"))  
is.vector(vetor); class(vetor); length(vetor)
# Como um vetor só pode ter uma classe de objeto dentro dele, sempre que tiver 
# números e texto em um vetor, os números virarão texto.

## Também podemos criar um vetor através de funções que retornam por padrão esse 
## tipo de estrutura como, por exemplo, as funções que servem para criar sequências no R. 
## Exemplos: 
(seq1 <- seq(from = 1, to = 10))   # Sequência que vai do nº 1 ao número 10.
is.vector(seq1)
class(seq1)
length(seq1)

(seq2 <- seq(from = 13, to = 1, by = -1))   # Sequência decrescente do 13 ao 1.
is.vector(seq2); class(seq2); length(seq2)

(rep1 <- rep(x = 1:5, times = 3))   # Repete 3 vezes os valores de 1 a 5.
is.vector(rep1); class(rep1); length(rep1)

(rep2 <- rep(x = 1:3, times = 1:3))   # Repete o 1º valor do intervalo uma vez, o 2º duas vezes e o 3º três vezes.
is.vector(rep2); class(rep2); length(rep2)

## 2.4.2 Matriz ---#
## Matrizes são tabelas organizadas em linhas e colunas no formato m x n, com uma 
## estrutura de dados homogêneas (armazenam o mesmo tipo de dados).

## Para criarmos uma matriz no R a função utilizada é matrix().

mtx <-
  matrix(
    rep1,           # Vetor com os valores usados para preencher a matriz.
    nrow = 3,       # Define a quantidade de linhas.
    ncol = 5,       # Define a quantidade de colunas.
    byrow = TRUE    # Se FALSE (o padrão) a matriz é preenchida por colunas, TRUE a matriz é preenchida por linhas.
  )
mtx

dim(mtx)        # Retorna a dimensão da matriz (Nº Linhas, Nº Colunas).
is.matrix(mtx)  # Verifica se é uma matriz e retorna TRUE ou FALSE.

## 2.4.3 Data frames ---#
## Data frames são tabelas em que cada coluna pode armazenar um tipo de dado diferente.

# É possível criar um data frame com a função data.frame():
(df <- data.frame(vn, vc))
is.data.frame(df)   # Verifica se é um data frame e retorna TRUE ou FALSE.

dim(df)     # Retorna a dimensão da matriz (Nº Linhas, Nº Colunas).
ncol(df)    # Retorna o númuro de colunas do data frame.
nrow(df)    # Retorna o númuro de linhas do data frame.
names(df)   # Retorna os nomes das colunas.
str(df)     # Retorna uma síntese da estrutura da base de dados.

## Podemos acessar as colunas do data frame usando o operador de indexação "$".
df$vn   # Retorna os elementos da coluna "vn".
df$vc   # Retorna os elementos da coluna "vc".

## Também podemos acessar os elementos usando o operador de indexação [Linhas, Colunas].
df[ ,1]        # Retorna a primeira coluna do conjunto de dados.
df[, -1]       # Retorna todos os dados, exceto os da coluna 1.
df[1:3, ]      # Retorna os dados da linha 1 até a linha 3.
df[c(2,4), ]   # Retorna os dados das linhas 2 e 4.

## R vem com muitos conjuntos de dados pré-instalados. 
## O conjunto de dados de qualidade do ar é um deles. Eles podem ser úteis para 
## praticar as análises que você deseja realizar em seus próprios dados.

## Digite ?airquality para acessar as informações de ajuda sobre esse conjunto de dados.
?airquality

is.data.frame(airquality)
str(airquality)

print(airquality)         # Imprime os resultados no console.
head(airquality, n = 3)   # Retorna as primeiras n linhas (por padrão 6 linhas). 
tail(airquality, n = 3)   # Retorna as últimas n linhas (por padrão 6 linhas). 

## Atividade - Usando o conjunto de dados "airquality" responda as seguintes questões:

 # 1: Calcule os valores médios, máximos e mínimos da variável radiação solar (Solar.R).
 # 2. Selecione apenas as colunas referentes à temperatura (Temp) e à quantidade 
 # de ozônio (Ozone) utilizando o operador de indexação [ , ]. Armazene o resultado 
 # em um novo objeto chamado dados_sel.

## 2.5 R base e pacote ---#

## A linguagem R é composta por um conjunto de pacotes que oferecem as funcionalidades 
## básicas da linguagem. Alguns desses pacotes são base (funções de uso geral) e 
## stats (funções para análises e operações estatísticas).
## Esses pacotes fazem parte da instalação básica do R e estão disponíveis através
## do Comprehensive R Archive Network (CRAN R).

## Além dos pacotes da base do R, podemos instalar pacotes (packages) com funcionalidades 
## específicas criadas por colaboradores. A grande maioria desses pacotes também estão
## disponíveis através do CRAN R, mas alguns estão disponíveis em outras plataformas, como o GitHub.

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

# Nota: Podemos descarregar um pacote com a função detach("package:nome_do_pacote").

# Podemos realizar uma breve inspeção nas funções do pacote utilizando a função ls().
# Assim, podemos procurar alguma função que atenda às nossas necessidades.

ls("package:tidyverse")   # Lista os comandos do pacote.

tidyverse_packages()   # Lista os pacotes pertencentes ao projeto.

# 3. CRIANDO PROJETOS NO RSTUDIO (.RPROJ) -------------------------------------#

# Trabalhar com programação exige um nível de organização, que é importante para 
# manter a eficiência e reprodutibilidade. No R, existem algumas maneiras de aumentar 
# esse nível de organização, como Rprojects e controle do diretório de trabalho.

# O diretório de trabalho é, em suma, a pasta onde o R vai procurar os arquivos na
# na hora de ler informações e vai gravar os arquivos na hora de salvar informações.
# A definição do diretório de trabalho é uma etapa opcional, mas que pode economizar 
# muito tempo no processo de análise de dados.

# A função getwd() pode ser utilizada para verificar o diretório de trabalho atual.
getwd() 

# A função setwd()  pode ser utilizada para mudar o diretório de trabalho. 
setwd() 
## Ex.: setwd('C:/Users/Documentos/R')

## Nota: Na função `setwd()`, devemos usar a barra oblíqua (`/`) para definir o caminho.

# Caso opte por definir o diretório manualmente, podemos realizá-lo em:
# -- Session > Set Working Directory > Choose Directory.
# Podemos utilizar também o atalho de teclado: Ctrl + Shift + H.

# No RStudio podemos ainda criar projetos (Rproject).
# O Rproject nada mais é do que uma pasta no seu computador específica para uma análise.
# Alguns dos principais benefícios do Rproject:

# 1. Organização de arquivos: Você pode organizar todos os arquivos relacionados 
#    a um projeto em um único diretório, facilitando a localização e o gerenciamento 
#    de scripts, dados, gráficos, relatórios e outros arquivos associados.

# 2. Independência de diretórios: Cada projeto R possui seu próprio diretório de 
#    trabalho, o que significa que os caminhos para arquivos e pacotes são relativos 
#    ao diretório do projeto. Isso evita conflitos entre projetos e permite que você 
#    alterne facilmente entre projetos sem precisar reconfigurar caminhos e configurações.
#
# 3. Controle de versão: Você pode integrar o projeto R com sistemas de controle de 
#    versão, como o Git, para rastrear alterações, colaborar com outros usuários e 
#    recuperar versões anteriores do código.
#
# 4. Facilidade de compartilhamento: Ao compartilhar um projeto R, você pode incluir 
#    todos os arquivos e configurações necessários para que outras pessoas reproduzam 
#    sua análise. Isso torna mais fácil colaborar em projetos, compartilhar código 
#    e resultados, e garantir que todos estejam trabalhando no mesmo contexto.
#
# 5. Automatização: Você pode automatizar tarefas e análises por meio de scripts e 
#    funções. Isso permite que você crie fluxos de trabalho reprodutíveis e repetíveis, 
#    economizando tempo e minimizando erros.
#
## Em resumo, o uso de um projeto R ajuda na organização, reprodutibilidade, 
## compartilhamento e controle de versão, tornando suas análises mais eficientes, 
## colaborativas e confiáveis.

## Para criar um projeto vá em: File > New Project. 
## Em seguida, clique em: New Directory para criar o projeto em uma nova pasta.
## Nesta etapa, escolhemos o tipo de projeto que iremos criar, que podem ser ambientes 
## para uma análise simples, ambientes de desenvolvimentos de pacotes e até ambientes 
## para produção de livros. Para utilizar o ambiente simples, clique em New R Projetc.
## Em Directory name, insira o nome para o diretório que será criado.
## Em seguida, clique em Browse e defina um subdiretório para o projeto, local onde será criado a pasta.

## Se possuir o Git instalado, você também pode usar projetos para conectar com 
## repositórios do Github. Para isso, clique em Version Control na primeira janela 
## e siga as instruções lá fornecidas.
