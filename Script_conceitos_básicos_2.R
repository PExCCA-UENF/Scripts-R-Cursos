#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script atualizado em 01/05/2023                        #
#==============================================================================#

#                   LINGUAGEM R: CONCEITOS BÁSICOS (PARTE 2)                   # 

#-------------------------------------------------------------------------------
# TÓPICOS ABORDADOS:
# 1. R BASE E PACOTES
# 2. BASES DE DADOS NATIVAS DO R
# 3. IMPORTAÇÃO E EXPORTAÇÃO DE DADOS
# 4. MANIPULAÇÃO DE DADOS: BÁSICO
# 5. GRÁFICOS BÁSICOS

# 1. R BASE E PACOTES ----------------------------------------------------------
# Na linguagem R, algumas funções estão implementadas no ambiente básico do R,
# ou seja, fazem parte da instalação básica do R.

# Além do R base, podemos instalar pacotes (packages) com funcionalidades específicas
# criadas por colaboradores.  

# Para usar as funções dos pacotes, é necessário fazer a instação conforme sua necessidade. 
installed.packages()        # Retorna todos os pacotes instalados, local e versão.

# Para instalar um pacote do R, podemos usar a função install. packages("nome_do_pacote"). 
install.packages("writexl") # Instala o pacote "writexl".

# Nota: O pacote pode ser desinstalado com a função remove.packages("nome_do_pacote").

# Após a instalação, o pacote deve ser carregado. 
# Podemos usar a função library(nome_do_pacote) ou require(nome_do_pacote).
library(writexl)            # Carrega o pacote.
require(writexl)            # Carrega o pacote.

# A função library(), por padrão, retorna um erro quando o pacote não está instalado. 
# A função require() retorna um warning caso o pacote não esteja instalado.

search()                    # Retorna todos os pacotes carregados.

# Nota: Podemos descarregar um pacote com a função detach("package:nome_do_pacote").

ls("package:writexl")       # Lista os comandos do pacote.

# 2. BASES DE DADOS NATIVAS DO R -----------------------------------------------
# O R possui diversas bases de dados que podem ser exploradas para estudar a linguagem.

data()                      # Retorna todas as bases de dados do R.

# Vamos utilizar a base de dados airquality.
data(airquality)            # Carrega a base de dados.
View(airquality)            # Apresenta a base de dados em uma aba.

head(airquality, n = 5)     # Retorna as primeiras n linhas (por padrão 6 linhas). 
tail(airquality, n = 5)     # Retorna as últimas n linhas (por padrão 6 linhas). 
str(airquality)             # Retorna uma síntese da estrutura da base de dados.

# 3. IMPORTAÇÃO E EXPORTAÇÃO DE DADOS ------------------------------------------
# A importação de dados funciona como upload de arquivos externos. 
# Além de importar arquivos para o R, podemos exportar do R para outros formatos. 

## 3.1 Extensão CSV (Comma-Separated Values) ---
# O CSV é um formato simples de armazenamento de dados em formato de planilhas. 
# Podemos usar funções básicas do R (sem instalar outros pacotes) para importar e
# exportar arquivos em CSV. 

### 3.1.1 Exportar dados em CSV ---
# Podemos usar duas funções: write.csv() ou write.csv2().

write.csv(
  x = airquality,             # Nome do objeto que será exportado.
  file = "airquality1.csv")   # Nome e extensão do arquivo a ser gerado.

write.csv2(
  x = airquality,             # Nome do objeto que será exportado.
  file = "airquality2.csv")   # Nome e extensão do arquivo a ser gerado.

# Use args(nome_da_função) para verificar os argumentos da função e os valores correspondentes.
args(read.csv)	
args(read.csv2)	

# O write.csv2() usa uma vírgula para o delimitador decimal (dec = ",") e um 
# ponto e vírgula para o separador (sep = ";").

### 3.1.2 Importar dados em CSV ---
# Podemos usar duas funções: read.csv() ou read.csv2().  

### Atenção! Para fazer importação de dados é importante conhecer o delimitador decimal,
# o separador de colunas e identificar os valores ausentes (se houver).

# Por padrão, a função read.csv() usa um ponto para o delimitador decimal (dec = ".") e  
# uma vírgula para o separador (sep = ","), mas podemos personalizar esses argumentos.

# A função read.csv2(), por padrão, usa uma virgula para o delimitador decimal (dec = ",")   
# e um ponto e vírgula para o separador (sep = ";"), mas também podemos personalizar.

dados_csv <- 
  read.csv(
    file = "airquality2.csv", # Nome do arquivo que será importado.
    header = TRUE,            # Se TRUE, a primeira linha do arquivo será interpretada como os nomes das colunas.
    sep = ";",                # Separador de colunas.
    dec = ",",                # Delimitador decimal.
    na.strings = "NA")        # Identificação dos valores ausentes.

head(dados_csv)               # Retorna as primeiras n linhas (por padrão 6 linhas).

## 3.2 Extensão TXT ---
# Um arquivo TXT é um documento de texto padrão que não contém formatação.
# Podemos usar funções básicas do R (sem instalar outros pacotes) para importar e
# exportar arquivos em CSV. 

### 3.2.1 Exportar dados em TXT ---
# Podemos usar a função: write.table().

write.table(
  x = airquality,             # Nome do arquivo que será importado.
  file = "airquality.txt",    # Nome e extensão do arquivo a ser gerado.
  sep = " ",                  # Separador de colunas.
  dec = ",",                  # Delimitador decimal.
  na = "NA")                  # Identificação dos valores ausentes. 

#  O separador de colunas (sep) também pode ser: ";", "\t" para tabulação, entre outros. 

### 3.2.2 Importar dados em TXT ---
# Podemos usar a função: read.table().

### Atenção! Para fazer importação de dados é importante conhecer o delimitador decimal,
# o separador de colunas e identificar os valores ausentes (se houver).

dados_txt <-
  read.table(
    file = "airquality.txt",  # Nome do arquivo que será importado.
    header = TRUE,            # Se TRUE, a primeira linha do arquivo será interpretada como os nomes das colunas.?
    sep = " ",                # Separador de colunas.
    dec = ",",                # Delimitador decimal.
    na.strings = "NA")        # Identificação dos valores ausentes.

head(dados_txt)               # Retorna as primeiras n linhas (por padrão 6 linhas).

## 3.3 Extensão XLSX ---
# Um arquivo XLSX é uma planilha do Excel. 
# Precisamos instalar pacotes para importar e exportar arquivos em XLSX. 

# O pacote 'writexl' contém funções para exportar um arquivo do R para o Excel.
install.packages("writexl")     # Instala o pacote "writexl".
library(writexl)                # Carrega o pacote.

# O pacote 'readxl' contém funções para importar um arquivo do Excel para o R.
install.packages("readxl")      # Instala o pacote "writexl".
library(readxl)                 # Carrega o pacote.

### 3.3.1 Exportando dados em formato Excel ---
# Podemos usar a função: write_xlsx()

write_xlsx(
  x = airquality,             # Nome do objeto que será exportado.
  path = "airquality.xlsx")   # Nome e extensão do arquivo a ser gerado.

### 3.3.2 Importando dados em formato Excel ---
# Podemos usar a função: read_xlsx().

dados_xlsx <- 
  read_xlsx(
    path = "airquality.xlsx", # Nome do arquivo que será importado.
    sheet = 1)                # Nome ou posição da aba de interesse da planilha.

head(dados_xlsx)              # Retorna as primeiras n linhas (por padrão 6 linhas).

# O objeto dados_xlsx está no formato tibble, que é um tipo especial de data frame.
# Para mudar do tipo tibble para o data frame tradicional usamos a função as.data.frame().
dados_df <- 
  as.data.frame(dados_xlsx)
head(dados_df)

# 4. MANIPULAÇÃO DE DADOS: BÁSICO ----------------------------------------------
# A manipulação de dados é uma etapa que consiste em coletar, limpar, processar e 
# consolidar os dados para que sejam usados/analisados. 

# Vamos usar o conjunto de dados airquality.
dados <- airquality

str(dados)          # Retorna uma síntese da estrutura da base de dados.
names(dados)        # Lista os nomes das colunas.

# Para alterar os nomes das colunas, basta atribuir um vetor com novos nomes à função names().
names(dados) <- c("O3", "R.Solar", "Vento", "Temp", "Mes", "Dia")  

## 4.1 Acessando os elementos de um data frame ---
# Podemos acessar os elementos usando o $ ou pela sua posição.

### Usando o $:
dados$O3            # Retorna os dados da coluna O3.
dados$R.Solar       # Retorna os dados da coluna R.Solar.

### Usando [ ]: dados[Linhas, Colunas]. 
dados[1, ]           # Retorna a primeira linha da tabela.
dados[ ,1]          # Retorna a primeira coluna da tabela
dados[1:10, ]       # Retorna os dados da linha 1 até a linha 10.
dados[, c(2,4)]	    # Retorna os dados das colunas 2 e 4.
dados[, -1]         # Retorna todos os dados, exceto os da coluna 1.

# Também podemos informar o nome da coluna dentro dos colchetes:
dados["O3"]         # Imprime a coluna Ozone da tabela

## 4.2 Modificando e criando novas colunas ---
# Ao utilizar o $ com um nome que não existente na tabela de dados, será criado
# uma nova coluna.

# Os dados do conjunto airquality são medições diárias da qualidade do ar em 
# Nova York, de maio a setembro de 1973. 
# Portanto, vamos acrescentar a coluna Ano no conjunto de dados:
dados$Ano <- 1973   # Cria a coluna Ano no objeto dados.
head(dados)

### Também podemos criar uma coluna com a data completa (Ano-Mes-Dia).
# Vamos usar a função paste() para juntar as informações.

(Vetor_Datas <- paste(dados$Ano, dados$Mes, dados$Dia, sep = "-"))
# No argumento sep informamos o caracter que será utilizado para separar as informações.

class(Vetor_Datas)    # Verifica a classe do objeto.

# Para converter uma data de texto (character) em data, podemos usar a função as.Date().
dados$Data <- as.Date(Vetor_Datas)
class(dados$Data)     # Verifica a classe do objeto.
head(dados)

## 4.3 Filtrando dados ---
# Função subset: cria um subconjunto de dados de acordo com determinada condição.

# Selecionando as linhas que Temp é maior que 92°F:
dados_f1 <- 
  subset(x = dados,            # Objeto a ser filtrado.
         subset = Temp > 92)   # Condição que será aplicada. 
dados_f1                      

# Selecionando as linhas que Temp é maior que 92°F e Mes é igual a 8: 
dados_f2 <- 
  subset(x = dados, 
         subset = Temp > 92 & Mes == 8) 
dados_f2                       

# Selecionando as linhas que Temp é maior que 92°F apenas das colunas Data e O3: 
dados_f3 <- 
  subset(x = dados, 
         subset = Temp > 92,           
         select = c(Data, O3))  # Seleciona colunas da tabela de dados.        
dados_f3                     

## 4.6 Criando sumários ----
# Função by e tapply: agrupa os dados de acordo uma variável a partir de uma função.

# Média mensal da variável Temp (°F) usando a função by():
by(data = dados$Temp,            # Variável a ser aplicada a função.
   INDICES = dados$Mes,          # Fator/categoria para agrupar os dados.
   FUN = mean)                   # A função a ser aplicada.

# Nota: Se nos dados tiver dados ausentes (NA), ao calcular estatísticas descritivas, 
# o resultado será NA. Para realizar o cálculo, precisamos definir na.rm = TRUE.

## Se na.rm é TRUE, a função ignora os NA. Se na.rm é FALSE, ele retorna NA no cálculo feito. 
by(data = dados$R.Solar,            
   INDICES = dados$Mes,          
   FUN = mean, na.rm = T)                   

# Média mensal da variável Temp (°F) usando a função tapply():

Temp.med <- 
  tapply(X = dados$Temp,      # Variável a ser aplicada a função.
         INDEX = dados$Mes,   # Fator/categoria para agrupar os dados.
         FUN = max)           # A função a ser aplicada.
Temp.med

### Podemos ocultar os argumentos ao passar os vetores e a função na ordem correta.
(Temp.max <- tapply(dados$Temp, dados$Mes, max))
(Temp.min <- tapply(dados$Temp, dados$Mes, min))

# 5. GRÁFICOS BÁSICOS ----------------------------------------------------------

# 5.1 Gráfico de dispersão e linha ---
# É uma representação gráfica da associação entre pares de dados.

# Do R base, a função mais usada e flexível para gerar gráficos é a função plot().
#  A função plot recebe um vetor para o eixo x e	um outro vetor para o eixo y.

plot(dados$Temp, dados$O3)

# Configurando o gráfico de dispersão:
plot(
  x = dados$Temp,                     # Vetor do eixo x.
  y = dados$O3,                       # Vetor do eixo y.
  pch = 16,                           # Tipo dos pontos.
  col = "blue",                       # Cor dos pontos.
  cex = 2,                            # Tamanho dos pontos.
  main = "Temperatura vs O3",         # Título do gráfico.
  xlab = "Temperatura (°F)",          # Título eixo x.
  ylab = "O3")                        # Título eixo y.
grid()                                # Adiciona grade no gráfico.

# Configurando o gráfico de linha:
plot(
  x = dados$Data,                     # Vetor do eixo x.
  y = dados$Temp,                     # Vetor do eixo y.
  type = "l",                         # Tipo de gráfico ("l" = "lines").
  lwd = 2,                            # Espessura da linha.
  main = "Temperatura (°F) de Nova York",   # Título do gráfico.
  xlab = "Data",                      # Título eixo x.
  ylab = "Temperatura (°F)")          # Título eixo y.

# Tipo de gráfico - argumento type:
# "p": pontos
# "l": linhas
# "b": pontos e linhas
# "c": linhas sem os pontos
# "o": linhas e pontos sobrepostos
# "h": linhas verticais
# "s": degraus
# "S": outro tipo de degrau
# "n": sem pontos

# 5.2 Gráfico de barras ---
# A função barplot() cria um gráfico de barras com barras verticais ou horizontais.

barplot(Temp.med)

# Barras verticais:
barplot(
  height = Temp.med,                    # Variável a ser plotada.
  col = "cyan",                         # Cor das barras.
  ylim = c(0, 100),                     # Limites do eixo y.
  names.arg = month.abb[5:9],           # Nomeando as barras.
  main = "Temperaturas Médias Mensais", # Título do gráfico.
  ylab = "Temperatura (°F)")            # Título do eixo Y.
  
# Barras horizontais:
barplot(
  height = Temp.med,                    # Variável a ser plotada.
  col = "cyan",                         # Cor das barras.
  xlim = c(0, 100),                     # Limites do eixo x.
  names.arg = month.abb[5:9],           # Nomeando barras.
  main = "Temperaturas Médias Mensais", # Título do gráfico.
  ylab = "Temperatura (°F)",            # Título do eixo Y.
  horiz = T)

# 5.3 Exportando gráficos ---
# Com o gráfico plotado na aba Plots clique em "Export" e selecione "Save as Image..." 
# para salvar nos formatos PNG, JPEG e outros. Selecione o formato em "Image Format" 
# e escreva o nome da imagem em "File name" depois clique em Ok.

## Tambem podemos exportar os gráficos com linhas de comandos. 
# Podemos usar a função png() ou jpeg() do R base. 

# Exemplo 1:
png("Gráfico_1.png")            # Inicia o comando para salvar o gráfico.
plot(dados$Temp, dados$O3)      # Plota o gráfico.
dev.off()                       # Finaliza o comando para salvar o gráfico.

# Exemplo 2:
png(filename = "Gráfico_2.png",   
    width = 7,                  # Largura do gráfico
    height = 5,                 # Altura do gráfico.
    units = "in",               # Unidade da altura e largura ("px" (pixel), "in" (polegada), "cm", "mm")
    res = 300)                  # Resolução.
barplot(Temp.med)               # Plota o gráfico.
dev.off()                       # Finaliza o processo.

# 5.4 Explorando parâmetros gráficos ---
# Podemos personalizar alguns parâmetros gráficos com a função par().

par(
  mfrow = c(1, 3),              # Define o Layout 1x3.
  bg = "gray",                  # Define a cor do fundo do gráfico.
  pty = "s")                    # Define o formato do gráfico.

barplot(Temp.med)
barplot(Temp.max)
barplot(Temp.min)

#------------------------https://linktr.ee/pexcca.lamet------------------------#
