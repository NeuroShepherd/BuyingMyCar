
# Subaru Forester generations
# 4th: 2014-2018
# 5th: 2019-present

subaru_foresters <- scrape_truecar_data(make = "subaru",
                        model = "forester",
                        location = "san-francisco-ca",
                        min_year = 2018) %>%
  mutate(age = lubridate::year(Sys.Date()) - year) %>%
  dplyr::filter(!is.na(price_usd))


subaru_foresters_lm <- lm(price_usd ~ age + miles + trim, data = subaru_foresters)
summary(subaru_foresters_lm)

subaru_foresters %<>%
  mutate(residual = residuals(subaru_foresters_lm) %>% round(0))


subaru_foresters %>%
  write_csv(path = "./subaru_forester.csv", na="")
