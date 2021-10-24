
# CRV generations
# 4th: 2012-2016
# 5th: 2017-2020
# 6th: 2021-

honda_crv <- scrape_truecar_data(make = "honda",
                                 model = "cr-v",
                                        location = "san-francisco-ca",
                                        min_year = 2017) %>%
  mutate(age = lubridate::year(Sys.Date()) - year) %>%
  dplyr::filter(!is.na(price_usd))

# honda_crv %<>% 
#   mutate(drive_type = if_else(str_detect(trim,"AWD"), 1, 0))

honda_crv_lm <- lm(price_usd ~ age + miles + trim, data = honda_crv)
summary(honda_crv_lm)

honda_crv %<>%
  mutate(residual = residuals(honda_crv_lm) %>% round(0))

honda_crv %<>%
  dplyr::filter(str_detect(trim, "AWD")) %>%
  write_csv(path = "./honda_crv.csv", na="")
