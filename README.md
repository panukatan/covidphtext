
<!-- README.md is generated from README.Rmd. Please edit that file -->

# covidphtext: Utilities to Extract Text Data From COVID-19-Related Resolutions and Policies From the Philippines

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/como-ph/covidphtext/workflows/R-CMD-check/badge.svg)](https://github.com/como-ph/covidphtext/actions)
<!-- badges: end -->

To assess possible impact of various COVID-19 prediction models on
Philippine government response, text from various resolutions, press
releases and legislation has been collected using data mining approaches
implemented in R. This package includes functions used for this data
mining process and datasets of text that have been collected and
processed for use in text analysis.

## Installation

`covidphtext` is not yet available on CRAN. It is currently in
experimental development stage. Installation of `covidphtext` at this
point is only possible through its development version via
[GitHub](https://github.com/como-ph/covidphtext):

``` r
if(!require(remotes)) install.packages("remotes")
remotes::install_github("como-ph/covidphtext")
```

then load the
package:

## Usage

### Datasets

#### Inter-Agency Task Force for the Management of Emerging Infectious Diseases

`covidphtext` currently has `41` datasets of which `39` are
COVID-19-related resolutions and policies in the Philippines made by the
Inter-Agency Task Force for the Management of Emerging Infectious
Diseases (IATF), 1 is the Omnibus Guidelines on the Implementation of
Community Quarantine in the Philippines released by the IATF and 2 are
reference lists of links to these resolutions and guidelines.

A description of the available datasets can be found
[here](https://como-ph.github.io/covidphtext/reference/index.html#section-datasets).

The IATF resolutions are officially available from two online sources:
1) The Department of Health (DOH)
[website](https://www.doh.gov.ph/COVID-19/IATF-Resolutions); and, 2) The
Philippines Official Gazette
[website](https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/).
The DOH website currenlty only holds IATF resolutions starting from
resolution number 9 and later. The Official Gazette on the other hand
contains resolutions 1 to the most current.

To get a list of the IATF resolutions that are available from the DOH
website, the function `get_iatf_links()` can be used as follows:

``` r
get_iatf_links()
#> # A tibble: 32 x 7
#>       id title              date       source type  url               checked   
#>    <dbl> <chr>              <date>     <chr>  <chr> <chr>             <date>    
#>  1     9 Recommendations f… 2020-03-03 IATF   reso… https://doh.gov.… 2020-05-26
#>  2    10 Recommendations f… 2020-03-09 IATF   reso… https://doh.gov.… 2020-05-26
#>  3    11 Recommendations f… 2020-03-12 IATF   reso… https://doh.gov.… 2020-05-26
#>  4    12 Recommendations f… 2020-03-13 IATF   reso… https://doh.gov.… 2020-05-26
#>  5    13 Recommendations f… 2020-03-17 IATF   reso… https://doh.gov.… 2020-05-26
#>  6    14 Resolutions Relat… 2020-03-20 IATF   reso… https://doh.gov.… 2020-05-26
#>  7    15 Resolutions Relat… 2020-03-25 IATF   reso… https://doh.gov.… 2020-05-26
#>  8    16 Additional Guidel… 2020-03-30 IATF   reso… https://doh.gov.… 2020-05-26
#>  9    17 Recommendations R… 2020-03-30 IATF   reso… https://doh.gov.… 2020-05-26
#> 10    18 Recommendations R… 2020-04-01 IATF   reso… https://doh.gov.… 2020-05-26
#> # … with 22 more rows
```

Given that the DOH website doesn’t have the first 8 resolutions, this
function will soon be deprecated in favour of the newer function below
that interfaces with the Official Gazette.

A table of all the IATF resolutions and the URLs to download them can be
generated using the newer function `get_iatf_gazette()` as
follows:

``` r
get_iatf_gazette(base = "https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/")
#> # A tibble: 44 x 7
#>    id    title                 date source type   url                 checked   
#>    <chr> <chr>                <dbl> <chr>  <chr>  <chr>               <date>    
#>  1 <NA>  OMNIBUS GUIDELINES … 18404 IATF   resol… https://www.offici… 2020-05-26
#>  2 39    RESOLUTION NO. 39, … 18404 IATF   resol… https://www.offici… 2020-05-26
#>  3 38    RESOLUTION NO. 38, … 18404 IATF   resol… https://www.offici… 2020-05-26
#>  4 <NA>  OMNIBUS GUIDELINES … 18397 IATF   resol… https://www.offici… 2020-05-26
#>  5 37    RESOLUTION NO. 37, … 18397 IATF   resol… https://www.offici… 2020-05-26
#>  6 36    RESOLUTION NO. 36, … 18395 IATF   resol… https://www.offici… 2020-05-26
#>  7 35    RESOLUTION NO. 35-A… 18395 IATF   resol… https://www.offici… 2020-05-26
#>  8 35    RESOLUTION NO. 35, … 18393 IATF   resol… https://www.offici… 2020-05-26
#>  9 34    RESOLUTION NO. 34, … 18390 IATF   resol… https://www.offici… 2020-05-26
#> 10 33    RESOLUTION NO. 33, … 18388 IATF   resol… https://www.offici… 2020-05-26
#> # … with 34 more rows
```

The actual PDF of the IATF resolutions/s can be downloaded using the
`get_iatf_pdf()` function. For example, to download IATF Resolution
No. 29, the following command is issued:

``` r
get_iatf_pdf(id = 29)
#> [1] "/var/folders/fk/s0yv8hhn2cs_nfsmzhm4dmhc0000gn/T//Rtmp4SOdgd/iatfResolution29.pdf"
```

The command downloads the PDF of the specified IATF Resolution into a
temporary directory (using `tempdir()` function) and assigns it with a
filename `iatfResolution` followed by the resolution number. For IATF
Resolution 29, the filename is `iatfResolution29.pdf`. The output of the
`get_iatf_pdf()` function is a character vector of directory path/s to
downloaded PDFs as shown above. These paths can then be used when
working with these files.

It should be noted that the `get_iatf_pdf()` function interfaces with
the DOH website. An update is to follow which will allow this function
to interface with the Official Gazette as well or instead of. This will
be provided in the next release.

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
#> # A tibble: 4,440 x 6
#>    linenumber text                               source type       id date      
#>         <int> <chr>                              <chr>  <chr>   <dbl> <date>    
#>  1          1 WHEREAS, Executive Order No. 168,… IATF   resolu…     1 2020-01-28
#>  2          2 for the Management of Emerging In… IATF   resolu…     1 2020-01-28
#>  3          3 WHEREAS, the Inter-agency Task Fo… IATF   resolu…     1 2020-01-28
#>  4          4 identify, screen, and assist Fili… IATF   resolu…     1 2020-01-28
#>  5          5 prevent and/or minimize the entry… IATF   resolu…     1 2020-01-28
#>  6          6 as prevent and/or minimize local … IATF   resolu…     1 2020-01-28
#>  7          7 WHEREAS, on January 7, 2020, Chin… IATF   resolu…     1 2020-01-28
#>  8          8 the viral pneumonia outbreak in W… IATF   resolu…     1 2020-01-28
#>  9          9 (2019-nCoV) that has not been pre… IATF   resolu…     1 2020-01-28
#> 10         10 WHEREAS, as of January 27, 2020, … IATF   resolu…     1 2020-01-28
#> # … with 4,430 more rows
```

The `combine_iatf` function is a specialised wrapper of the
`combine_docs` function that specifically returns datasets containing
IATF resolutions. An additional argument `res` allows users to specify
which IATF resolutions to return. To get IATF resolution 10, 11, and 12,
the following call to `combine_iatf` is made as follows:

``` r
combine_iatf(docs = "resolution", res = 10:12)
#> # A tibble: 324 x 6
#>    linenumber text                               source type       id date      
#>         <int> <chr>                              <chr>  <chr>   <dbl> <date>    
#>  1          1 WHEREAS, Section 15 of Article II… IATF   resolu…    10 2020-03-09
#>  2          2 protect and promote the right to … IATF   resolu…    10 2020-03-09
#>  3          3 them:                              IATF   resolu…    10 2020-03-09
#>  4          4 WHEREAS, recognizing the need for… IATF   resolu…    10 2020-03-09
#>  5          5 preparedness and ensure efficient… IATF   resolu…    10 2020-03-09
#>  6          6 and prevent the spread of any pot… IATF   resolu…    10 2020-03-09
#>  7          7 (IATF) for the Management of Emer… IATF   resolu…    10 2020-03-09
#>  8          8 Executive Order No. 168, series o… IATF   resolu…    10 2020-03-09
#>  9          9 WHEREAS, on January 7, 2020, Chin… IATF   resolu…    10 2020-03-09
#> 10         10 a viral pneumonia outbreak in the… IATF   resolu…    10 2020-03-09
#> # … with 314 more rows
```

To check if only resolutions 10 to 12 have been returned:

``` r
combine_iatf(docs = "resolution", res = 10:12)[ , c("type", "id")]
#> # A tibble: 324 x 2
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
#> # … with 314 more rows
```
