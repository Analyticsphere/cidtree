#' Retrieve the Key Associated with a Concept ID from a Data Tree
#'
#' This function takes a `data.tree` object representing a data dictionary
#' and a concept ID (cid), returning the "key" associated with that specific
#' concept ID within the data tree.
#'
#' @param dd A `data.tree` object representing the data dictionary.
#' @param cid A concept ID as a string or numeric value, used to locate the specific node
#'   within the data tree whose key is desired.
#' @return The key associated with the given concept ID. If the concept ID does not
#'   exist, returns NULL.
#' @examples
#' # Assuming `dd` is a properly structured `data.tree` object
#' # and '123' is a valid concept ID in the tree:
#' path <- get_path_to_example_dictionary() # Replace with path to your dictionary
#' dd <- construct_dictionary_tree(path)
#' key <- get_key(dd, '151488193')
#' key
#' @export
#' @importFrom glue glue
get_key <- function(dd, cid) {
  # Implement using data.frame
  key <- dd$df[dd$df$cid == cid, "key"]
  # Implement using data.tree
  a <- dd$Get(function(node) node$key,
              filterFun = function(node) node$name == cid)
}

#' Retrieve the Concept ID Associated with a Key
#'
#' This function returns the concept ID (cid) corresponding to a given key
#' within the data.tree object representing the data dictionary.
#'
#' @param dd A `data.tree` object representing the data dictionary.
#' @param key A key to locate the corresponding concept ID.
#' @return The concept ID associated with the given key. If no match is found, returns NULL.
#' @examples
#' path <- get_path_to_example_dictionary() # Replace with path to your dictionary
#' dd <- construct_dictionary_tree(path)
#' concept_id <- get_cid(dd, 'University of Chicago Medicine')
#' concept_id
#' @export
get_cid <- function(dd, key) {
  cid <- dd$df[dd$df$key == key, "cid"]
}

#' Retrieve Metadata for a Concept
#'
#' This function retrieves metadata for a concept based on whether it's a valid concept ID (cid) or key.
#'
#' @param dd A `data.tree` object representing the data dictionary.
#' @param concept The concept ID or key to find metadata for.
#' @return A dataframe containing metadata for the given concept, or NULL if not found.
#' @examples
#' path <- get_path_to_example_dictionary() # Replace with path to your dictionary
#' dd <- construct_dictionary_tree(path)
#' metadata <- get_meta(dd, '317567178')  # for a valid cid
#' metadata
#' metadata <- get_meta(dd, 'In the past month')  # for a valid key
#' metadata
#' @export
get_meta <- function(dd, concept) {
  if (is_valid_cid(concept) && concept %in% dd$df$cid) {
    return(dd$df[dd$df$cid == concept, ])
  } else if (concept %in% dd$df$key) {
    return(dd$df[dd$df$key == concept, ])
  } else {
    warning("Not a valid concept ID or key.")
    return(NULL)
  }
}

#' Retrieve Responses for a Concept
#'
#' This function retrieves responses associated with a given concept.
#'
#' @param dd A `data.tree` object representing the data dictionary.
#' @param concept The concept ID or key whose responses are to be retrieved.
#' @return Responses associated with the concept if it is a question; otherwise, NULL.
#' @examples
#' path <- get_path_to_example_dictionary() # Replace with path to your dictionary
#' dd <- construct_dictionary_tree(path)
#' responses <- get_responses(dd, '763164658')
#' responses
#' responses <- get_responses(dd, 'How many cigarettes have you smoked in your entire life?')
#' responses
#' @export
get_responses <- function(dd, concept) {
  meta <- get_meta(dd, concept)
  if (is.null(meta)) {
    return(NULL)
  } else if (meta$concept_type != 'QUESTION') {
    warning("Concept is not a question and should not have responses.")
    return(NULL)
  }
  return(meta$responses)
}


#' Validate if the Input is a 9-digit Concept ID (cid)
#'
#' This function checks if a given input is a valid 9-digit concept ID.
#' Returns TRUE if valid, FALSE otherwise.
#'
#' @param input The input to check, expected to be a string or numeric type.
#' @return A boolean indicating if the input is a valid 9-digit concept ID.
#' @examples
#' is_valid_cid(123456789)   # Should return TRUE
#' is_valid_cid("987654321") # Should return TRUE
#' is_valid_cid(12345)       # Should return FALSE
#' is_valid_cid(9876543210)  # Should return FALSE
#' @export
is_valid_cid <- function(input) {
  if (is.numeric(input)) {
    input <- as.character(input)
  }

  return(is.character(input) && grepl("^\\d{9}$", input))
}


#' Retrieve Variable Name for a Question Concept
#'
#' This function retrieves the variable name for a question concept, given a
#' string containing it's Concept ID. This is particularly useful for labeling
#' data from Connect's BigQuery tables.
#'
#' @param dd The data dictionary tree
#' @param cid_str A string containing the concept id for a question concept.
#' @return The variable name for the question concept.
#' @examples
#' path <- get_path_to_example_dictionary() # Replace with path to your dictionary
#' dd <- construct_dictionary_tree(path)
#' var_name <- get_var_name(dd, "d_142654897_d_461488577") # Should return "RcrtES_Aware_v1r0_Email"
#' var_name
#'
#' @export
get_var_name <- function(dd, cid_str) {
  # Retrieve the variable name with a filter function
  var_name <- dd$Get('var_name', filterFun = function(x) x$concept_type == 'QUESTION' && grepl(x$cid, cid_str))

  # If var_name is NULL, issue a warning with the cid_str
  if (is.null(var_name)) {
    warning(paste("No variable name found for the concept ID:", cid_str, "in the data dictionary."))
  }

  # Return the variable name (could be NULL)
  return(var_name)
}


#' Get Path to an example dictionary
#'
#' @return string Path to a folder containing JSON files for a example dictionary
#'
#' @examples
#' path <- get_path_to_example_dictionary()
#' print(path)
#'
#' @export
get_path_to_example_dictionary <- function () {
  system.file("extdata/test_dictionary", package = "cidtree", mustWork = TRUE)
}
