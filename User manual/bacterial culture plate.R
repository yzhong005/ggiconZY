#plot an agar with streaked bacterial culture and single colonies
#agar plate, streak line and single colonies are separate data frames, can be combined and customized according to your own requirements. 
#color code #b24745 (red) color is to represent blood agar, can change to normal orange or yellow color to represent common LB or MH.  

ggplot(agar,aes(x,y))+
  geom_polygon(color="black",fill="grey50",alpha=0.2,linewidth=1)+
  geom_polygon(aes(x=0.98*x,y=0.98*y),color="black",fill="#b24745",alpha=0.5,linewidth=1)+
  geom_segment(aes(xend=xend,yend=yend),data=streak,lineend = "round",linejoin = "round",
               linewidth=8,color="#2d6d66",alpha=0.3)+
  geom_segment(aes(xend=xend,yend=yend),data=streak,lineend = "round",linejoin = "round",
               linewidth=3,color="#8f7700",alpha=0.6)+
  geom_point(aes(x,y),data=single,color="#2d6d66",size=7,alpha=0.3)+
  geom_point(aes(x,y),data=single,color="#8f7700",size=3.5,alpha=0.6)+
  theme_void()

  
