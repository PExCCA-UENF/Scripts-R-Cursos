#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 02/08/2025                        #
#==============================================================================#

# 0. APRESENTAÇÃO --------------------------------------------------------------
# O projeto "Processamento e Análise de Dados Ambientais com R" (Proamb.R)
# apresenta o minicurso "Estatística Computacional com R: Fundamentos e Possibilidades".
# Esta iniciativa integra as atividades de extensão do grupo de Pesquisa e Extensão
# Universitária em Ciências Climáticas e Ambientais (PExCCA), apoiado pela
# Pró-Reitoria de Extensão da Universidade Estadual do Norte Fluminense Darcy
# Ribeiro (UENF). Desenvolvido no Laboratório de Meteorologia (LAMET) do
# Campus Macaé da UENF, o curso foi elaborado para introduzir estudantes de graduação
# às potencialidades da linguagem R aplicada à análise estatística de dados
# biológicos, utilizando como estudo de caso o clássico conjunto de dados
# 'crabs' do pacote MASS, que contém medidas morfométricas de caranguejos.

# Através de uma abordagem prática e acessível, os participantes terão a
# oportunidade de aprender desde manipulação básica de dados até técnicas
# estatísticas fundamentais, sempre com foco na aplicação prática e na interpretação
# contextualizada dos resultados.

# 1. INTRODUÇÃO ---------------------------------------------------------------

# A estatística básica consiste em técnicas que são usadas para coleta, organização,
# análise, interpretação e apresentação de dados. Ela inclui cálculos como média aritmética
# e frequência absoluta, além de medidas dispersão, variabilidade e medidas de tendência central.

# Após a coleta dos dados, o passo seguinte é a sua organização. Para organização,
# exploração e visualização de dados, vamos usar o 'tidyverse', que é uma coletânea
# de pacotes da linguagem R construídos para a ciência de dados. Todos os pacotes
# compartilham uma mesma filosofia de design, gramática e estrutura de dados,
# facilitando a programação.

# Instalando e carregando o 'tidyverse':
if (!require('tidyverse'))
  install.packages('tidyverse')
library(tidyverse)

# Carregar o 'tidyverse' é o mesmo que carregar os seguintes pacotes:
# 'tibble': para data frames repaginados;
# 'readr': para importarmos bases para o R;
# 'tidyr' e dplyr: para arrumação e manipulação de dados;
# 'stringr': para trabalharmos com textos;
# 'forcats': para trabalharmos com fatores;
# 'ggplot2': para visualização de dados;
# 'purrr': para programação funcional.

# Neste minicurso vamos usar o operador pipe nativo `|>` para o encadeamento de
# funções, que está disponível a partir da versão 4.1 do R.

# Para ativar o atalho Ctrl + Shift + M para o operador pipe nativo (|>), no Windows,
# basta irmos no menu Tools → Global Options → Code e ativar a caixa 'Use native
# pipe operator, |> (requires R.4.1+)'.

# 2. EXPLORAÇÃO INICIAL DOS DADOS ---------------------------------------------

# Para este curso, vamos utilizar um conjunto de dados disponível no pacote MASS,
# de Venables, W. N. e Ripley, B. D. (2002). Estes podem ser acessados pelo seu nome,
# `crabs`. O data frame "crabs" contém 200 linhas e 8 colunas, descrevendo 5 medidas
# morfológicas de 50 caranguejos para cada uma das duas variedades de cor e ambos
# os sexos, da espécie *Leptograpsus variegatus*, coletados em Fremantle, Austrália Ocidental.

if (!require("MASS"))
  install.packages("MASS")

# Podemos acessar mais informações sobre o conjunto com o seguinte comando:
help(MASS::crabs)

# Carregar e inspecionar a estrutura dos dados
dados <- MASS::crabs

# Visualizar as primeiras observações e estrutura
# A função glimpse() oferece uma visão compacta e informativa do dataset
dplyr::glimpse(dados)

# 3. MANIPULAÇÃO DE DADOS COM TIDYVERSE ---------------------------------------

## 3.1 Operador Pipe e Funções Básicas
# O operador pipe (%>% ou |>) permite encadear operações de forma intuitiva
# A função pull() extrai uma coluna como vetor, útil para cálculos estatísticos

# Calcular média da largura da carapaça (CW)
dados %>%
  pull(CW) %>%
  mean(na.rm = TRUE)  # na.rm = TRUE remove valores missing

# Calcular desvio padrão da mesma variável
dados %>%
  pull(CW) %>%
  sd(na.rm = TRUE)

## 3.2 Renomeando Variáveis
# A função rename() permite modificar nomes de colunas para melhor legibilidade
dados <- dados %>%
  rename(
    Especie = sp,
    Sexo = sex,
    Indice = index,
    Frontal_Lobe = FL,
    Rear_Width = RW,
    Carapace_Length = CL,
    Carapace_Width = CW,
    Body_Depth = BD
  )

## 3.3 Selecionando Colunas
# select() permite focar em variáveis relevantes para análise
dados %>%
  select(Especie, Sexo, Carapace_Width)

## 3.4 Criando Novas Variáveis
# mutate() permite criar/modificar colunas mantendo o dataframe original
dados %>%
  mutate(
    CW_cm = Carapace_Width / 10,
    # Conversão de mm para cm
    Grupo = paste(Especie, Sexo)   # Combinação de categorias
  )

# 4. ESTATÍSTICAS DESCRITIVAS --------------------------------------------------

## 4.1 Medidas Resumo com summarize()
# summarize() condensa múltiplos valores em medidas resumo estatísticas
dados %>%
  summarise(
    Media_CW = mean(Carapace_Width, na.rm = TRUE),
    DP_CW = sd(Carapace_Width, na.rm = TRUE),
    Media_BD = mean(Body_Depth, na.rm = TRUE),
    DP_BD = sd(Body_Depth, na.rm = TRUE)
  )

## 4.2 Estatísticas Agrupadas com group_by()
# group_by() + summarize() permitem análises por grupos categóricos
estatisticas_por_grupo <- dados %>%
  group_by(Especie, Sexo) %>%
  summarise(
    Media_CW = mean(Carapace_Width, na.rm = TRUE),
    DP_CW = sd(Carapace_Width, na.rm = TRUE),
    N = n(),
    # Contagem de observações por grupo
    .groups = 'drop'  # Evita agrupamento persistente
  )

# 5. DISTRIBUIÇÃO NORMAL E TESTE DE SHAPIRO ------------------------------------

# A distribuição normal, também conhecida como distribuição gaussiana ou "curva
# em forma de sino", é um dos conceitos mais fundamentais em estatística. Imagine
# medir a altura de todas as pessoas em uma sala - a maioria terá alturas próximas
# da média, enquanto poucas pessoas serão muito altas ou muito baixas. Essa tendência
# de os dados se concentrarem em torno de um valor central, diminuindo gradualmente
# em direção aos extremos, é exatamente o que caracteriza uma distribuição normal.
# Na natureza, muitos fenômenos seguem esse padrão, desde medidas corporais de
# animais até erros de medição em experimentos científicos. A importância dessa
# distribuição reside no fato de que muitos testes estatísticos (como o teste t
# e ANOVA) assumem que os dados seguem essa distribuição, tornando essencial
# verificar essa premissa antes de realizar análises mais complexas. No nosso
# estudo com os caranguejos, vamos verificar se as medidas morfométricas seguem
# esse padrão esperado.

## 5.1 Verificação Visual da Normalidade
# A distribuição normal é caracterizada por forma simétrica de "sino"
# Vamos filtrar dados para espécie B e sexo Feminino
dados_BF <- dados %>%
  filter(Especie == "B", Sexo == "F")

# Histograma com curva normal teórica
ggplot(dados_BF, aes(Carapace_Width)) +
  geom_density(color = "black",
               fill = "steelblue",
               alpha = 0.7)

ggplot(data.frame(x = c(-4, 4)), aes(x)) +
  stat_function(fun = dnorm,
                color = "red3",
                size = 1)

ggplot(dados_BF, aes(x = Carapace_Width)) +
  geom_density(fill = "steelblue",
               color = "black",
               alpha = 0.7) +
  stat_function(
    fun = dnorm,
    args = list(
      mean = mean(dados_BF$Carapace_Width),
      sd = sd(dados_BF$Carapace_Width)
    ),
    color = "red3",
    size = 1.2
  ) +
  labs(
    title = "Distribuição da Largura da Carapaça (Espécie B - Fêmeas)",
    subtitle = "Comparação com distribuição normal teórica",
    x = "Largura da Carapaça (mm)",
    y = "Densidade"
  ) +
  theme_minimal()

## 5.2 Teste de Shapiro-Wilk

# O teste de Shapiro-Wilk é um dos métodos mais confiáveis para verificar se um
# conjunto de dados segue uma distribuição normal. O teste calcula a probabilidade
# de que os dados analisados tenham sido gerados por uma distribuição normal.

# Em termos simples, ele compara os dados observados com os valores esperados caso
# seguissem perfeitamente uma distribuição normal, gerando uma estatística W que
# varia entre 0 e 1 (quanto mais próximo de 1, maior a aderência à normalidade)
# e um valor-p que indica a significância estatística desta comparação. A interpretação
# é intuitiva: se o valor-p for maior que 0,05, não temos evidências suficientes para
# rejeitar a hipótese de normalidade; se for menor, concluímos que os dados não
# seguem uma distribuição normal.

# H0: Os dados seguem distribuição normal
# H1: Os dados não seguem distribuição normal
shapiro_resultado <- shapiro.test(dados_BF$Carapace_Width)
print(shapiro_resultado)

# 6. CORRELAÇÃO E REGRESSÃO LINEAR ---------------------------------------------

## 6.1 Análise de Correlação

# A correlação de Pearson, é uma das medidas mais utilizadas para quantificar a
# relação linear entre duas variáveis contínuas. Este coeficiente (representado
# por r) varia entre -1 e +1, onde valores próximos de +1 indicam uma forte
# correlação positiva (quando uma variável aumenta, a outra tende a aumentar),
# valores próximos de -1 indicam uma forte correlação negativa (quando uma
# variável aumenta, a outra tende a diminuir), e valores próximos de zero sugerem
# ausência de relação linear. É crucial entender que correlação não implica
# causalidade - duas variáveis podem estar correlacionadas sem que exista uma
# relação de causa e efeito entre elas.

# Gráfico de dispersão com reta de ajuste
ggplot(dados, aes(x = Carapace_Width, y = Body_Depth)) +
  geom_point(alpha = 0.6, size = 2) +
  labs(title = "Relação entre Largura e Profundidade da Carapaça", x = "Largura da Carapaça (mm)", y = "Profundidade do Corpo (mm)")

dados %>%
  select(Carapace_Length, Body_Depth) %>%
  summarise(Correlação = cor(Carapace_Length, Body_Depth))

# Teste de correlação

# Para verificar se a correlação observada é estatisticamente significativa, podemos
# aplicar o teste de Pearson assume que os dados seguem distribuição normal e que a
# relação entre as variáveis é linear. No R, aplicá-lo com a função `cor.test()`,
# que retorna não apenas o valor de r mas também o valor-p, indicando se a
# correlação observada é estatisticamente significativa. Valores de p muito pequenos
# (comumente < 0.05) indicam a presença de uma correlação estatísticamente significativa.

cor_test <- cor.test(dados$Carapace_Width, dados$Body_Depth, method = "pearson")
print(cor_test)

## 6.2 Matriz de Correlação

# Podemos ainda construir uma matriz de correlações para verificar multiplas variáveis
# com pouco esforço. Para isto, vamos utilizar a função ggcorplot do pacote ggcorplot

if (!require('ggcorrplot'))
  install.packages('ggcorrplot')
library(ggcorrplot)

# Visualização simultânea de múltiplas correlações
cor_matrix <-
  dados %>%
  select(Frontal_Lobe:Body_Depth) %>%
  cor(use = "complete.obs")

cor_p <-
  dados %>%
  select(Frontal_Lobe:Body_Depth) %>%
  cor_pmat(use = "complete.obs")

ggcorrplot(
  corr = cor_matrix,
  p.mat = cor_p,
  type = "lower",
  lab = TRUE,
  colors = c("red", "white", "blue"),
  title = "Matriz de Correlação entre Variáveis Morfométricas"
)

# 7. MODELO DE REGRESSÃO LINEAR -----------------------------------------------

# A regressão linear simples é uma técnica estatística fundamental que permite
# modelar a relação linear entre duas variáveis contínuas. Diferentemente da correlação,
# que apenas mede a força e direção da associação, a regressão nos permite prever
# valores de uma variável dependente (Y) com base em uma variável independente (X).
# O modelo segue a equação Y = β₀ + β₁X + ε, onde β₀ é o intercepto (valor de Y
# quando X é zero), β₁ é o coeficiente angular (mudança em Y para cada unidade de
# mudança em X) e ε representa o erro aleatório. No contexto dos nossos dados de
# caranguejos, podemos usar a regressão para entender como medidas corporais se
# relacionam e prever valores umas com base nas outras.

# 7.1 Ajustando o Modelo de Regressão
modelo_regressao <- lm(Body_Depth ~ Carapace_Width, data = dados)

# Resumo detalhado do modelo
summary(modelo_regressao)

# 6.2.2 Interpretação dos Resultados:
# - Intercept (β₀): -1.302 mm (profundidade esperada quando "Carapace_Width" = 0)
# - Slope (β₁): 0.421 mm (a cada 1mm de aumento na largura, profundidade aumenta 0.421 mm)
# - R²: 0.9367 (93,67% da variação na profundidade é explicada pela largura)
# - p-value: <2e-16 (relação estatisticamente significativa)

# 7.2 Visualização da Regressão

if (!require('ggpmisc'))
  install.packages('ggpmisc')
library(ggpmisc)

ggplot(dados, aes(x = Carapace_Width, y = Body_Depth)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = TRUE) +
  stat_poly_eq(aes(label = paste(
    after_stat(eq.label),
    after_stat(rr.label),
    after_stat(p.value.label),
    sep = "*\"; \"*"
  )), label.x = 0.05) +
  labs(
    title = "Relação entre Largura e Profundidade da Carapaça",
    subtitle = "Modelo de Regressão Linear Simples",
    x = "Largura da Carapaça (mm)",
    y = "Profundidade do Corpo (mm)"
  ) +
  theme_minimal()

# 7.3 Verificação dos Pressupostos da Regressão
# Para que o modelo seja válido, quatro pressupostos devem ser atendidos. Podemos
# utilizar o pacote performance para acelerar e facilitar o processo.

if (!require(performance))
  install.packages("performance")
library(performance)

# 1. Linearidade: relação linear entre X e Y
# 2. Independência: os resíduos são independentes
# 3. Homocedasticidade: variância constante dos resíduos
# 4. Normalidade: resíduos normalmente distribuídos

check_model(modelo_regressao)  # Visualização gráfica dos pressupostos

# Testes formais dos pressupostos:
check_heteroscedasticity(modelo_regressao)  # Homocedasticidade
check_normality(modelo_regressao)           # Normalidade dos resíduos
check_autocorrelation(modelo_regressao)     # Independência dos resíduos

# 8. TESTE T -----------------------------

# O teste t é um dos métodos estatísticos mais utilizados para comparar as médias.
# Este teste avalia se a diferença entre as médias de dois grupos é estatisticamente
# significativa ou se pode ter ocorrido por mero acaso amostral. O teste calcula
# uma estatística t que compara a diferença entre as médias dos grupos considerando
# a variabilidade interna de cada grupo e o tamanho das amostras. A interpretação
# do teste depende do valor-p obtido: se menor que 0,05, rejeitamos a hipótese nula
# de que as médias são iguais; se maior, não temos evidências suficientes para afirmar
# que as médias diferem. Em nosso estudo com os caranguejos, utilizamos o teste t
# para comparar a largura média da carapaça entre os sexos da espécie B, nos
# permitindo identificar se existem diferenças morfométricas significativas entre eles.

# Para aplicar o teste correto, devemos verificar primeiramente os seus pressupostos:
# - Amostras com Distribuição Normal
# - Amostras com Variância Homogênia

# Já aprendemos a realizar a verificação da normalidade com o teste de shapiro

shapiro.test(dados$Carapace_Width[dados$Especie == "O" &
                                    dados$Sexo == "F"])   # p > 0.05; Distribuição Normal
shapiro.test(dados$Carapace_Width[dados$Especie == "O" &
                                    dados$Sexo == "M"])   # p > 0.05; Distribuição Normal

# Agora, vamos aplicar o teste de variâncias para verificar a homocedasticidade

var.test(Carapace_Width ~ Sexo, data = dados %>% filter(Especie == "O"))     # p > 0.05; Variâncias Homogêneas

# Finalmente, podemos aplicar o teste adequado:

# H0: As médias dos dois grupos são iguais
# H1: As médias dos dois grupos não são iguais
t_test <- t.test(
  Carapace_Width ~ Sexo,
  data = dados %>% filter(Especie == "O"),
  var.equal = TRUE
)
print(t_test)

# Uma maneira simples e didática de interpretar o resultado pode ser atingida com
# um gráfico de barras com desvios padrões.

dados %>%
  filter(Especie == "O") %>%
  group_by(Sexo) %>%
  summarise(Media = mean(Carapace_Width),
            SD = sd(Carapace_Width)) %>%
  ggplot(aes(x = Sexo, y = Media, fill = Sexo)) +
  geom_col(width = 0.7) +
  geom_errorbar(aes(ymin = Media - SD, ymax = Media + SD),
                width = 0.2,
                size = 0.8) +
  scale_fill_brewer(palette = "Set1") +
  labs(
    title = "Largura Média da Carapaça por Sexo na Espécie O",
    subtitle = "Barras de erro representam ±1 desvio padrão",
    y = "Largura da Carapaça (mm)",
    x = "Espécie"
  ) +
  theme_minimal()

# 9. ANÁLISE DE VARIÂNCIA (ANOVA) -----------------------------------------

# A Análise de Variância (ANOVA) é um método estatístico utilizado para comparar
# médias entre três ou mais grupos. Ela avalia se existe evidência estatística
# de que as médias dos grupos sejam significativamente diferentes. A ANOVA decompõe
# a variabilidade total dos dados em componentes: variação entre grupos e variação dentro dos grupos.

# A interpretação baseia-se no valor-p: se menor que 0,05, rejeitamos a hipótese
# nula de que todas as médias são iguais. Em nosso estudo com caranguejos,
# usaremos a ANOVA para verificar se há diferenças na largura da carapaça entre:

# 1. Espécies (B e O)
# 2. Sexos (M e F)
# 3. Interação entre espécie e sexo

# Pressupostos da ANOVA:
# 1. Normalidade dos resíduos
# 2. Homogeneidade das variâncias (homocedasticidade)
# 3. Independência das observações

# Verificação dos pressupostos:
# 1. Normalidade (teste de Shapiro-Wilk nos resíduos do modelo):

modelo_anova <- aov(Carapace_Width ~ Especie * Sexo, data = dados)
shapiro.test(residuals(modelo_anova)) # p > 0.05 indica normalidade

# 2. Homogeneidade de variâncias (teste de Levene):

if (!require(car))
  install.packages("car")
car::leveneTest(Carapace_Width ~ interaction(Especie, Sexo), data = dados) # p > 0.05 indica homogeneidade

# 3. Independência: Avaliada pelo desenho amostral (as observações devem ser independentes)

# Execução da ANOVA:
# H0: Não há diferenças nas médias entre os grupos
# H1: Pelo menos uma média difere das demais

anova_result <- aov(Carapace_Width ~ Especie + Sexo + Especie:Sexo, data = dados)
summary(anova_result)

# Interpretação:
# - Valores-p < 0.05 indicam efeitos estatisticamente significativos
# - Observe os efeitos principais (Espécie e Sexo) e a interação (Espécie:Sexo)

# Caso necessário, testes post-hoc (ex: Tukey HSD para comparações múltiplas):
if (any(summary(anova_result)[[1]]$'Pr(>F)' < 0.05)) {
  tukey_result <- TukeyHSD(anova_result)
  print(tukey_result)
}

# Visualização dos resultados:
ggplot(dados,
       aes(
         x = interaction(Especie, Sexo),
         y = Carapace_Width,
         fill = interaction(Especie, Sexo)
       )) +
  geom_boxplot(alpha = 0.7) +
  stat_summary(
    fun = mean,
    geom = "point",
    shape = 18,
    size = 3,
    color = "red"
  ) +
  scale_fill_brewer(palette = "Set1") +
  
  labs(
    title = "ANOVA: Largura da Carapaça por Espécie e Sexo",
    subtitle = "Pontos vermelhos indicam médias de cada grupo",
    x = "Grupos (Espécie-Sexo)",
    y = "Largura da Carapaça (mm)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Versão alternativa com gráfico de médias e intervalos de confiança:
if (!require(gplot))
  install.packages("gpltos")

plotmeans(
  Carapace_Width ~ interaction(Especie, Sexo),
  data = dados,
  xlab = "Grupos",
  ylab = "Largura da Carapaça (mm)",
  main = "Médias com IC 95%"
)


