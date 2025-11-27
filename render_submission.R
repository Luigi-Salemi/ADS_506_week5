#!/usr/bin/env Rscript

# Script to render Week5_Submission.qmd to PDF
# Run this in RStudio or from R console

cat("Attempting to render Week5_Submission.qmd to PDF...\n\n")

# Try quarto package first
if (requireNamespace("quarto", quietly = TRUE)) {
  cat("Using quarto package...\n")
  quarto::quarto_render("Week5_Submission.qmd")
  cat("\n✓ PDF created successfully using quarto!\n")
  cat("Output: Week5_Submission.pdf\n")
} else if (requireNamespace("rmarkdown", quietly = TRUE)) {
  # Fallback to rmarkdown
  cat("Using rmarkdown package...\n")
  rmarkdown::render("Week5_Submission.qmd", output_format = "pdf_document")
  cat("\n✓ PDF created successfully using rmarkdown!\n")
  cat("Output: Week5_Submission.pdf\n")
} else {
  cat("\n✗ ERROR: Neither 'quarto' nor 'rmarkdown' package is installed.\n")
  cat("\nPlease install one of them:\n")
  cat("  install.packages('quarto')\n")
  cat("  OR\n")
  cat("  install.packages('rmarkdown')\n")
  cat("\nThen run this script again.\n")
  quit(status = 1)
}

cat("\nNext step: Rename the file to Week5_Salemi_Luigi.pdf\n")

