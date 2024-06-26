% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/construct.R
\name{construct_dictionary_tree}
\alias{construct_dictionary_tree}
\title{Construct a Dictionary Tree from JSON Files}
\usage{
construct_dictionary_tree()
}
\arguments{
\item{path}{The path to the directory containing JSON files.}
}
\value{
A \code{Node} object representing the root of the dictionary tree.
}
\description{
This function reads JSON files from a specified directory, creates nodes for each file,
and builds a hierarchical tree based on the relationships defined within the files.
}
\examples{
path <- get_path_to_example_dictionary()
print(path)
dd <- construct_dictionary_tree(path)
# Print output so that it does not wrap on the screen
output <- capture.output(print(dd, 'concept_str', 'concept_type','pathString'))
cat(output, sep="\n")
}
