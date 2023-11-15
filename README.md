# ggiconZY
Here is a collection of icons you can plot together with your ggplot objectives, with demo code of how to incorporate them in your plot. Hope you enjoy using it and I will keep updating it when I have time. Also, expecting contributions from you!

## You can download the .csv datasets first and read them in R
## Here are some demo code for usage
```R
library(tidyverse)
library(ggplot2)
library(ggsci)
library(ggpubr)

#read the .csv files in R first

mice_line<-read.csv("./mice_line.csv") # put the download path (.csv file location) before mice_line.csv, or setwd() to the file path first. 

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
# Citation
If you use this project in your research, please cite it as follows:

>Zhong, Yang. (2023). ORCID: "https://orcid.org/0000-0002-9146-0875". *ggiconZY*. Version 1.0.0. Date-released: 2023-11-13. Available at URL: "https://github.com/yzhong005/ggiconZY"
## or
[View the CITATION.cff file](./CITATION.cff)

