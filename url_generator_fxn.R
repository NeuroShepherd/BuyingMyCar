


truecar_url_creator <- function(make,model=NA,location,min_year,max_year="max",
                                searchRadius=75,online_dealers=FALSE){
  library(rvest)
  model <- ifelse(is.na(model),"/",paste0("/",model,"/"))
  
  # Ifelse for filtering out online dealers when creating slugs
  pagination <- if (online_dealers) {
    glue::glue('https://www.truecar.com/used-cars-for-sale/listings/{make}{model}year-{min_year}-{max_year}/location-{location}/?page=1&searchRadius={searchRadius}') %>%
      read_html() %>%
      html_node(css = ".pagination") %>%
      html_text() %>%
      stringr::str_extract(.,"(\\d+)$") 
  } else {
    glue::glue('https://www.truecar.com/used-cars-for-sale/listings/{make}{model}year-{min_year}-{max_year}/location-{location}/?onlineDealers=none&page=1&searchRadius={searchRadius}') %>%
      read_html() %>%
      html_node(css = ".pagination") %>%
      html_text() %>%
      stringr::str_extract(.,"(\\d+)$")
  }
   
  
  
  # Some make/model combos only have 1 page so the pagination number is just listed as chr ""
  # Create ifelse statement to set "" to 1
  npages<- ifelse(is.na(pagination), 1, pagination) %>% seq_len()

  # Return links including or w/o onlineDealers slug
  if (online_dealers){
    glue::glue('https://www.truecar.com/used-cars-for-sale/listings/{make}{model}year-{min_year}-max/location-{location}/?page={npages}&searchRadius={searchRadius}') %>%
      return()
  } else {
    glue::glue('https://www.truecar.com/used-cars-for-sale/listings/{make}{model}year-{min_year}-max/location-{location}/?onlineDealers=none&page={npages}&searchRadius={searchRadius}') %>%
      return()
  }
}


# The xpath for the max page, when pages > 10, can be found with this:
# xpath = "/html/body/div[2]/main/div/div[3]/div/div[2]/div/div[2]/div[2]/nav/ul/li[12]/a"
# But I found a better option by looking at the flexbox holding all page number values at the bottom of the page

# truecar_url_creator("subaru",
#                     location = "san-francisco-ca",
#                     min_year=2013,
#                     searchRadius = 75)



