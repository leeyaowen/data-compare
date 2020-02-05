library(sqldf)
library(dplyr)
library(stringr)
library(magrittr)

dt1<-read.csv(choose.files(default=paste0(getwd(), "/*.*")),colClasses = "character")
dt2<-read.csv(choose.files(default=paste0(getwd(), "/*.*")),colClasses = "character")

dt1 %<>% mutate_if(is.character,str_trim)
dt2 %<>% mutate_if(is.character,str_trim)

anti1<-anti_join(dt1,dt2)
anti2<-anti_join(dt2,dt1)

tag1<-sqldf("select distinct Tag ,B,count(Tag) as tagnum from dt1 group by Tag,B having tagnum>1 order by tagnum desc")
tag2<-sqldf("select distinct Tag ,B,count(Tag) as tagnum from dt2 group by Tag,B having tagnum>1 order by tagnum desc")

semi1<-semi_join(dt1,dt2)
semi2<-semi_join(dt2,dt1)

muanti1<-mutate(anti1,marks="V")
muanti2<-mutate(anti2,marks="V")
musemi1<-mutate(semi1,marks="")
musemi2<-mutate(semi2,marks="")

bdt1<-bind_rows(muanti1,musemi1) %>% arrange(X1,Y1,X2,Y2,Tag,B,sp)
bdt2<-bind_rows(muanti2,musemi2) %>% arrange(X1,Y1,X2,Y2,Tag,B,sp)

q111<-filter(bdt1,X2==1,Y2==1)
q112<-filter(bdt1,X2==1,Y2==2)
q122<-filter(bdt1,X2==2,Y2==2)
q121<-filter(bdt1,X2==2,Y2==1)
qall1<-bind_rows(q111,q112,q122,q121)

q211<-filter(bdt2,X2==1,Y2==1)
q212<-filter(bdt2,X2==1,Y2==2)
q222<-filter(bdt2,X2==2,Y2==2)
q221<-filter(bdt2,X2==2,Y2==1)
qall2<-bind_rows(q211,q212,q222,q221)

b12<-merge(qall1,qall2,by=0,all = TRUE,sort = F)
write.csv(b12,file = "Jackie123.csv")

#a<-sqldf("select * from dt1 except select * from dt2")
#b<-sqldf("select * from dt2 except select * from dt1")

