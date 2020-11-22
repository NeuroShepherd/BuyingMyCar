


# successfully pull a vector of brands
read_html("https://www.truecar.com/shop/used/?filterType=brand&makeSlug=subaru") %>%
  html_nodes(".tab.d-inline-block.text-left.padding-x-2.padding-y-3._128slgv") %>%
  html_text()


# trying to pull a vector of models available for subaru (and to then apply this to other brands)
read_html("https://www.truecar.com/shop/used/?filterType=brand&makeSlug=subaru") %>%
  html_nodes(xpath = '//*[@data-qa="UsedModelDropdown"]/option') %>%
  html_attr("value")

read_html("https://www.truecar.com/shop/used/?filterType=brand&makeSlug=subaru") %>%
  html_nodes(css = '.field-container.field-size-md.field-layout-float') %>%
  str()
  html_text()

 
# Looking at the nesting, it doesn't appear the options list is actually being captured
# by read_html() even though I can see it on the webpage by inspecting element. JS feature?
  read_html("https://www.truecar.com/shop/used/?filterType=brand&makeSlug=subaru") %>%
    View()
    
