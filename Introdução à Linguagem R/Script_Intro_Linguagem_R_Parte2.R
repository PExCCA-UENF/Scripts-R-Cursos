#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#==============================================================================#

#                      INTRODUÇÃO À LINGUAGEM R - PARTE 1                      
#                        Script atualizado em 15/11/2025

#==============================================================================#

# 1. DIRETÓRIO DE TRABALHO E PROJETOS -----------------------------------------#

# Diretório de trabalho: pasta onde o R lê e grava arquivos.
getwd()                        # Mostra o diretório atual.
setwd("C:/Users/Documentos/R") # Define novo diretório.
# Atalho no RStudio: Ctrl + Shift + H

# Projetos (.Rproj): pastas dedicadas a uma análise.
# Benefícios: organização, independência, compartilhamento, controle de versão.
# Criar em: File > New Project > New Directory > New R Project

#==============================================================================#
# 2. IMPORTAÇÃO E EXPORTAÇÃO DE DADOS -----------------------------------------#

# Criando pasta para armazenar dados.
if(!dir.exists("Dados/")) dir.create("Dados")

# Neste curso, vamos utilizar as 'Normais Climatológicas' obtidas do Instituto 
# Nacional de Meteorologia (INMET), disponíveis no link: https://portal.inmet.gov.br/normais

# As 'Normais Climatológicas' são médias de variáveis meteorológicas, que foram 
# calculadas obedecendo os critérios recomendados pela Organização Meteorológica Mundial (OMM).

# Definindo a URL do arquivo que será baixado:
url.tmax <- "https://portal.inmet.gov.br/uploads/normais/Normal-Climatologica-TMAX.xlsx"

# Fazendo o download do arquivo e salvando localmente:
download.file(
  url.tmax,               # 1º argumento: URL do arquivo a ser baixado (objeto definido acima).
  "./Dados/Tmax.xlsx",    # 2º argumento: caminho e nome do arquivo que será salvo no computador.
  # "./Dados/" → pasta chamada 'Dados' dentro do diretório de trabalho atual.
  # "Tmax.xlsx" → nome do arquivo que será criado.
  mode = "wb"             # 3º argumento: modo de gravação.
  # "wb" = write binary → grava em modo binário.
  # Se fosse um arquivo de texto simples, poderia usar "w".
)

dir("./Dados")   # Verifica se o arquivo foi salvo.

# Importação de dados Excel com pacote readxl.

# Verificando se o pacote 'readxl' está instalado. Se não estiver, o comando 
# install.packages() faz a instalação.
if (!require("readxl")) install.packages("readxl")

# Carregando o pacote 'readxl' para importar arquivos Excel (.xlsx ou .xls).
library(readxl)

# Importando o arquivo Excel com a função read_excel().
TMAX <- read_excel(
  path = "./Dados/Tmax.xlsx",   # Caminho e nome do arquivo que será importado.
  # "./Dados/" → pasta chamada 'Dados' dentro do diretório de trabalho.
  # "Tmax.xlsx" → nome do arquivo Excel salvo anteriormente.
  
  sheet = 1,                    # Número ou nome da planilha dentro do arquivo Excel.
  na = "-",                     # Define qual símbolo será interpretado como valor ausente (NA).
  skip = 2                      # Número de linhas iniciais que devem ser ignoradas.
  # Útil quando o arquivo tem cabeçalhos ou informações extras.
)

# Visualizando os dados importados
print(TMAX)   # Mostra o conteúdo no console.
View(TMAX)    # Abre o conteúdo em uma aba interativa no RStudio.

# # Exportando dados em formato CSV.
write.table(
  x = TMAX,                        # Objeto que contém os dados a serem exportados.
  file = "./Dados/TMAX_INMET.csv", # Caminho e nome do arquivo que será gerado.
  dec = ",",                       # Define o separador decimal.
  row.names = TRUE,                # Indica se os nomes das linhas devem ser exportados.
  sep = ";",                       # Define o separador de colunas.
  # ";" → padrão comum em arquivos CSV no Brasil.
  na = "NA",                       # Define como os valores ausentes serão representados.
  fileEncoding = "ISO-8859-1"      # Define a codificação de caracteres.
  # "ISO-8859-1" → evita problemas com acentos em português.
  # Alternativa: "UTF-8".
)

# Exportando dados em formato Excel (.xlsx).
# Para isso, usamos o pacote 'writexl'.
if (!require("writexl")) install.packages("writexl")
library(writexl)

write_xlsx(
  x = TMAX,                        # Objeto que contém os dados a serem exportados.
  path = "./Dados/TMAX_INMET.xlsx" # Caminho e nome do arquivo Excel que será gerado.
)

# Verificando os arquivos exportados dentro da pasta "Dados".
dir("./Dados")

#==============================================================================#
# 3. MANIPULAÇÃO DE DADOS COM DPLYR E TIDYR -----------------------------------#

# Os pacotes dplyr e tidyr fazem parte do tidyverse, coleção de pacotes voltados
# para ciência de dados. Carregar o tidyverse inclui pacotes como:
# - dplyr: manipulação e transformação de dados.
# - tidyr: organização/limpeza de dados.
# - ggplot2: visualização.
# - lubridate: datas e horas.
# (entre outros)

if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

#------------------------------------------------------------------------------#
## 3.1 Operador Pipe
# O pipe (%>% ou |> a partir do R 4.1) encadeia funções, passando o resultado
# de uma operação como argumento da próxima. Atalho: Ctrl + Shift + M.

# Exemplo sem pipe:
resultado <- round(sqrt(sum(1:9)), digits = 2)
print(resultado)

# Exemplo passo a passo:
somatorio <- sum(1:9)
raiz <- sqrt(somatorio)
resultado <- round(raiz, 2)
print(resultado)

# Exemplo com pipe (mais limpo e legível):
resultado <- 
  1:9 |>       # Sequência de 1 a 9.
  sum() |>     # Soma dos valores.
  sqrt() |>    # Raiz quadrada da soma.
  round(2) |>  # Arredonda para 2 casas decimais.
  print()      # Imprime resultado.

#------------------------------------------------------------------------------#
## 3.2 Exploração inicial

# Antes de manipular, é importante conhecer os dados.
# glimpse() mostra dimensões, nomes e tipos das variáveis (similar ao str(), mas mais completo).
pillar::glimpse(TMAX)

#------------------------------------------------------------------------------#
## 3.3 Seleção de variáveis

# select(): escolhe colunas específicas sem usar o operador $.

# Sem pipe:
dplyr::select(TMAX, `Nome da Estação`, UF, Ano)

# Com pipe:
TMAX |> dplyr::select(`Nome da Estação`, UF, Ano)

# Seleção por intervalo de colunas:
TMAX |> dplyr::select(Código:Janeiro)

# Seleção por padrão nos nomes:
TMAX |> dplyr::select(Código:UF, starts_with("Ju"))   # começa com "Ju"
TMAX |> dplyr::select(Código:UF, ends_with("bro"))    # termina com "bro"
TMAX |> dplyr::select(Código:UF, contains("em"))      # contém "em"

#------------------------------------------------------------------------------#
## 3.4 Renomeando variáveis

# rename(): altera nomes de colunas → sintaxe: novo_nome = nome_antigo.

TMAX |> dplyr::rename(
  Estação = `Nome da Estação`,
  Jan = Janeiro, Fev = Fevereiro, Mar = Março, Abr = Abril,
  Mai = Maio, Jun = Junho, Jul = Julho, Ago = Agosto,
  Set = Setembro, Out = Outubro, Nov = Novembro, Dez = Dezembro
)

# rename_with(): aplica uma função/vetor de nomes a todas as colunas.

TMAX_INMET <- TMAX |> dplyr::rename_with(
  .fn = ~c("Código","Estação","UF","Jan","Fev","Mar","Abr","Mai","Jun",
           "Jul","Ago","Set","Out","Nov","Dez","Ano")
) |> print()

#------------------------------------------------------------------------------#
## 3.5 Criando/alterando colunas

# mutate(): cria, altera ou remove colunas.
# Excluir colunas → atribuir NULL.

TMAX_INMET |> dplyr::mutate(Código = NULL, Ano = NULL)

# Criar nova coluna combinando Estação e UF.
TMAX_INMET |> dplyr::mutate(
  Estações_UF = paste(Estação, UF, sep = "-"), # Concatena informações.
  .before = Jan,                               # Insere antes da coluna Jan.
  Código = NULL, Estação = NULL, UF = NULL     # Remove colunas antigas.
)

#------------------------------------------------------------------------------#
## 3.6 Filtrando dados

# filter(): seleciona linhas com base em condições lógicas.
TMAX_RJ <- TMAX_INMET |> 
  dplyr::filter(UF == "RJ") 
|> print()

# Filtrar múltiplos valores.
TMAX_INMET |> 
  dplyr::filter(UF %in% c("RJ","SP"))

# Filtrar com mais de uma condição.
TMAX_INMET |> 
  dplyr::filter(UF == "RJ", Ano >= 30)

# Usando between(): valores dentro de um intervalo.
TMAX_INMET |> 
  dplyr::filter(between(Ano, 34, 35))

#------------------------------------------------------------------------------#
## 3.7 Mudando da estrutura da base de dados

# Em R, podemos "pivotar" os dados, ou seja, transformar:
# - formato largo (wide): cada coluna representa uma variável/tempo.
# - formato comprido (long): valores agrupados em uma única coluna.

# pivot_longer(): transforma de largo → comprido.
TMAX_longer <- 
  TMAX_INMET |> 
  dplyr::mutate(Ano = NULL) |>        # Remove coluna 'Ano' antes da transformação.
  tidyr::pivot_longer(
    cols = Jan:Dez,                   # Colunas que serão agrupadas (meses).
    names_to = "Meses",               # Nova coluna com os nomes das variáveis (meses).
    values_to = "Tmax"                # Nova coluna com os valores correspondentes.
  ) |> 
  print()

# pivot_wider(): transforma de comprido → largo (operação inversa).
TMAX_wider <- 
  TMAX_longer |> 
  tidyr::pivot_wider(
    names_from = "Meses",             # Coluna que contém os nomes das variáveis.
    values_from = "Tmax"              # Coluna que contém os valores.
  ) |> 
  print()

#==============================================================================#
# 4. TRABALHANDO COM DATAS (LUBRIDATE) ----------------------------------------#

# Em R, datas são objetos da classe "Date". O pacote lubridate (parte do tidyverse) 
# facilita a criação, manipulação e extração de informações de datas e horários.

# Criando um objeto de data.
data <- lubridate::as_date("2024-06-13")   # Converte string para objeto Date.
class(data)                                # Verifica a classe do objeto.

# Funções para diferentes formatos de datas:
ymd("2024-06-13")   # ano-mês-dia
dmy("13-06-2024")   # dia-mês-ano
dmy("13062024")     # dia-mês-ano sem separadores

# Trabalhando com data e horário.
ymd_hms(20240613213010)   # ano-mês-dia hora:minuto:segundo

# Extraindo componentes da data.
year(data)    # ano
month(data)   # mês
day(data)     # dia
# Para objetos com horário: hour(), minute(), second()

#------------------------------------------------------------------------------#
# Criando sequências de datas 

# Definindo datas inicial e final.
ymd("2024-01-01")
today()   # Retorna a data atual.

# Sequência diária.
seq(data_inicial, data_final, by = "day")

# Sequência mensal.
seq(data_inicial, data_final, by = "month")

#==============================================================================#
# 5. VISUALIZAÇÃO DE DADOS COM GGPLOT2 

# O ggplot2 (parte do tidyverse) cria gráficos em camadas, permitindo personalização.
# Estrutura básica: ggplot(data, aes(...)) + geom_...( )

# Primeiro passo: definir o conjunto de dados.
ggplot(data = TMAX_longer)   # Gera apenas o plano de fundo.

# Adicionando mapeamento estético (aes): define variáveis para os eixos
ggplot(data = TMAX_longer, aes(x = UF, y = Tmax))

# Exemplos de mapeamentos possíveis em aes():
# x, y → variáveis nos eixos.
# color → cor de pontos/linhas.
# fill → preenchimento de áreas.
# size → tamanho.
# alpha → transparência.
# shape → formato dos pontos.

# Gráfico de dispersão simples.
ggplot(TMAX_longer, aes(x = UF, y = Tmax)) + 
  geom_point()

# Gráfico de dispersão categorizado por mês.
ggplot(TMAX_longer, aes(x = UF, y = Tmax, color = Meses)) + 
  geom_point()

# Ajustando ordem dos meses como fator.
TMAX_longer <- TMAX_longer |> 
  mutate(Meses = factor(Meses, 
                        levels = c("Jan","Fev","Mar","Abr","Mai","Jun",
                                   "Jul","Ago","Set","Out","Nov","Dez")))

# Paleta de cores personalizada.
corDegrade <- colorRampPalette(c("red","blue","goldenrod"))

gr1 <- ggplot(TMAX_longer, aes(x = UF, y = Tmax, color = Meses)) +
  geom_point() +
  scale_color_manual(values = corDegrade(12))
gr1

# Temas visuais
gr1 + theme_minimal()
gr1 + theme_classic()
gr1 + theme_bw()

#------------------------------------------------------------------------------#
# Histogramas

# Histograma simples.
TMAX_longer |> 
  ggplot(aes(x = Tmax)) + 
  geom_histogram()

# Histograma filtrando apenas RJ.
hist_RJ <- TMAX_longer |> 
  filter(UF == "RJ") |> 
  ggplot(aes(x = Tmax)) +
  geom_histogram(color = "steelblue4", fill = "steelblue1", alpha = 0.8, bins = 20) +
  theme_minimal()
hist_RJ

# Personalizando eixos.
hist_RJ +
  scale_y_continuous(name = "Frequência", limits = c(0,16), breaks = seq(0,18,2)) +
  scale_x_continuous(name = "Temperatura Máxima (ºC)", breaks = seq(22,35,2))

#==============================================================================#
# 6. EXPORTAÇÃO DE RESULTADOS 

# Exportar gráfico com ggsave().
ggsave(
  filename = "Gráfico_Tmax.png",   # Nome e extensão do arquivo que será salvo.
  plot = gr1,                      # Objeto do gráfico que será exportado.
  device = "png",                  # Formato do arquivo de saída.
  width = 3000, height = 1500,     # Dimensões do gráfico.
  # Valores dependem da unidade escolhida.
  
  units = "px",                    # Unidade de medida das dimensões.
  # Opções: "px" (pixels), "cm" (centímetros), "mm" (milímetros), "in" (polegadas).
  
  dpi = 300,                       # Resolução da imagem (dots per inch).
  # Padrão para impressão de qualidade é 300 dpi.
  
  bg = "white"                     # Cor de fundo do gráfico exportado.
)

#------------------------https://linktr.ee/pexcca.lamet------------------------#
