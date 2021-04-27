library(tidyverse)
library(readxl)
library(glue)

excel_sheets("raw-data/covid_deaths_demographics_full_breakdown.xls")

deaths1 <- read_excel("raw-data/covid_deaths_demographics_full_breakdown.xls", 
                     sheet = "Данные",
                     col_types = c("guess", "guess", "guess", "guess", "guess", "guess", "numeric")) %>%
  .[-(1:3),]
deaths2 <- read_excel("raw-data/covid_deaths_demographics_full_breakdown.xls", 
                      sheet = "Данные 2",
                      col_types = c("guess", "guess", "guess", "guess", "guess", "guess", "numeric")) %>%
  .[-(1:3),]
deaths3 <- read_excel("raw-data/covid_deaths_demographics_full_breakdown.xls", 
                      sheet = "Данные 3",
                      col_types = c("guess", "guess", "guess", "guess", "guess", "guess", "numeric")) %>%
  .[-(1:3),]

deaths <- rbind(deaths1, deaths2, deaths3)
names(deaths) <- c("year", "age", "area", "reg", "gender", "promille", "value")
write_csv(deaths, "clean_data/deaths.csv")