#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 03/07/2023                        #
#==============================================================================#
#                                CONHECENDO O R                                # 
#-------------------------------------------------------------------------------
# TÓPICOS ABORDADOS:
# 1. INTRODUÇÃO;
# 2. INTERFACE DO RSTUDIO;
# 3. R BASE E PACOTES;
# 4. TIPOS E ESTRUTURAS DE DADOS;
# 5. OPERAÇÕES ARITMÉTICAS E LÓGICAS;
# 6. LEITURA E EXPORTAÇÃO DE DADOS;
# 7. GERANDO GRÁFICOS E MAPAS.

# 1. INTRODUÇÃO ---------------------------------------------------------------#
# R é uma linguagem de programação e ambiente de software gratuito, livre e código 
# aberto (open source). 
## Para baixar o R acesse o link: https://www.r-project.org/

# O RStudio é um ambiente de desenvolvimento integrado, que fornece uma interface,
# gráfica mais amigável para programação em linguagem R.
## Para baixar o RStudio Desktop acesse o link: https://posit.co/downloads/

# 2. INTERFACE DO RSTUDIO------------------------------------------------------#
# A interface do RStudio é dividida, inicialmente, em 3 partes:
#  1° Console: fica do lado esquerdo, onde os comandos podem ser digitados e onde ficam os outputs.
#     O sinal > no canto esquerdo do console significa que o software está pronto para receber os comandos.
#     No console, depois de escrever cada linha de comando, clique em ENTER.

#  2° Environment, History...
#     Environment: exibe os objetos atualmente salvos.
#     History: exibe os comandos que foram executados na sessão atual.
#     Connections: exibe conexões com bancos de dados locais ou remotos.
#     Tutorial: carrega tutoriais interativos para alunos.

#  3° Files, Plots, Packages, Help...
#     Files: fornece exploração interativa do projeto R atual com todo o diretório.
#     Plots: exibe as imagens estáticas geradas pelos códigos.
#     Packages: exibe os pacotes R instalados.
#     Help: guia de ajuda.
#     Viewer: exibe conteúdo da Web, como aplicativos Shiny.
#     Presentation: exibe apresentação em HTML.

## IMPORTANTE: Inserindo os comandos direto no console, cada vez que você precisar 
## executar um conjunto de comandos, terá que digitá-los novamente no console. 
## Para esse problema, a solução é usar o script R, que é um editor de texto. 
## Ao usar um script você pode fazer alterações e correções em seus comandos.

## No RStudio, podemos abrir um script:
### Manualmente: Clique em File > New File > R Script. 
### Por atalho de teclado: Ctrl + Shift + N.

## No script, para executar um comando, devemos colocar o cursor na linha do comando 
## ou selecioná-lo e pressionar Ctrl + Enter (Para o RStudio) e o resultado será mostrado no console.
## No script, é possível fazer comentários usando o caracter #.

## Para salvar o script, clique em File > Save As..., dê um nome ao arquivo e inclua a extensão .R.

## IMPORTANTE: Defina um diretório de trabalho ou a pasta onde ficará salvo o seu script.
## O diretório de trabalho é o local onde o R vai procurar e salvar os arquivos.

## Definindo o diretório de trabalho:
## Manualmente: Session > Set Working Directory > Choose Directory
## Por atalho de teclado: Ctrl + Shift + H

# 3. R BASE E PACOTES----------------------------------------------------------#
# Na linguagem R, algumas funções estão implementadas no ambiente básico do R,
# ou seja, fazem parte da instalação básica do R.

# As funções são blocos de códigos que executam tarefas específicas, sejam elas 
# de matemática, estatística, para leitura e manipulação de dados ou arquivos, etc.

# Exemplos:
# seq()     Retorna uma sequência, sendo possível controlar a que passo a sequência cresce.
seq(from = 1, to = 10)            # Sequência que vai do nº 1 ao número 10.
seq(from = 0, to = 100, by = 10)  # Sequência que vai de 10 em 10 do 0 ao 100.
seq(from = 10, to = 1, by = -1)   # Sequência decrescente do 10 ao 1.

# rep()     Retorna uma sequência de repetições.
rep(x = 2, times = 10)            # Repete o nº 2 dez vezes.
rep(x = 1:5, times = 3)           # Repete 3 vezes os valores de 1 a 5.
rep(x = 1:5, each = 3)            # Repete 3 vezes cada valor do intervalo 1:5.
rep(x = 1:3, times = 1:3)         # Repete o 1º valor do intervalo uma vez, o 2º duas vezes e o 3º três vezes.
rep(FALSE, 3)                     # Repete o valor lógico "FALSE" três vezes.
rep(seq(0, 10, 2), 3)             # Repete a sequência de 0 a 10 com passo 2 três vezes.

# Na linguagem R podemos criar objetos/variáveis usando <- ou = (símbolos de atribuição).
Temp1 <- 25.5
Temp2 = 30.2

impar <- seq(from = 1, to = 10, by = 2)
par = seq(from = 2, to = 10, by = 2)

impar        # Visualizar o conteúdo armazenado no objeto/variável.
print(par)   # Também podemos usar a função print() para visualizar o conteúdo armazenado no objeto/variável.

## Exibição concomitante:
Temp1; Temp2; impar; par

# Listagem e remoção de variáveis (e outros objetos):
ls()                # Lista todas as variáveis (e outros objetos) armazenadas.
remove(Temp1)       # Remove variável(eis) ou objeto(s) especificado(s). 
rm(Temp2)           # Também remove variável(eis) ou objeto(s) especificado(s). 
rm(impar, par)                 
remove(list = ls()) # Remove todas as variáveis (e outros objetos) criadas na sessão.

# Para ver os arquivos de ajuda do R, use o help(nome_da_função) ou ?nome_da_funcão.
## Exemplo:
help(seq)
?seq

# Além do R base, podemos instalar pacotes (packages) com funcionalidades específicas
# criadas por colaboradores.  

# Para usar as funções dos pacotes, é necessário fazer a  instalação conforme sua necessidade. 
installed.packages()        # Retorna todos os pacotes instalados, local e versão.

# Para instalar um pacote do R, podemos usar a função install. packages('nome_do_pacote'). 
install.packages('writexl') # Instala o pacote 'writexl'.

# Nota: O pacote pode ser desinstalado com a função remove.packages('nome_do_pacote').

# Após a instalação, o pacote deve ser carregado. 
# Podemos usar a função library(nome_do_pacote) ou require(nome_do_pacote).
library(writexl)            # Carrega o pacote.
require(writexl)            # Carrega o pacote.

# A função library(), por padrão, retorna um erro quando o pacote não está instalado. 
# A função require() retorna um warning caso o pacote não esteja instalado.

search()                    # Retorna todos os pacotes carregados.
# Nota: Podemos descarregar um pacote com a função detach('package:nome_do_pacote').

ls('package:writexl')       # Lista os comandos do pacote.

# 4. TIPOS E ESTRUTURAS DE DADOS-----------------------------------------------#
# No R existem muitas estruturas de dados, uma delas é o vetor.
# O Vetor (vector) é uma sequência de dados de um mesmo tipo.

# Para criarmos um vetor no R a função utilizada é c().
# Função "c()" (concatenar ou combinar).

vc <- c('a', 'b', 'c', 'd')   # Vetor de caracteres.
# Nota: Os caracteres ou cadeias de texto devem ser colocados entre aspas simples ' ' ou duplas " ".

vn <- c(2, 3, 6, 9, 12, 16)   # Vetor numérico.
vi <- c(5L, 1L, 4L, 5L)       # Vetor de números inteiros .    

vc; vn; vi

# Existem 5 tipos básicos de dados no R:
# character: "A", "B"
# numeric: 6, 5.3
# integer: 3L (L serve para armazenar como inteiro no R)
# logical: TRUE, FALSE
# complex: 1+5i

# Para verificar o tipo de dados podemos usar a função class().
class(vc); class(vn); class(vi)

# Para verificar o tamanho do vetor podemos usar a função length().
length(vc); length(vn); length(vi)

# Estruturas de dados do tipo matriz.
# A matriz é uma tabela organizada em linhas e colunas no formato m x n,
# com uma estrutura de dados homogêneas (armazenam o mesmo tipo de dados).

# Para criarmos uma matriz no R a função utilizada é matrix().
mtx <-     
  matrix(                     
    vn,             # Vetor com os valores usados para preencher a matriz.
    nrow = 3,       # Define a quantidade de linhas.
    ncol = 2,       # Define a quantidade de colunas.
    byrow = TRUE)   # Se FALSE (o padrão) a matriz é preenchida por colunas, TRUE a matriz é preenchida por linhas.
mtx

dim(mtx)        # Retorna a dimensão da matriz (Nº Linhas, Nº Colunas).

# Estruturas de dados do tipo data frame.
# Os data frames são tabelas em que cada coluna pode armazenar um tipo de dado diferente.

# É possível criar um data frame com a função data.frame():
(df <- data.frame(vc, vi))

dim(df)   # Retorna a dimensão da matriz (Nº Linhas, Nº Colunas).
ncol(df)  # Retorna o número de colunas do data frame.
nrow(df)  # Retorna o número de linhas do data frame.
names(df) # Retorna os nomes das colunas.
str(df)   # Retorna uma síntese da estrutura da base de dados.

# 5. OPERAÇÕES ARITMÉTICAS E LÓGICAS-------------------------------------------#
# Os símbolos da linguagem R para realizar as operações matemáticas básicas são os mesmos
# das calculadoras científicas: + (adição), * (multiplização), / (divisão) e - (subtração).
100 + 50    # Soma
mtx + 10

100 - 50    # Subtração
mtx - 10

100 * 50    # Multiplicação
mtx * 10

100 / 50    # Divisão
mtx / 10

3 ^ 2       # Potenciação
mtx ^ 2

2 ** 4      # Potenciação
mtx ** 4

sqrt(mtx)   # Raiz quadrada
sqrt(mtx)

log(4)      # Função logarítmica
log(mtx)
# Nota: log() e sqrt() são funções do R.

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

vc == vi
vc == vc 

# 6. LEITURA E EXPORTAÇÃO DE DADOS---------------------------------------------#
# Vamos fazer download de dados de Temperatura Média Compensada Mensal e Anual (°C)
# do Instituto Nacional de Meteorologia (INMET). 

# Link para baixar os dados:
url.file <- 'https://portal.inmet.gov.br/uploads/normais/Normal-Climatologica-TMEDSECA.xlsx'

# Use a função download.file() para baixar o arquivo conforme descrito por url da Internet.
download.file(url.file,      # URL do arquivo a ser baixado.
              'Tmed.xlsx',   # Nome e extensão do arquivo que será gerado.
              mode = 'wb')   # Modo de gravação do arquivo: 'wb' para Windows.

# Obs.: Quando o caminho não é especificado para salvar o arquivo, o arquivo é salvo no diretório.

dir()   # Verifique os arquivos do diretório de trabalho.

##	Importação de dados em .xlsx e .xls
#	Como não tem a função no R básico, será necessário instalar e carregar o pacote readxl.
# install.packages('readxl')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.
library(readxl)

TMED <- read_excel(
  path = 'Tmed.xlsx',   # Caminho e nome do arquivo que será importado.
  sheet = 1,                    # Planilha de interesse.
  na = '-',                     # Identificação dos valores ausentes.
  skip = 2)                     # Número de linhas a serem ignoradas antes de ler os dados. 

View(TMED)   # Apresenta o conteúdo completo da base de dados em uma nova aba.
str(TMED)    # Retorna uma síntese da estrutura da base de dados.

# Obs.: Os dados estão no formato tibble.
# Tibbles são similares aos data frames, mas são diferentes em dois aspectos: impressão e indexação.

### Podemos acessar os elementos usando [ ]: dados[Linhas, Colunas]. 
TMED[ , 3]       # Retorna a terceira coluna da tabela de dados.
TMED[, c(4,7)]   # Retorna os dados das colunas 4 e 7.
TMED[1:7, 4:7]   # Retorna os dados das linhas 1 a 5 e colunas 4 a 7.

# Também podemos acessar os elementos usando o $.
TMED$UF   # Retorna os dados da coluna UF.

colnames(TMED)   # Lista os nomes das colunas.

# Vamos selecionar os dados de Piauí:
subset(TMED,                  # Objeto a ser filtrado.
       subset = UF == "PI")   # Condição que será aplicada. 

PI <- subset(TMED,                  # Objeto a ser filtrado.
             subset = UF == "PI",   # Condição que será aplicada. 
             select = c(2, 4:15))   # Seleciona colunas da tabela de dados.
View(PI)

# Vamos selecionar os dados Floriano-PI:
Floriano <- subset(x = PI, 
                   subset = `Nome da Estação` == "FLORIANO",
                   select = -1)   # Excluindo a coluna 1.
View(Floriano)

Meses = colnames(Floriano)
Temp = as.numeric(Floriano)

# Agora vamos criar um objeto data frame com as colunas Meses e Temp:
TF.df <- data.frame(Meses, Temp)
TF.df

# Para exportar os dados em csv ou txt, use a função write.table().
write.table(x = PI,                       # Nome do arquivo que será exportado.
            file = "PI.csv",              # Nome e extensão do arquivo que será gerado.
            dec = ",",                    # Separador de decimais.
            row.names = F,                # FALSE:  os nomes das linhas não devem ser considerados.
            sep = ";",                    # Separador de colunas.
            na = "NA",                    # Identificação dos valores ausentes.
            fileEncoding = "ISO-8859-1")  # Especifica a codificação a ser usada.

dir()   # Verifique os arquivos do diretório de trabalho.

# 7. GERANDO GRÁFICOS E MAPAS--------------------------------------------------#
# Visualização de dados usando o 'ggplot2'.
# install.packages('ggplot2')   # Se o pacote ainda não estiver instalado, remova o # e mande executar. 
library(ggplot2)

# No ggplot2, os gráficos são construídos camada por camada.
# A camada base é dada pela função ggplot(), que recebe o conjunto de dados.
ggplot(data = TF.df)

# É necessário especificar como as observações serão mapeadas nos aspectos visuais do gráfico 
# e quais formas geométricas serão utilizadas.

# A função geom_<FUNCTIONS>() define qual forma geométrica será utilizada para a visualização dos dados.
# Os mapeamentos estéticos são especificados por aes().

# Gerando gráficos de barra/coluna ---#
# Exemplo 1:
gb1 <- 
  ggplot(TF.df, aes(x = Meses, y = Temp)) +
  geom_col()
gb1

# Vamos transformar a coluna Meses em fator e ordenar os nomes:
TF.df$Meses2 <- factor(TF.df$Meses, levels = Meses)

# Exemplo 2:
gb2 <-
ggplot(TF.df, 
       aes(x = Meses2, y = Temp)) +   # Observações que serão mapeadas.
  geom_col()
gb2

# # Exemplo 3 - Configurando o gráfico:
gb3 <-
ggplot(TF.df, 
       aes(x = Meses2, y = Temp)) +                                   # Observações que serão mapeadas.
  geom_col(fill = "lightblue")+                                       # fill: altera a cor do preenchimento.
  labs(title = "Temperatura Média do Ar (1991-2020) de Floriano-PI",  # Título do gráfico.
       y = "Temperatura (ºC)",                                        # Alterando o rótulo do eixo y.
       x = "Meses",                                                   # Alterando o rótulo do eixo x.
       caption = "Elaborado por @proamb.r")+                          # Adicionado texto abaixo do gráfico.
  theme_light()+                                                      # Alterando o tema do gráfico.
  geom_text(aes(label = Temp),                                        # Adiciona o rótulo das barras.
            vjust = 1.2,                                              # Ajustando a posição vertical do rótulo das barras.
            colour = "blue")                                          # Definindo a cor do rótulo das barras.
gb3

# Pacote 'geobr'---#
# Vamos usar o pacote 'geobr' para acessar os shapefiles do Instituto Brasileiro de Geografia e Estatística (IBGE).
# O shapefile é um formato para bases de dados geoespaciais e vetoriais em sistemas de informação geográfica.

# install.packages('geobr')   # Se o pacote ainda não estiver instalado, remova o # e mande executar. 
library(geobr)                # Carregando o pacote.

View(list_geobr())     # Retorna a base de dados do pacote 'geobr'.

# Podemos usar a função read_state() para baixar os dados espaciais dos estados do Brasil.
Estados <- read_state(year = 2020)   # 2020 é o ano do conjunto de dados. 
View(Estados)

# Selecionando o estado de Piauí:
PI <- read_state(code_state = "PI")
View(PI)

# Podemos usar a função read_municipality() para baixar os dados espaciais dos municípios do Brasil.
Municipios <- read_municipality()
View(Municipios)

# Selecionando os municípios de Piauí:
PI.mun <- read_municipality(code_muni = "PI")
View(PI.mun)

# Selecionando o município de Picos-PI:
Picos <- read_municipality(code_muni= 2208007)

# Selecionando o município de Cerejeiras-PI:
Cerejeiras <- read_municipality(code_muni= 1100056)

# Gerando mapas ---#
# Exemplo 1:
mp1 <- 
  ggplot(data = PI, fill='lightyellow') +
  geom_sf()
mp1

# Nota: Cada função pode receber dados diferentes das demais, sendo que se mantivermos todas 
# as configurações da função aes() na função ggplot(), elas serão replicadas para as demais funções.

# Exemplo 2:
mp2 <- 
ggplot() +
  geom_sf(data = PI, fill='lightyellow')+                              # Desenha o estado de Piauí.
  geom_sf(data = PI.mun, fill='lightyellow', colour = "darkblue", )+   # Desenha os municípios de Piauí.
  geom_sf(data = Picos, fill='darkred')+                               # Desenha o município de Picos-PI.
  labs(title = "Estado de Piauí")+                                     # Título do gráfico.
  theme_light()                                                        # Tema do gráfico.
mp2

# Exemplo 3:
mp3 <-
  ggplot() +
  geom_sf(data = PI)+
  geom_sf(data = PI.mun, 
          aes(fill='Estado de Piauí'), 
          colour = "darkblue")+
  geom_sf(data = Picos, 
          aes(fill='Município de Picos-PI'))+
  labs(title = "Estado de Piauí", fill = NULL)+
  scale_fill_manual(values = c(`Estado de Piauí`='lightyellow', 
                               `Município de Picos-PI` = 'darkblue'))+
  theme_light()
mp3

# É possível salvar os gráficos e mapas em vários formatos, como jpeg, png, pdf.
# Para criar um arquivo jpeg, por exemplo, há a função jpeg:

# JPEG - Exemplo 1:
jpeg('Piauí_1.jpeg')   # Inicia o comando para salvar o gráfico.
mp3                    # Objeto que será salvo.
dev.off()              # Finaliza o comando para salvar o gráfico.


# JPEG - Exemplo 2:
jpeg('Piauí_2.jpeg',    # Inicia o comando para salvar o gráfico.
     width = 5,         # Comprimento.
     height = 4.5,      # Altura.
     units = 'in',      # Unidade ('px' (pixel), 'in' (polegada), 'cm', 'mm')
     res = 300)         # Resolução.
mp3                     # Objeto que será salvo.
dev.off()               # Finaliza o comando para salvar o gráfico

#------------------------------------------------------------------------------#
# Para salvar o gráfico de forma manual:
# Com o gráfico plotado na aba Plots clique em 'Export' e selecione 'Save as Image...' para salvar nos formatos PNG, JPEG e outros.
# Selecione o formato em 'Image Format' e escreva o nome da imagem em 'File name' depois clique em Ok.

#------------------------https://linktr.ee/pexcca.lamet------------------------#
