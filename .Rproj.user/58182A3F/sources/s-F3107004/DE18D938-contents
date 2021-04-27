library(tidyverse)
library(readxl)
library(bbplot2)
library(glue)
library(grDevices)

deaths <- read_csv("clean_data/deaths.csv")

deaths_urb <- deaths %>% 
  filter(area == "городское население" & 
           year > 2010 &
           gender == "Оба пола") %>%
  select(-area, -promille)

age_groups <- unique(deaths$age)[(13:18)]

deaths_filter <- deaths_urb %>%
  filter(grepl("Чеченск", reg) &
           age %in% age_groups)

deaths_filter$age <- 
  factor(deaths_filter$age, 
         levels = c(
           "85 и старше",
           "80-84 года",
           "75-79 лет",
           "70-74 лет",
           "65-69 лет",
           "60-64 лет"
         ))

deaths_filter$year <- as.Date(ISOdate(deaths_filter$year, 01, 01))

chechnya_plot <- 
  deaths_filter %>%
  ggplot() +
  geom_hline(yintercept = 0, size = 1, color = "#333333") +
  geom_line(aes(x = year, 
                y = value, 
                color = age), size = 1) +
  bbc_style() + 
  labs(
    title = "Самая высокая смертность среди\nнаселения 85 лет и старше - в Чечне",
    subtitle = glue("Смертей на 1 тыс. человек в каждой возрастной категории,\nгородское население")
  ) +
  guides(color = guide_legend(ncol = 3, byrow = FALSE)) +
  theme(
    panel.grid.major.x = element_line(size = .5, color = "#dddddd"),
    panel.grid.major.y = element_line(size = .3, color = "#dddddd")
  )

finalise_plot(
  chechnya_plot,
  save_filepath = glue("charts/chechnya.png"),
  source_name = "Источник: Росстат"
)

cairo_pdf("pdf/chechnya.pdf", width = 670/72, height = 480/72)
print(chechnya_plot)
dev.off()