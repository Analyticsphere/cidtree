# Install c4c
devtools::load_all("./")

# Construct data dictionary tree
dd <- c4c::construct_dictionary_tree(path = "./data/test_dictionary")

# Print output so that it does not wrap on the screen
output <- capture.output(print(dd, 'concept_str', 'responses_str'))
cat(output, sep="\n")

# View data frame version of the data dictionary
head(dd$df)

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


