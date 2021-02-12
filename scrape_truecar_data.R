

scrape_truecar_data <- function(make,model=NA,location,min_year,max_year="max",searchRadius=75){
  
  
  front_pages <- truecar_url_creator(make,model,location,
                                     min_year,max_year,
                                     searchRadius) %>% 
    map(read_html)
  
  

# Price scrape
# ----- 
  price <- front_pages %>%
    map(~html_nodes(.x,".d-flex.w-100.vehicle-card-bottom-pricing.justify-content-between") %>%
          html_text()) %>%
    map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
    rename(temp = value) %>% 
    separate(temp, into = c("junk","price_usd"), sep = "list price") %>% 
    select(-junk) %>%
    mutate(price_usd = str_remove_all(price_usd,"\\$|,") %>% as.numeric())
  # ----- 

# Model and year scrape
  # ----- 
  model_year <- front_pages %>%
    map(~html_nodes(.x,'.vehicle-card-header.w-100') %>%
          html_text()) %>%
    map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
    rename(year = value) %>%
    mutate(model = str_replace(year, "\\d{4}|Sponsored\\d{4}|","") %>% str_trim("left"),
           year = str_extract(year, "\\d{4}") %>% as.numeric())
  # ----- 
  
# Miles travelled scrape
  # ----- 
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
  # ----- 

# Car colors scrape, interior and exterior
  # ----- 
  colors <- front_pages %>%
    map(~html_nodes(.x,'.vehicle-card-location.font-size-1.margin-top-1.text-truncate') %>%
          html_text()) %>%
    map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
    separate(value, into = c("exterior","interior"), sep = ", ") %>%
    mutate(exterior = str_remove_all(exterior, " exterior"),
           interior = str_remove_all(interior, " interior"))
  # ----- 

# Car trim scrape
  # ----- 
  trim <- front_pages %>%
    map(~html_nodes(.x,'.vehicle-card-top') %>%
          html_children() %>%
          html_children() %>%
          html_text()) %>%
    map_dfr(~ .x %>% as_tibble(), .id = "name") %>% 
    dplyr::filter(row_number() %in% seq(2,nrow(.),2)) %>%
    rename(trim = value)
  # ----- 
  
  
# VIN Scrape
  VIN <- front_pages %>%
    map(~html_nodes(.x, ".linkable.card.card-shadow.card-shadow-hover.vehicle-card._1qd1muk") %>%
          html_attr('data-test-item')) %>%
    map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
    rename(vin = value)
  
# Dealer ID scrape
  dealer_id <- front_pages %>%
    map(~html_nodes(.x, ".linkable.card.card-shadow.card-shadow-hover.vehicle-card._1qd1muk") %>%
          html_attr('data-test-dealerid')) %>%
    map_dfr(~ .x %>% as_tibble(), .id = "name") %>%
    rename(dealer_id = value)
  
# Create table and create unique TrueCar links to go to webpages
  tibble(model_year,trim,price, miles_travelled, colors,VIN,dealer_id,
                            .name_repair = "unique") %>%
    select(-contains("name")) %>%
    distinct(vin, .keep_all = T) %>%
    mutate(link = glue::glue("https://www.truecar.com/used-cars-for-sale/listing/{vin}/")) %>%
    return()
  
  
}
