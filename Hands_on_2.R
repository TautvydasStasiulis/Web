##############################################################
# Paketų install ir loadinimas
##############################################################
if(!require(eurostat)) install.packages("eurostat"); require("eurostat")
if(!require(tidyverse)) install.packages("tidyverse"); require("tidyverse")
##############################################################
# Duomenų parsiuntimas iš Eurostat pagal kodą ir filtravimas
##############################################################
gov_10a_exp<-get_eurostat("gov_10a_exp",
                          stringsAsFactors = F,
                          filters=list(cofog99="GF02",
                                      na_item="TE",
                                      sector="S13",
                                      time="2017",
                                      unit="PC_GDP"))
##############################################################
# Duomenų filtravimas ir apdorojimas
##############################################################
df<-gov_10a_exp %>%
  filter(geo %in%  c("BE" ,"BG" ,"CZ" ,"DK" ,"DE" ,"EE" ,"IE" ,"EL" ,"ES" ,"FR" ,"HR" ,"IT" ,"CY" ,"LV" ,"LT" ,"LU" ,"HU" ,"MT" ,"NL" ,"AT" ,"PL" ,"PT" ,"RO" ,"SI" ,"SK" ,"FI" ,"SE" ,"UK"))
##############################################################
# Grafikų braižymas
##############################################################
ggplot(df, aes(x=reorder(geo, values),y=values))+
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=values), vjust=-0.3,size=3.5)+
  labs(title = "Real GDP in Europe",
       subtitle = "Source: Eurostat (gov_10a_exp)",
       x="Countries",
       y="Values")
