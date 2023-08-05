
#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO 'PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R'         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 04/08/2023                        #
#==============================================================================#

#                 ANÁLISE DE SÉRIES TEMPORAIS NO R - PARTE 2                   #

#------------------------------------------------------------------------------#
# Atenção! A primeira parte do curso está disponível no GitHub.
#          Link: https://github.com/PExCCA-UENF

# Bibliotecas (Pacotes) -------------------------------------------------------#
## Para instalar as bibliotecas necessárias, use os comandos abaixo:
for (p in c('tidyverse', 'trend', 'xts', 'forecast')) {
  if (!require(p, character.only = T)) {
    install.packages(p, character = T)
  }
  library(p, quietly = T, character.only = T)
}

## Importação dos dados -------------------------------------------------------#
## vamos baixar a série temporal de Itaperuna (RJ) organizada na 1ª parte do curso.
url_dados <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/An%C3%A1lise%20de%20S%C3%A9ries%20Temporais/dados_itaperuna.csv'

dados <- 
  readr::read_delim(url_dados,
             delim = ';', 
             locale = locale(decimal_mark = ',')) %>% 
  dplyr::mutate(Data = dmy(Data)) %>% 
  print()

# Prec = PRECIPITACAO TOTAL, MENSAL(mm)
# Tmed = TEMPERATURA MEDIA COMPENSADA, MENSAL(°C)
# Tmin = TEMPERATURA MINIMA MEDIA, MENSAL(°C)
# Tmax = TEMPERATURA MAXIMA MEDIA, MENSAL(°C)

## Gráficos de linha ----------------------------------------------------------#

## Gráfico da temperatura média mensal para o período de 2010 a 2015.
gr <- 
  dados %>% 
  dplyr::filter(Ano >= 2010 & Ano <= 2015) %>% 
  ggplot2::ggplot() +
  aes(x = Data, y = Tmed) +
  geom_line(
    linetype = 1,
    lwd = 1,
    col = 'steelblue4') +
  scale_x_date(name = NULL, 
               date_breaks = '2 months',
               date_labels = '%m/%Y') +
  scale_y_continuous('Temperatura (ºC)', 
                     limits = c(20, 30), breaks = seq(20, 30, 1)) +
  theme_minimal() +
  theme(axis.text = element_text(size = 8, angle = 90))
gr

## Calculando a média anual das temperaturas (máxima, média e mínima):
Temp.a <-
  dados %>% 
  dplyr::group_by(Ano) %>% 
  dplyr::summarise(
    dplyr::across(.cols = 5:7,
           .fns = mean, na.rm = T))
print(Temp.a)

## Gráfico da série temporal anual da temperatura máxima:
gta1 <- 
  Temp.a %>% 
  ggplot2::ggplot() +
  aes(x = Ano, y= Tmax) +
  geom_line(aes(color = 'Tmax'), linetype = 1,	lwd = 1) +
  scale_y_continuous('Temperatura (ºC)', 
                     limits = c(29,32), breaks = seq(29, 32, 1)) +
  scale_x_continuous(NULL, limits = c(1993, 2021), 
                     breaks = seq(1993, 2021, 2)) +
  scale_color_manual(name = NULL, values = 'steelblue', 
                     labels = 'Média Anual da Temperatura Máxima (ºC) ') +
  theme_minimal(base_size = 12) +
  theme(legend.position = c(0.8, 0.1))
gta1

## Inserindo os pontos no gráfico da série temporal anual:
gta2 <- 
  gta1 +
  geom_point(color ='darkblue', 
             shape = 21, 
             size= 1.5) 
gta2

## Gráfico de linha com o desvio padrão da variável:
## A função geom_ribbon() exibe um intervalo y definido por ymin e ymax.
gta3 <- 
  gta2 +
  geom_ribbon(aes(x = Ano, 
                  ymin = Tmax - sd(Tmax, na.rm = T), 
                  ymax = Tmax - sd(Tmax, na.rm = T),
                  fill = 'Tmax'),
              alpha = 0.1) +
  scale_fill_manual(name = '', values ='red', labels = 'Desvio Padrão') +
  theme(legend.position = 'bottom') +
  guides(colour = guide_legend(order = 2),
         fill = guide_legend(order = 1))
gta3

## Gráfico de linha com a linha de tendência:
gtt <- 
  Temp.a %>% 
  ggplot2::ggplot() +
  aes(x = Ano, y = Tmax) +
  geom_line(color = 'steelblue', linetype = 1, lwd = 1) + 
  geom_smooth(aes( 
    colour = 'Linha de tendência com intervalo de confiança de 95%'), 
    method = lm,  # Para method = lm estamos definindo que queremos uma reta de regressão linear. 
    fill='darksalmon') +
  theme_minimal(base_size = 12) +
  scale_y_continuous('Temperatura (ºC)', 
                     limits = c(29,32), breaks = seq(29, 32, 1)) +
  scale_x_continuous(' ', limits = c(1993, 2021), 
                     breaks = seq(1993, 2021, 2)) +
  labs(colour = NULL) +
  theme(legend.position=c(0.74, 0.1))
gtt

## Adicionando a equação da reta e o R² no gráfico.
## Vamos usar a função do stat_regline_equation() do pacote ggpubr.

gtt2 <- gtt +
  ggpubr::stat_regline_equation(aes(
    label = paste(..eq.label.., ..rr.label.., sep = '~~~~')))
gtt2 

# y = A + Bx
# y = Variável dependente;
# A = intercepto (valor de y quando x = 0);
# B =	coeficiente angular (inclinação da reta: acréscimo ou decréscimo em y);
# x =	Variável independente.

# ANÁLISE DE TENDÊNCIA---------------------------------------------------------#

## Teste de Mann Kendall ---#
# utilizado para determinar se uma série temporal possui uma tendência de 
# alteração (aumento ou diminuição) estatisticamente significativa.

# Hipóteses do teste
# H0 (hipótese nula):  Não há tendência presente nos dados.
# H1 (hipótese alternativa):  Há tendência nos dados. A tendência pode ser positiva ou negativa.

# Vamos usar a função mk.test() do pacote trend:
trend::mk.test(Temp.a$Tmax)   # tau mede a monotonia da inclinação.

# Se o valor p do teste for inferior a algum nível de significância (Ex.: 1%, 5% e 10%), 
# então há evidência estatisticamente significativa de que uma tendência está presente nos dados da série temporal.

## Estimator de Sen ---#  
# Utilizando para determinar a existência de tendência e sua magnitude.

S <- Temp.a$Tmax %>% 
    trend::sens.slope(conf.level = 0.95) %>% 
  print()

S$estimates  # Magnitude da tendência estimada.
S$p.value    # Valor p. 

## Teste de Pettitt---#
# Verifica a presença de mudança na tendência de uma série temporal.

# Hipóteses do teste
# H0: Não há mundança na tendência da série.
# H1: Há mundança na tendência da série.

# Verificando quebra estrutura na série temporal:
Pett.Tmax <- Temp.a$Tmax %>% 
  trend::pettitt.test() %>% 
  print()

# Observando em que ano se encontra a quebra estrutural:
Temp.a$Ano[Pett.Tmax$estimate]

## Gráfico de linha da série temporal anual com a magnitude de tendência e o p valor:
gtt +
  geom_label(aes(x = 1993, 
                 y = 31.7, 
                 hjust = 0,
                 vjust = 0,
                 label = paste('Slope =', round(S$estimates, 7),'ºC/ano','\n',
                               'p-value =',round(S$p.value, 7))), 
             label.size = NA,
             fill = NA)

# MODELOS DE PREVISÃO----------------------------------------------------------#
# Primeiro vamos transformar as temperaturas (máxima, média e mínima) em série temporal:
Tm_st <- 
  dados %>%
  dplyr::select(Tmax, Tmed, Tmin) %>% 
  stats::ts(start = 1993 , end = 2022, freq = 12) %>% 
  print()

# Dependendo do modelo utilizado, será necessário preencher os dados ausentes,
# uma alternativa é a função 'na.StructTS', que é uma função genérica para 
# preencher valores de NA usando filtro de Kalman sazonal.
zoo::na.StructTS(Tm_st[,2])

## Com a função 'decompose' podemos fazer a decomposição de séries temporais.
## Podemos observar a tendência, sazonalidade e a componente aleatória da série.
stats::decompose(
  zoo::na.StructTS(Tm_st[,2])) %>% 
  plot()

### Sugestão para lidar com dados ausentes: Pacote 'mice' ---#
### MICE ('Multivariate Imputation via Chained Equations)
### Esse pacote cria várias imputações (valores de substituição) para dados ausentes multivariados.

## Modelo de Holt-winters ---#
# É um dos modelos mais utilizados para a previsão de curto prazo, devido à 
# sua simplicidade, baixo custo de operação e boa precisão.

# O modelo Holt-Winters possui dois métodos: Multiplicativo e Aditivo.

### Modelo Aditivo:
# É utilizado quando a amplitude da variação sazonal é constante ao longo do 
# tempo, ou seja, a diferença entre o maior e o menor ponto nos ciclos 
# permanece constante com o passar do tempo.

### Método Multiplicativo:
# Tem como premissa básica a suposição de que a amplitude da sazonalidade é 
# variante no tempo, e provavelmente, essa variação ocorre de forma crescente.
# Esse modelo é capaz de incorporar tanto a tendência linear quanto o efeito sazonal.

### Estimando o modelo Holt Winters.
# Para avaliar a qualidade do modelo vamos reservar a parte final dos dados. 
# a ideia é comparar as previsões com as observações da parte final.

# Podemos usar a função 'window' para extrair um subconjunto dos dados.
(dados.mod <- Tm_st[,2] %>% 
    stats::window(end = c(2020, 12)))

### Método Aditivo:
HWa <- 
  zoo::na.StructTS(dados.mod) %>% 
  stats::HoltWinters(seasonal = 'additive')	
HWa

### Método Multiplicativo:
HWm <- 
  zoo::na.StructTS(dados.mod) %>% 
  stats::HoltWinters(seasonal = 'multiplicative')	
HWm

## Constantes de suavização calculadas:
## alpha: nível da série 
## beta: tendência
## gama: sazonalidade

HWm$alpha; HWm$beta; HWm$gamma
HWm$fitted   # Estimativas

# Previsão para 6 meses com um intervalo de confiança de 95%.
pred <- HWm %>% 
  stats::predict(n.ahead = 10,
          prediction.interval = TRUE, level = 0.95)
pred

# Transformando os dados estimados e previstos em série temporal:
ts_pred <- c(HWm$fitted[, 1], pred) %>%
  stats::ts(start = 1993, frequency = 12) %>% 
  print()

# Vamos usar a função 'merge' para combinar os conjuntos de dados: 
dt <- merge(estimados = xts::as.xts(ts_pred), 
            observados = xts::as.xts(Tm_st[,2])) %>% 
  print()

# Vizualização dos dados observados e estimados:
dt %>% 
  ggplot2::ggplot() +
  aes(x = as.POSIXct(index(dt))) + 
  geom_line(aes(y = estimados, color = 'Estimado')) + 
  geom_line(aes(y = observados, color = 'Observado')) + 
  theme_minimal() +
  geom_vline(xintercept = as.numeric(as.POSIXct('2020-12-01')), 
             linetype = 'dashed') + 
  labs(title = 'Modelo Holt-Winters', x = 'Data', y = 'Observado/Estimado') + 
  theme(plot.title = element_text(size = 18, face = 'bold'),
        legend.direction='horizontal') +
  scale_color_manual(name = NULL, values = c('#E54D1E', '#217CD1'))+
  theme(legend.position=c(0.8, 0.99))

## Modelo de Box-Jenkins ---#
# A metodologia Box-Jenkins é aplicada aos processos estocásticos que sejam estacionários
# A ideia básica de estacionariedade é que as leis de probabilidade que atuam 
# no processo não mudam com o tempo, isto é, o processo mantém o equilíbrio estatístico.

## Pressuposto básico do modelo: homocedasticidade (variâncias iguais) no conjunto de dados.
stats::bartlett.test(dados$Tmed ~ dados$Ano)

### Hipóteses do teste de Bartlett:
# H0 (hipótese nula): as variâncias são iguais.
# H1 (hipótese alternativa): as variâncias não são iguais.
# Se o valor p do teste for menor do que o de seu nível de significância (Ex.: 1%, 5% e 10%), 
# rejeite a hipótese nula.

### Obs.: Se as condições não forem respeitadas, a série estudada deve passar por
### um processo de transformação. É possível aplicar a transformação de Box-Cox (pacote 'car')
### para obter homocedasticidade (variâncias iguais) dos dados.

## Teste de raiz unitária: verificar a estacionariedade da série.
### teste de Phillips-Perron
zoo::na.StructTS(dados.mod) %>%
  stats::PP.test()

### Hiposteses do teste:
# H0: Existe pelo menos uma raiz dentro do círculo unitário (não estacionária).
# H1: Não existe raiz dentro do círculo unitário (estacionária).
# Se o valor p do teste for menor do que o de seu nível de significância (Ex.: 1%, 5% e 10%), 
# rejeite a hipótese nula.

### Obs.: Para tornar estacionária uma determinada série temporal, podemos estimar 
### o número de diferenças necessárias usando funções do pacote 'forecast' (Ex: diff, ndiffs, nsdiffs)

## O método de previsão do modelo de Box-Jenkins é dividido em quatro etapas:
# 1. Identificação: encontrar os valores de p, d, e q que sejam apropriados para
#    descrever o comportamento da série;
# 2. Estimação: deve-se estimar os parâmetros autorregressivos de médias móveis incluídos no modelo;
# 3. Diagnóstico: deve-se verificar se o modelo escolhido se ajusta aos dados.
#    Verificar se os resíduos estimados do modelo são ruídos brancos (média zero, 
#    variância constante e independente e identicamente distribuído). Se sim, 
#    pode-se aceitar o ajuste específico; caso contrário deve-se repetir o processo.
# 4. Previsão.

## A previsão baseada na metodologia de Box-Jenkins tem como base o ajuste de 
## modelos de tentativa chamados de ARIMA (auto regressivos integrados de médias móveis) 

## O modelo ajustado terá a notação usual ARIMA(p,d,q)(P,D,Q)[m], onde:
# p = A ordem do modelo auto regressivo. O modelo inclui valores defasados da 
#     variável dependente entre os regressores.
# d = A ordem de diferenciação. A diferenciação é usada para transformar os 
#     dados de forma que fiquem estacionários.
# q = a ordem da média móvel. Envolve obter a média dos pontos de uma série 
#     para um atraso específico.

## Caso a série possua sazonalidade ([m] representa a ordem sazonal), vamos ter:
# P para o número de parâmetros autorregressivos sazonais;
# D para a ordem de integração sazonal;
# Q para o número de parâmetros de médias móveis sazonais.

# Inicialmente, vamos rodar a função 'auto.arima', pois ela vai possibilitar a 
# definição de parâmetros “P”, “D” e “Q”, e fornecer o melhor ajuste da série.
dados.mod %>% 
  forecast::auto.arima(trace = TRUE)   # trace: TRUE exibe todos os possíveis modelos.

## A função 'auto.arima' retorna o melhor modelo de acordo com os valores de:
## AIC, AICc ou BIC.
# Critério de informação de Akaike - AIC
# Critério de informação de Akaike corrigido - AICc
# Critério de informação bayesiano - BIC
## Tais parâmetros podem e devem ser alterados a fim de buscar um melhor ajuste do modelo.

# Estimando o modelo usando a função 'arima':
(fit <- 
   dados.mod %>% 
    stats::arima(order = c(2,0,0), 
         seasonal = list(order = c(2,1,0), period = 12)))

# Aplicando a função predict() para previsao:
prev <- fit %>% 
    stats::predict(n.ahead = 12, prediction.interval = TRUE) %>% 
  print()

# Verificação dos resíduos ---#
# Vamos usar a função 'checkresiduals' do pacote 'forecast'.
forecast::checkresiduals(fit)

# 1. A sequência de erros deve oscilar em torno de zero (gráfico superior). 
# 2. No gráfico ACF, os valores devem estar dentro do intervalo de confiança (gráfico inferior esquerdo),
#    ou seja,os resíduos não devem mostras autocorrelações significativas.
# 3. Além disso, a distribuição dos erros deve seguir uma distribuição 
#    aproximadamente normal (gráfico inferior direito).

# Teste de normalidade Shapiro-Wilk:
stats::shapiro.test(fit$residuals)    

# Teste de normalidade Kolmogorv-Sminorv:
stats::ks.test(fit$residuals,'pnorm') 

# Para ambos os testes, a hipótese nula do teste é de que a série analisada é 
# normalmente distribuída. Se o valor p do teste for menor do que o de seu nível 
# de significância (Ex.: 1%, 5% e 10%), rejeite a hipótese nula (que os resíduos 
# do modelo são normalmente distribuídos).

# Se os resíduos são não autocorrelacionados e são normalmente distribuídos, 
# passa-se ao próximo passo. Caso contrário, retorna-se ao primeiro passo.

#------------------------https://linktr.ee/pexcca.lamet------------------------#
