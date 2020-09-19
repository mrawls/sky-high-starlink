library(ggplot2)
library(scales)
library(extrafont)
loadfonts(device = "win", quiet = TRUE)

popLim=50

fil=read.csv(".../StarlinkData_2018.csv",fileEncoding="UTF-8-BOM",header = T)
fil$Cost=60*12/fil$GDPcapita #Starlink cost ($60/month) as a percentage of GDP/capita
fil$Pop=fil$Pop/1000000 #Population in millions
countryLab=data.frame("CountryCode"=subset(fil,Pop>popLim)$CountryCode,"CountryName"=subset(fil,Pop>popLim)$CountryName,"Category3"=subset(fil,Pop>popLim)$Category3)
countryLab=countryLab[order(countryLab$CountryCode),]

countryLab$p=seq(0.02,min(1,0.41/26*length(subset(fil,Pop>popLim)$Pop)),length.out = length(subset(fil,Pop>popLim)$Pop))

ggplot(data=fil,aes(Cost,InternetPercentage))+
  geom_point(aes(size=Pop,shape=Category2,col=Category3),alpha=0.65,stroke=1)+
  geom_vline(xintercept=0.10,size=1,alpha=0.15)+
  geom_hline(yintercept=0.75,size=1,alpha=0.15)+
  geom_rect(aes(xmin=0.00316,xmax=0.0125,ymin=0,ymax=min(1,0.41/26*length(subset(fil,Pop>popLim)$Pop))+0.02),fill="white",col="black")+
  geom_text(aes(x=Cost*(1+Pop^0.5/110),label=ifelse(Pop>popLim,as.character(CountryCode),''),col=Category3),hjust=0,vjust=0.5,family="Segoe UI Semilight",size=3)+
  geom_text(data=countryLab,aes(x=0.0047,y=p,label=CountryName),hjust=0,family="Segoe UI Semilight",size=3)+
  geom_text(data=countryLab,aes(x=0.0033,y=p,label=CountryCode),hjust=0,family="Segoe UI Semilight",size=3)+
  labs(x="Annual satellite internet subscription as a percentage of GDP/capita (%)",y="Individuals with access to the Internet (%)")+
  scale_x_log10(labels=percent)+
  scale_y_continuous(labels=percent)+
  scale_size_area(name="Population (in millions)",breaks = c(1,3,10,30,100,300,1000,3000),max_size = 25)+
  scale_color_manual(name="Internet satellite access",values=c("#3366ff","#ff6600"))+
  scale_shape_manual(name="Current Internet cost",values=c(1,16))+
  guides(col = guide_legend(order=1,override.aes = list(size = 5)),shape = guide_legend(order=2,override.aes = list(size = 5)),size=guide_legend(order=3))+
  theme_light()+
  theme(width = 10.9,height = 8.02,aspect.ratio = 1,text=element_text(size=13.5,family="Segoe UI Semilight"))
  
ggsave("affordability.png",path="D:/...",device="png",dpi=500) #save the plot with the desired name at the desired path
