# Install c4c
library(glue)
library(purrr)

devtools::load_all("./")

# Construct data dictionary tree
path <- get_path_to_example_dictionary() # Replace with the path to your dictionary
dd <- c4c::construct_dictionary_tree(path = path)

# Print output so that it does not wrap on the screen
output <- capture.output(print(dd, 'concept_str', 'responses_str'))
cat(output, sep="\n")

# View data frame version of the data dictionary
dd$df <- data.tree::ToDataFrameTree(dd)
print(df, 'path')

# Retrieve a key, given a cid
cid <- 639684251
key <- c4c::get_key(dd, cid)
print(key)

# Retrieve a concept id, given a key
key <- "Do you smoke cigarettes now?"
cid <- c4c::get_cid(dd, key)
print(cid)

# Retrieve all metadata
meta <- c4c::get_meta(dd, cid)
print(meta)

project <- "nih-nci-dceg-connect-stg-5519"
dataset <- "FlatConnect"
table   <- "participants_JP"

bq_ds   <- bq_dataset(project, dataset)
bq_tbl  <- bq_table(project, dataset, table)
bq_vars <- bq_table_fields(bq_tbl)


df_vars <- tibble(name = map_chr(bq_vars, ~ .x$name)) %>%
  as.data.frame() %>%
  mutate(path = sapply(name, extract_cids))

dd$pathString

str <- "d_142654897_d_461488577"
var_name <- dd$Get("var_name", filterFun = function(x) x$concept_type == "QUESTION" && grepl(x$cid, str))
var_name
