library(sf)
library(spdep)
library(tidyr)

#location 
df1 <- st_read("gadm36_levels_shp/gadm36_1.shp")

#set row names
row.names(df1) <- as.character(df1$GID_1)
#find neighbors
nb <- poly2nb(df1)
#convert to matrix and rename rows and cols
mat <- nb2mat(nb, style="B", zero.policy = TRUE)
colnames(mat) <- rownames(mat)

#convert to df and then make first col into country names
df2 <- as.data.frame(mat)
df3<- cbind(data.frame(country=colnames(df2)),df2)

#turn to long format and then select variables
df4<-gather(df3,loc,value, AFG.1_1:ZWE.10_1, factor_key=FALSE) %>% dplyr::filter(value==1) %>% dplyr::select(gid_1=loc, borders=country)

write.csv(df4,"gid_1_bordering_locations.csv")
