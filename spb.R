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
  filter(grepl("Петерб", reg) &
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

spb_plot <- 
  deaths_filter %>%
  ggplot() +
  geom_hline(yintercept = 0, size = 1, color = "#333333") +
  geom_line(aes(x = year, 
                y = value, 
                color = age), size = 1) +
  bbc_style() + 
  labs(
    title = "Количество смертей на 1 тыс. человек\nв каждой возрастной категории в Петербурге"
  ) +
  guides(color = guide_legend(ncol = 3, byrow = FALSE)) +
  theme(
    panel.grid.major.x = element_line(size = .5, color = "#dddddd"),
    panel.grid.major.y = element_line(size = .3, color = "#dddddd")
  ) + 
  scale_y_continuous(
    limits = c(0, 155)
  )

finalise_plot(
  spb_plot,
  save_filepath = glue("charts/spb.png"),
  source_name = "Источник: Росстат"
)

cairo_pdf("pdf/spb.pdf", width = 670/72, height = 480/72)
print(spb_plot)
dev.off()
