



links <- truecar_url_creator("subaru","outback",
                             location = "san-francisco-ca",
                             min_year=2017, online_dealers = F)

front_pages <- links %>% map(read_html)
  
# scrape_truecar_data("jeep","grand-cherokee",
#                     location = "san-francisco-ca",
#                     min_year=2019) %>%
#   View()



# old price section: '.heading-3.margin-y-1.font-weight-bold'
  # this selection fails when no price is listed
price <- front_pages %>%
  map(~html_nodes(.x,".d-flex.w-100.vehicle-card-bottom-pricing.justify-content-between") %>%
        html_text()) %>%
  map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
  rename(temp = value) %>% 
  separate(temp, into = c("junk","price_usd"), sep = "list price") %>% 
  select(-junk) %>%
  mutate(price_usd = str_remove_all(price_usd,"\\$|,") %>% as.numeric())

model_year <- front_pages %>%
  map(~html_nodes(.x,'.vehicle-card-header.w-100') %>%
        html_text()) %>%
  map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
  rename(year = value) %>%
  mutate(model = str_replace(year, "\\d{4}|Sponsored\\d{4}|","") %>% str_trim("left"),
         year = str_extract(year, "\\d{4}") %>% as.numeric())

miles_travelled <- front_pages %>%
  map(~html_nodes(.x,'.d-flex.w-100.justify-content-between') %>%
        html_text()
        ) %>%
  map_dfr(~ .x %>% as_tibble(.name_repair = "unique"), .id = "name") %>%
  dplyr::filter(str_detect(value,"miles")) %>%
  rename(miles = value) %>%
  mutate(miles = str_extract(miles, "\\d+.*\\d+") %>% 
           str_replace(",","") %>% 
           as.numeric())

colors <- front_pages %>%
  map(~html_nodes(.x,'.vehicle-card-location.font-size-1.margin-top-1.text-truncate') %>%
        html_text()) %>%
  map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
  separate(value, into = c("exterior","interior"), sep = ", ") %>%
  mutate(exterior = str_remove_all(exterior, " exterior"),
         interior = str_remove_all(interior, " interior"))

trim <- front_pages %>%
  map(~html_nodes(.x,'.vehicle-card-top') %>%
        html_children() %>%
        html_children() %>%
        html_text()) %>%
  map_dfr(~ .x %>% as_tibble(), .id = "name") %>% 
  dplyr::filter(row_number() %in% seq(2,nrow(.),2)) %>%
  rename(trim = value)
      
VIN <- front_pages %>%
  map(~html_nodes(.x, ".card.card-1.card-shadow.card-shadow-hover.vehicle-card._1qd1muk") %>%
        html_attr("data-test-item")) %>%
  map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
  rename(vin = value)
  
dealer_id <- front_pages %>%
  map(~html_nodes(.x, ".card.card-1.card-shadow.card-shadow-hover.vehicle-card._1qd1muk") %>%
        html_attr("data-test-dealerid")) %>%
  map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
  rename(dealer_id = value)

subaru_outbacks <- tibble(model_year,trim,price, miles_travelled, colors,VIN,dealer_id,
       .name_repair = "unique") %>%
  select(-contains("name")) %>%
  distinct(vin, .keep_all = T) %>%
  mutate(link = glue::glue("https://www.truecar.com/used-cars-for-sale/listing/{vin}/")) 






