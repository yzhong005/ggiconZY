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


# plot result of disc diffusion, with inhibition zones. 

disc<-data.frame(x=0.7*sin(1:6),y=0.7*cos(1:6)) # can change to 1:n for different numbers of discs
disc$drug<-c("TZP","AMC","MEM","CTX","TGC","New") # label the disc according to your requirement. 

ggplot(agar,aes(x,y))+
  geom_polygon(color="black",fill="grey50",alpha=0.2,linewidth=1)+
  geom_polygon(aes(x=0.98*x,y=0.98*y),color="black",fill="#b24745",alpha=0.3,linewidth=1)+
  geom_polygon(aes(x=0.2*x+disc$x[1],y=0.2*y+disc$y[1]),fill="#b24745",color="grey85",alpha=0.7)+
  geom_polygon(aes(x=0.1*x+disc$x[2],y=0.1*y+disc$y[2]),fill="#b24745",color="grey85",alpha=0.7)+
  geom_polygon(aes(x=0.25*x+disc$x[3],y=0.25*y+disc$y[3]),fill="#b24745",color="grey85",alpha=0.7)+
  geom_polygon(aes(x=0.15*x+disc$x[5],y=0.15*y+disc$y[5]),fill="#b24745",color="grey85",alpha=0.7)+
  geom_polygon(aes(x=0.18*x+disc$x[6],y=0.18*y+disc$y[6]),fill="##b24745",color="grey85",alpha=0.7)+
  geom_point(aes(x,y),data=disc,size=8,color="white")+
  geom_text(aes(label=drug),data=disc,size=2,fontface="bold")+
  geom_text(x=0,y=0,label="My isolate ID",size=5,fontface="bold")+
  theme_void()
  
