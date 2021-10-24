

library(rvest)
library(tidyverse)
library(tictoc)

# https://davisvaughan.github.io/furrr/


base_link <- "https://www.cargurus.com/Cars/inventorylisting/viewDetailsFilterViewInventoryListing.action?zip=94122&distance=50&entitySelectingHelper.selectedEntity=d001"

read_html(base_link) %>%
  html_nodes("h1") %>%
  html_text() %>%
  str_remove("Used ") %>%
  str_remove(" for Sale in San Francisco, CA")


targets <- function(number) {
  
  number <- as.character(number)
  
  read_html(
      glue::glue("https://www.cargurus.com/Cars/inventorylisting/viewDetailsFilterViewInventoryListing.action?zip=94122&distance=50&entitySelectingHelper.selectedEntity=d{number}")
                 ) %>%
    html_nodes("h1") %>%
    html_text() %>%
    str_remove("Used ") %>%
    str_remove(" for Sale in San Francisco, CA")
  
}

targets("001")
targets("002")


test_frame <- tibble(place1 = c(seq(from=0, to=9)),
                      place2 = place1, place3 = place1, place4 = place1
                      ) %>%
  expand.grid() %>%
  tibble() %>%
  mutate(combos_3_letter = paste0(place1,place2,place3),
         combos_4_letter = paste0(place1,place2,place3,place4))



future::plan("multisession", workers = 6)

tic()
combo_3_letter_list <- furrr::future_map(pull(test_frame,combos_3_letter),
                                         ~targets(.x))
toc()

tic()
combo_4_letter_list <- furrr::future_map(pull(test_frame,combos_4_letter),
                                         ~targets(.x))
toc()

# tic()
# purrr::map(pull(test_frame,combos_3_letter)[1:20],
#     ~targets(.x))
# toc()
# holy shit this was slow, purrr

test_frame %<>%
  mutate(combo_3_letter_vec = reshape2::melt(combo_3_letter_list) %>% pull(value)) %>%
  dplyr::filter(combo_3_letter_vec != "Cars") %>%
  arrange(combo_3_letter_vec)


# "https://www.cargurus.com/" %>%
#   read_html() %>%
#   html_nodes("optgroup")
 
makes <- "https://www.cargurus.com/" %>%
  read_html() %>%
  html_node(css="#carPickerUsed_makerSelect") %>%
  html_node(xpath = "optgroup[2]") %>%
  html_children()

makes %>%
  html_attr("value")

makes_text <- makes %>%
  html_text()


# models <- "https://www.cargurus.com/" %>%
#   read_html() %>%
#   html_node(css="#carPickerUsed_makerSelect") %>%
#   html_node(xpath = "optgroup[2]") %>%
#   html_children()


# https://stackoverflow.com/questions/35790652/removing-words-featured-in-character-vector-from-string
# https://dcl-wrangle.stanford.edu/rvest.html


test_frame %>%
  mutate(testing = tm::removeWords(combo_3_letter_vec, makes_text)) %>%
  distinct(combo_3_letter_vec, .keep_all = T) %>%
