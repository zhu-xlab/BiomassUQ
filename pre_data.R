# Prepare the data: Merge the specific-height-biomass data pairs of Jucker and BAAD data
# by Qian Song on May 9, 2021
# modified by Qian Song on November 4 2021

library(ggplot2)
library(magrittr)
library (plyr)  # to convert list to dataframe
library(dplyr)
library("readxl")


# BAAD
baad <- baad.data::baad_data()
baad_data <- as.data.frame(baad$data)
baad_data <- baad_data %>% dplyr::filter(!is.na(m.so))
baad_data <- baad_data %>% dplyr::filter(!is.na(d.bh))
baad_data <- baad_data %>% dplyr::filter(d.bh>=5)
baad_data <- baad_data %>% dplyr::filter(!is.na(h.t))
baad_data <- baad_data %>% dplyr::filter(!is.na(latitude))
baad_data <- baad_data %>% dplyr::filter(!is.na(longitude))
# EURASIAN FORESTS
data14 <- read_excel("EURASIAN_FORESTS.xlsx")
data14 <- data14 %>% dplyr::filter(!is.na(H))
data14 <- data14 %>% dplyr::filter(!is.na(Pabo))
data14 <- data14 %>% dplyr::filter(!is.na(D))
data14 <- data14 %>% dplyr::filter(D>=5)
data14 <- data14 %>% dplyr::filter(!is.na(Latitude_M))
data14 <- data14 %>% dplyr::filter(!is.na(Longitude_M))
# Chave data
data5 <- read.csv("chave.csv")
data5 <- data5 %>% dplyr::filter(!is.na(Total.height.m.))
data5 <- data5 %>% dplyr::filter(!is.na(Dry.total.AGB.kg.))
data5 <- data5 %>% dplyr::filter(!is.na(DBH.cm.))
data5 <- data5 %>% dplyr::filter(DBH.cm. >= 5)
data5 <- data5 %>% dplyr::filter(!is.na(latitude))
data5 <- data5 %>% dplyr::filter(!is.na(longitude))

# Merge data
AGB <- c(baad_data$m.so, data14$Pabo, data5$Dry.total.AGB.kg.)
H <- c(baad_data$h.t, data14$H, data5$Total.height.m.)
latitude <- c(baad_data$latitude, data14$Latitude_M, data5$latitude)
longitude <- c(baad_data$longitude, data14$Longitude_M, data5$longitude)
D <- c(baad_data$d.bh, data14$D, data5$DBH.cm.)
data_AGB_H_D <- data.frame(AGB, H, D, latitude, longitude, stringsAsFactors = FALSE)
data_AGB_H_D <- data_AGB_H_D %>% dplyr::filter(AGB>=2)

write.csv(data_AGB_H_D, "data_AGB_H_D.csv")
save(data_AGB_H_D,file="data_AGB_H_D.RData")

pdf(file="hist_AGB_H_D_1104.pdf", width = 7, height=3)
ggplot(data_AGB_H_D, aes(x=x)) +
  # Top
  geom_density(aes(x = log(AGB), y = ..density..), fill="#69b3a2" ) +
  geom_label( aes(x = 0.5, y=0.25, label="log(AGB)"), color="#69b3a2") +
  # Bottom
  geom_density( aes(x = log(H), y = -..density..), fill= "#404080") +
  geom_density( aes(x = log(D), alpha = 0.5, y = -..density..), fill= "#355F70") +
  geom_label( aes(x=0.6, y=-0.25, label="log(Height)"), color="#404080") +
  geom_label( aes(x=5.6, y=-0.25, label="log(Diameter)"), color="#355F70")
dev.off()

pdf(file="AGB_H.pdf", width = 6, height=4)
ggplot(data_AGB_H, aes(x= log(H), y=log(AGB))) +
  stat_density_2d(aes(fill = ..density..), geom = "raster", contour = FALSE) +
  scale_fill_distiller(palette=4, direction=0) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme_set(theme_bw()) +
  geom_smooth(method='gam', color="mistyrose2", n = 10000, se=FALSE) +
  theme(panel.grid=element_blank())
dev.off()

pdf(file="AGB_D_H.pdf", width = 6, height=4)
ggplot(data_AGB_H_D, aes(x=log(H), y=log(D), color=log2(AGB), alpha=0.3)) +
  geom_point(shape=1)+ 
  scale_color_gradient(low = "#BECA55", high = 'darkgreen')
dev.off()

#violin plot<><><><><><><><><><><><>
data <- read.csv("data_AGB_H_D.csv", stringsAsFactors = TRUE)
nrow(data %>% dplyr::filter(biome_type=='Tundra'))
nrow(data %>% dplyr::filter(biome_type=='Tropical and subtropical'))
nrow(data %>% dplyr::filter(biome_type=='Temperate mixed forests'))
nrow(data %>% dplyr::filter(biome_type=='Temperate coniferous forests'))
nrow(data %>% dplyr::filter(biome_type=='Savannas, woodlands, and Mediterranean forests'))
nrow(data %>% dplyr::filter(biome_type=='Grasslands and shrublands'))
nrow(data %>% dplyr::filter(biome_type=='Deserts and xeric shrublands'))
nrow(data %>% dplyr::filter(biome_type=='Boreal forests'))

library(ridgeline)
pdf(file="hist_H_1106.pdf", width = 4, height=4)
ridgeline(log(data$H), data$biome_type, labels = c("", "", "", "", "", "", "", ""))
dev.off()
pdf(file="hist_D_1106.pdf", width = 4, height=4)
ridgeline(log(data$D), data$biome_type, labels = c("", "", "", "", "", "", "", ""))
dev.off()
pdf(file="hist_B_1106.pdf", width = 4, height=4)
ridgeline(log(data$AGB), data$biome_type, labels = c("", "", "", "", "", "", "", ""))
dev.off()

pdf(file="hist_H_D_1106.pdf", width = 6, height=2)
ggplot(data, aes(x=x, fill = biome_type)) +
  # Top
  geom_density(aes(x=log(H), y=..density..), alpha = 0.2)+
  # Bottom
  geom_density(aes(x =log(D), y = -..density..), alpha = 0.2) +
  scale_color_brewer(palette="Set3")
dev.off()

pdf(file="violin_all_H_biome.pdf", width = 6, height = 3)
ggplot(data, aes(x=H, y=biome_type, color=biome_type, fill=biome_type)) +
  geom_violin(trim=TRUE, width=0.7, scale="width") + 
  scale_y_discrete(limits=c("Tundra", "Tropical and subtropical", "Temperate mixed forests","Temperate coniferous forests",
                            "Savannas, woodlands, and Mediterranean forests", "Grasslands and shrublands", 
                            "Deserts and xeric shrublands", "Boreal forests")) +
  scale_x_continuous(breaks=c(1,5,10,20,50)) + 
  coord_trans(x = "log") +
  scale_color_grey() + theme_classic() +
  scale_fill_manual(values=c( "#b9ddb9", "#dccbaf", "#bfdc8c", "#dd9473",
                              "#ffcf57", "#98ad74", "#4f914c", "#dbdbdb" 
                             )) +
  geom_boxplot(width=0.1, col="#808080", alpha=0.2) + 
  # stat_summary(fun=mean, geom="point", shape=23, size=2) +
  stat_summary(fun=median, geom="point", size=1, color="lightblue") +
  labs(x = "Height (m)") +
  labs(y = "Biome") + 
  annotate("text", x=50, y=8.3, label= "1464", size = 2) +
  annotate("text", x=50, y=7.3, label= "83", size = 2) +
  annotate("text", x=50, y=6.3, label= "1636", size = 2) +
  annotate("text", x=50, y=5.3, label= "918", size = 2) +
  annotate("text", x=50, y=4.3, label= "71", size = 2) +
  annotate("text", x=50, y=3.3, label= "1105", size = 2) +
  annotate("text", x=50, y=2.3, label= "2934", size = 2) +
  annotate("text", x=50, y=1.3, label= "131", size = 2) +
  theme(legend.position="none")
dev.off()

pdf(file="violin_all_D_biome.pdf", width = 3, height = 3)
ggplot(data, aes(x=D, y=biome_type, color=biome_type, fill=biome_type)) +
  geom_violin(trim=TRUE, width=0.7, scale="width") + 
  scale_y_discrete(limits=c("Tundra", "Tropical and subtropical", "Temperate mixed forests","Temperate coniferous forests",
                            "Savannas, woodlands, and Mediterranean forests", "Grasslands and shrublands", 
                            "Deserts and xeric shrublands", "Boreal forests")) +
  scale_x_continuous(breaks=c(5,10,20,50,100)) + 
  coord_trans(x = "log") +
  scale_color_grey() + theme_classic() +
  scale_fill_manual(values=c( "#b9ddb9", "#dccbaf", "#bfdc8c", "#dd9473",
                              "#ffcf57", "#98ad74", "#4f914c", "#dbdbdb" 
  )) +
  geom_boxplot(width=0.1, col="#808080", alpha=0.2) + 
  # stat_summary(fun=mean, geom="point", shape=23, size=2) +
  stat_summary(fun=median, geom="point", size=1, color="lightblue") +
  labs(x = "Diameter (cm)") +
  labs(y = "Biome") + 
  theme(legend.position="none", axis.text.y = element_blank())
dev.off()

pdf(file="violin_all_AGB_biome.pdf", width = 3, height = 3)
ggplot(data, aes(x=AGB, y=biome_type, color=biome_type, fill=biome_type)) +
  geom_violin(trim=TRUE, width=0.7, scale="width") + 
  scale_y_discrete(limits=c("Tundra", "Tropical and subtropical", "Temperate mixed forests","Temperate coniferous forests",
                            "Savannas, woodlands, and Mediterranean forests", "Grasslands and shrublands", 
                            "Deserts and xeric shrublands", "Boreal forests")) +
  scale_x_continuous(breaks=c(2,5,20,100,1000)) + 
  coord_trans(x = "log") +
  scale_color_grey() + theme_classic() +
  scale_fill_manual(values=c( "#b9ddb9", "#dccbaf", "#bfdc8c", "#dd9473",
                              "#ffcf57", "#98ad74", "#4f914c", "#dbdbdb" 
  )) +
  geom_boxplot(width=0.1, col="#808080", alpha=0.2) + 
  # stat_summary(fun=mean, geom="point", shape=23, size=2) +
  stat_summary(fun=median, geom="point", size=1, color="lightblue") +
  labs(x = "Biomass (kg)") +
  labs(y = "Biome") + 
  theme(legend.position="none", axis.text.y = element_blank())
dev.off()