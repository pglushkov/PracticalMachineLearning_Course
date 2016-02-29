make_report <- function() {

  library(knitr);
  knit2html('report.Rmd');

  browseURL('report.html')

}
