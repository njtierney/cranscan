#' Search CRAN and return a tibble
#'
#' This uses tools::CRAN_package_db() then returns a tibble with the columns:
#'     col_1....col_m. This function is currently internal as it is called in
#'     scan_cran.
#'
#' @return a tibble
#'
#' @examples
#'
#' \dontrun{
#' get_cran_tbl()
#' }
#'
get_cran_tbl <- function(){

  # big Thank You to Julia Silge for the code to do this in her blog post:
  # https://juliasilge.com/blog/mining-cran-description/

cran_db <- tools::CRAN_package_db()

# the returned data frame has two columns with the same name???
cran_db <- cran_db[,-65]

# possibly make all the columns into lowercase

# return it a tibble
dplyr::as_tibble(cran_db)

}

#' Find packages mentioning key words in description.
#'
#' @param key_words character vector containing text to put into grepl
#' @param when character vector either containing "last-day", "last-week", or
#'     "last-month".
#'
#' @return a tibble with R package names matching some strings, and download
#'     counts from the last month by default.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' scan_cran_tbl <- scan_cran("miss | imp*")
#'
#' }
#'
scan_cran <- function(key_words, when = "last-month"){

cran_tbl <- get_cran_tbl()
# key_words = "miss | imp"
# when = "last-month"

cran_scanned <- cran_tbl %>%
  dplyr::select(Package,
                Description) %>%
  dplyr::mutate(has_key_words = grepl(key_words, Description)) %>%
  dplyr::filter(has_key_words) %>%
  # make lower case
  dplyr::rename(package = Package,
                description = Description)

# use cranlogs to find how often packages are downloaded
# currently only takes the first 950
# possibly due to API constraints?
cran_scanned_dl <- cranlogs::cran_downloads(packages = cran_scanned$package[1:950],
                                            when = when)

cran_scanned_dl %>%
  dplyr::as_tibble() %>%
  dplyr::group_by(package) %>%
  dplyr::mutate(n_dl = sum(count)) %>%
  dplyr::select(package, n_dl) %>%
  dplyr::ungroup() %>%
  dplyr::distinct() %>%
  dplyr::arrange(-n_dl) %>%
  dplyr::left_join(cran_scanned,
                   by = "package") %>%
  dplyr::select(package, description, n_dl)

}
