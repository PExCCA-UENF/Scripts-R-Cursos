#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 05/11/2025                        #
#==============================================================================#

#             PROCESSAMENTO E ANÁLISE DE DADOS METEOROLÓGICOS NO R             #
#------------------------------------------------------------------------------#

# 1. Instalação de pacotes-----------------------------------------------------#

# Instalar pacotes necessários (executar apenas uma vez)
install.packages(c("tidyverse", "skimr", "DataExplorer", "readr", "corrplot"))

# 2. Carregamento de pacotes---------------------------------------------------#
library(tidyverse)     # Manipulação e visualização de dados.
library(skimr)         # Resumo estatístico detalhado das variáveis.
library(DataExplorer)  # Gráficos automáticos para análise exploratória.
library(readr)         # Leitura de arquivos CSV.
library(corrplot)      # Visualização de correlações entre variáveis numéricas.

# 3. Importação dos dados------------------------------------------------------#

# Leitura do arquivo CSV com configurações:
dados <- read_delim("generatedBy_react-csv.csv", 
                    delim = ";",                     # Define o delimitador usado no arquivo CSV (neste caso, ponto e vírgula).
                    col_types = cols(                
                      Data = col_date(format = "%d/%m/%Y"),         # Interpreta a coluna "Data" como data no formato dia/mês/ano.
                      `Hora (UTC)` = col_time(format = "%H%M")      # Interpreta a coluna "Hora (UTC)" como horário no formato HHMM.
                    ), 
                    locale = locale(                 
                      decimal_mark = ",",            # Define a vírgula como separador decimal.
                      grouping_mark = "."            # Define o ponto como separador de milhar.
                    ), 
                    trim_ws = TRUE)                  # Remove espaços em branco antes/depois dos valores nas células.


# Visualizar os dados como planilha no RStudio:
View(dados)

# 4. Inspeção e estrutura dos dados #
str(dados)
glimpse(dados)     
names(dados)       

# 5. Verificação de valores ausentes-------------------------------------------#
plot_missing(dados)           # Gráfico de variáveis com dados ausentes.
colSums(is.na(dados))         # Contagem de NAs por coluna.

# 6. Seleção e filtragem de dados----------------------------------------------#
# Nesta etapa, vamos a selecionar colunas específicas e filtrar linhas com base em condições.

# Selecionar apenas algumas variáveis (exemplo: Data, Temperatura e Umidade)
dados_selecionados <- 
  select(dados, Data, `Temp. Ins. (C)`, `Umi. Ins. (%)`)

print(dados_selecionados)

# Filtrar dados de um período específico (exemplo: mês de outubro):
dados_outubro<- 
  filter(dados, format(Data, "%m") == "10")

print(dados_outubro)

# Filtrar dados com temperatura acima de 30°C:
dados_quentes <- 
  filter(dados, `Temp. Ins. (C)` > 30)

print(dados_quentes)

# 7. Cálculos estatísticos básicos---------------------------------------------#
# Nesta etapa, vamos  calcular medidas como média, mediana, mínimo, máximo e desvio padrão.

# Média da temperatura instantânea (coluna única)
mean(dados$`Temp. Ins. (C)`, na.rm = TRUE)

# Mediana da umidade instantânea
median(dados$`Umi. Ins. (%)`, na.rm = TRUE)

# Mínimo e máximo da temperatura
min(dados$`Temp. Ins. (C)`, na.rm = TRUE)
max(dados$`Temp. Ins. (C)`, na.rm = TRUE)

# Desvio padrão da temperatura
sd(dados$`Temp. Ins. (C)`, na.rm = TRUE)

# Resumo estatístico completo de todas as variáveis numéricas
summary(dados)     # Estatísticas básicas

summary(select(dados, where(is.numeric)))

skim(dados)        # Resumo completo com distribuição, tipos e valores ausentes

# Calcular a média de cada coluna numérica:
medias <- sapply(select(dados, where(is.numeric)), mean, na.rm = TRUE)

print(medias)

# 8. Distribuição de variáveis numéricas---------------------------------------#

# Histogramas e curvas de densidade separadas:
plot_histogram(dados$`Temp. Ins. (C)`)
plot_density(dados$`Temp. Ins. (C)`)

# Histograma + curva de densidade no mesmo gráfico:
ggplot(dados, aes(x = `Temp. Ins. (C)`)) +
  geom_histogram(aes(y = ..density..), bins = 30, 
                 fill = "lightblue", color = "black", alpha = 0.6) +
  geom_density(color = "red", size = 1.2) +
  labs(title = "Distribuição da Temperatura Instantânea",
       x = "Temperatura (°C)", y = "Densidade") +
  theme_minimal()

# 9. Boxplot para detecção de outliers-----------------------------------------#

ggplot(dados, aes(x = format(Data, "%m"), y = `Temp. Ins. (C)`)) +
  geom_boxplot(fill = "orange", color = "darkred") +  # Boxplot por mês
  stat_summary(fun = mean, geom = "point", shape = 20, size = 3, color = "blue") +  # Média em azul
  labs(title = "Boxplot da Temperatura por Mês com Média",
       x = "Mês", y = "Temperatura (°C)") +
  theme_minimal()

# 10. Gráfico de dispersão entre variáveis--------------------------------------#

# Relação entre temperatura e umidade:
ggplot(dados, aes(x = `Temp. Ins. (C)`, y = `Umi. Ins. (%)`)) +
  geom_point(alpha = 0.6, color = "darkgreen") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Relação entre Temperatura e Umidade Relativa",
       x = "Temperatura (°C)", y = "Umidade Relativa (%)") +
  theme_minimal()

# 11. Correlação entre variáveis numéricas--------------------------------------#

# Selecionar apenas variáveis numéricas
dados_num <- select(dados, where(is.numeric))

# Calcular matriz de correlação
cor_matrix <- cor(dados_num, use = "complete.obs")
print(cor_matrix)

# Visualizar matriz de correlação:
corrplot(cor_matrix, method = "color", type = "upper", tl.cex = 0.8,
         title = "Matriz de Correlação", mar = c(0,0,1,0))

# 10. Facet plot: temperatura por hora-----------------------------------------#

ggplot(dados, aes(x = `Hora (UTC)`, y = `Temp. Ins. (C)`)) +
  geom_point(alpha = 0.5, color = "purple") +
  facet_wrap(~ format(Data, "%m"), ncol = 4) +
  labs(title = "Temperatura por Hora ao Longo dos Meses",
       x = "Hora (UTC)", y = "Temperatura (°C)") +
  theme_minimal()

#------------------------https://linktr.ee/pexcca.lamet------------------------#
