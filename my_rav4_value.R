
car_miles <- 52000
car_age <- 3

toyota_rav4_lm %>%
  summary() %>%
  extract2(4) %>%
  as.data.frame() %>%
  rownames_to_column() %>%
  select(rowname, Estimate) %>%
  dplyr::filter(rowname %in% c("(Intercept)","age","miles","trimHybrid LE AWD")) %>%
  mutate(values = c(1,car_age,car_miles,1),
         values2 = Estimate*values) %>%
  janitor::adorn_totals() %>%
  extract2(4) %>%
  extract2(5)
