# covidphtext v0.2.1

* Re-assigned linenumbers to concatenated datasets when using `combine_` functions

* Added codefactor checking [![CodeFactor](https://www.codefactor.io/repository/github/como-ph/covidphtext/badge)](https://www.codefactor.io/repository/github/como-ph/covidphtext)

# covidphtext v0.2.0

* Updated `get_iatf_pdf` syntax such that is now takes on as first argument a links table produced when making a call to either `get_iatf_links` or `get_iatf_gazette` allowing for piped operations between these set of functions

* Updated IATF resolutions datasets structre to include sections of resolutions

* Added missing resolutions no. 30 and 30A

# covidphtext v0.1.0

* Created functions to extract download information for the various IATF resolutions issued either through [DoH](https://www.doh.gov.ph) or the [Official Gazette](https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/)

* Added text datasets for each available IATF resolution (as of 16 June 2020, there were 46 resolutions)

* Added CI/CD configuration using Github Actions [![R build status](https://github.com/como-ph/covidphtext/workflows/R-CMD-check/badge.svg)](https://github.com/como-ph/covidphtext/actions)

* Added coverage tests ![test-coverage](https://github.com/como-ph/covidphtext/workflows/test-coverage/badge.svg) [![codecov](https://codecov.io/gh/como-ph/covidphtext/branch/master/graph/badge.svg)](https://codecov.io/gh/como-ph/covidphtext)

* Added a package website using `pkgdown`
