#load packages
library(tidyverse)
library(readxl)
#set the working directory 
setwd('C:/Users/rankinjq/Hendon/Summary_Tables/Groundwater/Background_Eval')

#Read the GW analytical Data
df <-  read_excel('20220208_ALL_Cleaned_GW_Data_Hendon.xlsx', sheet = 'All_Data')

#read the offsite well list
well_df <-  read_csv('upgradient_wells.csv')

View(offsite_detects)

#Select all the data in df that are associated 
#with the wells listed in well_df
offsite_data <- df %>%
  filter(Location_Code %in% well_df$Name)

#Select all analytes that were detected
offsite_detects <- offsite_data %>%
  filter(is.na(Prefix))

#Select only Boron
test <- offsite_detects %>%
  filter((Location_Code == 'MW02') & (ChemName == 'Boron'))
#Draw Boxplot
p <- ggplot(test, mapping = aes(x=ChemName, y = Concentration, xlab = "Chemical", ylab="Concentration (ug/L)"))+
  stat_boxplot(geom = 'errorbar', linetype=1, width=0.5)+
  geom_boxplot()

print(p + labs(x="Chemical", y = "Concentration (ug/L)")) + 
  coord_cartesian(ylim=c(min(test$Concentration) -100, max(test$Concentration)+100)) + 
  scale_y_continuous(breaks=seq(1000, 2500 , 250))

#define a plotting function
plot_chemdata <- function(data, well_name, chem_name) {
  
  plot_title <- paste0(well_name, ' ', chem_name)
  
  in_data <- data %>%
    filter((Location_Code == well_name) & (ChemName == chem_name))
  
  p <- ggplot(in_data, mapping = aes(x=ChemName, y = Concentration, xlab = "Chemical", ylab="Concentration (ug/L)"))+
    stat_boxplot(geom = 'errorbar', linetype=1, width=0.5)+
    geom_boxplot()+
    ggtitle(plot_title)+
    xlab('Constituent')+
    ylab('Concentration (ug/L)')+
    theme(plot.title = element_text(hjust = 0.5))
  
  return(p)
}

y = plot_chemdata(offsite_detects, 'MW01', 'Chloride')
print(y)


