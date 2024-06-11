#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 02/07/2023                        #
#==============================================================================#
#                      ANÁLISE DE DADOS AMBIENTAIS NO R                        #
#------------------------------------------------------------------------------#
# TÓPICOS ABORDADOS:
# 1. Introdução;
# 2. Diretório de Trabalho e Projetos;
# 3. R Base e Pacotes;
# 4. Variáveis e Atribuições;
# 5. Download e Importação de Dados;
# 6. Funções e Comandos Essenciais;
# 7. Estatística Descritiva;
# 8. Apresentação e Visualização de Dados;
# 9. Diagramas de Dispersão e Correlação;
# 10. Exportação dos Resultados.

# 1. INTRODUÇÃO ---------------------------------------------------------------#
# R é uma linguagem de programação e ambiente de software gratuito, livre e código 
# aberto (open source). 

# O RStudio é um ambiente de desenvolvimento integrado, que fornece uma interface,
# gráfica mais amigável para programação em linguagem R.

# A interface do RStudio é dividida, inicialmente, em 3 partes:
#   1° - Console
#   2° - Environment, History...
#   3° - Files, Plots, Packages, Help...

# Podemos abrir um editor de texto (script):
## Manualmente (RStudio): Clique em File > New File > R Script. 
## Por atalho de teclado (RStudio): Ctrl + Shift + N.

## No script, para executar um comando, devemos colocar o cursor na linha do comando
## ou selecioná-lo e pressionar Ctrl + Enter (no RStudio) e o resultado será mostrado no console.

## Use # para fazer comentários.

## Para salvar o script, clique em File > Save As..., 
# dê um nome ao arquivo e inclua a extensão .R (editor de texto do R).

# 2. DIRETÓRIO DE TRABALHO E PROJETOS------------------------------------------#
# O diretório de trabalho é o local onde o R vai procurar e salvar os arquivos.
# A definição do diretório de trabalho é uma etapa opcional, mas que pode economizar
# muito tempo no processo de análise de dados.

getwd() # Informa o diretório de trabalho atual.
# setwd() # Seta um local como novo diretório. Ex.: setwd('C:/Users/Documentos/R')
## Nota: Na função setwd(), devemos usar a barra oblíqua (/) para definir o caminho.

## Definindo o diretório de trabalho:
## Manualmente: Session > Set Working Directory > Choose Directory
## Por atalho de teclado: Ctrl + Shift + H

# No RStudio podemos criar projetos, que nada mais é do que uma pasta no seu computador.
# A principal razão de utilizarmos projetos é a organização. 
# Uma maneira simples de gerenciar os scripts e dados que você pretende trabalhar.

# No menu 'File', clique em 'New Project'...
# Em seguida, clique em 'New Directory' para criar o projeto em uma nova pasta.
# Em 'Directory name', insira o nome para o diretório que será criado.
# Em 'Create project as subdirectory of', clique em 'Browse' e defina um subdiretório para o projeto.

# Se você tiver o Github instalado, você também pode usar projetos para conectar com 
# repositórios do Github. Para isso, clique em Version Control.

# 3. R BASE E PACOTES ---------------------------------------------------------#
# Na linguagem R, algumas funções estão implementadas no ambiente básico do R,
# ou seja, fazem parte da instalação básica do R.

# Além do R base, podemos instalar pacotes (packages) com funcionalidades específicas
# criadas por colaboradores.  

# Para usar as funções dos pacotes, é necessário fazer a instação conforme sua necessidade. 
installed.packages()   # Retorna todos os pacotes instalados, local e versão.

# Para instalar um pacote do R, podemos usar a função install.packages('nome_do_pacote'). 
# install.packages('readxl')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.
# Nota: O pacote pode ser desinstalado com a função remove.packages('nome_do_pacote').

# Após a instalação, o pacote deve ser carregado. 
# Podemos usar a função library(nome_do_pacote) ou require(nome_do_pacote).
library(readxl)   # Carrega o pacote.
require(readxl)   # Carrega o pacote.

# A função library(), por padrão, retorna um erro quando o pacote não está instalado. 
# A função require() retorna um warning caso o pacote não esteja instalado.

search()   # Retorna todos os pacotes carregados.
# Nota: Podemos descarregar um pacote com a função detach('package:nome_do_pacote').

ls('package:readxl')   # Lista os comandos do pacote.

# 4. VARIÁVEIS E ATRIBUIÇÕES --------------------------------------------------#
# As variáveis permitem armazenar valores, incluindo objetos, em um local da memória do software.
# Para acessar a informação armazenada, basta usar o nome da variável que a contém. 

# Para declarar uma variável e atribuir-lhe um valor/objeto podemos usar três métodos:
## Símbolo de atribuição <-
## Use o atalho ALT + - para inserir o sinal de atribuição (<-).
Temp1 <- 25.5
26.8 -> Temp2 #A ponta da seta está sempre voltada para o nome da variável.

## Símbolo de atribuição =
Temp2 = 30.2

## Função assign()
assign('Temp3', 29.5)

# Visualizar o conteúdo armazenado na variável:
## Coloque os comandos entre parênteses para executar e visualizar o resultado:
(Temp4 <- 19.6)

## Digite o nome da variável: 
Temp4

## Use a função print():
print(Temp4)

## Exibição concomitante:
Temp1; Temp2; Temp3; Temp4

# Regras para nomear variáveis na linguagem R:
## a) Devem sempre começar com uma letra ou um ponto. 
## b) Se iniciar com ponto, não pode ser seguido de um número.
## c) Os nomes das variáveis não podem conter espaços em branco. Para separar 
## palavras, utiliza-se o underline (_). 
## d) Não usar palavras reservadas da linguagem, como if, for, while, entre outras.

#  a) O R/RStudio diferencia letras maiúsculas de letras minúsculas.
#  b) Por padrão, o separador decimal utilizado é o ponto (.). 
#  c) A vírgula (,) é reservada para separar diferentes objetos dentro de uma função.

# Listagem e remoção de variáveis (e outros objetos):
ls()                  # Lista todas as variáveis (e outros objetos) armazenadas.
remove(Temp1)         # Remove variável(eis) ou objeto(s) especificado(s). 
rm(Temp2)             # Também remove variável(eis) ou objeto(s) especificado(s).                
rm(Temp3, Temp4)                 
remove(list = ls())   # Remove todas as variáveis (e outros objetos) criadas na sessão.

# 5. DOWNLOAD E IMPORTAÇÃO DE DADOS -------------------------------------------#
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

#------------------------------------------------------------------------------#
dir.create(path = 'Dados')          # Criando uma pasta denominada 'Dados' no diretório de trabalho.
file.copy('Tmed.xlsx', './Dados')   # Copiando o arquivo 'TMED.xlsx' para a pasta 'Dados'.
file.remove('Tmed.xlsx')            # Removendo o arquivo 'TMED.xlsx' do diretório de trabalho.

dir('./Dados')   # Verifique os arquivos dentro da pasta 'Dados'.

#------------------------------------------------------------------------------#
##	Importação de dados em .xlsx e .xls
#	Como não tem a função no R básico, será necessário instalar e carregar o pacote readxl.
# install.packages('readxl')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.
library(readxl)

TMED <- read_excel(
  path = './Dados/Tmed.xlsx',   # Caminho e nome do arquivo que será importado.
  sheet = 1,                    # Planilha de interesse.
  na = '-',                     # Identificação dos valores ausentes.
  skip = 2)                     # Número de linhas a serem ignoradas antes de ler os dados. 

View(TMED)   # Apresenta o conteúdo completo da base de dados em uma nova aba.
str(TMED)    # Retorna uma síntese da estrutura da base de dados.

# Obs.:
# 1. Os dados estão no formato tibble.
# 2. Tibbles são similares aos data frames, mas são diferentes em dois aspectos: impressão e indexação.
#	3. Por padrão, apenas as dez primeiras linhas da base são apresentadas.
#	4. Também são apresentadas a dimensão da tabela e as classes de cada coluna.
#	5. dbl (double): com precisão dupla, que armazena a parte fracionária com maior precisão.

head(TMED, n = 5)     # Retorna as primeiras n linhas (por padrão 5 linhas). 
tail(TMED, n = 5)     # Retorna as últimas n linhas (por padrão 5 linhas). 

### Podemos acessar os elementos usando [ ]: dados[Linhas, Colunas]. 
TMED[ , 3]       # Retorna a terceira coluna da tabela de dados.
TMED[, c(4,7)]   # Retorna os dados das colunas 4 e 7.
TMED[1:7, 4:7]   # Retorna os dados das linhas 1 a 5 e colunas 4 a 7.

# Também podemos acessar os elementos usando o $.
TMED$UF   # Retorna os dados da coluna UF.

attach(TMED)  # Permite acessar os elementos individualmente (sem necessidade de $).

colnames(TMED)                  # Lista os nomes das colunas.
colnames(TMED)[2] <-'Estação'   # Alterando o nome da 2º coluna.

# 6. FUNÇÕES E COMANDOS ESSENCIAIS --------------------------------------------#
## Operador pipe (%>%):
#  O operador pipe facilita a construção e leitura de uma série de comandos interligados, 
#  o que será essencial para o processamento e análise de dados.

# O operador pipe do pacote 'magrittr' é representado por %>%.
# install.packages('magrittr')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.
library(magrittr)

# A ideia do operador pipe %>% é usar o valor resultante da expressão do lado esquerdo 
# como primeiro argumento da função do lado direito. 
# Ele recebe o resultado de uma expressão e passa ele adiante.
# Para o atalho de teclado do pipe, tecle ctrl + shift + m.

# Ex.:
head(TMED)
TMED %>% head()

# Criando sumários:
TMED %>% summary()   # Retorna um resumo dos dados.

# Função by e tapply: agrupa os dados de acordo uma variável a partir de uma função.

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
  TMED %>%                      # Objeto a ser filtrado.
  subset(subset = UF == 'RJ')   # Condição que será aplicada. 
RJ %>% View()

RJ2 <-
  TMED %>%                      # Objeto a ser filtrado.
  subset(subset = UF == 'RJ',   # Condição que será aplicada. 
         select = c(2, 4:15))   # Seleciona colunas da tabela de dados.
RJ2 %>% View()

# 7. ESTATÍSTICA DESCRITIVA----------------------------------------------------#
# As medidas descritivas mais comuns utilizadas para resumir os dados numéricos 
# são as medidas de tendência central e dispersão.

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

# Vamos calcular as medidas descritivas usando a função summarise() do pacote 'dplyr'.
# install.packages('dplyr')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.  
library(dplyr)

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
                   sd, na.rm = T))
View(DP)

# Com o auxílio do comando groupy_by() podemos ainda agrupar os dados para a sumarização.
DP.UF <- 
  TMED %>% 
  group_by(UF) %>%
    summarise(across(4:15,             # Selecionando as colunas 4 a 15.
                   sd, na.rm = T))
View(DP.UF)

# Calculando a média (mean), mediana (median) e desvio padrão (sd):
T.md <- 
  TMED %>% 
  group_by(UF) %>%
  summarise(across(4:15, 
                   list(Média = mean, 
                        Mediana = median,
                        DP = sd), na.rm = T))
View(T.md)

# 8. APRESENTAÇÃO E VISUALIZAÇÃO DE DADOS--------------------------------------#

RJ %>% View()

# Pivotando os dados para obter três colunas: Estações, Meses e Temperatura.
# Vamos usar a função pivot_longer() do pacote 'tidyr'.

# install.packages('tidyr')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.
library(tidyr)

RJmensal <- 
RJ[, -c(1, 3, 16)] %>% 
pivot_longer(cols = 2:13,          # Selecionado as colunas.
             names_to = 'Mês',   # Nome da coluna com os meses.
             values_to = 'Tmed')   # Nome da coluna com os valores de temperatura.
RJmensal %>% View()

# Visualização de dados usando o 'ggplot2'.
# install.packages('ggplot2')   # Se o pacote ainda não estiver instalado, remova o # e mande executar. 
library(ggplot2)

# No ggplot2, os gráficos são construídos camada por camada.
# A camada base é dada pela função ggplot(), que recebe o conjunto de dados.

TMED %>%
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
# Boxplot (diagrama de caixa): geom_boxplot().

# O boxplot é um gráfico utilizado para avaliar a distribuição dos dados.
# Fornece como resultado informações como: valores máximo e mínimo, amplitude amostral, 
# quartis, mediana e outliers (valores atípicos que se distanciam da massa de dados).

bp1 <- 
  TMED %>%
  ggplot() +
  geom_boxplot(mapping = aes(y = Ano),   # Observações que serão mapeadas.
               fill = 'lightblue')       # fill: altera a cor do preenchimento.
bp1

bp2 <- 
  TMED %>%
  ggplot() +
  geom_boxplot(mapping = aes(y = Ano, x = UF),
               fill = 'lightblue', 
               outlier.shape = 19)     # Use outlier.shape = NA para ocultar os outliers.
bp2

# No boxplot, por padrão, os outliers são os valores fora de:
## Q1 - 1.5 *(Q3 - Q1) e Q3 + 1.5 * (Q3 - Q1)
### Q1 = 1º quartil; Q3 = 3º quartil.

# Limite Inferior (LI): o próximo valor existente da variável a partir do LI calculado.
## LI (calculado) = Q1 - 1.5*(Q3 - Q1)

# Limite Superior (LS): O valor anterior existente da variável a partir do LS calculado.
## LS (calculado) = Q3 + 1.5*(Q3 -Q1).

#------------------------------------------------------------------------------#
# Boxplot por subgrupos/categorias.

RJmensal %>% str()

# Vamos transformar a coluna 'Estação' em fator/categoria.
RJmensal$Estação <- 
  RJmensal$Estação %>% 
  as.factor()  

# Boxplot da temperatura média por Estação.
bp3 <-
  RJmensal %>%
  ggplot() +
  geom_boxplot(mapping = aes(y = Tmed, x = Estação, fill = Estação))
bp3

#------------------------------------------------------------------------------#
# A função stat_summary() pode ser usada para adicionar pontos médios a um boxplot.

bp4 <- 
  bp3 +
  stat_summary(mapping = aes(y = Tmed, x = Estação), 
               fun = mean,          # Definindo a função que vai receber os dados e deve retornar um único valor.
               geom = 'point',      # Objeto geométrico a ser usado para exibir os dados.
               shape = 16,          # Definir a forma do símbolo.
               size = 2,            # Definir o tamanho.
               col = 'darkblue')    # Definir a cor.
bp4

#------------------------------------------------------------------------------#
# Ajustando a legenda e o tema:
bp5 <- 
  bp4 + 
  scale_y_continuous(name = 'Temperatura Média (ºC)',
                     limits = c(15, 30),         # Alterando o limite do eixo y.
                     breaks = seq(15, 30, 2)) +  # Alterando o rótulo do eixo y.
  scale_fill_brewer(palette = 'Pastel1')+        # Alterando a escala de cores dos preenchimentos das áreas.
  theme_minimal() +                              # Alterando o tema do gráfico.          
  theme(legend.position = 'bottom',              # Definindo a posição da legenda. 
        legend.direction='horizontal')+          # Definindo a direção da legenda.
  guides(fill = guide_legend(nrow = 1))+         # Ajustando a legenda em 1 linha.
  labs(title = 'Temperatura Média (1991-2020) de Estações Meteorológicas de Campos-RJ',
       fill = NULL, x = 'Municípios')
bp5

#------------------------------------------------------------------------------#
# Boxplot com pontos: todos os pontos podem ser adicionados usando a função geom_jitter().

bp5 +
  geom_jitter(aes(y = Tmed, x = Estação))

bp6 <- 
  bp5 +
  geom_jitter(aes(y = Tmed, x = Estação),
              shape = 16,	  	     # Definir a forma.
              width = .1,	         # Definir o espalhamento dos pontos.
              alpha = .3,	  	     # Alterar a transparência das formas.
              size = 1,	    	     # Definir o tamanho.
              color = 'black')+	   # Definir a cor.
  theme(legend.position = 'none')  # Remove a legenda.
bp6

# 9. DIAGRAMAS DE DISPERSÃO E CORRELAÇÃO---------------------------------------#

# 1º Vamos selecionar as colunas de Janeiro a Dezembro do conjunto de dados RJ.
View(RJ)

RJ.t <-
  RJ %>%                                  # Objeto a ser filtrado.
  subset(select = Janeiro:Dezembro) %>%   # Seleciona colunas da tabela de dados.
  t() %>%                                 # Matriz transposta.
  data.frame()                            # Transformando em dataframe.
RJ.t %>% View()

colnames(RJ.t) <- RJ$Estação

## Diagrama de dispersão: representação gráfica para visualizar a relação entre duas variáveis.
bp7 <- 
  RJ.t %>% 
  ggplot(aes(x = CAMPOS,
             y = CORDEIRO)) +
  geom_point(color = 'blue')+
  geom_smooth(method = 'lm', se = T, fill='darksalmon')+   # Inserindo a reta de regressão linear.
  theme_minimal()
bp7

# Com a função geom_smooth() inserimos uma reta, e usando o método “lm” estamos 
# definindo que queremos uma reta de regressão linear.

# Nota: Cada função pode receber dados diferentes das demais, sendo que se mantivermos todas 
# as configurações da função aes() na função ggplot(), elas serão replicadas para as demais funções.

## Correlação: é uma medida que permite mensurar a relação entre duas variáveis.
# A função cor() retorna a correlação entre dois vetores ou uma matriz.
cor(RJ.t$CAMPOS, RJ.t$CORDEIRO, 
    method = 'pearson',   # method='pearson': coeficiente de correlação de Pearson.
    use = 'complete.obs') # use='complete.obs': removendo todos os casos com valores omissos (dados ausentes).

# A função cor.test() também calcula o coeficiente de correlação, mas ela traz mais detalhes.
cor.test(RJ.t$CAMPOS, RJ.t$CORDEIRO, 
         method = 'pearson', conf.level = 0.95)

# Matriz de correlação:
(cor.dados <- cor(RJ.t, 
                  method = 'pearson', use = 'complete.obs'))

#------------------------------------------------------------------------------#
# Visualização de uma matriz de correlação usando o pacote 'GGally'.
# install.packages('GGally')   # Se o pacote ainda não estiver instalado, remova o # e mande executar.
library(GGally)

RJ.t %>% ggpairs(lower = list(continuous = 'smooth'))

RJ.t %>% ggpairs(lower = list(continuous = 'smooth'),
                 diag = list(continuous = wrap('barDiag')),
                 upper = list(continuous = wrap('cor', size = 3)))

# 10. EXPORTAÇÃO DOS RESULTADOS------------------------------------------------#

# Para exportar os dados em csv ou txt, use a função write.table().
write.table(x = RJ.t,                         # Nome do arquivo que será exportado.
            file = 'RJ.csv',                  # Nome e extensão do arquivo que será gerado.
            dec = ',',                        # Separador de decimais.
            row.names = TRUE,                 # FALSE: os nomes das linhas não devem ser considerados.
            sep = ';',                        # Separador de colunas.
            na = 'NA',                        # Identificação dos valores ausentes.
            fileEncoding = 'ISO-8859-1')      # Especifica a codificação a ser usada.

#------------------------------------------------------------------------------#
# Exportando gráficos com linhas de comando. 

# É possível salvar os gráficos em vários formatos, como jpeg, png, pdf.
# No primeiro argumento filename, especifique o nome do arquivo a salvar.
# Para criar um arquivo jpeg, por exemplo, há a função jpeg:

# JPEG - Exemplo 1:
jpeg('Boxplot_1.jpeg') # Inicia o comando para salvar o gráfico.
bp6                    # Objeto que será salvo.
dev.off()              # Finaliza o comando para salvar o gráfico.

# JPEG - Exemplo 2:
jpeg('Boxplot_2.jpeg',  # Inicia o comando para salvar o gráfico.
     width = 9,         # Comprimento.
     height = 5,        # Altura.
     units = 'in',      # Unidade ('px' (pixel), 'in' (polegada), 'cm', 'mm')
     res = 300)         # Resolução.
bp6                     # Objeto que será salvo.
dev.off()               # Finaliza o comando para salvar o gráfico

#------------------------------------------------------------------------------#
# Para salvar o gráfico de forma manual:
# Com o gráfico plotado na aba Plots clique em 'Export' e selecione 'Save as Image...' para salvar nos formatos PNG, JPEG e outros.
# Selecione o formato em 'Image Format' e escreva o nome da imagem em 'File name' depois clique em Ok.

#------------------------https://linktr.ee/pexcca.lamet------------------------#
