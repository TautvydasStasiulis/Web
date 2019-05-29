##############################################################
# Paketų install ir loadinimas
##############################################################
if(!require(eurostat)) install.packages("eurostat"); require("eurostat")
if(!require(tidyverse)) install.packages("tidyverse"); require("tidyverse")
##############################################################
# Duomenų parsiuntimas iš Eurostat pagal kodą
##############################################################
namq_10_gdp<-get_eurostat("namq_10_gdp",
                          stringsAsFactors = F)
##############################################################
# Duomenų filtravimas ir apdorojimas
##############################################################
df<-namq_10_gdp %>%
  filter(geo %in% c("LT","LV","EE"),
         na_item=="B1GQ",
         s_adj=="SCA",
         time>="2004-01-01",
         unit=="CLV_I10")
#############################################################
# Grafikų braižymas ir išsaugojimas png formatu
#############################################################
#png(filename = "Real GDP Lithuania.png",width = 1280, height = 800, units = "px")
ggplot(df, aes(x=time,y=values))+
  geom_line(aes(col=geo))+
  scale_x_date(date_labels="%Y",date_breaks="2 years")+
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  labs(title = "Real GDP in Latvia, Estonia, Lithuania",
       subtitle = "Source: Eurostat (namq_10_gdp)",
       x="Time",
       y="Index")
#dev.off()
############################################################

  