% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.R
\name{is_valid_cid}
\alias{is_valid_cid}
\title{Validate if the Input is a 9-digit Concept ID (cid)}
\usage{
is_valid_cid(input)
}
\arguments{
\item{input}{The input to check, expected to be a string or numeric type.}
}
\value{
A boolean indicating if the input is a valid 9-digit concept ID.
}
\description{
This function checks if a given input is a valid 9-digit concept ID.
Returns TRUE if valid, FALSE otherwise.
}
\examples{
is_valid_cid(123456789)   # Should return TRUE
is_valid_cid("987654321") # Should return TRUE
is_valid_cid(12345)       # Should return FALSE
is_valid_cid(9876543210)  # Should return FALSE
}
