#!/usr/bin/env Rscript

# Set working directory
setwd("/Users/luigisalemi/Documents/ShinyApp")

# Try to find and set pandoc path
possible_pandoc_paths <- c(
  "/usr/local/bin/pandoc",
  "/opt/homebrew/bin/pandoc",
  "/Applications/RStudio.app/Contents/MacOS/pandoc/pandoc",
  "~/Library/Application Support/Posit/bin/pandoc",
  "/Library/Frameworks/R.framework/Versions/Current/Resources/bin/pandoc"
)

pandoc_found <- FALSE
for (path in possible_pandoc_paths) {
  expanded_path <- path.expand(path)
  if (file.exists(expanded_path)) {
    Sys.setenv(RSTUDIO_PANDOC = dirname(expanded_path))
    cat("Found pandoc at:", expanded_path, "\n")
    pandoc_found <- TRUE
    break
  }
}

if (!pandoc_found) {
  cat("Trying to use system pandoc...\n")
}

# Try rendering
cat("Attempting to render Week5_Submission.qmd...\n\n")

if (requireNamespace("rmarkdown", quietly = TRUE)) {
  tryCatch({
    rmarkdown::render(
      "Week5_Submission.qmd",
      output_format = rmarkdown::pdf_document()
    )
    cat("\n✓ SUCCESS! PDF created: Week5_Submission.pdf\n")
  }, error = function(e) {
    cat("\n✗ Error:", conditionMessage(e), "\n")
    cat("\nTrying alternative method with knitr...\n")
    
    # Try with knitr
    if (requireNamespace("knitr", quietly = TRUE)) {
      knitr::knit("Week5_Submission.qmd", output = "Week5_Submission.md")
      cat("Created markdown file. You may need to convert to PDF manually.\n")
    }
  })
} else {
  cat("rmarkdown package not found. Installing...\n")
  install.packages("rmarkdown", repos = "https://cloud.r-project.org")
  rmarkdown::render("Week5_Submission.qmd")
}

