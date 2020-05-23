
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
#> 
#> The downloaded binary packages are in
#>  /var/folders/24/8k48jl6d249_n_qfxwsl6xvm0000gn/T//RtmpaMNbY7/downloaded_packages
remotes::install_github("como-ph/covidphtext")
#> tibble     (NA -> 3.0.1) [CRAN]
#> xml2       (NA -> 1.3.2) [CRAN]
#> rvest      (NA -> 0.3.5) [CRAN]
#> lubridate  (NA -> 1.7.8) [CRAN]
#> httr       (NA -> 1.4.1) [CRAN]
#> curl       (NA -> 4.3  ) [CRAN]
#> assertthat (NA -> 0.2.1) [CRAN]
#> crayon     (NA -> 1.3.4) [CRAN]
#> fansi      (NA -> 0.4.1) [CRAN]
#> cli        (NA -> 2.0.2) [CRAN]
#> utf8       (NA -> 1.1.4) [CRAN]
#> vctrs      (NA -> 0.3.0) [CRAN]
#> ellipsis   (NA -> 0.3.1) [CRAN]
#> openssl    (NA -> 1.4.1) [CRAN]
#> R6         (NA -> 2.4.1) [CRAN]
#> askpass    (NA -> 1.1  ) [CRAN]
#> sys        (NA -> 3.3  ) [CRAN]
#> lifecycle  (NA -> 0.2.0) [CRAN]
#> pillar     (NA -> 1.4.4) [CRAN]
#> pkgconfig  (NA -> 2.0.3) [CRAN]
#> selectr    (NA -> 0.4-2) [CRAN]
#> generics   (NA -> 0.0.2) [CRAN]
#> 
#> The downloaded binary packages are in
#>  /var/folders/24/8k48jl6d249_n_qfxwsl6xvm0000gn/T//RtmpaMNbY7/downloaded_packages
#> * checking for file ‘/private/var/folders/24/8k48jl6d249_n_qfxwsl6xvm0000gn/T/RtmpaMNbY7/remotesa6f249ca722/como-ph-covidphtext-a5dd2ff/DESCRIPTION’ ... OK
#> * preparing ‘covidphtext’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * looking to see if a ‘data/datalist’ file should be added
#> * building ‘covidphtext_0.1.0.tar.gz’
```

then load the package:

## Usage

### Datasets

`covidphtext` currently has 28 datasets of COVID-19-related resolutions
and policies in the Philippines. These datasets are 28 resolutions made
by the Inter-Agency Task Force for the Management of Emerging Infectious
Diseases (IATF).

A description of the available datasets can be found
[here](https://como-ph.github.io/comotext/reference/index.html#section-datasets).

A table of the `29` IATF resolutions and the URLs to download them can
be generated using the function `get_iatf_links()` as follows:

``` r
get_iatf_links()
#> [90m# A tibble: 29 x 7[39m
#>       id title              date       source type  url               checked   
#>    [3m[90m<dbl>[39m[23m [3m[90m<chr>[39m[23m              [3m[90m<date>[39m[23m     [3m[90m<chr>[39m[23m  [3m[90m<chr>[39m[23m [3m[90m<chr>[39m[23m             [3m[90m<date>[39m[23m    
#> [90m 1[39m     9 Recommendations f… 2020-03-03 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m 2[39m    10 Recommendations f… 2020-03-09 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m 3[39m    11 Recommendations f… 2020-03-12 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m 4[39m    12 Recommendations f… 2020-03-13 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m 5[39m    13 Recommendations f… 2020-03-17 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m 6[39m    14 Resolutions Relat… 2020-03-20 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m 7[39m    15 Resolutions Relat… 2020-03-25 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m 8[39m    16 Additional Guidel… 2020-03-30 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m 9[39m    17 Recommendations R… 2020-03-30 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m10[39m    18 Recommendations R… 2020-04-01 IATF   reso… https://doh.gov.… 2020-05-23
#> [90m# … with 19 more rows[39m
```

The actual PDF of the IATF resolutions/s can be downloaded using the
`get_iatf_pdf()` function. For example, to download IATF Resolution
No. 29, the following command is issued:

``` r
get_iatf_pdf(id = 29)
#> [1] "/var/folders/24/8k48jl6d249_n_qfxwsl6xvm0000gn/T//RtmpaMNbY7/iatfResolution29.pdf"
```

The command downloads the PDF of the specified IATF Resolution into a
temporary directory (using `tempdir()` function) and assigns it with a
filename `iatfResolution` followed by the resolution number. For IATF
Resolution 29, the filename is `iatfResolution29.pdf`. The output of the
`get_iatf_pdf()` function is a character vector of directory path/s to
downloaded PDFs as shown above. These paths can then be used when
working with these files.

### Concatenating text datasets

The datasets described above can be processed and analysed on their own
or as a combined corpus of text data. `covidphtext` provides convenience
functions that concatenates all or specific text datasets available from
the `covidphtext` package.

#### Concatenating datasets based on a specific search term

The `combine_docs` function allows the user to specify search terms to
use in identifying datasets provided by the `comotext` package. The
`docs` argument allows the specification of a vector of search terms to
use to identify the names of datasets to concatenate. If the name/s of
the datasets contain these search terms, the datasets with these name/s
will be returned.

``` r
combine_docs(docs = "resolution")
#> [90m# A tibble: 3,186 x 6[39m
#>    linenumber text                               source type       id date      
#>         [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m                              [3m[90m<chr>[39m[23m  [3m[90m<chr>[39m[23m   [3m[90m<dbl>[39m[23m [3m[90m<date>[39m[23m    
#> [90m 1[39m          1 WHEREAS, on January 31, 2020, upo… IATF   resolu…     9 2020-03-03
#> [90m 2[39m          2 Inter-Agency Task Force (IATF) fo… IATF   resolu…     9 2020-03-03
#> [90m 3[39m          3 a travel ban covering China, Maca… IATF   resolu…     9 2020-03-03
#> [90m 4[39m          4 SAR. On February 11, 2020, travel… IATF   resolu…     9 2020-03-03
#> [90m 5[39m          5 that it was being used as a trans… IATF   resolu…     9 2020-03-03
#> [90m 6[39m          6 WHEREAS, on February 14, 2020, tr… IATF   resolu…     9 2020-03-03
#> [90m 7[39m          7 lifted. On February 18, 2020, the… IATF   resolu…     9 2020-03-03
#> [90m 8[39m          8 exemptions in favor of certain cl… IATF   resolu…     9 2020-03-03
#> [90m 9[39m          9 SAR, and Macau SAR;                IATF   resolu…     9 2020-03-03
#> [90m10[39m         10 WHEREAS, on February 26, 2020, fo… IATF   resolu…     9 2020-03-03
#> [90m# … with 3,176 more rows[39m
```

The `combine_iatf` function is a specialised wrapper of the
`combine_docs` function that specifically returns datasets containing
IATF resolutions. An additional argument `res` allows users to specify
which IATF resolutions to return. To get IATF resolution 10, 11, and 12,
the following call to `combine_iatf` is made as follows:

``` r
combine_iatf(docs = "resolution", res = 10:12)
#> [90m# A tibble: 324 x 6[39m
#>    linenumber text                               source type       id date      
#>         [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m                              [3m[90m<chr>[39m[23m  [3m[90m<chr>[39m[23m   [3m[90m<dbl>[39m[23m [3m[90m<date>[39m[23m    
#> [90m 1[39m          1 WHEREAS, Section 15 of Article II… IATF   resolu…    10 2020-03-09
#> [90m 2[39m          2 protect and promote the right to … IATF   resolu…    10 2020-03-09
#> [90m 3[39m          3 them:                              IATF   resolu…    10 2020-03-09
#> [90m 4[39m          4 WHEREAS, recognizing the need for… IATF   resolu…    10 2020-03-09
#> [90m 5[39m          5 preparedness and ensure efficient… IATF   resolu…    10 2020-03-09
#> [90m 6[39m          6 and prevent the spread of any pot… IATF   resolu…    10 2020-03-09
#> [90m 7[39m          7 (IATF) for the Management of Emer… IATF   resolu…    10 2020-03-09
#> [90m 8[39m          8 Executive Order No. 168, series o… IATF   resolu…    10 2020-03-09
#> [90m 9[39m          9 WHEREAS, on January 7, 2020, Chin… IATF   resolu…    10 2020-03-09
#> [90m10[39m         10 a viral pneumonia outbreak in the… IATF   resolu…    10 2020-03-09
#> [90m# … with 314 more rows[39m
```

To check if only resolutions 10 to 12 have been returned:

``` r
combine_iatf(docs = "resolution", res = 10:12)[ , c("type", "id")]
#> [90m# A tibble: 324 x 2[39m
#>    type          id
#>    [3m[90m<chr>[39m[23m      [3m[90m<dbl>[39m[23m
#> [90m 1[39m resolution    10
#> [90m 2[39m resolution    10
#> [90m 3[39m resolution    10
#> [90m 4[39m resolution    10
#> [90m 5[39m resolution    10
#> [90m 6[39m resolution    10
#> [90m 7[39m resolution    10
#> [90m 8[39m resolution    10
#> [90m 9[39m resolution    10
#> [90m10[39m resolution    10
#> [90m# … with 314 more rows[39m
```
