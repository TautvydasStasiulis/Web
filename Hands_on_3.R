##############################################################
# Paketų install ir loadinimas
##############################################################
if(!require(eurostat)) install.packages("eurostat"); require(eurostat)
if(!require(tidyverse)) install.packages("tidyverse"); require(tidyverse)
if(!require(rsdmx)) install.packages("rsdmx"); require(rsdmx)
if(!require(openxlsx)) install.packages("openxlsx"); require(openxlsx)
##############################################################
# Duomenų parsiuntimas iš LSD pagal kodą
# Reikalingas meta failas
##############################################################
meta<-readSDMX("https://osp-rs.stat.gov.lt/rest_xml/dataflow/")
meta<-as.data.frame(meta)
write.xlsx(meta, "LSD_Meta.xlsx")

S3R180_M3010502<-readSDMX(providerId = "LSD",
                          resource = "data",
                          flowRef ="S3R180_M3010502",
                          dsd = TRUE)
S3R180_M3010502<-as.data.frame(S3R180_M3010502,label=T)
#############################################################
# Duomenų išsirinkimas
#############################################################
df<-S3R180_M3010502 %>%
    filter(!(amziusM3010502 %in% c("gxxx","g000g999")),
           Vietove==0,
           LAIKOTARPIS %in% c("2000", "2017")) %>%
    group_by(LAIKOTARPIS)%>%
  mutate(proc=obsValue/sum(obsValue)*100)%>%
  select(-c(1,2,4:7,10))%>%
  mutate(amziusM3010502_label.lt=factor(amziusM3010502_label.lt,
                                        levels= c("Iki 15 metų","15–19","20–24","25–29","30–34","35–39","40–44","45–49","50 ir vyresni")))
#############################################################
# Grafikų brėžimas
#############################################################
ggplot(df, aes(x=df$amziusM3010502_label.lt,y=df$proc, col=LAIKOTARPIS,group=LAIKOTARPIS))+
  geom_line()+
  geom_point()+
  labs(title = "Gimusieji pagal motinos amziu",
       subtitle = "Source: LSD (S3R180_M3010502)",
       x="Motinos amzius",
       y="Procentai")
