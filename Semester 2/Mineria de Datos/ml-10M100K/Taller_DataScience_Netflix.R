library(tidyverse)
library(caret)
library(data.table)
library(kableExtra)
library(plotly)




movies <- read.csv("movies.csv", col.names = c("movieId", "title", "genres"))
ratings <- read.csv("ratings.csv", col.names = c("userId", "movieId", "rating", "timestamp"))

ratings$timestamp <- as.POSIXct(ratings$timestamp, origin = "1970-01-01")


##Lo primero que hace es leer: los Datos de las peliculas, y los datos de ratings y como estan en otro 


movies <- as.data.frame(movies) %>%
  mutate(genres = strsplit(as.character(genres), "\\|")) %>% # Split genres into a list
  unnest(genres) # Expand the list so each genre has its own row

# Join the ratings and movies data frames on the movieId column
movielens <- left_join(ratings, movies, by = "movieId")

## La funcion %>% es un pipe, que es una forma de concatenar funciones, en este caso esta concateenando dos funciones
#La primera es mutate() la cual se utiliza para modificar o crear una nueva columna
#en este caso esta modificando la culumna genres la cual esta serapando por cada | que encuentre



# Validation set will be 10% of the movielens data
set.seed(1)

#Esta funcion lo que hace es ayudarnos a dividir el dataset en dos partes, una para entrenar y otra para validar
#Lo que busca es que la distrubucion de la variable respuesta sea muy parecida en el training y en el tes


test_index <- createDataPartition(y = movielens$rating, times = 1, p = 0.1, list = FALSE)
edx <- movielens[-test_index,]
temp <- movielens[test_index,]


validation <- temp %>% 
     semi_join(edx, by = "movieId") %>%
     semi_join(edx, by = "userId")

# Add rows removed from validation set back into edx set

removed <- anti_join(temp, validation)

#esta funcion recive como parametros la variable respuesta, el numero de veces que se quiere dividir el dataset
#p especifica la proporcion del dataset en este caso el 10 porciento de los datos son selccionados


edx <- rbind(edx, removed)

#Aqui ya tiene preparada la data, teiene el test de validation y el training set, union los ratings con las peliculas


rm(ratings, movies, test_index, temp, movielens, removed)




head(edx) %>%  kable(caption = "Top rows of edx file") %>%
  kable_styling(font_size = 10, position = "center",
                latex_options = c("scale_down", "HOLD_position"))

#Lo que hace es mostrar las primeras 6 filas de la data, con la funcion head() y luego con kable() lo que hace es
#darle un formato de tabla, con el caption se le da un titulo a la tabla, y con kable_styling se le da un formato a la tabla



edx_summary <- data.frame(number_of_rows = nrow(edx),
                          number_of_column = ncol(edx),
                          number_of_users = n_distinct(edx$userId),
                          number_of_movies = n_distinct(edx$movieId),
                          average_rating = round(mean(edx$rating),2),
                          number_of_genres = n_distinct(edx$genres),
                          the_first_rating_date = 
                            as.Date(as.POSIXct(min(edx$timestamp), 
                                               origin = "1970-01-01")),
                          the_last_rating_date = 
                            as.Date(as.POSIXct(max(edx$timestamp),
                                               origin = "1970-01-01")))

edx_summary[,1:6] %>% 
  kable(caption = "Summary of edx set (part 1)") %>%
  kable_styling(font_size = 10, position = "center",
                latex_options = c("scale_down","HOLD_position"))

##Proyect methodology

#What is rating


rating_sum <- edx %>% group_by(rating) %>%
  summarize(count = n())

#calculate the average rating of all the data

average_rating <- mean(edx$rating)
average_std <- sd(edx$rating)



#Priemro convierte la columna de mutate en un factor, luego con ggplot() crea un grafico de barras, con aes() se le da el formato
#de x y y, con geom_bar() se le da el formato de barra, con stat = "identity" se le da el formato de barra, con fill se le da el color
#con geom_text() se le da el formato de texto, con vjust se le da el formato de la posicion del texto, con size se le da el tamaño del texto
#con labs() se le da el formato al titulo, con theme_minimal() se le da el formato al grafico

gg <- rating_sum %>% mutate(rating = factor(rating)) %>%
  ggplot(aes(rating, count^2)) +
  geom_col(fill = "steel blue", color = "#dd0000") +
  theme_classic() + 
  labs(x = "Rating", y = "Count",
       title = "Number of rating",
       caption = "Figure 1 - Rating in edx dataset")
ggplotly(gg)


###############################################Movie#################


movie_sum <- edx %>% group_by(movieId) %>%
  summarize(n_rating_of_movie = n(), 
            mu_movie = mean(rating),
            sd_movie = sd(rating))


ggplot(movie_sum, aes(x = n_rating_of_movie, y = otra_variable)) +
  geom_smooth(method = 'gam', formula = 'y ~ s(x, bs = "cs")')


gg <- movie_sum %>% 
  ggplot(movie_sum,aes(n_rating_of_movie, mu_movie)) +
  geom_point(color = "steel blue", alpha = 0.3) +
  geom_smooth()+
  geom_vline(aes(xintercept = mean(movie_sum$n_rating_of_movie)), color = "red")+
  annotate("text", x = 2000, y = 5,
           label = print(round(mean(movie_sum$n_rating_of_movie),0)),
           color = "red", size = 3) +
  theme_classic() +
  labs(title = "Scatter plot - Average rating vs number of rating",
       x = "Number of rating / movie",
       y = "Average rating",
       caption = "Figure 4") +
  theme(axis.title.x = element_text(size = 10),
        axis.title.y = element_text(size = 10),
        plot.title = element_text(size = 12))

ggplotly(gg)