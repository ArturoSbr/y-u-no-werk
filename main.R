# Librería
library(dplyr)

# Leer datos
df <- read.csv('https://raw.githubusercontent.com/ArturoSbr/y-u-no-werk/main/data.csv') %>% as.data.frame()

# Con Neyman
n <- df %>% 
  group_by(X1, X2, T) %>% 
  summarise(Ybar = mean(Y)) %>% 
  group_by(X1, X2) %>% 
  mutate(diff = Ybar - lag(Ybar)) %>%
  select(X1, X2, diff) %>% 
  filter(!is.na(diff))

# Con regresión
m <- lm(Y ~ T + X1 + I(X1*T) + X2 + I(X2*T), data = df)

# Still no luck
n
m
