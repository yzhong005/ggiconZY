# ggiconZY
Here is a collection of icons you can plot together with you ggplot objectives, with demo code of how to cooperate them in your plot. Hope you enjoy using it and I will keep update it when I have time. Also, expecting contribution from you!


## Here are some demo code for usage
```R
require(ggplot2)
require(ggsci) 
require(ggpubr)

#plot the mice line plot alone with ggplot

mice<-ggplot(mice_line,aes(x,y))+
  geom_point(size=1E-200)+
  theme_void()+
  coord_equal()

mice
```
<p align="center">
<img src="https://github.com/yzhong005/ggiconZY/blob/main/User%20manual/demo_mice.png" width="800" height="800" />
</p>

```R
# plot within other ggplots

A<-data.frame(x=sample(1:100,30),y=sample(150:400,30),color=LETTER[1:3]) # generate a demo dataframe

ggplot(A,aes(x,y,color=color))+
  geom_point(size=6)+ # plot the point plot of dataframe A
  theme_classic()+
  scale_color_aaas()+ # add beautiful color of the point
  annotation_custom(ggplotGrob(mice),xmin=0,xmax=25,ymin=350,ymax=400) # add the mice plot to the left up conner of the plot, you can change the position of mice plot with xmin, xmax, ymin, and ymax. 
```
<p align="center">
<img src="https://github.com/yzhong005/ggiconZY/blob/main/User%20manual/demo_point_mice.png" width="800" height="800" />
</p>

**More demo code for usage can be find in manual**

