library(readxl)
library(dplyr)
library(gt)
library(openxlsx)
library(rlang)
library(stringr)

# Load the data from Excel
df <- read_excel("/Users/petersjm/Documents/cidtree/data/data_dictionary_trimmed.xlsx")

# Execute clean-up transformations on the dictionary data frame
df <- df %>%
  mutate(
    # Ensure that CID fields are integers
    across(ends_with("_CID"), as.integer),
    # Extract leading numbers
    RESPONSE_CODE = str_extract(RESPONSE_KEY, "^\\d+"),
    # Remove the numeric prefix and '='
    RESPONSE_KEY = str_replace(RESPONSE_KEY, "^\\d+\\s*=\\s*", ""),
    # Removes any leading or trailing white space
    RESPONSE_KEY = str_trim(RESPONSE_KEY),
    # Replace "N/A" or NA with an empty string
    RESPONSE_KEY = if_else(RESPONSE_KEY == "N/A" | is.na(RESPONSE_KEY),
                           "",
                           RESPONSE_KEY),
    RESPONSE_KEY = if_else(is.na(RESPONSE_CID),
                           "",
                           RESPONSE_KEY)
    # # Set RESPONSE_CID to NA if RESPONSE_KEY is NA or "N/A"
    # RESPONSE_CID = if_else(is.na(RESPONSE_KEY) | RESPONSE_KEY == "N/A",
    #                        as.integer(NA),
    #                        RESPONSE_CID,
    #                        missing = as.integer(NA)) #
  )

# Function to analyze distinct keys
analyze_keys <- function(data, cid_name, key_name) {
  group_fields <- rlang::syms(c(cid_name, key_name))
  result <- data %>%
    group_by(!!!group_fields) %>%
    summarise(
      COUNT = n(),  # Count occurrences
      .groups = 'drop'
    ) %>%
    group_by(!!!rlang::syms(cid_name)) %>%
    filter(n_distinct(!!!rlang::syms(key_name)) > 1) %>%
    arrange(!!!group_fields)
}

# List of CID and KEY pairs to analyze
field_pairs <- list(
  c("QUESTION_CID", "QUESTION_KEY"),
  c("RESPONSE_CID", "RESPONSE_KEY"),
  c("PRIMARY_CID", "PRIMARY_KEY"),
  c("SECONDARY_CID", "SECONDARY_KEY"),
  c("SOURCE_CID", "SOURCE_KEY")
)
# Apply function to each pair and print results
for (pair in field_pairs) {
  results <- analyze_keys(df, pair[1], pair[2])
  openxlsx::write.xlsx(results, tolower(paste0("test/qc/", pair[1], "_key_pairs.xlsx")))
}

## ------------------------------------------

# Function to replace each CID's KEY with the most prevalent KEY, considering ties
replace_key_with_most_prevalent <- function(data, cid_name, key_name) {
  # Calculate the most prevalent KEY for each CID
  # Group by CID and KEY, count occurrences, and then sort first by count desc, then by KEY to handle ties
  prevalent_keys <- data %>%
    group_by_at(vars(cid_name, key_name)) %>%
    summarise(COUNT = n(), .groups = 'drop') %>%
    arrange(desc(COUNT), !!rlang::sym(key_name)) %>%
    group_by_at(vars(cid_name)) %>%
    slice(1) %>%  # Select the most prevalent KEY (or the first in case of ties)
    ungroup()

  # Rename the key column to 'most_frequent_key' for clarity
  names(prevalent_keys)[which(names(prevalent_keys) == key_name)] <- "most_frequent_key"

  # Join this back to the original data to update the KEY field
  data <- data %>%
    left_join(prevalent_keys %>% select(!!rlang::sym(cid_name), most_frequent_key), by = cid_name) %>%
    mutate(!!rlang::sym(key_name) := most_frequent_key) %>%
    select(-most_frequent_key)  # Remove the temporary most_frequent_key column after replacement

  return(data)
}

# Apply function to each pair and print results
for (pair in field_pairs) {
  print(analyze_keys(df, pair[1], pair[2]))
}

# Process each pair and update the df
for(pair in field_pairs) {
  df <- replace_key_with_most_prevalent(df, pair[1], pair[2])
}

# Apply function to each pair and print results
for (pair in field_pairs) {
  print(analyze_keys(df, pair[1], pair[2]))
}

openxlsx::write.xlsx(df, tolower(paste0("/Users/petersjm/Documents/cidtree/data/data_dictionary_trimmed_cleaned.xlsx")))
