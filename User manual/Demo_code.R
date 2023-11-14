require(ggplot2)
require(ggsci)
require(ggpubr)

# plot the mice line plot alone with ggplot

mice<-ggplot(mice_line,aes(x,y))+
  geom_point(size=1E-200)+
  theme_void()+
  coord_equal()

mice

# plot within other ggplots

A<-data.frame(x=sample(1:100,30),y=sample(150:400,30),color=LETTER[1:3]) # generate a demo dataframe

ggplot(A,aes(x,y,color=color))+
  geom_point()+ # plot the point plot of dataframe A
  theme_classic()+
  scale_color_aaas()+ # add beautiful color of the point
  annotation_custom(ggplotGrob(mice),xmin=0,xmax=25,ymin=350,ymax=400) # add the mice plot to the left up conner of the plot, you can change the position of mice plot with xmin, xmax, ymin, and ymax. 

# plot outside (left up side) other ggplots

ggplot(A,aes(x,y,color=color))+
  geom_point()+ # plot the point plot of dataframe A
  theme_classic()+
  scale_color_aaas()+
  coord_cartesian(clip="off",xlim=c(0,100))+ # fixed the plot limit of the point plot, so that you can annotate the mice plot outside the plot area. 
  annotation_custom(ggplotGrob(mice6),xmax=-40,ymin=350)+  # add the mice plot to the left up conner outside the point plot, you can change the position of mice plot with xmin, xmax, ymin, and ymax.
  theme(plot.margin = margin(l=150,r=20,t=20,b=20,unit="pt")) # add more space to the left margin to place the mice plot.



 
