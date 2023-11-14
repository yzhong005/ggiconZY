require(ggplot2)
require(ggsci)
require(ggpubr)

# plot the mice line plot alone with ggplot

mice<-ggplot(mice,aes(x,y))+
  geom_point(size=1E-200)+
  theme_void()+
  coord_equal()
