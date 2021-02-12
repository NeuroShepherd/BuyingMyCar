
# RAV4 generations
# 4th: 2014-2018
# 5th: 2019-Present

toyota_rav4 <- scrape_truecar_data(make = "toyota",
                                        model = "rav4",
                                        location = "san-francisco-ca",
                                        min_year = 2017) %>%
  mutate(age = lubridate::year(Sys.Date()) - year) %>%
  dplyr::filter(!is.na(price_usd))


toyota_rav4_lm <- lm(price_usd ~ age + miles + trim, data = toyota_rav4)
summary(toyota_rav4_lm)

toyota_rav4 %<>%
  mutate(residual = residuals(toyota_rav4_lm) %>% round(0))


toyota_rav4 %>%
  dplyr::filter(str_detect(trim, "AWD") | str_detect(trim, "Hybrid", negate = F)) %>%
  write_csv(path = "./toyota_rav4.csv", na="")
