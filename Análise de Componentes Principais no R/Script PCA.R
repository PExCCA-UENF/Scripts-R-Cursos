#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 26/05/2025                        #
#==============================================================================#

#                    ANÁLISE DE COMPONENTES PRINCIPAIS NO R                    #
#-------------------------------------------------------------------------------

# 1. INTRODUÇÃO E CONCEITOS BÁSICOS--------------------------------------------#

# Neste curso, exploraremos uma das técnicas mais poderosas e amplamente utilizadas
# em estatística e análise de dados: a Análise de Componentes Principais (Principal 
# Component Analysis - PCA). A PCA é uma ferramenta essencial para a redução da 
# dimensionalidade e visualização de dados, permitindo transformar um grande número 
# de variáveis correlacionadas em um conjunto menor de variáveis não correlacionadas, 
# chamadas de "componentes principais".

# A PCA busca reduzir a dimensionalidade dos dados, projetando as variáveis originais
# em um novo espaço de coordenadas, no qual as novas variáveis (os componentes 
# principais) são combinações lineares das variáveis originais. Pode ser usada para 
# redução dos dados ou simplificação de sua estrutura. Também pode ser usada para 
# reconhecimento de padrão, classificação e agrupamento.

# O principal objetivo da PCA é encontrar os "componentes" que maximizam a variação 
# nos dados. Os componentes principais são as novas variáveis obtidas pela PCA. 
# Cada componente é uma combinação linear das variáveis originais, e os componentes 
# são ordenados de acordo com a quantidade de variação que eles explicam nos dados. 
# O primeiro componente principal explica a maior parte da variação, o segundo 
# explica a segunda maior parte, e assim por diante.

# Durante o curso, você terá a oportunidade de trabalhar com um conjunto de dados 
# real, no qual aplicaremos a técnica de PCA passo a passo. O RStudio será a plataforma 
# utilizada para a implementação de todo o processo.

# 2. IMPORTAÇÃO E PREPARAÇÃO DOS DADOS-----------------------------------------#

# Primeiro, vamos criar um projeto para o nosso curso. A principal razão de utilizarmos 
# projetos é a organização. Uma maneira simples de gerenciar os scripts e dados 
# que você pretende trabalhar.

# No menu "File", clique em "New Project"...
# Em seguida, clique em "New Directory" para criar o projeto em uma nova pasta.
# Em "Directory name", insira o nome para o diretório que será criado.
# Em "Create project as subdirectory of", clique em "Browse" e defina um subdiretório para o projeto.

## Download e importação dos dados---#

# Vamos fazer download de dados de Temperatura Média Compensada Mensal e Anual (°C)
# do Instituto Nacional de Meteorologia (INMET). 

# Link para baixar os dados:
url <- "https://portal.inmet.gov.br/uploads/normais/Normal-Climatologica-TMEDSECA.xlsx"

# Use a função download.file() para baixar o arquivo conforme descrito por url da Internet.
download.file(url,           # URL do arquivo que você deseja baixar.
              "TMED.xlsx",   # Nome e extensão do arquivo que será gerado.
              mode = "wb")   # Modo "wb" significa "write binary" (escrever em modo binário). 

## Obs.: 
# 1. Modo "wb" é necessário ao baixar arquivos que não são de texto puro, como imagens, planilhas, arquivos compactados, etc. 
# 2. Quando o caminho não é especificado para salvar o arquivo, o arquivo é salvo no diretório de trabalho.

getwd()	# Verifique o diretório de trabalho atual.
dir()   # Verifique os arquivos do diretório de trabalho.

#------------------------------------------------------------------------------#
dir.create(path = "Dados")          # Criando uma pasta denominada "Dados" no diretório de trabalho.
file.copy("TMED.xlsx", "./Dados")   # Copiando o arquivo "TMED.xlsx" para a pasta "Dados".
file.remove("TMED.xlsx")            # Removendo o arquivo "TMED.xlsx" do diretório de trabalho.

dir("./Dados")   # Verifique os arquivos dentro da pasta "Dados".

#------------------------------------------------------------------------------#
##	Importação de dados em .xlsx e .xls---#
#	Como não tem a função no R básico, será necessário instalar e carregar o pacote readxl.

if (!require(readxl)) install.packages("readxl")  # Instalando o pacote "readxl", caso necessário.
library(readxl) # Carregando o pacote "readxl".

TMED <- read_excel("./Dados/TMED.xlsx",  # Nome do arquivo que será importado.
                   sheet = 1,            # Planilha de interesse.
                   na = "-",             # Identificação dos valores ausentes.
                   skip = 2)             # Número de linhas a serem ignoradas antes de ler os dados. 

View(TMED)  # Apresenta o conteúdo completo da base de dados em uma aba.
str(TMED)   # Mostra a estrutura dos dados.

# Obs.:
# 1. Os dados estão no formato tibble.
# 2. Tibbles são similares aos data frames, mas são diferentes em dois aspectos: impressão e indexação.
#	3. Por padrão, apenas as dez primeiras linhas da base são apresentadas.
#	4. Também são apresentadas a dimensão da tabela e as classes de cada coluna.
#	5. dbl (double): com precisão dupla, que armazena a parte fracionária com maior precisão.

#------------------------------------------------------------------------------#
## Operador Pipe---#
## Neste curso, vamos utilizar o operador pipe que é uma das funcionalidades mais 
## populares na comunidade R. Ele facilita a construção e leitura de uma série de 
## comandos interligados, o que será essencial para análise exploratória de dados multivariados.

## O operador pipe foi introduzido pelo pacote `magrittr`, criado por Stefan Milton 
## Bache e Hadley Wickham, representado por `|>`. Devido ao seu grande sucesso, 
## a equipe principal da linguagem R implementou na linguagem uma versão do pipe
## nativo com a sintaxe `|>`, que está disponível a partir da versão 4.1 do R. 

## A ideia do operador pipe é usar o valor resultante de uma expressão como
## primeiro argumento da próxima função, possibilitando o encadeamento de funções.
## Podemos usá-lo facilmente com o atalho Ctrl + Shift + M.

# Ex.:
mean(TMED$Ano, na.rm = T)

TMED$Ano |> 
  mean(na.rm = T)		# Calculando a média usando o pipe.

## Para ativar o atalho Ctrl + Shift + M para o operador pipe nativo (|>), no Windows,
## basta irmos no menu Tools → Global Options → Code e ativar a caixa 'Use native pipe operator, |> (requires R.4.1+)'.

#------------------------------------------------------------------------------#
# Para organização, análise e visualização de dados, vamos usar o 'tidyverse', que 
# é uma coletânea de pacotes da linguagem R construídos para a ciência de dados. 
# Todos os pacotes compartilham uma mesma filosofia de design, gramática e estrutura 
# de dados, facilitando a programação.

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

## Preparando os dados---#
TMED_mensal <- TMED |>
  dplyr::select(`Nome da Estação`: Dezembro) |>  # Selecionando as colunas que vão de 'Nome da Estação' até a coluna 'Dezembro'.
  stats::na.omit() |> # Removendo as estações meteorológicas com dados ausentes.
  print()

# 3. ANÁLISE EXPLORATÓRIA DE DADOS MULTIVARIADOS-------------------------------#

## Medidas de Posição ou Tendência Central---#

# Vamos calcular as medidas descritivas usando a função summarise() do pacote "dplyr".
# A função summarise() agrega sumarizações unindo diversos cálculos ao longo de uma base de dados.

# Calculando a média (mean):
TMED_mensal  |>  
  dplyr::summarise(TMED.jan = mean(Janeiro, na.rm = T),
            TMED.fev = mean(Fevereiro, na.rm = T))

# Com o auxílio do comando groupy_by() podemos ainda agrupar os dados para a sumarização.
TMED_mensal |> group_by(UF) |>
  dplyr::summarise(TMED.jan = mean(Janeiro, na.rm = T),
            TMED.fev = mean(Fevereiro, na.rm = T))

# Use a função across() com a função summarise() para facilitar a execução da mesma operação em várias colunas.
TMED_mensal |> group_by(UF) |>
  dplyr::summarise(across(2:13,  # Selecionando as colunas 2 a 13.
                   mean, na.rm = T))

# Calculando a média (mean) e a mediana (median):
TMED.med <- 
  TMED_mensal  |> group_by(UF) |>
  dplyr::summarise(across(2:13, 
                   list(Média = mean, Mediana = median), na.rm = T))
View(TMED.med)

## Visualização e apresentação de dados com ggplot2---#

# No ggplot2, os gráficos são construídos por camadas. A camada base é construída 
# com o conjunto de dados pela função ggplot(). É possível fazer a combinação 
# dessa camada base com outras funções, como o geom_histogram().

TMED_mensal |>
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
# Boxplot (diagrama de caixa): geom_boxplot()

# O boxplot é um gráfico utilizado para avaliar a distribuição dos dados. Fornece como 
# resultado informações como: valores máximo e mínimo, amplitude amostral, quartis, 
# mediana e outliers (valores atípicos que se distanciam da massa de dados).

TMED_mensal |>
  ggplot2::ggplot() +
  geom_boxplot(mapping = aes(y = Janeiro),  # Observações que serão mapeadas.
               fill = "lightblue")                   # fill: altera a cor do preenchimento.

#------------------------------------------------------------------------------#
# Boxplot por subgrupos/categorias.

# Precisamos, primeiramente, transformar as colunas categóricas em fator.

TMED_mensal$UF <- 
  TMED_mensal$UF |> 
  as.factor()  # Transformando a coluna "UF" em fator/categoria.

# Podemos usar a informação da Unidade Federativa (UF) para montar o boxplot.

gr1 <-
  TMED_mensal |>
  ggplot2::ggplot() +
  geom_boxplot(mapping = aes(y = Janeiro, x = UF,
                             fill = UF))
gr1

# Esse gráfico pode ser customizado, alterando o seu estilo, informações dos 
#rótulos e paleta de cores. 

gr2 <- 
  gr1 + 
  scale_y_continuous(name = "Temperatura Média Anual (ºC)", 
                     breaks = seq(12, 30, 2)) +  # Alterando o rótulo do eixo y.
  scale_fill_viridis_d(option = "turbo") +       # Alterando a escala de cores dos preenchimentos das áreas.
  theme_minimal() +                              # Alterando o tema do gráfico.          
  theme(legend.position = "right")               # Definindo a posição da legenda.   
gr2

#------------------------------------------------------------------------------#
# A função stat_summary() pode ser usada para adicionar pontos médios a um boxplot:

gr3 <- 
  gr2 +
  ggplot2::stat_summary(mapping = aes(y = Janeiro, x = UF), 
               fun = mean,        # Definindo a função que vai receber os dados e deve retornar um único valor.
               geom = "point",    # Objeto geométrico a ser usado para exibir os dados.
               shape = 16,        # Forma dos pontos.
               size = 1,          # Tamanho dos pontos.
               col = "blue")      # Cor dos pontos.
gr3

#------------------------------------------------------------------------------#
# Boxplot com pontos: todos os pontos podem ser adicionados usando a função geom_jitter().

gr3 +
  ggplot2::geom_jitter(aes(y = Janeiro, x = UF))

gr4 <- 
  gr3 +
  ggplot2::geom_jitter(aes(y = Janeiro, x = UF),
              shape = 16,	  	     # Definir a forma.
              width = .1,	         # Definir o espalhamento dos pontos.
              alpha = .3,	  	     # Alterar a transparência das formas.
              size = 1,	    	     # Definir o tamanho.
              color = "black")+	   # Definir a cor.
  theme(legend.position = "none")  # Remove a legenda.
gr4

#------------------------------------------------------------------------------#
### Covariância e Correlação: medem a relação linear entre duas variáveis. 

# Os valores de covariância não são padronizados, podem variar de menos infinito a mais infinito.
# Os coeficientes de correlação são padronizados, podem variar entre -1 e +1.

# A função cov() retorna a covariância entre dois vetores ou uma matriz:
TMED_mensal |> 
  select(Janeiro:Dezembro)|> 
  cov()

# Para escolher o método de correlação, precisamos saber se os dados seguem uma 
# distribuição normal. Existem diferentes testes para normalidade multivariada, 
# e aqui vamos utilizar o pacote 'MVA'. Para detalhes do pacote acesse o link:
# https://pdfs.semanticscholar.org/5f56/fddab96311b6ff592fe1f1f59093809900a3.pdf

if (!require(MVN)) install.packages("MVN")  # Instalando o pacote "MVN".
library(MVN)

# Testando a normalidade multivariada:
TMED_mensal |> 
  select(Janeiro:Dezembro)|> 
  mvn()

## Nenhuma variável segue uma distribuição normal, logo, o método de Pearson não 
## deve ser usado. Vamos utilizar o método de Spearman na correlação.

# A função cor() retorna a correlação entre dois vetores ou uma matriz:
Cor.dados <- 
    TMED_mensal |> 
    select(Janeiro:Dezembro)|> 
    cor(method = "spearman") |> 
  print()

# Use o pacote "ggcorrplot" para visualizar a matriz de correlação usando ggplot2.
if (!require(ggcorrplot)) install.packages("ggcorrplot")  # Instalando o pacote "ggcorrplot".
library(ggcorrplot)               

# Visualização da matriz de correlação:
Cor.dados |> 
  ggcorrplot(hc.order = TRUE,     # Se TRUE, reordena as variáveis, colocando as variáveis com padrões de correlação semelhantes juntas.
             type = "lower",       # Exibição inferior da matriz.
             lab = T,              # Se TRUE, adicione o coeficiente de correlação no gráfico.
             lab_size = 3,         # Tamanho do rótulo.
             method = "circle",    # Método de visualização da matriz de correlação a ser usado.
             colors = c("#D81B60", "white", "#1E88E5"),  # Definindo as cores para valores de correlação baixo, médio e alto.
             legend.title = "Correlação",                     # Alterando o título da legenda.
             ggtheme = theme_bw)                              # Definindo o tema do gráfico.

# Podemos calcular o p-valor para verificar se essas correlações são significativas.

p.mat = cor_pmat(Cor.dados) 

# O p.mat calcula as matrizes de correlação e p-valor para observar a existência 
# de significância estatística entre as variáveis do conjunto de dados.

p.mat

# Vamos inserir o valor calculado no gráfico de correlação utilizando o "p.mat".
Cor.dados |> 
  ggcorrplot(hc.order = TRUE,
             type = "lower",       
             lab = T,              
             lab_size = 3,         
             method = "circle",    
             colors = c("#D81B60", "white", "#1E88E5"),  
             legend.title = "Correlação",                     
             p.mat = p.mat,    # Adicionando a informação da significância da correlação.
             ggtheme = theme_bw) 

#------------------------------------------------------------------------------#
# 4. ANÁLISE DE COMPONENTES PRINCIPAIS OU PCA (PRINCIPAL COMPONENT ANALYSIS)

# No R, existem dois métodos para executar a PCA: 
# 1. Função princomp(): decomposição espectral de uma matriz em um conjunto de autovalores.
# 2. Função prcomp(): o cálculo é feito por uma decomposição de valor singular da matriz de dados.

# A normalidade multivariada dos dados NÃO é um requisito para utilizar a PCA.

# Função princomp().
# Decomposição espectral de uma matriz em um conjunto de autovalores.

res.pca <- 
  TMED_mensal |> 
  select(Janeiro:Dezembro)|> 
  princomp(cor = T)    # Usando a matriz de correlação no cálculo.

res.pca |> 
  summary()   # Resumo dos objetos da PCA.

res.pca |> 
  loadings()   # Carregamentos (loadings) de cada variável nas componentes principais.

# Visualização dos resultados usando o pacote "factoextra".
if (!require(factoextra)) install.packages("factoextra")  # Instalando o pacote "factoextra".
library(factoextra)   

# Visualização das variâncias das dimensões (CPs):
res.pca |> 
  factoextra::fviz_screeplot(addlabels = T)

# Visualização da variância por outro comando, o fviz_eig().
res.pca |> 
  factoextra::fviz_eig(choice = "variance",
                       addlabels = T)

# Visualização dos autovalores (eigenvalue) das dimensões:
res.pca |>
  factoextra::fviz_eig(choice = "eigenvalue",
                       addlabels = T)

# A escolha do número de componentes principais pode ser considerando o(a):
# Percentual de variância explicada (acima de 70%); 
# Número de autovalores maiores do que 1 (critério Kaiser);
# Gráfico screeplot;
# Experiência do pesquisador. 

# Use a função fviz_pca_var() para plotar as variáveis. Gráfico de loadings:
res.pca |> 
  factoextra::fviz_pca_var()

# Novo conjunto de dados baseado na função princomp():
comp <- 
  res.pca$scores |> 
  round(3)
comp

# Salvando os dados da PCA em arquivo de valores separado por vírgula (csv):
write.table(comp,                      # Dados a ser salvo.
            file="PCA_princomp.csv",   # Nome e extensão do arquivo a ser salvo.
            sep = ";",                 # Separador de colunas. 
            quote = FALSE)             # Se TRUE, qualquer coluna de caractere ou fator será colocada entre aspas duplas.

#------------------------------------------------------------------------------#
# Função prcomp().
# O cálculo é feito por uma decomposição de valor singular da matriz de dados.

res.pca2 <- 
  TMED_mensal |> 
  select(Janeiro:Dezembro)|> 
  stats::prcomp(center = T,   # center: se TRUE, ajuda os dados de acordo com a média.
                scale = T)    # scale: se TRUE, padroniza os dados de entrada.

res.pca2 |> 
  summary()       # Resumo dos objetos da PCA.

res.pca2$rotation   # Carregamentos (loadings) de cada variável nas componentes principais.

# Visualização das variâncias das dimensões:
res.pca2 |> 
  factoextra::fviz_eig(choice = "variance",
                       addlabels = T)

# Visualização dos autovalores das dimensões:
res.pca2 |>
  factoextra::fviz_eig(choice = "eigenvalue",
                       addlabels = T)

# Use a função fviz_pca_var() para plotar as variáveis:
res.pca2 |> 
  factoextra::fviz_pca_var(
  col.var = "contrib",           # Cor por contribuições nas componentes principais 1 (Dim1) e 2 (Dim2).
  legend.title = "Contribuição", # Alterando o título da legenda.        
  repel = T)                     # Texto não sobreposto. 

#------------------------------------------------------------------------------#
### PCA com os dados de temperatura média do Sudeste do Brasil (SEB).

# Selecionando os dados do SEB e transformando em data frame:

SEB <- TMED_mensal |> 
  dplyr::filter(UF %in% c("RJ", "SP", "ES", "MG")) |>
  data.frame()
View(SEB)

# Definindo os nomes das linhas:
rownames(SEB) <- paste(SEB$UF, 
                       SEB$Nome.da.Estação, 
                       sep="_") 

# Removendo a informação das UF não utilizadas.
SEB$UF = droplevels(SEB$UF) 
  

#------------------------------------------------------------------------------#
# PCA: função prcomp() - método da decomposição em valor singular gera mais confiabilidade numérica.

res.pca3 <- 
  SEB |> 
  dplyr::select(Janeiro:Dezembro) |> 
  stats::prcomp(center = T,   # center: se TRUE, ajuda os dados de acordo com a média.
                scale = T)    # scale: se TRUE, padroniza os dados de entrada.
res.pca3

res.pca3 |> 
  summary()   # Resumo dos objetos da PCA.

res.pca3$loadings |> 
  unclass()    # Carregamentos (loadings) de cada variável nas componentes principais.

res.pca3$scores               # Novos escores para as observações.

# Visualização das variâncias das dimensões:
gpca1 <- 
  res.pca3 |> 
  factoextra::fviz_screeplot(geom = c("bar", "line"),   # Geometria a ser usada no gráfico.
               linecolor = "red",   # Cor da linha.
               addlabels = T)       # Se TRUE, os rótulos são adicionados.
gpca1

# Visualização dos autovalores das dimensões:
gpca2 <- 
  res.pca3 |>
  factoextra::fviz_eig(choice = "eigenvalue",
                       addlabels = T)
gpca2

# PCA: gráfico dos indivíduos.
gpca3 <-
  res.pca3 |>
  factoextra::fviz_pca_ind(geom = c("point", "text"),   # Geometria a ser usada no gráfico.
               pointsize = 2,                # Tamanho do ponto.
               pointshape = 21,              # Forma do ponto.
               fill = "lightblue",           # Cor do preenchimento.
               labelsize = 2,                # Tamanho do rótulo.
               repel = T)                    # Texto não sobreposto. 
gpca3


# Gráfico dos indivíduos: preenchimento por contribuição.
gpca4 <- 
res.pca3 |>
  factoextra::fviz_pca_ind(col.ind = "contrib",         # Cor por contribuições nas componentes principais 1 (Dim1) e 2 (Dim2).
               legend.title = "Contribuição",           # Alterando o título da legenda. 
               repel = T) +                             # Texto não sobreposto.
               scale_color_gradient2(low = "steelblue", # Criando um gradiente de cores.
                        mid = "gold3", 
                        high = "red4", 
                        midpoint = 6)  
gpca4

# Adicionando o preenchimento das geometrias de acordo com o UF.
gpca5 <- 
  res.pca3 |>
  factoextra::fviz_pca_ind(geom = "point",    # Geometria a ser usada no gráfico.
               habillage = SEB$UF)            # Especificar uma variável qualitativa a ser usada para colorir os indivíduos por grupos.
gpca5

# Adicionando elipse de confiança. Ela é uma representação da região onde uma 
#proporção das amostras de um grupo estaria localizada, baseada na incerteza e 
#variabilidade dos dados.

gpca6 <- 
  res.pca3 |>
  factoextra::fviz_pca_ind(geom.ind = "point",   # Mostra apenas pontos.
               col.ind = SEB$UF,                 # Cor por grupos.
               palette = c("#00AFBB", "#E7B800", "#FC4E07", "#529FE3"),
               addEllipses = T,                  # Se TRUE, desenha elipses ao redor dos indivíduos.
               ellipse.type = "confidence",      # Tipo da elipse. Existe de "confidence", "convex", "t", "euclid".
               ellipse.level=0.95,               # Nível de confiança de 95%.
               
               legend.title = "UF") # Alterando o título da legenda.
gpca6

# Sugestão de site para definir cores: https://color.adobe.com/pt/create/color-wheel

gpca7 <-
  res.pca3 |>
  factoextra::fviz_pca_ind(geom.ind = c("text", "point"),
               habillage = SEB$UF,          # Especificar uma variável qualitativa a ser usada para colorir os indivíduos por grupos.
               addEllipses = T,             # Se TRUE, desenha elipses ao redor dos indivíduos.
               ellipse.level = 0.95,        # Nível de confiança da elipse.
               ellipse.type = "convex",     # Tipo de elipse. O padrão é "norm".
               repel = T,                   # Texto não sobreposto.
               pointsize = 1,               # Tamanho do ponto.
               labelsize = 3,               # Tamanho do rótulo.
               invisible = c("quali"),      # Elementos a serem ocultados.
               show.legend = F,             # Removendo as letras da legenda.
               legend.title = "UF")         # Alterando o título da legenda.     
gpca7

# PCA: gráfico das variáveis (loadings).

gpca8 <- 
  res.pca3 |>
  factoextra::fviz_pca_var(geom = c("arrow", "text"),   # Geometria a ser usada no gráfico.
               col.var = "contrib",            # Cor por contribuições nas componentes principais 1 (Dim1) e 2 (Dim2).
               legend.title = "Contribuição",  # Alterando o título da legenda.        
               labelsize = 3,                  # Tamanho do rótulo.
               repel = T)                      # Texto não sobreposto.
gpca8

# PCA: gráfico das variáveis e indivíduos (biplot).
gpca9 <- 
  res.pca3 |>
  factoextra::fviz_pca_biplot(geom = "point",   # Geometria a ser usada no gráfico.
                  pointsize = 1,                # Tamanho do ponto.
                  labelsize = 3,                # Tamanho do rótulo.
                  repel = T,                    # Texto não sobreposto.
                  addEllipses = T,              # Se TRUE, desenha elipses ao redor dos indivíduos.
                  ellipse.level = 0.95,         # Nível de confiança da elipse.
                  col.var = "darkblue",         # Definindo a cor das variáveis.
                  col.ind = SEB$UF,             # Define uma variável categórica a ser usada para colorir indivíduos por grupos.
                  show.legend = F,              # Removendo as letras da legenda.
                  legend.title = "UF",          # Alterando o título da legenda. 
                  axes = c(1, 2))               # Especificando as dimensões a serem plotadas.
gpca9

gpca10 <- 
  res.pca3 |>
  factoextra::fviz_pca_biplot(geom.ind = "point",  
                  fill.ind = SEB$UF,         # Cor do preenchimento por grupos. 
                  col.ind = "black",         # Cor dos indivíduos.
                  pointshape = 21, 
                  pointsize = 2,
                  repel = T,
                  palette = "jco",            # Definindo a paleta de cores para o preenchimento dos indivíduos.
                  addEllipses = T,
                  alpha.var ="contrib",       # Transparência de cores das variáveis por contribuições.
                  col.var = "contrib",        # Cor por contribuições nas componentes principais 1 (Dim1) e 2 (Dim2).
                  gradient.cols = "RdYlBu",   # Definindo as cores das contribuições das variáveis. 
                  legend.title = list(fill = "UF", color = "Contribuição",
                                    alpha = "Contribuição"))
gpca10 

#------------------------------------------------------------------------------#
# Combinar várias plotagens.
# Use o pacote "cowplot" para organizar os gráficos em forma de painéis.

if (!require(cowplot)) install.packages("cowplot")  # Instalando o pacote "cowplot".
library(cowplot)   

sc_bi <- cowplot::plot_grid(gpca1, 
                            gpca10, 
                            ncol = 2)
sc_bi

#-------------------------------------------------------------------------------
# Exportando gráficos com linhas de comando. 

# Usando o ggsave do ggplot2:
ggplot2::ggsave( 
  plot = sc_bi,               # Gráfico criado anteriormente.
  filename = "PCA_SEB2.png",  # Nome e extensão do arquivo a ser salvo.
  device = "png",             # Formato do arquivo.
  dpi = 600,                  # Resolução do arquivo.
  width = 7000,               # Largura do gráfico. 
  height = 4000,              # Altura do gráfico.
  units = "px",               # Unidade.
  bg = "white"
)

#------------------------https://linktr.ee/pexcca.lamet------------------------#
