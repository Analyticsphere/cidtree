#' Construct a Dictionary Tree from JSON Files
#'
#' This function reads JSON files from a specified directory, creates nodes for each file,
#' and builds a hierarchical tree based on the relationships defined within the files.
#'
#' @param path The path to the directory containing JSON files.
#' @return A `Node` object representing the root of the dictionary tree.
#' @importFrom data.tree Node
#' @importFrom dplyr Filter
#' @importFrom jsonlite fromJSON
#' @importFrom base tryCatch
#' @examples
#' dd <- construct_dictionary_tree("./data/test_dictionary")
#' # Print output so that it does not wrap on the screen
#' output <- capture.output(print(dd, 'concept_str', 'concept_type','pathString'))
#' cat(output, sep="\n")
#' @export
construct_dictionary_tree <- function(path="./data/test_dictionary") {

  library(dplyr)
  library(data.tree)
  library(jsonlite)

  # Get a list of file paths
  json_files <- list.files(path = path, full.names = TRUE, pattern = "*.json")

  # Define a function to process each file
  create_node_from_json <- function(file_path) {
    tryCatch(
      {
        # Read and parse JSON data
        data <- jsonlite::fromJSON(file_path)

        # Initialize Node
        n <- Node$new(data$conceptID, nameName = "conceptID")

        # Explicitly add required field, values to node
        #     NOTE: NULL fields will not be populated for each concept_type, they
        #     will be given as NULL when empty and will be removed later
        n$key           <- data$key
        n$var_name      <- data$name # name is already a keyword in data.tree
        n$cid           <- data$conceptID
        n$responses     <- data$responses
        n$label         <- data$label
        n$source        <- data$source
        n$concept_type  <- data$object_type # rename object_type to concept_type

        # Assign concept_str based on concept_type
        n$concept_str <- switch(
          n$concept_type,
          "PRIMARY"   = format_and_truncate(" PRI_SRC: ",  n$key),
          "SECONDARY" = format_and_truncate("  SEC_SRC: ", n$key),
          "SOURCE"    = format_and_truncate("   SRC: ",    n$key),
          "QUESTION"  = format_and_truncate("     QUEST: ", n$var_name),
          "RESPONSE"  = format_and_truncate(" RESP: ",     n$key)
        )

        str <- paste(as.character(n$responses), collapse = ", ")
        n$responses_str <- sprintf("%-120s", str)

        # # Set parent_tmp to 0 for PRIMARY and RESPONSE objects, else retain the original parent
        # n$parent_tmp <- ifelse(data$object_type %in% c("PRIMARY", "RESPONSE"),
        #                        as.integer(0),
        #                        data$parent)

        # Set parent_tmp to 0 for PRIMARY and RESPONSE objects.
        # Insert additional generation for cases that have a SOURCE
        if (!is.null(data$source)) {
          n$parent_tmp  <- data$source
          n$grandparent <- data$parent
        } else if (data$object_type %in% c("PRIMARY", "RESPONSE")){
          n$parent_tmp  <- as.integer(0)
          n$grandparent <- NULL
        } else {
          n$parent_tmp  <- data$parent
          n$grandparent <- NULL
        }

        # TODO: add loop to handle arbitrary additional fields that the dictionary
        # may contain that are not in the list of required fields given above

        return(n) # Return the node object
      },
      error = function(e) {
        cat("Error parsing JSON file:", file_path, "\n")
        message(e)
        return(NULL) # Return NULL if parsing fails
      }
    )
  }

  # Process each file using lapply
  nodes <- lapply(json_files, create_node_from_json)
  nodes <- Filter(Negate(is.null), nodes) # Remove nodes where parsing failed

  # Add a root node
  root              <- Node$new("0")
  root$key          <- "dictionary"
  root$var_name     <- "dictionary"
  root$cid          <- 0
  root$concept_type <- "ROOT"
  root$concept_str  <- sprintf("%-50s", "DICT: connect4cancer")
  nodes             <- c(root, nodes)

  # Order nodes in hierarchical order so that the tree can be built in order
  desired_order <- c("ROOT", "PRIMARY", "SECONDARY", "SOURCE", "QUESTION", "RESPONSE")
  order_func <- function(node) {
    match(node$concept_type, desired_order)
  }
  nodes <- nodes[order(sapply(nodes, order_func))]
  # # Print for debugging
  # for (n in nodes) {
  #   cat(sprintf("%-10s %-10s %-10s\n", n$name, n$concept_type, n$key))
  # }

  ## Pedigree --------------------------------------------------------------------

  # TODO: Add Source Question between Secondary Source and Question
  # Extract Parent-Child relationships from nodes
  relationships <- lapply(nodes, function(node) {
    if (!is.null(node$parent_tmp)) {
      list(grandparent = node$grandparent,
           parent = node$parent_tmp,
           child = node$cid)
    }
  })

  # Create data frame from relationships
  df_relationships <- as.data.frame(
    do.call(rbind, relationships)
  )
  # print(df_relationships)

  # Assemble tree
  build_tree <- function(nodes) {
    for (i in 1:nrow(df_relationships)) {
      child_cid        <- df_relationships[[i, "child"]]
      parent_cid       <- df_relationships[[i, "parent"]]

      child_node  <- nodes[[which(Get(nodes, "name") == child_cid)]]
      parent_node <- nodes[[which(Get(nodes, "name") == parent_cid)]]

      parent_node$AddChildNode(child_node)
      child_node$RemoveAttribute("parent_tmp")

      grandparent_cid <- df_relationships[[i, "grandparent"]]
      if (!is.null(grandparent_cid)) {
        grandparent_node <- nodes[[which(Get(nodes, "name") == grandparent_cid)]]
        grandparent_node$AddChildNode(parent_node)
      }

    }
    nodes[[1]] # Return the root node
  }

  dd <- build_tree(nodes)

  # Add a data frame version of the data dictionary as an attribute to the root node
  # TODO: Write a version of this that will work with arbitrary field names
  dd$df <- data.tree::ToDataFrameTree(dd, 'cid', 'path', 'key', 'label',
                                      'var_name', 'responses', 'source',
                                      'concept_type')

  return(dd)


}


# Helper functions -------------------------------------------------------------
# TODO implement this using a `SetFormat` in the data.tree package.
# https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html#printing

# Function to truncate and add ellipses
truncate_string <- function(text, max_length) {
  # If the text is longer than max_length, truncate and add "..."
  if (nchar(text) > max_length) {
    return(paste0(substr(text, 1, max_length - 3), "..."))
  } else {
    return(text)  # If not, return the original text
  }
}

# Define a function for formatted and truncated text
format_and_truncate <- function(prefix, value, max_length = 50) {
  # Use sprintf to format and truncate
  formatted_text <- sprintf("%-50s", paste0(prefix, value))
  truncate_string(formatted_text, max_length)
}
