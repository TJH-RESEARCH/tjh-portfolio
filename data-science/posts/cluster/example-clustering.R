library(tidyverse)

plot_cluster_blank <-
  tibble(x = c(1,2,3,1,2,3,9,7,8),
         y = c(2,1,2,6,8,7,5,6,4)
         ) %>% 
  ggplot(aes(x, y)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0,10,2), limits = c(0,10)) +
  scale_y_continuous(breaks = seq(0,10,2), limits = c(0,10)) +
  #lims(x = c(0, 10), y = c(0, 10)) +
  theme_classic()

plot_cluster_blank
plot_cluster_blank +
  ggforce::geom_mark_circle(x = 2, y = 1.8, r = .14, color = "blue") +
  ggforce::geom_mark_circle(x = 1.9, y = 6.8, r = .14, color = "green") +
  ggforce::geom_mark_circle(x = 7.9, y = 5.15, r = .14, color = "red")



# 3d plot 
library(rgl)
data <- 
  tibble(x = c(1,2,3,1,2,3,9,7,8),
       y = c(2,1,2,6,8,7,5,6,4),
       z = c(1,2,1,8,7,7,3,4,4),
       color = c(rep('blue',3),rep('green', 3), rep('red', 3))
       )

plot3d(x = data$x, y = data$y, z = data$z, 
       col = data$color, 
       type = "s",
       xlab = 'x', ylab = "y", zlab = "z")
rglwidget()

