#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 25/07/2023                        #
#==============================================================================#

#                   MANIPULAÇÃO E VISUALIZAÇÃO DE DADOS NO R                   #
#                         PROGRAMANDO COM O TIDYVERSE                          #

#------------------------------------------------------------------------------#
# TÓPICOS ABORDADOS:
# ✓ Introdução;
# ✓ Projetos no RStudio (.RProj);
# ✓ Operador pipe (%>%);
# ✓ Manipulando dados com ‘tidyr’ e ‘dplyr’;
# ✓ Visualização gráfica com ‘ggplot2’;
# ✓ Extensões do ‘ggplot2’.

# 1. INTRODUÇÃO ---------------------------------------------------------------#
# A manipulação de dados é o processo de coleta, limpeza, processamento, seleção, 
# agregação e síntese dos dados.

# Em geral, a manipulação e a visualização de dados pode ser feita com o R base, 
# mas o 'tidyverse' facilita as tarefas de análise de dados, além de ter melhor 
# performance computacional. 

# O `tidyverse` é uma coleção de pacotes da linguagem R construídos para a ciência 
# de dados. Todos os pacotes compartilham uma mesma filosofia de design, gramática 
# e estrutura de dados, facilitando a programação.

# Neste curso, vamos usar os pacotes: 'tidyr’, ‘dplyr’ e ‘ggplot2’. 

### Nota: Recomendados a leitura do livro "R for Data Science" dos autores Hadley 
### Wickham e Garrett Grolemund, disponível em: r4ds.had.co.nz/.

# 2. PROJETOS NO RSTUDIO (.RPROJ)----------------------------------------------#
# Uma funcionalidade muito útil do RStudio é a possibilidade de criar projetos (Rproject).
# O Rproject nada mais é do que uma pasta no seu computador. Seu uso traz uma série 
# de benefícios na organização e reprodução de análises. 

# Alguns dos principais benefícios do Rproject:
# 1. Organização de arquivos: Você pode organizar todos os arquivos relacionados 
#    a um projeto em um único diretório, facilitando a localização e o gerenciamento
#    de scripts, dados, gráficos, relatórios e outros arquivos associados.

# 2. Independência de diretórios: Cada projeto R possui seu próprio diretório de
#    trabalho, o que significa que os caminhos para arquivos e pacotes são
#    relativos ao diretório do projeto. Isso evita conflitos entre projetos e
#    permite que você alterne facilmente entre projetos sem precisar reconfigurar
#    caminhos e configurações.

# 3. Controle de versão: Você pode integrar o projeto R com sistemas de controle 
#    de versão, como o Git, para rastrear alterações, colaborar com outros usuários 
#    e recuperar versões anteriores do código.

# 4. Facilidade de compartilhamento: Ao compartilhar um projeto R, você pode
#    incluir todos os arquivos e configurações necessários para que outras
#    pessoas reproduzam sua análise. Isso torna mais fácil colaborar em
#    projetos, compartilhar código e resultados, e garantir que todos estejam
#    trabalhando no mesmo contexto.

# 5. Automatização: Você pode automatizar tarefas e análises por meio de scripts
#    e funções. Isso permite que você crie fluxos de trabalho reprodutíveis e 
#    repetíveis, economizando tempo e minimizando erros.

# Em resumo, o uso de um projeto R ajuda na organização, reprodutibilidade,
# compartilhamento e controle de versão, tornando suas análises mais eficientes,
# colaborativas e confiáveis.

# 3. OPERADOR PIPE (%>%)-------------------------------------------------------#
# O operador pipe é uma das funcionalidades mais populares na comunidade R. 
# Ele foi introduzido pelo pacote 'magrittr', criado por Stefan Milton Bache e 
# Hadley Wickham. Pouco tempo depois foi incorporado ao `dplyr`, onde segue como 
# parte do `tidyverse`.

# O operador pipe do pacote 'magrittr' é representado por '%>%'. 
# A ideia principal é facilitar o processo de manipulação e transformação de dados, 
# proporcionando uma sintaxe fluida e orientada a ações através do encadeiamento
# de funções, evitando a criação de objetos intermediários.

# Devido o grande sucesso do operador pipe, a equipe principal da linguagem R 
# implementou na linguagem uma versão do pipe nativo com a sintaxe '|>', que está
# disponível à partir da versão 4.1 do R. Apesar disso, neste curso vamos usar o `%>%`.

# A ideia do operador pipe é usar o valor resultante de uma expressão como 
# primeiro argumento da próxima função, possibilitando o encadeiamento de funções.

# Atalho de teclado do pipe (%>%): Ctrl + Shift + M

# Exemplo 1: Calcule a raiz quadrada da soma dos valores de 1 a 9 com 2 casas decimais.

## Primeiro, sem o pipe:
x <- sqrt(sum(1:9))
round(x, digits = 2)

## Agora com o pipe.
1:9 %>% sum() %>% sqrt() %>% round(digits = 2)

# Exemplo 2: Fazer a importação do arquivo que será utilizado neste curso.
# Vamos importar os dados do GitHub, no link abaixo:
urf_file <- 'https://raw.githubusercontent.com/PExCCA-UENF/Scripts-R-Cursos/main/Manipula%C3%A7%C3%A3o%20e%20Visualiza%C3%A7%C3%A3o%20de%20Dados/Dados_Prec_INMET_A607.csv'

## Para realizar a importação de maneira adequada, devemos conhecer a tabela de dados.
## Vamos importar um arquivo CSV que utiliza como separador de colunas o ";" e 
## como separador decimal o ",". Outro ponto importante é  identificar como os
## dados ausentes estão representados, que nesse caso estão representados por "null". 
## Assim, podemos utilizar a função `read_csv2()` para realizar a importação, 
## configurando apenas o argumento dos dados ausentes.

## Primeiro, sem o pipe:
dados_prec <- read_csv2(urf_file, na = "null")
View(dados_prec)

## Agora com o pipe.
dados_prec2 <- 
  urf_file %>% 
  read_csv2(na = "null") %>% 
  View()

## Esse arquivo possui dados de precipitação diária de Campos dos Goytacazes (RJ),
## para o período de 2012 a 2022. Foi obtido do Instituto Nacional de Meteorologia (INMET).

# 4. MANIPULANDO DADOS COM ‘TIDYR’ E ‘DPLYR’-----------------------------------#

# install.packages("tidyverse")
library(tidyverse)
