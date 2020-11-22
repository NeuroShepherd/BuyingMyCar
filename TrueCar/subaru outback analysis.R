
subarus_filtered <- subaru_outbacks %>% 
  dplyr::filter(trim %in% c("2.5i Limited","2.5i Premium")) %>%
  mutate(trim = factor(trim)) %>%
  mutate(age = 2021 - year)

model <- subarus_filtered %>%
  lm(price_usd ~ age + miles + trim, data = .)

prediction <- model %>%
  predict() %>%
  tibble(prediction = .)

residuals <- model %>%
  residuals() %>%
  tibble(residuals = .)

subarus_filtered <- tibble(subarus_filtered, prediction, residuals) 

subarus_filtered %>%
  mutate(trim = factor(trim)) %>%
  mutate(age = 2021 - year) %>%
  ggplot(aes(age,price_usd,color=trim)) +
  geom_point() +
  geom_jitter() +
  geom_smooth(se=F, method = "lm")

subarus_filtered %>%
  ggplot(aes(residuals,fill=trim)) +
  geom_histogram(alpha=.6, bins=20, color="black", position = "identity") +
  theme_minimal()