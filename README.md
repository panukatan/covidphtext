
<!-- README.md is generated from README.Rmd. Please edit that file -->

# covidphtext: Utilities to Extract Text Data From COVID-19-Related Resolutions and Policies From the Philippines <img src="man/figures/covidphtext.png" width="200px" align="right" />

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/covidphtext)](https://CRAN.R-project.org/package=covidphtext)
[![CRAN](https://img.shields.io/cran/l/covidphtext.svg)](https://CRAN.R-project.org/package=covidphtext)
[![CRAN](http://cranlogs.r-pkg.org/badges/covidphtext)](https://CRAN.R-project.org/package=covidphtext)
[![CRAN](http://cranlogs.r-pkg.org/badges/grand-total/covidphtext)](https://CRAN.R-project.org/package=covidphtext)
[![R build
status](https://github.com/como-ph/covidphtext/workflows/R-CMD-check/badge.svg)](https://github.com/como-ph/covidphtext/actions)
[![test-coverage](https://github.com/como-ph/covidphtext/workflows/test-coverage/badge.svg)](https://github.com/como-ph/covidphtext/actions?query=workflow%3Atest-coverage)
[![codecov](https://codecov.io/gh/como-ph/covidphtext/branch/master/graph/badge.svg)](https://codecov.io/gh/como-ph/covidphtext)
[![CodeFactor](https://www.codefactor.io/repository/github/como-ph/covidphtext/badge)](https://www.codefactor.io/repository/github/como-ph/covidphtext)
[![DOI](https://zenodo.org/badge/265376181.svg)](https://zenodo.org/badge/latestdoi/265376181)
<!-- badges: end -->

To assess possible impact of various COVID-19 prediction models on
Philippine government response, text from various resolutions issued by
the Inter-agency Task Force for the Management of Emerging Infectious
Diseases (IATF) has been collected using data mining approaches
implemented in R. This package includes functions used for this data
mining process and datasets of text that have been collected and
processed for use in text analysis.

## Installation

`covidphtext` is not yet available on CRAN. It is currently in active
development stage. Installation of `covidphtext` at this point is only
possible through its development version via
[GitHub](https://github.com/como-ph/covidphtext):

``` r
if(!require(remotes)) install.packages("remotes")
remotes::install_github("como-ph/covidphtext")
```

then load the package:

``` r
library(covidphtext)
```

## Usage

### Datasets

`covidphtext` currently has `58` datasets of which `55` are
COVID-19-related resolutions and policies in the Philippines made by the
Inter-Agency Task Force for the Management of Emerging Infectious
Diseases (IATF), 1 is the Omnibus Guidelines on the Implementation of
Community Quarantine in the Philippines released by the IATF and 2 are
reference lists of links to these resolutions and guidelines.

A description of the available datasets can be found
[here](https://como-ph.github.io/covidphtext/reference/index.html#section-datasets).

The IATF resolutions are officially available from two online sources:
1) The Department of Health (DoH)
[website](http://www.doh.gov.ph/COVID-19/IATF-Resolutions/); and, 2) The
Philippines Official Gazette
[website](https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/).
The DOH website currently only holds IATF resolutions starting from
resolution number 9 and later. The Official Gazette on the other hand
contains resolutions 1 to the most current.

To get a list of the IATF resolutions that are available from the DOH
website, the function `get_iatf_links()` can be used as follows:

``` r
get_iatf_links()
#> # A tibble: 61 x 7
#>       id title              date       source type  url               checked   
#>    <dbl> <chr>              <date>     <chr>  <chr> <chr>             <date>    
#>  1     9 Recommendations f… 2020-03-03 IATF   reso… https://doh.gov.… 2020-07-16
#>  2    10 Recommendations f… 2020-03-09 IATF   reso… https://doh.gov.… 2020-07-16
#>  3    11 Recommendations f… 2020-03-12 IATF   reso… https://doh.gov.… 2020-07-16
#>  4    12 Recommendations f… 2020-03-13 IATF   reso… https://doh.gov.… 2020-07-16
#>  5    13 Recommendations f… 2020-03-17 IATF   reso… https://doh.gov.… 2020-07-16
#>  6    14 Resolutions Relat… 2020-03-20 IATF   reso… https://doh.gov.… 2020-07-16
#>  7    15 Resolutions Relat… 2020-03-25 IATF   reso… https://doh.gov.… 2020-07-16
#>  8    16 Additional Guidel… 2020-03-30 IATF   reso… https://doh.gov.… 2020-07-16
#>  9    17 Recommendations R… 2020-03-30 IATF   reso… https://doh.gov.… 2020-07-16
#> 10    18 Recommendations R… 2020-04-01 IATF   reso… https://doh.gov.… 2020-07-16
#> # … with 51 more rows
```

Given that the DOH website doesn’t have the first 8 resolutions, this
function will soon be deprecated in favour of the newer function below
that interfaces with the Official Gazette.

A table of all the IATF resolutions and the URLs to download them can be
generated using the newer function `get_iatf_gazette()` as follows:

``` r
list_iatf_pages(base = "https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/", 
                pages = 1:6) %>%
  get_iatf_pages() %>%
  get_iatf_gazette()
```

    #> # A tibble: 62 x 7
    #>       id title              date       source type  url               checked   
    #>    <dbl> <chr>              <date>     <chr>  <chr> <chr>             <date>    
    #>  1    52 RESOLUTION NO. 52… 2020-07-06 IATF   reso… https://www.offi… 2020-07-07
    #>  2    51 RESOLUTION NO. 51… 2020-07-02 IATF   reso… https://www.offi… 2020-07-07
    #>  3    NA OMNIBUS GUIDELINE… 2020-07-02 IATF   reso… https://www.offi… 2020-07-07
    #>  4    50 RESOLUTION NO. 50… 2020-06-29 IATF   reso… https://www.offi… 2020-07-07
    #>  5    50 RESOLUTION NO. 50… 2020-06-29 IATF   reso… https://www.offi… 2020-07-07
    #>  6    NA OMNIBUS GUIDELINE… 2020-06-25 IATF   reso… https://www.offi… 2020-07-07
    #>  7    49 RESOLUTION NO. 49… 2020-06-25 IATF   reso… https://www.offi… 2020-07-07
    #>  8    48 RESOLUTION NO. 48… 2020-06-22 IATF   reso… https://www.offi… 2020-07-07
    #>  9    47 RESOLUTION NO. 47… 2020-06-19 IATF   reso… https://www.offi… 2020-07-07
    #> 10    46 RESOLUTION NO. 46… 2020-06-15 IATF   reso… https://www.offi… 2020-07-07
    #> # … with 52 more rows

The actual PDF of the IATF resolutions/s can be downloaded using the
`get_iatf_pdf()` function. For example, to download IATF Resolution
No. 29, the following command is issued:

``` r
get_iatf_pdf(links = iatfLinks, id = 29)
#>                                                               iatfResolution29 
#> "/var/folders/rx/nr32tl5n6f3d_86tn0tc7kc00000gp/T//Rtmpcp8QbW/file4c947abe8dd"
```

The command downloads the PDF of the specified IATF Resolution into a
temporary directory (using `tempdir()` function). The output of the
`get_iatf_pdf()` function is a named character vector of directory
path/s to downloaded PDFs as shown above. The names of the character
vector correspond to the resolution number. These paths can then be used
when working with these files.

The `get_iatf_pdf()` function interfaces with both the DOH and The
Official Gazette website.

### Concatenating text datasets

The datasets described above can be processed and analysed on their own
or as a combined corpus of text data. `covidphtext` provides convenience
functions that concatenates all or specific text datasets available from
the `covidphtext` package.

#### Concatenating datasets based on a specific search term

The `combine_docs` function allows the user to specify search terms to
use in identifying datasets provided by the `covidphtext` package. The
`docs` argument allows the specification of a vector of search terms to
use to identify the names of datasets to concatenate. If the name/s of
the datasets contain these search terms, the datasets with these name/s
will be returned.

``` r
combine_docs(docs = "resolution")
#> # A tibble: 6,626 x 7
#>    linenumber text                       source type       id section date      
#>         <int> <chr>                      <chr>  <chr>   <dbl> <chr>   <date>    
#>  1          1 Republic of the Philippin… IATF   resolu…     1 heading 2020-01-28
#>  2          2 Department of Health       IATF   resolu…     1 heading 2020-01-28
#>  3          3 Office of the Secretary    IATF   resolu…     1 heading 2020-01-28
#>  4          4 Inter-Agency Task Force f… IATF   resolu…     1 heading 2020-01-28
#>  5          5 Emerging Infectious Disea… IATF   resolu…     1 heading 2020-01-28
#>  6          6 28 January 2020            IATF   resolu…     1 heading 2020-01-28
#>  7          7 Resolution No. 01          IATF   resolu…     1 heading 2020-01-28
#>  8          8 Series of 2020             IATF   resolu…     1 heading 2020-01-28
#>  9          9 Recommendations for the M… IATF   resolu…     1 heading 2020-01-28
#> 10         10 Novel Coronavirus Situati… IATF   resolu…     1 heading 2020-01-28
#> # … with 6,616 more rows
```

The `combine_iatf` function is a specialised wrapper of the
`combine_docs` function that specifically returns datasets containing
IATF resolutions. An additional argument `res` allows users to specify
which IATF resolutions to return. To get IATF resolution 10, 11, and 12,
the following call to `combine_iatf` is made as follows:

``` r
combine_iatf(docs = "resolution", res = 10:12)
#> # A tibble: 351 x 7
#>    linenumber text                        source type      id section date      
#>         <int> <chr>                       <chr>  <chr>  <dbl> <chr>   <date>    
#>  1          1 Republic of the Philippines IATF   resol…    10 heading 2020-03-09
#>  2          2 DOH DFA DILG DOJ DOLE DOT … IATF   resol…    10 heading 2020-03-09
#>  3          3 Inter-Agency Task Force fo… IATF   resol…    10 heading 2020-03-09
#>  4          4 Emerging Infectious Diseas… IATF   resol…    10 heading 2020-03-09
#>  5          5 Resolution No. 10           IATF   resol…    10 heading 2020-03-09
#>  6          6 Series of 2020              IATF   resol…    10 heading 2020-03-09
#>  7          7 9 March 2020                IATF   resol…    10 heading 2020-03-09
#>  8          8 Recommendations for the ma… IATF   resol…    10 heading 2020-03-09
#>  9          9 disease 2019 (COVID-19) si… IATF   resol…    10 heading 2020-03-09
#> 10         10 WHEREAS, Section 15 of Art… IATF   resol…    10 preamb… 2020-03-09
#> # … with 341 more rows
```

To check if only resolutions 10 to 12 have been returned:

``` r
combine_iatf(docs = "resolution", res = 10:12)[ , c("type", "id")]
#> # A tibble: 351 x 2
#>    type          id
#>    <chr>      <dbl>
#>  1 resolution    10
#>  2 resolution    10
#>  3 resolution    10
#>  4 resolution    10
#>  5 resolution    10
#>  6 resolution    10
#>  7 resolution    10
#>  8 resolution    10
#>  9 resolution    10
#> 10 resolution    10
#> # … with 341 more rows
```
