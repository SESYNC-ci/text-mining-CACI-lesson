require(knitr)
require(yaml)
require(stringr)

config = yaml.load_file("_config.yml")
render_markdown(fence_char = "~")
opts_knit$set(base.url = paste0(config$baseurl, "/"))
opts_chunk$set(
    comment = NA,
    fig.path = "images/",
    block_ial = c("{:.input}", "{:.output}"))

current_chunk = knit_hooks$get("chunk")
chunk = function(x, options) {
    x <- current_chunk(x, options)
    if (!is.null(options$title)) {
        first <- paste0("~~~\n{:.text-document title=\"", options$title, "\"}\\1")
    } else {
        first <- paste0("~~~\n", options$block_ial[1], "\\1")
    }
    if (str_count(x, "~~~") <= 2) {
        x <- gsub("~~~(\n*$)", first, x)
    } else {
        x <- gsub("~~~\n(.+)", first, x)
        last <- paste0("~~~\n", options$block_ial[2], "\\1")
        x <- gsub("~~~(\n*$)", last, x)
    }
    return(x)
}
knit_hooks$set(chunk = chunk)

for (f in config$slide_sorter) {
    fname <- paste0("_slides/", f, ".Rmd")
    if (file.exists(fname)) {
        knit(input = fname, 
             output = paste0("_slides/", f, ".md"))
    }
}
