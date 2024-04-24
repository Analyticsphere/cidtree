#!/bin/bash

# Generate man pages from roxygen comments
R -e 'devtools::document()'

# Define the path to the PDF file
PDF_PATH="cidtree_docs.pdf"

# Check if the PDF file exists and remove it if it does
if [ -f "$PDF_PATH" ]; then
    echo "Removing existing file: $PDF_PATH"
    rm "$PDF_PATH"
fi

# Run R CMD Rd2pdf to generate a new PDF
echo "Generating new PDF documentation..."
R CMD Rd2pdf --output="$PDF_PATH" ./

echo "Done."
