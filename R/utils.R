#' Extract Nine-Digit Concept IDs from a String
#'
#' This function extracts all nine-digit sequences from a given input string
#' and returns them as a concatenated single string separated by slashes.
#'
#' @param input_string A character string from which to extract nine-digit numbers.
#' @return A character string containing all found nine-digit numbers concatenated
#' with a slash ("/") separator. Returns \code{NA} if no nine-digit numbers are found.
#' @examples
#' # Extract nine-digit numbers from a sample string
#' extract_cids("123456789 d_987654321 other text")
#' # Output: "123456789/987654321"
#'
#' extract_cids("no nine-digit numbers")
#' # Output: NA
#'
extract_cids <- function(input_string) {
  # Define the regular expression pattern to find contiguous 9-digit numbers
  pattern <- "\\d{9}"

  # Get the starting indices of all nine-digit numbers
  matches <- gregexpr(pattern, input_string)

  # Extract the matching substrings
  extracted <- regmatches(input_string, matches)[[1]]

  # Check if any nine-digit numbers were found
  if (length(extracted) == 0) {
    return(NA)  # Return NA if no nine-digit numbers are found
  }

  # Concatenate extracted numbers with a slash separator
  return(paste(extracted, collapse = "/"))
}
