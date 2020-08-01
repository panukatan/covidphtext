
x <- "http://www.doh.gov.ph/COVID-19/IATF-Resolutions/"
y <- "https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/"

z <- list(x, y)
names(z) <- c("Department of Health", "Official Gazette")

base_urls <- z

usethis::use_data(base_urls, overwrite = TRUE, internal = TRUE)
