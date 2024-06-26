% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.R
\name{get_responses}
\alias{get_responses}
\title{Retrieve Responses for a Concept}
\usage{
get_responses(dd, concept)
}
\arguments{
\item{dd}{A \code{data.tree} object representing the data dictionary.}

\item{concept}{The concept ID or key whose responses are to be retrieved.}
}
\value{
Responses associated with the concept if it is a question; otherwise, NULL.
}
\description{
This function retrieves responses associated with a given concept.
}
\examples{
path <- get_path_to_example_dictionary() # Replace with path to your dictionary
dd <- construct_dictionary_tree(path)
responses <- get_responses(dd, '763164658')
responses
responses <- get_responses(dd, 'How many cigarettes have you smoked in your entire life?')
responses
}
