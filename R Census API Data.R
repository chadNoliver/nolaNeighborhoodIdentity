#Census Data Files
#install.packages("censusapi")
#install.packages("tidyverse")
#install.packages("tidycensus")
#library(censusapi)
#install.packages("geojsonio")
#install.packages("geojsonR")
library(magrittr)
library(tidyverse)
library(tidycensus)
library (sf)
library(geojsonio)
library(rgdal)
library(geojsonR)



options(tigris_use_cache = TRUE)
census_api_key <- "f5635f227baae2f8f165f369feae8591fd32a5d8"

Sys.setenv(census_api_key=api_key)


#Create Variables

#1) Blocks and Tracts with Data

#Use for creating ACS data dictionary 
#var_ops <- load_variables(2017,"acs5",cache=TRUE)
#View( var_ops)

block <- st_as_sf(get_acs(state="LA",county="Orleans",geography="block", 
                 variables="B01001_010M",geometry=TRUE))

tract <- st_as_sf(get_acs(state="LA",county="Orleans",geography="tract", 
                  variables=c("B01001_003","B01001_004","B01001_005","B01001_006",
                              "B01001_007","B01001_008","B01001_009","B01001_010",
                              "B01001_027","B01001_028","B01001_029","B01001_030",
                              "B01001_031","B01001_032","B01001_033","B01001_034"),geometry=TRUE))

#2 city polygons

city_council_district <- st_read("https://opendata.arcgis.com/datasets/4593a994e7644bcc91d9e1c096df1734_0.geojson")

neighborhood=st_read("https://opendata.arcgis.com/datasets/e7daa4c977d14e1b9e2fa4d7aff81e59_0.geojson")

nola <- st_read("C:/Users/User/Documents/R/data/Orleans Parish - Boundary/geo_export_825e39e1-e34f-4c7f-816d-3ae98f3a4e90.shp")
?TO_GeoJson
library(geojsonR)
file_to_geojson(tract)
View(neighborhood)
neighborhood <- neighborhood %>% 
  mutate(GNOCDC_LAB = str_to_title(GNOCDC_LAB),
         GNOCDC_LAB = str_replace(GNOCDC_LAB,"U.s.","U.S.")
  )

View(neighborhood)

city_council_district <- city_council_district %>% 
  mutate(img=if_else(DISTRICTID=='A','images/Joe-Giarrusso-sm.jpg',
                     if_else(DISTRICTID=='B','images/Jay-H-Banks-sm.jpg',
                             if_else(DISTRICTID=='C','images/Kristen-Gisleson-Palmer-sm.jpg',
                                     if_else(DISTRICTID=='D','images/Jared-Brossett-sm.jpg',
                                             if_else(DISTRICTID=='E','images/Cyndi-Nguyen-sm.jpg',
                                                     'null.png')))) )
  )



city_council_district <- city_council_district %>% 
  mutate(web_link=if_else(DISTRICTID=='A','<a href="https://council.nola.gov/councilmembers/joseph-giarrusso/">Joeseph I. Giarrusso III</a>',
                     if_else(DISTRICTID=='B','<a href="https://council.nola.gov/councilmembers/jay-banks/">Jay H. Banks</a>',
                             if_else(DISTRICTID=='C','<a href="https://council.nola.gov/councilmembers/kristin-gisleson-palmer/">Kristen Gisleson Palmer</a>',
                                     if_else(DISTRICTID=='D','<a href="https://council.nola.gov/councilmembers/jared-brossett/">Jared C. Brossett</a>',
                                             if_else(DISTRICTID=='E','<a href="https://council.nola.gov/councilmembers/cyndi-nguyen/">Cyndi Nguyen</a>',
                                                     'null.png')))) )
  )


city_council_district <- city_council_district %>% 
  mutate(email_link=if_else(DISTRICTID=='A','<A HREF="mailto:Joseph.Giarrusso@nola.gov">Email</A>',
                              if_else(DISTRICTID=='B','<A HREF="mailto:Jay.Banks@nola.gov> Email</A>',
                                      if_else(DISTRICTID=='C','<A HREF="mailto:Kristin.Palmer@nola.gov> Email</A>',
                                              if_else(DISTRICTID=='D','<A HREF="mailto:councildistrictd@nola.gov> Email</A>',
                                                      if_else(DISTRICTID=='E','A HREF="mailto:Cyndi.Nguyen@nola.gov> Email</A>',
                                                              'null.png')))) )
  )




city_council_district <- city_council_district %>% 
  mutate(twitter_link=if_else(DISTRICTID=='A','<a href="https://twitter.com/CmGiarrusso">Twitter</a>',
                          if_else(DISTRICTID=='B','<a href="https://twitter.com/cmjayhbanks">Twitter</a>',
                                  if_else(DISTRICTID=='C','<a href="https://twitter.com/kgislesonpalmer">Twitter</a>',
                                          if_else(DISTRICTID=='D','<a href="https://twitter.com/JaredCBrossett">Twitter</a>',
                                                  if_else(DISTRICTID=='E','<a href="https://twitter.com/Vote4Cyndi">Twitter</a>',
                                                          'null.png')))) )
  )

city_council_district <- city_council_district %>% 
  mutate(facebook_link=if_else(DISTRICTID=='A','<a href="https://www.facebook.com/cmgiarrusso/">Facebook</a>',
                              if_else(DISTRICTID=='B','<a href="https://www.facebook.com/JHBanks4NOLA/">Facebook</a>',
                                      if_else(DISTRICTID=='C','<a href="https://www.facebook.com/kristin.gislesonpalmer/">Facebook</a>',
                                              if_else(DISTRICTID=='D','<a href="https://www.facebook.com/jared.brossett/">Facebook</a>',
                                                      if_else(DISTRICTID=='E','<a href="https://www.facebook.com/vote4cyndinguyen/">Facebook</a>',
                                                              'null.png')))) )
  )




View(city_council_district)
#geojson_write(block,file="C:/Users/User/traumamap/geometry/WIP-polygons-new-orleans-block-populations.geoJSON")

geojson_write(tract,"C:/Users/User/traumamap/geometry/WIP-polygons-new-orleans-tract-populations-needs-cleaning.geoJSON")
geojson_write(neighborhood, file="C:/Users/User/traumamap/geometry/WIP-polygons-nola-neighborhood-boundaries.geoJSON")
geojson_write(city_council_district, file="C:/Users/User/traumamap/geometry/WIP-polygons-nola-city-council-district-boundaries.geoJSON")
geojson_write(nola, file="C:/Users/User/traumamap/geometry/WIP-polygons-new-orleans-city-boundaries.geoJSON",driver="GeoJSON")
View(city_council_district)
View(city_council_district)


view(tract)



neighborhood <- neighborhood %>% st_transform(4269)
tract <- tract %>% st_transform(4269)

#we'll keep st_intersects as the rule assuming tracts neatly nest w/in districts
tract_neighborhood<- st_join(neighborhood, tract, join = st_intersects,suffix=c("neighborhood","tract"))
View(tract_neighborhood)
st_transform

#sum up population
neighborhood_pop <- tract_neighborhood %>% group_by(GNOCDC_LAB) %>%
  summarize(neighborhood_est = sum(estimate),
            neighborhood_moe=moe_sum(moe)
  )
warnings()
install.packages("lwgeom")
tract <- tract %>% 
  mutate(
  tract_area=st_area(geometry)* 0.000000386102159
)
View(tract)

tract_pop <- tract %>% group_by(NAME) %>%
  summarize(tract_estimate = sum(estimate),
            tract_moe=moe_sum(moe,estimate=estimate),
            tract_moe=round(tract_moe),
            tract_area=mean(tract_area)
)

tract_pop <- tract_pop %>%
  mutate(tract_estimate_density = round((tract_estimate/tract_area),2),
         tract_moe_density = round((tract_moe/tract_area),2)
)
 

            
View(neighborhood)
geojson_write(tract_pop, file="C:/Users/User/traumamap/geometry/WIP-polygons-nola-tract-pop-needs-cleaning.geoJSON",driver="GeoJSON")
View(tract_pop)
?moe_sum

View(city_council_district)














# Reload .Renviron
readRenviron("~/.Renviron")
# Check to see that the expected key is output in your R console
Sys.getenv("CENSUS_KEY")
getCensus(name="timeseries/healthins/sahie",
          vars=c("NAME","IPRCAT","IPR_DESC","PCTUI_PT"),
          region = "us:*",
          time = 2017)



