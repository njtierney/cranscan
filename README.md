<!-- README.md is generated from README.Rmd. Please edit that file -->
cranscan
========

The goal of cranscan is to make it easy to search for relevant R packages to your interests, using an interface based on [papr](https://github.com/jtleek/papr).

The first step in this is retrieving the data from CRAN, and then appending a download count to it.

``` r
library(cranscan)

scan_cran_tbl <- scan_cran("miss | imp*")

scan_cran_tbl
#> # A tibble: 950 x 3
#>      package
#>        <chr>
#>  1  jsonlite
#>  2      curl
#>  3       DBI
#>  4  lazyeval
#>  5 backports
#>  6      lme4
#>  7     Hmisc
#>  8     git2r
#>  9     minqa
#> 10      glue
#> # ... with 940 more rows, and 2 more variables: description <chr>,
#> #   n_dl <dbl>
```

Future work
===========

-   adding download counts: Currently only 950 calls via `cranlogs::cran_downloads()` are made possible in a single call, need to work out how to get up to 10K.

-   data: Currently I am loading the data from `tools::CRAN_package_db()` as of 19/06/2017, as this data request is slow. Future work will do some sort of clever caching.

-   shiny app: there will of course be a shiny app that allows for swiping through relevant R packages and then having some clever way of handling what you liked and didn't like.

-   some sort of machine-learning-y way to show CRAN packages that you might be interested in, based on previous swipe patterns?

-   cranberry juice: another option to just view what has recently been pushed to cranberries.
