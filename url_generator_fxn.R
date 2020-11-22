


truecar_url_creator <- function(make,model=NA,location,min_year,max_year="max",searchRadius=75){
  
  model <- ifelse(is.na(model),"/",paste0("/",model,"/"))
  
  npages <- glue::glue('https://www.truecar.com/used-cars-for-sale/listings/{make}{model}year-{min_year}-{max_year}/location-{location}/?page=1&searchRadius={searchRadius}') %>%
    read_html() %>%
    html_node(css = ".d-flex.justify-content-center") %>%
    html_text() %>%
    stringr::str_extract(.,"(\\d+)$") %>%
    seq_len()


   glue::glue('https://www.truecar.com/used-cars-for-sale/listings/{make}{model}year-{min_year}-max/location-{location}/?page={npages}&searchRadius={searchRadius}') %>%
    return()
}


# The xpath for the max page, when pages > 10, can be found with this:
# xpath = "/html/body/div[2]/main/div/div[3]/div/div[2]/div/div[2]/div[2]/nav/ul/li[12]/a"
# But I found a better option by looking at the flexbox holding all page number values at the bottom of the page

# truecar_url_creator("subaru",
#                     location = "san-francisco-ca",
#                     min_year=2013,
#                     searchRadius = 75)



