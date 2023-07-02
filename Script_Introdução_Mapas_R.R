#==============================================================================#
#          EXTENSÃO UNIVERSITÁRIA EM CIÊNCIAS CLIMÁTICAS E AMBIENTAIS          #
#          PROJETO "PROCESSAMENTO E ANÁLISE DE DADOS AMBIENTAIS COM R"         #
#                        Contato: pexcca.lamet@uenf.br                         #
#                       https://linktr.ee/pexcca.lamet                         #
#                       Script Atualizado em 02/07/2023                        #
#==============================================================================#

#                          INTRODUÇÃO A MAPAS NO R                             # 

# ---------------------------------------------------------------------------- #
# TÓPICOS ABORDADOS:
# 1. Introdução;
# 2. Estruturas vetoriais;
# 3. Explorando atributos de dados vetoriais;
# 4. Manipulando dados vetoriais;
# 5. Arquivos vetoriais no formato shapefile;
# 6. Criando mapas com `geobr` e ‘ggplot2’.

# 1. INTRODUÇÃO----------------------------------------------------------------#
# Os dados espaciais têm dois formatos primários: raster/matricial e vector/vetorial.
# Aqui, vamos trabalhar com arquivos vetoriais, que podem representados por pontos, linhas e polígonos. 

# Exemplos: 
#   Uma casa pode ser representada por ponto;
#   Um rio pode ser representado por uma linha, ou seja, uma junção de pontos;
#   Um estado pode ser representado por um polígono.

# Esses pontos e linhas tem posições no espaço, medidas pelo sistema de coordenadas (x e y).
# Os Sistemas de coordenadas podem ser cartesiano, lat e lon.

# 2. ESTRUTURAS VETORIAIS------------------------------------------------------#
# Vamos trabalhar com arquivos vetoriais utilizando o pacote 'sf'(simple features) do R.
# O pacate 'sf' permite manipular dados em duas, três ou quatro dimensões.
# É um conjunto de especificações para representar objetos geométricos (como ponto,
# linha, polígono, multiponto...) e seus atributos associados.

# install.packages('sf')   # instalando o pacote 'sf'.
library(sf)                # Carregando o pacote.

## 2.1 Criando pontos e multipontos ---
# Usando a função st_point() do pacote 'sf' podemos criar um ponto a partir das 
# informações de coordenadas ou um ponto resultante de uma representação.

p1 <- st_point(x = c(4,3))   # 2 dimensões (XY). 
class(p1)

(p2 <- st_point(x = c(1,1)))
(p3 <- st_point(x =c(4,1)))

# Usando a função st_multipoint() do pacote 'sf' podemos criar um objeto do tipo "multiponto".
# Objeto do tipo "multiponto" pode armazenar mais de um ponto ao mesmo tempo.

# 1º vamos criar uma matriz com vários pontos:
(mtx <- matrix(data = c(p1, p2, p3, p1),   # Vetor com os pontos.
               nrow = 4))                  # Número de linhas.

rownames(mtx) <- c("p1", "p2", "p3", "p1")  # Renomear as linhas.
colnames(mtx) <- c("X", "Y")                # Renomear as colunas.
print(mtx)                                  # Visualizar o conteúdo armazenado no objeto.

# Agora podemos criar um Objeto do tipo "multiponto":
mp <- st_multipoint(x = mtx)
print(mp); class(mp)

# Plotando os pontos com a função plot() do do R base:
plot(mp, col='red', pch=19)

## 2.2 Criando linhas e multilinhas ---
# As linhas representam uma sequência de pontos conectados.
# A função st_linestring() do pacote 'sf' cria uma linha a partir de uma entrada especificada:

st_linestring(x = mtx)

L1 <- st_linestring(x = c(p1, p2))   # Linha entre os pontos p1 e p2.
print(L1); class(L1); plot(L1)

L2 <- st_linestring(x = c(p2, p3))   # Linha entre os pontos p2 e p3.
print(L2); class(L2); plot(L2)

L3 <- st_linestring(x = c(p3, p1))   # Linha entre os pontos p3 e p1.
print(L3); class(L3); plot(L3)

# Usando a função st_multilinestring() podemos criar um objeto multilinhas. 
# Para isso, usamos como dado de entrada uma lista contendo os pontos que conectam as linhas.

L123 <- st_multilinestring(x = list(L1, L2, L3))
print(L123); class(L123); plot(L123)

ML <- st_multilinestring(x = list(mp))
print(ML); class(ML); plot(ML)

## 2.3 Criando polígonos ---
# Os polígonos são usados para representar áreas. 
# São definidos por um conjunto ordenado de pontos interligados, onde o primeiro e último ponto coincidem.

# Podemos usar a função st_polygon() do pacote 'sf' para criar um polígono.
# Para isso, usamos como dado de entrada uma lista com os pontos que serão interligados.

pol <- st_polygon(x = ML)
print(pol); class(pol); plot(pol, col = "lightblue")

## 2.3 Medições geométricas ---
# O pacote'sf' possui várias funções para obter algumas métricas.
(d.pts <- st_distance(p1, p2))   # Retorna a menor distância entre pontos geométricos.
(c.l <- st_length(L1))           # Retorna o comprimento de uma linha.
(ct.l <- st_centroid(L1))        # Retorna o centroide de uma geometria.
(ct.pol <- st_centroid(pol))             
(a.pol <- st_area(pol))          # Retorna a área do polígono.

cat('Menor distância entre os pontos geométricos 1 e 2:', d.pts,
    '\nComprimento da linha (L1):', c.l,
    '\nCentróide (xy) da linha (L1):', ct.l,
    '\nCentróide (xy) do polígono:', ct.pol,
    '\nÁrea do polígono:', a.pol)

# 3. EXPLORANDO ATRIBUTOS DE DADOS VETORIAIS------------------------------------#
# De acordo com seus atributos, os dados vetoriais permitem atribuir diferentes objetos na mesma camada.

# Exemplo:
# 1º Vamos usar a função st_sfc() do pacote 'sf' para juntar vários sfg (geometria de um único recurso) 
# em um sfc (lista de geometrias de objetos). 
lista.g <- st_sfc(L1, L2, L3)
print(lista.g); class(lista.g)

# 2º Vamos criar uma tabela de atributos.
num <- c(1, 2, 3)                       # ID.
code <- c("A1", "R1", "R2")             # Código.
tipo <- c("Avenida", "Rua", "Rua")      # Informação adicional dos pontos.
tab.at <- data.frame(num, code, tipo)   # Tabela com os atributos.

# Agora vamos converter a tabela de atributos (tab.at) para a classe 'sf'(modelo geométrico de recursos simples):
tab.sf <- st_sf(tab.at,               # Elementos que serão vinculados a um objeto 'sf'.
                geometry = lista.g)   # Geometria 'sfc' para associação com a tabela de atributos. 
print(tab.sf); class(tab.sf)

plot(x = tab.sf, 
     axes = TRUE)   # Use axes = TRUE para adicionar os eixos x e y.

# Para plotar só a geometria podemos usar a função st_geometry() do pacote 'sf':
plot(x = st_geometry(tab.sf), 
     axes = TRUE)

# Também podemos usar o operador $geometry para especificar uma geometria.
plot(x = tab.sf$geometry, 
     axes = TRUE)

# Alterando alguns argumentos da função plot():
plot(x = tab.sf$geometry, 
     axes = TRUE, 
     col = c("black", "blue", "red"),   # Alterar as cores. 
     lwd = c(1, 2, 2),                  # Alterar as espessuras das linhas. 
     lty = c(1, 2, 3))                  # Alterar os tipos de linhas. 

# 4. MANIPULANDO DADOS VETORIAIS------------------------------------------------#
## 4.1 Obtendo e configurando Sistema de Referência de Coordenadas (SRC) de objetos 'sf'.
# Podemos usar a função st_crs() para obter o SRC do objeto.
sf::st_crs(x = tab.sf)   # Sistema de Referência de Coordenadas: NA

tab.sf2 <- tab.sf         # Criar um novo objeto.
sf::st_crs(tab.sf2) <- 4326   # Atribuindo um SRC.
sf::st_crs(tab.sf2)

# Transformações do Sistema de Referência de Coordenadas (SRC).
# Para realizar uma conversão ou transformação de coordenadas, podemos usar a função st_transform():
sf::st_transform(x = tab.sf2, 
                 crs = 3857)   # Sistema de Referência de Coordenadas.

## 4.2 Subconjuntos de dados---#
# Para criar subconjuntos de dados vetoriais podemos usar a função subset() da base do R.
R <- subset(x = tab.sf,               # Objeto a ser filtrado.
            subset = tipo == "Rua")   # Condição que será aplicada. 
print(R)
plot (R$geometry)

A <- subset(x = tab.sf, 
            subset = tipo=="Avenida")
print(A)
plot (A$geometry)

plot(R$geometry, axes = TRUE, 
     col = c("blue", "red"),
     lwd = 2,
     lty = c(2, 3))

plot(A$geometry, 
     add = TRUE)   # Se add = TRUE o objeto será adicionado no gráfico atual.

# 5. ARQUIVOS VETORIAIS NO FORMATO SHAPEFILE------------------------------------#
# O shapefile é um formato para bases de dados geoespaciais e vetoriais em sistemas de informação geográfica. 
# O shapefile consiste numa coleção de arquivos de mesmo nome e terminações diferentes, armazenados no mesmo diretório. 
# Existem três arquivos obrigatórios para o funcionamento correto de um shapefile: .shp, .shx e .dbf.  
#   shp: armazena as entidades geométricas dos objetos;
#   shx: armazena o índice de entidades geométricas;
#   dbf: armazena a tabela de atributos dos objetos;

# O arquivo shapefile propriamente dito é o .shp, mas se distribuído sozinho não será capaz de exibir os dados armazenados. 

## 5.1 Importação de dados shapefile---# 
# Vamos importar os dados de Unidades de Conservação na Amazônia Legal,
# Disponível em: http://terrabrasilis.dpi.inpe.br/downloads/

# Link para baixar os dados:
url_file <- "http://terrabrasilis.dpi.inpe.br/download/dataset/legal-amz-aux/vector/conservation_units_legal_amazon.zip"

# Use a função tempfile() para criar arquivos temporários. 
# Você pode substituir tempfile() por um caminho de seu computador.
dest_file1 <- tempfile()
dest_file2 <- tempfile()

# Use a função download.file() para para baixar o arquivo da Internet 
# conforme descrito em url e armazene em destfile.
download.file(url = url_file, 
              destfile = dest_file1)

# A função unzip() permite descompactar o arquivo zip.
unzip(zipfile = dest_file1,   # Arquivo que será executado. 
      exdir = dest_file2)     # O diretório que será extraído os arquivos.

dir(dest_file2)  # Lista os arquivos do dest_file2.

# Para ler os arquivos do tipo shapefile (.shp) vamos usar a função st_read() do pacote 'sf'.
UC <- sf::st_read(dsn = file.path(dest_file2, 
                                  layer = "conservation_units_legal_amazon.shp")) 

str(UC)  # Retorna a estrutura do objeto.
plot(UC$geometry, 
     axes = TRUE)

# Vamos selecionar as UCs dos últimos 23 anos.
## 1º precisamos converter a coluna 'ano_cria' para numérica.
UC$ano_cria
unique(UC$ano_cria)   # Verificando os valores únicos da coluna 'ano_cria'.

## Será necessário substituir a informação "e 2016 de 11/05/2016" por '2016':
UC$ano_cria[UC$ano_cria == "e 2016 de 11/05/2016"] <- '2016'

## Agora podemos transformar a coluna 'ano_cria' em numérica.
UC$ano_cria <- as.numeric(UC$ano_cria)

sort(UC$ano_cria)   # Ordenar os anos.

# Vamos selecionar os dados a partir de 2000.
UC.rec <- subset(x = UC, 
                 subset = ano_cria >= 2000)

sort(UC.rec$ano_cria)

# Podemos exportar dados shapefile usando a função st_write() do pacote 'sf'. 
sf::st_write(UC.rec,                # Objeto que será exportado.
             'UCs_2000_2023.shp')   # Nome e formato do arquivo que será exportado.


# 6. CRIANDO MAPAS COM `GEOBR` E ‘GGPLOT2’.-------------------------------------#
## 6.1 Pacote `geobr`---#
# O 'geobr' é um pacote R que permite o acesso dos shapefiles do Instituto Brasileiro de Geografia e Estatística (IBGE).
# install.packages('geobr')   # instalando o pacote 'geobr'.
library(geobr)                # Carregando o pacote.

View(list_geobr())     # Retorna a base de dados do pacote 'geobr'.

# Podemos usar a função read_country() para baixar os dados das fronteiras do Brasil.
BR <- geobr::read_country(year = 2020)   # 2020 é o ano do conjunto de dados. 
plot(BR$geom)

# Com a função read_amazon() podemos baixar os dados da Amazônia Legal.
Amazon <- geobr::read_amazon()
plot(Amazon$geom, col = 'lightgreen')

# Para plotar mais de um objeto 'sf' no mesmo plot, é importante que eles estejam no mesmo SRC.
sf::st_crs(BR)
sf::st_crs(Amazon)
st_crs(BR) == st_crs(Amazon)

## 6.2 Pacote ‘ggplot2’---#
# O 'ggplot2' faz parte da coleção de pacotes "Tidyverse" e foi construído para visualização de dados.
# install.packages('ggplot2')   # instalando o pacote 'ggplot2'. 
library(ggplot2)                # Carregando o pacote. 

# No ggplot2, os gráficos são construídos camada por camada.
# A camada base é dada pela função ggplot(), que recebe o conjunto de dados.
ggplot(data = BR)

# É necessário especificar como as observações serão mapeadas nos aspectos visuais do gráfico 
# e quais formas geométricas serão utilizadas.

# A função geom_<FUNCTIONS>() define qual forma geométrica será utilizada para a visualização dos dados.
# Use geom_sf() para plotar os mapas.
ggplot(data = BR)+
  geom_sf()

# Os mapeamentos estéticos são especificados por aes().
# Mapeamento Estético:
# x e y: observações que serão mapeadas;
# color: define a cor de pontos e retas;
# fill: define a cor dos preenchimentos das formas com área;
# size: altera o tamanho das formas;
# alpha: altera a transparência das formas;
# shape: altera o estilo das formas;
# labels: altera o nome das observações.
## Nota: Os aspectos que podem ou devem ser mapeados dependem do tipo de gráfico que você está construindo.

mapaBR <- ggplot() +
  geom_sf(data = BR,            # Dados do Brasil.
          color='white')        # Cor das linhas/bordas da camada.
mapaBR

# Plotando o mapa do Brasil com o mapa da Amazônia Legal:
mapaBR.AM <- mapaBR +             # Objeto com o mapa do Brasil.
  geom_sf(data = Amazon,          # Dados da Amazônia Legal.
          color = 'darkgreen',    # Cor das linhas/bordas da camada.
          fill = 'lightgreen')    # Cor de preenchimento da camada.
mapaBR.AM 

# Mapa das Unidades de Conservação na Amazônia Legal.
## Exemplo1:
ggplot() +
  geom_sf(data = BR,              # Dados do Brasil.
          color='darkgray',
          fill = '#F2F2E6',
          size = 2) + 
  geom_sf(data = Amazon,          # Dados da Amazônia Legal.
          color = 'darkgreen', 
          fill = 'lightgreen',
          alpha = 0.5)+           # Transparência da camada.
  geom_sf(data = UC.rec,          # Dados das Unidades de Conservação na Amazônia Legal.
          aes(fill = categoria))  # Use o argumento fill dentro de aes para aparecer a legenda.

## Exemplo2:
# 1º Vamos verificar valores únicos da coluna categoria.
categorias <- unique(UC.rec$categoria)
sort(categorias)  # Ordenar os nomes.

# 2º Vamos criar um degradê de cores:
color <- colorRampPalette(c('darkblue', 'purple', 'yellow4', 'orange', 'darkred'))
(cores <- color(11))
barplot(1:11, col = cores)

# Agora vamos criar o mapa e configurar as cores:
mapaBR.UC <- ggplot() +
  geom_sf(data = BR,                       # Dados do Brasil.
          aes(fill = 'Brasil'),
          size = 2) + 
  geom_sf(data = Amazon,                   # Dados da Amazônia Legal.
          aes(fill = 'Amazônia Legal'))+   
  geom_sf(data = UC.rec,                   # Dados das Unidades de Conservação na Amazônia Legal.
          aes(fill = categoria))+
  scale_fill_manual(values = c('Brasil' = 'beige', 
                               'Amazônia Legal' = 'lightgreen',
                               'Área de Proteção Ambiental' = cores[1],
                               'Área de Relevante Interesse Ecológico' = cores[2],
                               'Estação Ecológica' = cores[3],
                               'Floresta' = cores[4],
                               'Monumento Natural' = cores[5],
                               'Parque' = cores[6],
                               'Refúgio de Vida Silvestre' = cores[7],
                               'Reserva Biológica' = cores[8],
                               'Reserva de Desenvolvimento Sustentável' = cores[9],
                               'Reserva Extrativista' = cores[10],
                               'Reserva Particular do Patrimônio Natural' = cores[11]),
                    breaks = c('Brasil', 'Amazônia Legal', categorias))   # Definindo a ordem da legenda.
mapaBR.UC

# Ajustando a legenda e o tema:
mapaBR.UC2 <- 
  mapaBR.UC +
  labs(title = 'Unidades de Conservação na Amazônia Legal',
       subtitle = 'Unidades de Conservação para o período de 2000 a 2022',
       fill = NULL,
       caption = 'DATUM SIRGAS 2000 | Fonte dos dados: CNUC/MMA, 2023; IBGE, 2020 | Elaborado por @proamb.r')+
  theme_light()+
  theme(
    plot.title = element_text(face = 'bold', size = 16, hjust = 0.5),      # Alterando a estética do título.
    plot.subtitle = element_text(face = "italic", size = 12, hjust = 0.5), # Alterando a estética do subtítulo.
    legend.position = 'right',                                             # Definindo a posição da legenda. 
    legend.text = element_text(face = 'bold', size = 8))+                  # Alterando o tamanho da fonte da legenda.
  guides(fill = guide_legend(ncol = 1))+                                   # Ajustando a legenda em n colunas.
  scale_y_continuous(limits = c(-35, 6), breaks = seq(-35, 6, by = 5))+    # Alterando o eixo y.
  scale_x_continuous(limits = c(-75, -34), breaks = seq(-75, -34, by = 5)) # Alterando o eixo x.

mapaBR.UC2

# Para adicionar a escala gráfica e a seta norte vamos usar funções do pacote 'ggspatial'.
# install.packages('ggspatial')   # instalando o pacote 'ggspatial'.
library(ggspatial)                # Carregando o pacote.

mapaBR.UC3 <- 
  mapaBR.UC2 +
  ggspatial::annotation_scale(
    location = 'bl',                           # Localização da escala gráfica.
    bar_cols = c('darkgrey','white'),          # Cores das barras.
    height = unit(0.2, "cm"))+                 # Altura da escala gráfica.
  ggspatial::annotation_north_arrow(
    location = 'tr',                           # Localização da seta norte. 
    pad_x = unit(0.30, 'cm'),                  # Distância da borda do eixo x.
    pad_y = unit(0.30, 'cm'),                  # Distância da borda do eixo y.
    height = unit(1.0, 'cm'),                  # Altura  da seta norte.
    width = unit(1.0, 'cm'),                   # Largura da seta norte.
    style = north_arrow_fancy_orienteering(    # Tipo de seta.
      fill = c('grey40', 'white'),             # Cores de preenchimento da seta.
      line_col = 'grey20'))                    # Cor  das linhas da seta.
mapaBR.UC3

# Podemos exportar o mapa como imagem usando a função ggsave().
ggplot2::ggsave(                       
  filename = 'Mapa_UC.png',      # Nome do arquivo e formato que será salvo.
  plot = mapaBR.UC3,             # Nome do objeto na qual o mapa está armazenado.
  width = 1080,                  # Largura da imagem.
  height = 864,                  # Altura da imagem.
  units = 'px',                  # Unidade ("px" (pixel), "in" (polegada), "cm", "mm")
  scale = 3)                     # Multiplica os valores de altura e largura da imagem.

#------------------------https://linktr.ee/pexcca.lamet------------------------#

