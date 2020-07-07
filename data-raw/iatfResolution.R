## Libraries
library(rvest)
library(pdftools)
library(stringr)

## Resolutions table ###########################################################

iatfLinks <- get_iatf_links()

usethis::use_data(iatfLinks, overwrite = TRUE, compress = "xz")


## Resolutions table ###########################################################

iatfLinksGazette <- get_iatf_gazette(base = "https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/",
                                     pages = 1:7)

usethis::use_data(iatfLinksGazette, overwrite = TRUE, compress = "xz")


## Resolution 1 ################################################################

## Read resolution and restructure line by line
y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 1) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[27:length(y)]
y <- y[c(1:25, 29:35, 39:46, 61:69)]
y <- y[y != ""]

y <- stringr::str_remove_all(string = y, pattern = "[,|:!]$") %>%
  stringr::str_remove_all(pattern = "[ |._]$") %>%
  stringr::str_remove_all(pattern = "[ |._]$") %>%
  stringr::str_remove_all(pattern = "[ |._]$") %>%
  stringr::str_remove_all(pattern = "[ |._]$") %>%
  stringr::str_remove(pattern = "eee __-") %>%
  #stringr::str_remove(pattern = "^[©>-}]") %>%
  stringr::str_trim(side = "both") %>%
  stringr::str_remove(pattern = "— ") %>%
  stringr::str_replace(pattern = "WHERKAS", "WHEREAS") %>%
  stringr::str_replace(pattern = "atthe", "at the") %>%
  stringr::str_remove(pattern = "©") %>%
  stringr::str_remove(pattern = "\\}") %>%
  stringr::str_remove(pattern = "\\>") %>%
  stringr::str_remove(pattern = "= SS ") %>%
  stringr::str_remove(pattern = "= ea") %>%
  stringr::str_remove(pattern = "~ = lg") %>%
  stringr::str_remove(pattern = "os 22 , ") %>%
  stringr::str_remove(pattern = "= 50 Ee ") %>%
  stringr::str_trim(side = "both")

y[28] <- "FRANCISCO T. DUQUE III"
y[29] <- "Secretary, Department of Health"
y[30] <- "BRIGIDO J. DULAY"
y[31] <- "Undersecretary, Department of Foreign Affairs"
y[32] <- "FRANCISCO R. CRUZ"
y[33] <- "Assistant Secretary, Department of Interior and Local Government"
y[34] <- "ADONIS P. SULIT"
y[35] <- "Assistant Secretary, Department of Justice"
y[36] <- "MARCO ANTONIO S. VALEROS"
y[37] <- "Medical Officer IV, Department of Labor and Employment"
y[38] <- "BENJAMIN TERENCIO"
y[39] <- "Assistant Office-in-Charge, Civial Aviation Authority of the Philippines"
y[40] <- "CARMELO L. ARCILLA"
y[41] <- "Executive Director, Civil Aeronautics Board"
y[42] <- "ERIC STEVEN Y. GUIEB"
y[43] <- "Command-Surgeon, Philippine Coast Guard"

## Add heading
y <- c(c("Republic of the Philippines",
         "Department of Health",
         "Office of the Secretary",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "28 January 2020",
         "Resolution No. 01",
         "Series of 2020",
         "Recommendations for the Management of",
         "Novel Coronavirus Situation"), y)

## Identify sections for preamble and operative
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:10]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 1,
                section = section,
                date = as.Date("28/01/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution01 <- tibble::tibble(y)

usethis::use_data(iatfResolution01, overwrite = TRUE, compress = "xz")


## Resolution 2 ################################################################

## Read resolution
y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 2) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(14:40, 44:85, 90:100, 102:112)]
y <- y[y != ""]

y[71] <- "Arthur P. TUGADE"
y[72] <- "Secretary, Department of Transportation"
y[74] <- "BERNADETTE FATIMA P. ROMULA-PUYAT"
y[75] <- "Secretary, Department of Tourism"

y <- y[c(1:72, 74:77)]

## Add heading
y <- c(c("Republic of the Philippines",
         "Department of Health",
         "Office of the Secretary",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "31 January 2020",
         "Resolution No. 02",
         "Series of 2020",
         "Recommendations for the Management of 2019",
         "Novel Coronavirus (nCoV) Acute Respiratory",
         "Disease (ARD) Situation"), y)

## Add sections
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:11]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 2,
                section = section,
                date = as.Date("31/01/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution02 <- tibble::tibble(y)

usethis::use_data(iatfResolution02, overwrite = TRUE, compress = "xz")


## Resolution 3 ################################################################

## Read resolution
y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 3) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(16:43, 48:52)]
y <- y[y != ""]

y <- c(y, tail(iatfResolution02, 16)$text)

## Add heading
y <- c(c("Republic of the Philippines",
         "Department of Health",
         "Office of the Secretary",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "3 February 2020",
         "Resolution No. 03",
         "Series of 2020",
         "Designation of the quarantine facility for the",
         "Management of 2019 Novel Coronavirus Acute",
         "Respiratory Disease (2019-NCOV ARD) Situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:11]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 3,
                section = section,
                date = as.Date("06/02/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution03 <- tibble::tibble(y)

usethis::use_data(iatfResolution03, overwrite = TRUE, compress = "xz")


## Resolution 4 ################################################################

## Read resolution
y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 4) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(23:53, 59:81)]
y <- y[y != ""]

y <- c(y, tail(iatfResolution02, 16)$text)

## Add heading
y <- c(c("Republic of the Philippines",
         "Department of Health",
         "Office of the Secretary",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "11 February 2020",
         "Resolution No. 04",
         "Series of 2020",
         "Implementing the Expanded Travel Ban for the",
         "Management of the 2019 Novel Coronavirus Acute",
         "Respiratory Disease Situation, Amending for the",
         "Purpose Resolution No. 02"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:12]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 4,
                section = section,
                date = as.Date("11/02/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution04 <- tibble::tibble(y)

usethis::use_data(iatfResolution04, overwrite = TRUE, compress = "xz")


## Resolution 5 ################################################################

## Read resolution
y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 5) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(15:45, 49:89, 92:94)]
y <- y[y != ""]

y <- c(y, tail(iatfResolution02, 16)$text)

y[62] <- "BRIGIDO J. DULAY"
y[63] <- "Undersecretary, Department of Foreign Affairs"
y[74] <- "MANUEL ANTHONY Y. TAN"
y[75] <- "OIC-Undersecretary, Department of Information and Communications Technology"

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 05",
         "Series of 2020",
         "14 February 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 5,
                section = section,
                date = as.Date("14/02/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution05 <- tibble::tibble(y)

usethis::use_data(iatfResolution05, overwrite = TRUE, compress = "xz")


## Resolution 6 ################################################################

## Read resolution
y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 6) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(14:67, 71:73)]
y <- y[y != ""]

y <- y %>%
  stringr::str_remove_all(pattern = "\\|") %>%
  stringr::str_remove_all(pattern = "[\\)]$") %>%
  stringr::str_trim(side = "both")

y <- c(y, tail(iatfResolution02, 16)$text)

y[58] <- y[60]
y[59] <- y[61]
y[60] <- y[68]
y[61] <- y[69]
y[62] <- "BRIGIDO J. DULAY"
y[63] <- "Undersecretary, Department of Foreign Affairs"
y[64] <- "MANUEL ANTONIO L. TAMAYO"
y[65] <- "Undersecretary, Department of Tourism"
y[66] <- "ADONIS P. SULIT"
y[67] <- "Assistant Secretary, Department of Justic"
y[68] <- "HANS LEO J. CACDAC"
y[69] <- "Administrator, Overseas Workers Welfare Administration"
y[70] <- "GREGORIO B. HONASAN"
y[71] <- "Secretary, Department of Information and Communications Technology"

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 06",
         "Series of 2020",
         "18 February 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 6,
                section = section,
                date = as.Date("18/02/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution06 <- tibble::tibble(y)

usethis::use_data(iatfResolution06, overwrite = TRUE, compress = "xz")


## Resolution 7 ################################################################

## Read resolution
y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 7) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(13:85, 97:99)]
y <- y[y != ""]

y <- c(y, tail(iatfResolution06, 16)$text)

y[58] <- "EPIMACO DENSING III"
y[59] <- "Undersecretary, Department of the Interior and Local Government"
y[60] <- y[62]
y[61] <- y[63]
y[62] <- "MANUEL ANTONIO L. TAMAYO"
y[63] <- "Undersecretary, Department of Tourism"
y[64] <- "MARIA RICA C. BUENO"
y[65] <- "Assistant Secretary, Department of Tourism"
y[70] <- y[68]
y[71] <- y[69]
y[68] <- "MANUEL ANTHONY S. TAN"
y[69] <- "OIC-Undersecretary, Department of Information and Communications Technology"

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 07",
         "Series of 2020",
         "21 February 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 7,
                section = section,
                date = as.Date("21/02/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution07 <- tibble::tibble(y)

usethis::use_data(iatfResolution07, overwrite = TRUE, compress = "xz")


## Resolution 8 ################################################################

## Read resolution
y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 8) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(13:42, 51:89, 103:118)]
y <- y[y != ""]

y <- c(y, tail(iatfResolution07, 16)$text)

y[74] <- "EDUARDO M. AÑO"
y[75] <- "Secretary, Department of the Interior and Local Government"
y[76] <- "BERNADETTE ROMULA-PUYAT"
y[77] <- "Secretary, Department of Tourism"
y[80] <- y[78]
y[81] <- y[79]
y[78] <- "MENARDO I. GUEVARRA"
y[79] <- "Secretary, Department of Justice"
y[82] <- "MANUEL ANTONIO L. TAMAYO"
y[83] <- "Undersecretary, Department of Transportation"

y <- y %>%
  stringr::str_replace_all(pattern = "DOT\\?", replacement = "DOT") %>%
  stringr::str_replace_all(pattern = "IATE", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "JATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\[IATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "LATE", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "shail", replacement = "shall")

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 08",
         "Series of 2020",
         "26 February 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 8,
                section = section,
                date = as.Date("26/02/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution08 <- tibble::tibble(y)

usethis::use_data(iatfResolution08, overwrite = TRUE, compress = "xz")


## Resolution 9 ################################################################

## Read resolution
y <- iatfLinks %>%
  get_iatf_pdf(id = 9) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[3:length(y)]
y <- y[c(1:44, 56:length(y))]

y[67] <- "FRANCISCO T. DUQUE III"
y[68] <- "Secretary, Department of Health"
y[69] <- ""
y[70] <- "EDUARDO M. AÑO"
y[71] <- "Secretary, Department of the Interior and Local Government"
y[72] <- ""
y[73] <- "BERNADETTE ROMULO-PUYAT"
y[74] <- "Secretary, Department of Tourism"
y[75] <- ""
y[76] <- "BRIGIDO J. DULAY"
y[77] <- "Undersecretary, Department of Foreign Affairs"

y <- y[c(1:78, 92:length(y))]

y[79] <- "MANUEL ANTONIO L. TAMAYO"
y[80] <- "Undersecretary, Department of Transportation"
y[81] <- ""
y[84] <- ""
y[85] <- "ALAN A. SILOR"
y[86] <- "Assistant Secretary, Department of Information and Communications Technology"
y[87] <- ""
y[88] <- "MA. TERESITA S. CUCUECO"
y[90] <- ""

y[29] <- stringr::str_replace(string = y[29], pattern = "\\[ATF", replacement = "IATF")

y <- y[11:90]

y <- y[y != ""]

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 09",
         "Series of 2020",
         "3 March 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 9,
                section = section,
                date = as.Date("03/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution09 <- tibble::tibble(y)

usethis::use_data(iatfResolution09, overwrite = TRUE, compress = "xz")


## Resolution 10 ###############################################################

## Read resolution
y <- iatfLinks %>%
  get_iatf_pdf(id = 10) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

y <- y[6:length(y)]
y[41] <- stringr::str_remove(string = y[41], pattern = " J")

y <- y[c(1:42, 47:length(y))]
y <- y[c(1:82, 86:length(y))]

y <- c(y[1:85], "", y[86:length(y)])

y[87] <- "FRANCISCO T. DUQUE III"

y[89] <- ""

y[90] <- "TEODORO L. LOCSIN, JR"
y[91] <- "Secretary, Department of Foreign Affairs"

y[92] <- ""

y[93] <- "EDUARDO M. AÑO"
y[94] <- "Secretary, Department of the Interior and Local Government"

y[95] <- ""

y[96] <- y[97]
y[97] <- y[98]

y[98] <- ""

y[99]  <- "BERNADETTE FATIMA T. ROMULO-PUYAT"
y[100] <- "Secretary, Department of Tourism"

y[101] <- ""

y[102] <- "ARTHUR P. TUGADE"
y[103] <- "Secretary, Department of Transportation"

y[104] <- ""

y[105] <- "SILVESTRE H. BELLO III"
y[106] <- "Secretary, Department of Labor and Employment"

y[107] <- ""

y[108] <- "ALAN A. SILOR"
y[109] <- "Assistant Secretary, Department of Information and Communications Technology"

y[80] <- stringr::str_replace(string = y[80], pattern = "Malacafiang", replacement = "Malacañang")

y <- y[c(11:41, 46:81, 87:length(y))]
y <- y[y != ""]

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 10",
         "Series of 2020",
         "9 March 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 10,
                section = section,
                date = as.Date("09/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution10 <- tibble::tibble(y)

usethis::use_data(iatfResolution10, overwrite = TRUE, compress = "xz")


## Resolution 11 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 11) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(10:32, 41:66, 75:101, 110:138, 147:161, 170:177)]

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 11",
         "Series of 2020",
         "12 March 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 11,
                section = section,
                date = as.Date("12/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution11 <- tibble::tibble(y)

usethis::use_data(iatfResolution11, overwrite = TRUE, compress = "xz")


## Resolution 12 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 12) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(8:45, 57:89, 103:127, 143:174, 191:227)]

y[132] <- stringr::str_remove(string = y[132], pattern = " |")
y[133] <- "Malacañang Palace, Manila."
y[134] <- ""
y[135] <- "FRANCISCO T. DUQUE"
y[136] <- "Secretary, Department of Health"
y[137] <- ""
y[138] <- "EDUARDO M. AÑO"
y[139] <- "Secretary, Department of the Interior and Local Government"
y[140] <- ""
y[141] <- "BERNADETTE ROMULO-PUYAT"

y <- y[c(1:144, 156:165)]

y[151] <- ""
y[152] <- "ALAN A. SILOR"
y[153] <- "Assistant Secretary, Department of Information and Communications Technology"

y <- y[c(11:13, 15, 17:22, 24:32, 34:42, 44:48, 50:51, 53:60, 62:99,
         101:107, 109:111, 113:118, 120:133, 135:136, 138:139, 141:150, 152:153)]

y[56] <- stringr::str_remove(string = y[56], pattern = " \\|")
y[75] <- stringr::str_remove(string = y[75], pattern = " \\|")
y[110] <- stringr::str_remove(string = y[110], pattern = " \\|")

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 12",
         "Series of 2020",
         "13 March 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 12,
                section = section,
                date = as.Date("13/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution12 <- tibble::tibble(y)

usethis::use_data(iatfResolution12, overwrite = TRUE, compress = "xz")


## Resolution 13 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 13) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(7:38, 46:59, 61:63, 65:81, 91:134, 143:175, 184:length(y))]

y[166] <- "FRANCISCO T DUQUE III"
y[167] <- "Secretary, Department of Health"
y[168] <- "EDUARDO M. AÑO"
y[169] <- "Secretary, Department of Interior and Local Government"
y[170] <- "BERNADETTE ROMULO-PUYAT"
y[171] <- "Secretary, Department of Tourism"
y[172] <- "SILVESTRE H. BELLO III"
y[173] <- "Secretary, Department of Labor and Employment"
y[174] <- "MENARDO I. GUEVARRA"
y[175] <- "Secretary, Department of Justice"
y[176] <- "BRIGIDO J. DULAY"
y[177] <- "Undersecretary, Department of Foreign Affairs"
y[178] <- "ARTEMIO U. TUAZON, JR."
y[179] <- "ALAN A. SILOR"
y[180] <- "Assistant Secretary, Department of Information and Communications Technology"
y[181] <- "With the concurrence of:"
y[182] <- "KARLO B. NOGRALES"
y[183] <- "Cabinet Secretary, Cabinet Secretariat of the Philippines"
y[184] <- "RAMON M. LOPEZ"
y[185] <- y[210]
y[186] <- "ROLANDO JOSELITO D. BAUTISTA"
y[187] <- y[213]
y[188] <- y[214]
y[189] <- y[215]
y[190:193] <- y[216:219]
y[194] <- "MARTIN M. ANDANAR"
y[195] <- "Secretary, Presidential Communications Operations Office"
y[196:197] <- y[222:223]
y[198] <- "RICARDO B. JALAD"
y[199] <- "Administrator, Office of the Civil Defense"
y[200:203] <- y[234:237]
y[204] <- "RONNIE GIL L. GAVAN"
y[205] <- "Acting Deputy Chief of Staff for Operations, Philippine Coast Guard"
y[206] <- "VICENTE M. AGDAMAG"
y[207] <- y[242]
y[208] <- "JESUS L. R. MATEO"
y[209] <- "Undersecretary, Department of Education"
y[210] <- "BAYANI H. AGABIN"
y[211] <- y[247]
y[212] <- y[249]
y[213] <- "Undersecretary, National Economic and Development Authority"
y[214] <- y[251]
y[215] <- "Assistant Secretary, Office of the Chief Presidential Legal Counsel"

y <- y[1:215]
y <- y[y != ""]

y[14] <- stringr::str_remove(string = y[14], pattern = ": ")
y[14] <- stringr::str_remove(string = y[14], pattern = ":")
y[15] <- stringr::str_remove(string = y[15], pattern = "z ")
y[16] <- stringr::str_remove(string = y[16], pattern = "3 ")
y[45] <- stringr::str_remove(string = y[45], pattern = ": ")
y[46] <- stringr::str_remove(string = y[46], pattern = "4 ")
y[46] <- stringr::str_remove(string = y[46], pattern = ":")
y[47] <- stringr::str_remove(string = y[47], pattern = "; ")
y[52] <- stringr::str_remove(string = y[52], pattern = "\\? ")
y[53] <- stringr::str_remove(string = y[53], pattern = "\\| ")
y[54] <- stringr::str_remove(string = y[54], pattern = "\\| ")
y[55] <- stringr::str_remove(string = y[55], pattern = "\\| ")
y[56] <- stringr::str_remove(string = y[56], pattern = "\\| ")
y[57] <- stringr::str_remove(string = y[57], pattern = "\\| ")
y[75] <- stringr::str_replace(string = y[75], pattern = "OF Ws", replacement = "OFWs")
y[83] <- stringr::str_remove(string = y[83], pattern = "Z ")
y[84] <- stringr::str_remove(string = y[84], pattern = "j ")
y[86] <- stringr::str_remove(string = y[86], pattern = "f ")
y[87] <- stringr::str_remove(string = y[87], pattern = "5 ")
y[88] <- stringr::str_remove(string = y[88], pattern = "4")
y[89] <- stringr::str_remove(string = y[89], pattern = "2 ")
y[90] <- stringr::str_remove(string = y[90], pattern = "5 ")
y[91] <- stringr::str_remove(string = y[91], pattern = "& ")
y[92] <- stringr::str_remove(string = y[92], pattern = "é ")
y[115] <- stringr::str_remove(string = y[115], pattern = ": ")
y[119] <- stringr::str_remove(string = y[119], pattern = "- ")
y[121] <- stringr::str_remove(string = y[121], pattern = "z ")
y[122] <- stringr::str_remove(string = y[122], pattern = "\\% ")
y[145] <- stringr::str_remove(string = y[145], pattern = "2 ")
y[146] <- stringr::str_remove(string = y[146], pattern = "é ")
y[147] <- stringr::str_remove(string = y[147], pattern = "5 ")
y[148] <- stringr::str_remove(string = y[148], pattern = "2 ")
y[149] <- stringr::str_remove(string = y[149], pattern = "\\| ")
y[152] <- stringr::str_remove(string = y[152], pattern = "2 ")
y[120] <- stringr::str_remove(string = y[120], pattern = "= ")

y <- y[9:length(y)]
y <- y[y != ""]

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 06",
         "Series of 2020",
         "17 March 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 13,
                section = section,
                date = as.Date("17/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution13 <- tibble::tibble(y)

usethis::use_data(iatfResolution13, overwrite = TRUE, compress = "xz")

## Resolution 14 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 14) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[y != ""]

y <- y[c(5:34, 36:69, 71:107, 109:146, 148:186, 188:length(y))]

y[182] <- stringr::str_replace(string = y[182], pattern = "so p", replacement = "Club House, Camp")
y[183] <- "EDUARDO M. AÑO"
y[184] <- "Secretary, Department of the Interior and Local Government"
y[185] <- "BERNADETTE ROMULO-PUYAT"
y[186] <- "Secretary, Department of Tourism"
y[187] <- "SILVESTRE H. BELLO III"
y[188] <- "Secretary, Department of Labor and Employment"
y[189] <- "GREGORIO B. HONASAN II"
y[190] <- "Secretary, Department of Information and Communications Technology"
y[191] <- y[194]
y[192] <- y[195]
y[193] <- "DEO L. MARCO"
y[194] <- "Undersecretary, Department of Justice"
y[195] <- "BRIGIDO D. DULAY"
y[196] <- "Undersecretary, Department of Foreign Affairs"
y[197:198] <- y[200:201]
y[199] <- y[203]
y[200] <- "KARLO ALEXEI B. NOGRALES"
y[201] <- y[205]
y[202:203] <- y[206:207]
y[204] <- "RAMON M. LOPEZ"
y[205] <- y[209]
y[206] <- "ROLANDO D. BAUTISTA"
y[207] <- y[211]
y[208:209] <- y[215:216]
y[210] <- "ROY A. CIMATU"
y[211] <- y[219]
y[212:213] <- y[220:221]
y[214] <- "RICARDO B. JALAD"
y[215] <- y[224]
y[216] <- stringr::str_remove(string = y[228], pattern = " \\|")
y[217] <- stringr::str_remove(string = y[229], pattern = " \\|")

y <- y[c(1:217, 230:243)]

y[218] <- stringr::str_remove(string = y[218], pattern = " :")
y[219] <- stringr::str_remove(string = y[219], pattern = " \\|")
y[220] <- stringr::str_remove(string = y[220], pattern = " \\|")
y[221] <- stringr::str_remove(string = y[221], pattern = " \\|")
y[222] <- stringr::str_remove(string = y[222], pattern = " :")
y[223] <- stringr::str_remove(string = y[223], pattern = " oe")
y[224] <- stringr::str_remove(string = y[224], pattern = " \\|")
y[225] <- stringr::str_remove(string = y[225], pattern = " :")
y[226] <- stringr::str_remove(string = y[226], pattern = " ,")
y[227] <- stringr::str_remove(string = y[227], pattern = " \\|")
y[228] <- stringr::str_remove(string = y[228], pattern = " \\|")
y[229] <- stringr::str_remove(string = y[229], pattern = " 2")
y[230] <- stringr::str_remove(string = y[230], pattern = " !")
y[231] <- stringr::str_remove(string = y[231], pattern = " 4")

y[144] <- stringr::str_remove(string = y[144], pattern = "\\| ")
y[68] <- stringr::str_remove(string = y[68], pattern = ". ")
y[73] <- stringr::str_remove(string = y[73], pattern = ". ")
y[124] <- stringr::str_replace(string = y[124], pattern = "ui.", replacement = "iii.")

y <- y[10:length(y)]

## Add heading
y <- c(c("Republic of the Philippines",
         "DOH DFA DILG DOJ DOLE DOT DOTr DICT",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 14",
         "Series of 2020",
         "20 March 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:9]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 14,
                section = section,
                date = as.Date("20/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution14 <- tibble::tibble(y)

usethis::use_data(iatfResolution14, overwrite = TRUE, compress = "xz")

## Resolution 15 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 15) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- stringr::str_remove_all(string = y, pattern = "\\| |\\||= |\\/ |\\|!")
y <- y[y != ""]

y <- y[c(6:34, 43:69, 76:104, 113:123, 125:133, 135:142, 151:181, 191:208, 211:214)]

y[97] <- stringr::str_replace(string = y[97], pattern = "].", replacement = "1.")
y[132] <- stringr::str_remove(string = y[150], pattern = "1 ")
y[150] <- stringr::str_remove(string = y[150], pattern = "! ")

y[18] <- stringr::str_replace(string = y[18], pattern = "\\[ATF", replacement = "IATF")
y[163] <- "EDUARDO MAÑO"

y <- y[c(9:143, 145:length(y))]

y[101] <- stringr::str_replace(string = y[101], pattern = "OF Ws", replacement = "OFWs")
y[104] <- stringr::str_replace(string = y[104], pattern = "OF Ws", replacement = "OFWs")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force for the Management of",
         "Emerging Infectious Diseases",
         "Resolution No. 15",
         "Series of 2020",
         "24 March 2020",
         "Recommendations for the management of the coronavirus",
         "disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 15,
                section = section,
                date = as.Date("25/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution15 <- tibble::tibble(y)

usethis::use_data(iatfResolution15, overwrite = TRUE, compress = "xz")

## Resolution 16 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 16) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[y != ""]
y <- stringr::str_trim(string = y, side = "both")

section <- c(rep("heading", 4), rep("operative", length(5:length(y))))

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 16,
                section = section,
                date = as.Date("30/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution16 <- tibble::tibble(y)

usethis::use_data(iatfResolution16, overwrite = TRUE, compress = "xz")

## Resolution 17 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 17) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:70, 74:75, 77:101, 104:119, 121, 124:139, 142:157, 160:165)]
y <- y[y != ""]

y[112] <- "SALVADOR C. MEDIALDEA"

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 17,
                section = section,
                date = as.Date("30/03/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution17 <- tibble::tibble(y)

usethis::use_data(iatfResolution17, overwrite = TRUE, compress = "xz")

## Resolution 18 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 18) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:44, 51:91, 97:137)]
y <- y[y != ""]

y[1] <- "REPUBLIC OF THE PHILIPPINES"
y[2] <- "INTER-AGENCY TASK FORCE"
y[3] <- "FOR THE MANAGEMENT OF EMERGING INFECTIOUS DISEASE"
y[4] <- ""

y <- y[y != ""] %>%
  stringr::str_replace_all(pattern = "I\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "OF Ws", replacement = "OFWs")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
oEnd   <- length(y)

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 18,
                section = section,
                date = as.Date("01/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution18 <- tibble::tibble(y)

usethis::use_data(iatfResolution18, overwrite = TRUE, compress = "xz")

## Resolution 19 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 19) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:35, 41:70, 76:108, 114:129, 135:149, 155:169, 175:188)]

y[140] <- "RYAN ALVIN R. ACOSTA"

y[141] <- ""
y <- y[y != ""]

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 19,
                section = section,
                date = as.Date("03/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution19 <- tibble::tibble(y)

usethis::use_data(iatfResolution19, overwrite = TRUE, compress = "xz")

## Resolution 20 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 20) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:36, 42:57, 64:77, 83:93, 95:97, 103:116)]

y[77] <- "RYAN ALVIN R. ACOSTA"

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 20,
                section = section,
                date = as.Date("06/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution20 <- tibble::tibble(y)

usethis::use_data(iatfResolution20, overwrite = TRUE, compress = "xz")

## Resolution 21 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 21) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:35, 41:72, 78:111, 117:132, 138:152, 158:166, 168:173, 179:189)]

y[141] <- "RYAN ALVIN R. ACOSTA"
y[38] <- "3. The Abok Kamay ang Pagtulong (AKAP) so OFWs program."

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 21,
                section = section,
                date = as.Date("06/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution21 <- tibble::tibble(y)

usethis::use_data(iatfResolution21, overwrite = TRUE, compress = "xz")

## Resolution 22 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 22) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y[177] <- "RICARDO P. BERNABE III"

y <- y[c(1:33, 38:68, 73:88, 90:93, 95:104, 109:131, 136:150, 155:168, 173:177, 179:189, 194:199)]

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 22,
                section = section,
                date = as.Date("08/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution22 <- tibble::tibble(y)

usethis::use_data(iatfResolution22, overwrite = TRUE, compress = "xz")

## Resolution 23 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 23) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y[143] <- "RICARDO P. BERNABE III"

y <- y[c(1:36, 41:75, 80:99, 104:118, 123:137, 142:143, 145:156, 161:165)]

y[128] <- stringr::str_replace(string = y[128], pattern = "Comm\\\\nt", replacement = "Commandant")

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 23,
                section = section,
                date = as.Date("13/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution23 <- tibble::tibble(y)

usethis::use_data(iatfResolution23, overwrite = TRUE, compress = "xz")

## Resolution 24 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 24) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y[123] <- "RICARDO P. BERNABE III"

y <- y[c(1:34, 39:67, 72:87, 92:104, 109:123, 125, 130:143, 148:149)]

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]             <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 24,
                section = section,
                date = as.Date("15/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution24 <- tibble::tibble(y)

usethis::use_data(iatfResolution24, overwrite = TRUE, compress = "xz")

## Resolution 25 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 25) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:33, 40:45, 47:67, 75:95)]

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE"))
eEnd   <- cStart - 1

section <- NULL
section[1:8]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 25,
                section = section,
                date = as.Date("17/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution25 <- tibble::tibble(y)

usethis::use_data(iatfResolution25, overwrite = TRUE, compress = "xz")

## Resolution 26 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 26) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:34, 39:43, 50:70)]

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE"))
eEnd   <- cStart - 1

section <- NULL
section[1:8]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 26,
                section = section,
                date = as.Date("20/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution26 <- tibble::tibble(y)

usethis::use_data(iatfResolution26, overwrite = TRUE, compress = "xz")

## Resolution 27 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 27) %>%
  pdf_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:35, 40:70, 75:79, 86:106)]

y <- stringr::str_trim(string = y, side = "both")

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE"))
eEnd   <- cStart - 1

section <- NULL
section[1:8]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 27,
                section = section,
                date = as.Date("22/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution27 <- tibble::tibble(y)

usethis::use_data(iatfResolution27, overwrite = TRUE, compress = "xz")

## Resolution 28 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 28) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(12:46, 64:99, 109:131, 139:172)]

y <- y[y != ""]

y[74] <- "minutes of the meeting, held this 23rd April, 2020 via video conference."
y[75] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[76] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[77] <- "IATF Chairperson         IATF Co-Chairperson"

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 28",
         "Series of 2020",
         "23 April 2020",
         "Recommendations relative to the management",
         "of the coronavirus disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:8]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 28,
                section = section,
                date = as.Date("23/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution28 <- tibble::tibble(y)

usethis::use_data(iatfResolution28, overwrite = TRUE, compress = "xz")

## Resolution 29 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 29) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(14:48, 55:90, 98:109, 115:149)]
y <- y[y != ""]

y[69] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[70] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[71] <- "IATF Chairperson         IATF Co-Chairperson"
y[74] <- "1. I am presently an Assistant Secretary of the Department of Health;"
y[83] <- stringr::str_replace(string = y[83], pattern = "\\[", replacement = "I")
y[84] <- stringr::str_replace(string = y[84], pattern = "\\[", replacement = "I")
y[87] <- stringr::str_replace(string = y[87], pattern = "\\[", replacement = "I")
y[93] <- stringr::str_replace(string = y[93], pattern = "1g!", replacement = "28th")
y[95] <- "Kenneth G. Ronquillo, MD, MPHM"
y[97] <- stringr::str_replace(string = y[97], pattern = "\\[", replacement = "I")

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 29",
         "Series of 2020",
         "27 April 2020",
         "Recommendations relative to the management",
         "of the coronavirus disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:8]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 29,
                section = section,
                date = as.Date("27/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution29 <- tibble::tibble(y)

usethis::use_data(iatfResolution29, overwrite = TRUE, compress = "xz")

## Resolution 30 ###############################################################

y <- iatfLinksGazette %>%
  dplyr::filter(date == "2020-04-29" & id == 30) %>%
  get_iatf_pdf(id = 30) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(15:56, 66:82, 85:97, 104:108)]
y <- y[y != ""]

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "1") %>%

y[60] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[61] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[62] <- "IATF Chairperson         IATF Co-Chairperson"

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 30",
         "Series of 2020",
         "29 April 2020",
         "Recommendations relative to the management",
         "of the coronavirus disease 2019 (COVID-19) situation"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:8]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 30,
                section = section,
                date = as.Date("29/04/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution30 <- tibble::tibble(y)

usethis::use_data(iatfResolution30, overwrite = TRUE, compress = "xz")

## Resolution 30A ##############################################################

y <- iatfLinksGazette %>%
  dplyr::filter(date != "2020-04-29" & id == 30) %>%
  get_iatf_pdf(id = 30) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Clean-up
y <- y[c(8:40, 49, 51:54, 56, 58:62, 64, 66:72, 82:87)]
y <- y[y != ""]

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "Ist", replacement = "1st")

y[51] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[52] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[53] <- "IATF Chairperson         IATF Co-Chairperson"

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 30A",
         "Series of 2020",
         "1 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "NOW, THEREFORE"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 30,
                section = section,
                date = as.Date("1/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution30A <- tibble::tibble(y)

usethis::use_data(iatfResolution30A, overwrite = TRUE, compress = "xz")


## Resolution 31 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 31) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(9:51, 63:97, 107:131)]
y <- y[y != ""]

y[59] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[60] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[61] <- "IATF Chairperson         IATF Co-Chairperson"
y[73] <- stringr::str_replace(string = y[73], pattern = "\\[", replacement = "I")
y[74] <- stringr::str_replace(string = y[74], pattern = "\\[", replacement = "I")
y[77] <- stringr::str_replace(string = y[77], pattern = "\\[", replacement = "I")

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 31",
         "Series of 2020",
         "1 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 31,
                section = section,
                date = as.Date("01/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution31 <- tibble::tibble(y)

usethis::use_data(iatfResolution31, overwrite = TRUE, compress = "xz")

## Resolution 32 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 32) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(9:44, 53:94, 103:123, 136:170)]
y <- y[y != ""]

y[80] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[81] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[82] <- "IATF Chairperson         IATF Co-Chairperson"
y[94] <- stringr::str_replace(string = y[94], pattern = "\\[", replacement = "I")
y[95] <- stringr::str_replace(string = y[95], pattern = "\\[", replacement = "I")
y[98] <- stringr::str_replace(string = y[98], pattern = "\\[", replacement = "I")
y[102] <- stringr::str_remove(string = y[102], pattern = "\\[")
y[108] <- stringr::str_replace(string = y[108], pattern = "\\[", replacement = "I")

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 32",
         "Series of 2020",
         "4 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 32,
                section = section,
                date = as.Date("04/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution32 <- tibble::tibble(y)

usethis::use_data(iatfResolution32, overwrite = TRUE, compress = "xz")

## Resolution 33 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 33) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(9:46, 53:93, 103:122, 130:164)]
y <- y[y != ""]

y[79] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[80] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[81] <- "IATF Chairperson         IATF Co-Chairperson"
y[93] <- stringr::str_replace(string = y[93], pattern = "\\[", replacement = "I")
y[94] <- stringr::str_replace(string = y[94], pattern = "\\[", replacement = "I")
y[97] <- stringr::str_replace(string = y[97], pattern = "\\[", replacement = "I")
y[103] <- stringr::str_remove(string = y[103], pattern = "\\[")
y[107] <- stringr::str_replace(string = y[107], pattern = "\\[", replacement = "I")

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 33",
         "Series of 2020",
         "6 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 33,
                section = section,
                date = as.Date("06/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution33 <- tibble::tibble(y)

usethis::use_data(iatfResolution33, overwrite = TRUE, compress = "xz")

## Resolution 34 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 34) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(9:46, 52:76, 79:90, 97:98, 100:103, 105:108, 110:130, 136:147, 153:187)]
y <- y[y != ""]

y[97] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[98] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[99] <- "IATF Chairperson         IATF Co-Chairperson"

y <- stringr::str_replace_all(string = y, pattern = "\\[ATF", replacement = "IATF")

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 34",
         "Series of 2020",
         "8 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 34,
                section = section,
                date = as.Date("08/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution34 <- tibble::tibble(y)

usethis::use_data(iatfResolution34, overwrite = TRUE, compress = "xz")

## Resolution 35 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 35) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(9:45, 52:90, 98:131, 141:165, 173:207)]
y <- y[y != ""]

y[115] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[116] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[117] <- "IATF Chairperson         IATF Co-Chairperson"

y <- stringr::str_replace_all(string = y, pattern = "\\[ATF", replacement = "IATF")

y <- stringr::str_replace_all(string = y, pattern = "\\[", replacement = "I")

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 35",
         "Series of 2020",
         "11 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 35,
                section = section,
                date = as.Date("11/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution35 <- tibble::tibble(y)

usethis::use_data(iatfResolution35, overwrite = TRUE, compress = "xz")

## Resolution 36 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 36) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(9:46, 54:93, 101:131)]
y <- y[y != ""]

y[88] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[89] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[90] <- "IATF Chairperson         IATF Co-Chairperson"

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 36",
         "Series of 2020",
         "13 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 36,
                section = section,
                date = as.Date("13/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution36 <- tibble::tibble(y)

usethis::use_data(iatfResolution36, overwrite = TRUE, compress = "xz")

## Resolution 37 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 37) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(13:49, 58:76)]
y <- y[y != ""]

y[47] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[48] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[49] <- "IATF Chairperson         IATF Co-Chairperson"

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 37",
         "Series of 2020",
         "15 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 37,
                section = section,
                date = as.Date("15/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution37 <- tibble::tibble(y)

usethis::use_data(iatfResolution37, overwrite = TRUE, compress = "xz")

## Omnibus #####################################################################

x <- pdf_ocr_text(pdf = "data-raw/IATF/Omnibus-Guidelines-community-quarantine.pdf")

## Restructure text
y <- unlist(stringr::str_split(string = x, pattern = "\n"))

y <- y[c(8:39, 49:83, 94:129, 138:168, 179:218, 226:266, 277:317,
         328:369, 380:414, 424:456, 467:511, 520:578, 590:629, 639:677,
         687:721, 732:767, 779:821, 829:871, 880:913, 921:957, 969:length(y))]

y <- y[c(1:812, 820:851, 859:894, 901:938, 946:976)]

y <- y[y != ""]

y[751] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[752] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[753] <- "IATF Chairperson         IATF Co-Chairperson"

y <- stringr::str_trim(string = y, side = "both")

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "guideline",
                id = NA,
                date = as.Date("15/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfGuidelineOmnibus <- tibble::tibble(y)

usethis::use_data(iatfGuidelineOmnibus, overwrite = TRUE, compress = "xz")

## Resolution 38 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 38) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[y != ""]
y <- y[c(8:37, 42:69, 74:97, 102:129, 134:158, 162:190, 195:218, 225:248,
         253:280, 287:310, 315:340, 346:369, 376:399, 405:433, 439:463,
         469:497, 502:532, 537:561, 567:590, 596:623, 628:652, 660:687,
         694:719, 725:767)]

y[67]  <- "iii. Manufacturers of medicines, medical supplies, devices"
y[76]  <- "essential goods. Delivery of clothing, accessories,"
y[79]  <- "b. At a maximum of fifty percent (50%) operational capacity,"
y[85]  <- "activities in the value chain related to food, medicine and"
y[93]  <- "establishments insofar as take-out and delivery services,"
y[113] <- "therapy services for Persons With Disabilities (PWDs) shall"
y[119] <- "including their armored vehicle services, if any;"
y[140] <- "maintenance and repair works;"
y[150] <- "capacity necessary to maintain the prompt delivery of"
y[191] <- "their residences to attend the wake or interment of the"
y[215] <- "Foreign Affairs (DFA), whenever performing diplomatic"
y[228] <- "those accommodating the following:"
y[243] <- "services to guests through an an in-house skeleton"
y[246] <- "shall not be allowed to operate or to provide room service;"
y[256] <- "are essential for the provision of government services or"
y[276] <- "passes specifically exempting persons from community"
y[296] <- "All the following shall be allowed to operate at full operational capacity"
y[297] <- "a. All establishments or activities permitted to operate or be"
y[316] <- "Omnibus Guidelines, such as money exchange, insurance,"
y[343] <- "Provided that in all of the foregoing, hotel operations"
y[348] <- "shall not be allowed to operate or to provide roome service;"
y[362] <- "modified through subsequent issuances of the IATF"
y[395] <- "except when indispensible under the circumstances for obtaining essential goods and services or for work in establishment located"
y[400] <- "Provided that in all of the foregoing, hotel operations shall be"
y[403] <- "establishments within the premises, such as restaurants, cafés"
y[469] <- "modified through subsequent issuances of the IATF"
y[486] <- "skateboarding are allowed. Provided, that the minimum public"
y[504] <- "pertinent Sections of this Omnibus Guidelines shall be allowed to operate or be undertaken at full operational capacity;"
y[535] <- "permitted in the zone of destination, and going back home"
y[541] <- "Repatriated OFWs or returning non-OFWs who have been"
y[545] <- "for COVID-19 whichever is earlier, shall be granted unhampered"
y[566] <- "the payment of all loans, including but not limited to salary,"
y[569] <- "without incurring interests, penalties, fees or other charges."
y[592] <- "including their future amendments, shall be considered sufficient"
y[601] <- "combination thereof, which can effectively lessen the"

y <- c(y[1:395], y[395:length(y)])
y <- c(y[1:505], y[505:length(y)])

y[395] <- "except when indispensible under the circumstances for obtaining"
y[396] <- "essential goods and services or for work in establishment located"
y[505] <- "pertinent Sections of this Omnibus Guidelines shall be allowed"
y[506] <- "to operate or be undertaken at full operational capacity;"

y <- y[c(1:627, 630:length(y))]

y <- y %>%
  stringr::str_replace_all(pattern = "_", replacement = " ") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "I") %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "SECTIO. I\\] SEPARABILIT\\} AU",
                           replacement = "SECTION [9]: SEPARABILITY CLAUSE.") %>%
  stringr::str_replace(pattern = "Iam", replacement = "I am") %>%
  stringr::str_remove_all(pattern = "\\@")

y[625] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[626] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[627] <- "IATF Chairperson         IATF Co-Chairperson"
y[649] <- "KENNETH G. RONQUILLO, MD, MPHM"

y[574] <- "the ECQ or MECQ is lifted, whichever is later, for every loan."
y <- y[c(1:541, 543:length(y))]

y <- stringr::str_trim(string = y, side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 38",
         "Series of 2020",
         "22 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 38,
                section = section,
                date = as.Date("22/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution38 <- tibble::tibble(y)

usethis::use_data(iatfResolution38, overwrite = TRUE, compress = "xz")

## Resolution 39 ###############################################################

y <- iatfLinks %>%
  get_iatf_pdf(id = 39) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(11:47, 55:79, 84:118)]
y <- y[y != ""]

y[51] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[52] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[53] <- "IATF Chairperson         IATF Co-Chairperson"
y[75] <- "KENNETH G. RONQUILLO, MD, MPHM"
y[77] <- "Secretariat Head, IATF"

y <- y %>%
  stringr::str_replace(pattern = "8. \\|", replacement = "8. I") %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "I") %>%
  stringr::str_replace(pattern = "lam", replacement = "I am") %>%
  stringr::str_replace(pattern = "li", replacement = "ii") %>%
  stringr::str_replace(pattern = "ili", replacement = "iii") %>%
  stringr::str_replace(pattern = "Ill", replacement = "III") %>%
  stringr::str_remove(pattern = "_") %>%
  stringr::str_trim(side = "both")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 39",
         "Series of 2020",
         "22 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 39,
                section = section,
                date = as.Date("22/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution39 <- tibble::tibble(y)

usethis::use_data(iatfResolution39, overwrite = TRUE, compress = "xz")

## Resolution 40 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 40) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(10:44, 50:89, 97:135, 145:179, 186:220)]
y <- y[y != ""]

y[126] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[127] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[140] <- "In the Regular Meeting of the IATF held on 27 May 2020 via teleconference"
y[150] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 27th day of May"

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\]", replacement = "I")
  stringr::str_replace_all(pattern = "\\|", replacement = "I") %>%
  stringr::str_replace(pattern = "-b", replacement = "b") %>%
  stringr::str_remove(pattern = "\\/")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 40",
         "Series of 2020",
         "27 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 40,
                section = section,
                date = as.Date("27/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution40 <- tibble::tibble(y)

usethis::use_data(iatfResolution40, overwrite = TRUE, compress = "xz")


## Resolution 41 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 41) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(10:44, 53:88, 96:133, 142:160, 162:174, 182:191, 199:224)]
y <- y[y != ""]

y[139] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[140] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[165] <- "KENNETH G. RONQUILLO, MD, MPHM"

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\]", replacement = "I") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "I")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 41",
         "Series of 2020",
         "29 May 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 41,
                section = section,
                date = as.Date("29/05/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution41 <- tibble::tibble(y)

usethis::use_data(iatfResolution41, overwrite = TRUE, compress = "xz")


## Resolution 42 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 42) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(10:43, 52:76, 84:109)]
y <- y[y != ""]

y[47] <- "minutes of the meeting, held this 1 June 2020 via video conference."
y[48] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[49] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[62] <- "5. In the Regular Meeting of the IATF held on 1 June 2020 via teleconference"
y[73] <- "2020, Manila."
y[74] <- "KENNETH G. RONQUILLO, MD, MPHM"

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\[am", replacement = "I am") %>%
  stringr::str_replace_all(pattern = "\\]", replacement = "I") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "I") %>%
  stringr::str_replace_all(pattern = "\\]s\\%", replacement = "29th")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 42",
         "Series of 2020",
         "1 June 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 42,
                section = section,
                date = as.Date("01/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution42 <- tibble::tibble(y)

usethis::use_data(iatfResolution42, overwrite = TRUE, compress = "xz")


## Resolution 43 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 43) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(10:44, 51:52, 54:82, 91:123, 131:173, 183:201, 210:242)]
y <- y[y != ""]

y[141] <- "KARLO ALEXEI B. NOGRALES     ROY A. CIMATU"
y[144] <- "IATF Co-Chairperson     IATF Co-Chairperson"
y[145] <- "Francisco T. Duque III"
y[150] <- "1. I am presently an Assistant Secretary of the Department of Health;"
y[167] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 3d day of June"

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\]", replacement = "I") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "I")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 43",
         "Series of 2020",
         "3 June 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 43,
                section = section,
                date = as.Date("03/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution43 <- tibble::tibble(y)

usethis::use_data(iatfResolution43, overwrite = TRUE, compress = "xz")


## Resolution 44 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 44) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(9:52, 57:61, 74:96)]
y <- y[y != ""]

y[31] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[32] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[33] <- "IATF Chairperson         IATF Co-Chairperson"
y[44] <- "In the Regular Meeting of the IATF held on 8 June 2020 via teleconference during"
y[52] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 8th day of June"

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\]", replacement = "I") %>%
  stringr::str_remove_all(pattern = "\\|")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 44",
         "Series of 2020",
         "8 June 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 44,
                section = section,
                date = as.Date("08/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution44 <- tibble::tibble(y)

usethis::use_data(iatfResolution44, overwrite = TRUE, compress = "xz")


## Resolution 45 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 45) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(8:45, 53:96, 103:109, 115:146)]
y <- y[y != ""]

y[71] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[72] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[73] <- "IATF Chairperson         IATF Co-Chairperson"
y[84] <- "5. In the Regular Meeting of the IATF held on 10th of JUNE 2020 via teleconference during"
y[85] <- "which a quorum was present and acted throughout, IATF Resolution No. 45 was"
y[92] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 10th day of June"

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\]", replacement = "I") %>%
  stringr::str_remove_all(pattern = "\\|")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 45",
         "Series of 2020",
         "10 June 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 45,
                section = section,
                date = as.Date("10/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution45 <- tibble::tibble(y)

usethis::use_data(iatfResolution45, overwrite = TRUE, compress = "xz")


## Resolution 46 ###############################################################

x <- pdf_ocr_text(pdf = "data-raw/IATF/20200615-IATF-RESOLUTION-NO-46.pdf")

## Restructure text
y <- unlist(stringr::str_split(string = x, pattern = "\n"))

y <- y[c(10:46, 54:62, 65:79, 87:118)]
y <- y[y != ""]

y[48] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[49] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[50] <- "IATF Chairperson         IATF Co-Chairperson"
y[61] <- "5. In the Regular Meeting of the IATF held on 15th of JUNE 2020 via teleconference during"
y[62] <- "which a quorum was present and acted throughout, IATF Resolution No. 46 was"
y[69] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 15th day of June"
y[71] <- "KENNETH G. RONQUILLO, MD, MPHM"

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\]", replacement = "I") %>%
  stringr::str_remove_all(pattern = "\\|") %>%
  stringr::str_remove_all(pattern = "\\[")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 46",
         "Series of 2020",
         "15 June 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 46,
                section = section,
                date = as.Date("15/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution46 <- tibble::tibble(y)

usethis::use_data(iatfResolution46, overwrite = TRUE, compress = "xz")


## Resolution 46A ##############################################################

x <- pdf_ocr_text(pdf = "data-raw/IATF/20200615-IATF-RESOLUTION-NO-46-A.pdf")

## Restructure text
y <- unlist(stringr::str_split(string = x, pattern = "\n"))

y <- y[c(9:45, 54:91, 98:136, 146:174, 181:212)]
y <- y[y != ""]

y[36] <- "ii. Region I - Ilocos Norte, Ilocos Sur, La Union, Pangasinan,"
y[38] <- "iii. Batanes;"
y[39] <- "iv. Region III - Nueva Ecija, Pampanga, Zambales, Angeles"
y[44] <- "vii. Region V - Albay, Camarines Norte, Camarines Sur,"
y[50] <- "ii. Region VIII - Biliran, Eastern Samar, Leyte, Northern"
y[59] <- "iii. Region XI - Davao de Oro, Davao del Norte, Davao del"
y[72] <- "i. Region II - Cagayan, Isabela, Nueva Vizcaya, Quirino,"
y[74] <- "ii. Region III - Aurora, Bataan, Bulacan, Tarlac, Olongapo"
y[76] <- "iii. Region IV-A - Cavite, Laguna, Batangas, Rizal, Quezon;"
y[84] <- "ii. Davao City."
y[123] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[124] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[125] <- "IATF Chairperson         IATF Co-Chairperson"
y[136] <- "5. In the Regular Meeting of the IATF held on 15th of JUNE 2020 via teleconference during"
y[137] <- "which a quorum was present and acted throughout, IATF Resolution No. 46A was"
y[144] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 15th day of June"
y[71] <- "KENNETH G. RONQUILLO, MD, MPHM"

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\]", replacement = "I") %>%
  stringr::str_remove_all(pattern = "\\|") %>%
  stringr::str_remove_all(pattern = "\\[")

## Add heading
y <- c(c("Republic of the Philippines",
         "Inter-Agency Task Force",
         "for the Management of Emerging Infectious Diseases",
         "Resolution No. 46-A",
         "Series of 2020",
         "15 June 2020"), y)

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 46,
                section = section,
                date = as.Date("15/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution46A <- tibble::tibble(y)

usethis::use_data(iatfResolution46A, overwrite = TRUE, compress = "xz")

## Resolution 47 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 47) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:3, 5:7, 9:47, 57:96, 104:137, 145:173, 180:184, 191:222)]
y <- y[y != ""]

y[1:3] <- c("Republic of the Philippines",
            "Inter-Agency Task Force",
            "for the Management of Emerging Infectious Diseases")

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\_and\\_", replacement = "and") %>%
  stringr::str_replace_all(pattern = "\\_\\_\\_", replacement = " ")

y[126] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[127] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[128] <- "IATF Chairperson         IATF Co-Chairperson"
y[139] <- "5. In the Regular Meeting of the IATF held on 19th of JUNE 2020 via teleconference during"
y[147] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 19th day of June"

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 47,
                section = section,
                date = as.Date("19/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution47 <- tibble::tibble(y)

usethis::use_data(iatfResolution47, overwrite = TRUE, compress = "xz")

## Resolution 48 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 48) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:3, 5:7, 9:46, 53:96, 104:142, 149:152, 154:173, 180:208, 210:212)]
y <- y[y != ""]

y[1:3] <- c("Republic of the Philippines",
            "Inter-Agency Task Force",
            "for the Management of Emerging Infectious Diseases")

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "\\_at\\_", replacement = "at") %>%
  stringr::str_replace_all(pattern = "\\@\\.", replacement = "e.") %>%
  stringr::str_replace_all(pattern = "\\!3", replacement = "13") %>%
  stringr::str_replace_all(pattern = "l\\\\\\,", replacement = "1.") %>%
  stringr::str_replace_all(pattern = "2\\:", replacement = "3.") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "I")

y[93]  <- "e. Non-OFWs who may be required to undergo mandatory"
y[131] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[132] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[133] <- "IATF Chairperson         IATF Co-Chairperson"
y[144] <- "5. In the Regular Meeting of the IATF held on 22nd of JUNE 2020 via teleconference during"
y[145] <- "which a quorum was present and acted throughout, IATF Resolution No. 48 was"
y[152] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 19th day of June"
y[154] <- "KENNETH G. RONQUILLO, MD, MPHM"

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 48,
                section = section,
                date = as.Date("22/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution48 <- tibble::tibble(y)

usethis::use_data(iatfResolution48, overwrite = TRUE, compress = "xz")

## Resolution 49 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 49) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:6, 8:41, 49:57, 60:75, 78:86, 94:111, 118:149)]
y <- y[y != ""]

y[1:3] <- c("Republic of the Philippines",
            "Inter-Agency Task Force",
            "for the Management of Emerging Infectious Diseases")

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "l\\.", replacement = "1.") %>%
  stringr::str_replace_all(pattern = "fo ", replacement = "to ") %>%
  stringr::str_replace_all(pattern = "2\\%", replacement = "3.") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "I")

y[81] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[82] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[83] <- "IATF Chairperson         IATF Co-Chairperson"
y[94] <- "5. In the Regular Meeting of the IATF held on 25th of JUNE 2020 via teleconference during"
y[95] <- "which a quorum was present and acted throughout, IATF Resolution No. 49 was"
y[102] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 25th day of June"
y[103] <- "2020, Manila."
y[104] <- "KENNETH G. RONQUILLO, MD, MPHM"

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 49,
                section = section,
                date = as.Date("25/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution49 <- tibble::tibble(y)

usethis::use_data(iatfResolution49, overwrite = TRUE, compress = "xz")

## Resolution 50 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 50) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:3, 5:7, 9:56, 64:95)]
y <- y[y != ""]

y[1:3] <- c("Republic of the Philippines",
            "Inter-Agency Task Force",
            "for the Management of Emerging Infectious Diseases")

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "lg ", replacement = "1.") %>%
  stringr::str_replace_all(pattern = "\\|", replacement = "I")

y[30] <- "ii. Ensuring the protection of vulnerable populations;"
y[37] <- "economy."
y[40] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[41] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[42] <- "IATF Chairperson         IATF Co-Chairperson"
y[53] <- "5. In the Regular Meeting of the IATF held on 14th of JUNE 2020 via teleconference during"
y[58] <- "7. The aforesaid resolution has not been altered, modified nor revoked and the same is"
y[61] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 29th day of June"
y[63] <- "KENNETH G. RONQUILLO, MD, MPHM"
y[64] <- "Assistant Secretary, Department of Health"

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 50,
                section = section,
                date = as.Date("29/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution50 <- tibble::tibble(y)

usethis::use_data(iatfResolution50, overwrite = TRUE, compress = "xz")

## Resolution 50A ##############################################################

y <- pdf_ocr_text(pdf = "data-raw/IATF/20200629-IATF-RESOLUTION-NO-50A.pdf") %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(2:4, 6:8, 10:49, 58:96, 103:121, 128:159)]
y <- y[y != ""]

y[1:3] <- c("Republic of the Philippines",
            "Inter-Agency Task Force",
            "for the Management of Emerging Infectious Diseases")

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "l\\.", replacement = "1.")

y[88]  <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[89]  <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[90]  <- "IATF Chairperson         IATF Co-Chairperson"
y[94]  <- "2. I am the designated Head of the Secretariat of the Inter-Agency Task Force (IATF)"
y[101] <- "5. In the Regular Meeting of the IATF held on 29th of JUNE 2020 via teleconference during"
y[102] <- "which a quorum was present and acted throughout, IATF Resolution No. 5OA was"
y[109] <- "IN WITNESS WHEREOF, I have hereunto affixed my signature this 29th day of June"

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1
cStart <- which(stringr::str_detect(string = y, pattern = "CERTIFICATE|CERTIFICATION"))
eEnd   <- cStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:eEnd]      <- "endorsement"
section[cStart:length(y)] <- "certification"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 50,
                section = section,
                date = as.Date("29/06/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution50A <- tibble::tibble(y)

usethis::use_data(iatfResolution50A, overwrite = TRUE, compress = "xz")

## Resolution 51 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 51) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(1:3, 5:7, 9:44, 54:103, 111:124)]
y <- y[y != ""]

y[1:3] <- c("Republic of the Philippines",
            "Inter-Agency Task Force",
            "for the Management of Emerging Infectious Diseases")

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF")

y[82] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[83] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 51,
                section = section,
                date = as.Date("02/07/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution51 <- tibble::tibble(y)

usethis::use_data(iatfResolution51, overwrite = TRUE, compress = "xz")

## Resolution 52 ###############################################################

y <- iatfLinksGazette %>%
  get_iatf_pdf(id = 52) %>%
  pdf_ocr_text() %>%
  stringr::str_split(pattern = "\n") %>%
  unlist()

## Restructure text
y <- y[c(2:4, 6:8, 9:50, 58:88, 96:127)]
y <- y[y != ""]

y[1:3] <- c("Republic of the Philippines",
            "Inter-Agency Task Force",
            "for the Management of Emerging Infectious Diseases")

y <- y %>%
  stringr::str_replace_all(pattern = "\\[ATF", replacement = "IATF") %>%
  stringr::str_replace_all(pattern = "as \\|", replacement = "as") %>%
  stringr::str_replace_all(pattern = "Tourism\\; \\|", replacement = "Tourism;") %>%
  stringr::str_replace_all(pattern = "and \\|", replacement = "and") %>%
  stringr::str_replace_all(pattern = "restrictions\\; \\|", replacement = "restrictions;") %>%
  stringr::str_replace_all(pattern = "travelling\\, \\|", replacement = "travelling,") %>%
  stringr::str_replace_all(pattern = "the \\|", replacement = "the") %>%
  stringr::str_replace_all(pattern = "NTF\\)\\. \\|", replacement = "NTF).") %>%
  stringr::str_replace_all(pattern = "of \\|", replacement = "of") %>%
  stringr::str_replace_all(pattern = "departure\\. \\|", replacement = "departure.") %>%
  stringr::str_replace_all(pattern = "approved\\. \\|", replacement = "approved.") %>%
  stringr::str_replace_all(pattern = "conference\\. \\|", replacement = "conference.")

y[65] <- "Francisco T. Duque III       Karlo Alexei B. Nograles"
y[66] <- "Secretary, Department of Health     Cabinet Secretary, Office of the Cabinet Secretary"
y[67] <- "IATF Chairperson         IATF Co-Chairperson"
y[70] <- "1. I am presently an Assistant Secretary of the Department of Health;"
y[71] <- "2. I am the designated Head of the Secretariat of the Inter-Agency Task Force (IATF)"
y[78] <- "5. In the Regular Meeting of the IATF held on 6th July 2020 via"
y[80] <- "Resolution No. 52 was unanimously approved and adopted;"
y[83] <- "7. The aforesaid resolution has not been altered, modified nor revoked and the same is"
y[86] <- "In witness whereof, I have hereunto affixed my signature this 7th day of July"
y[88] <- "KENNETH G. RONQUILLO, MD, MPHM"

## Add section
pStart <- which(stringr::str_detect(string = y, pattern = "WHEREAS"))[1]
oStart <- which(stringr::str_detect(string = y, pattern = "RESOLVED"))[1]
pEnd   <- oStart - 1
eStart <- which(stringr::str_detect(string = y, pattern = "APPROVED"))[1]
oEnd   <- eStart - 1

section <- NULL
section[1:6]              <- "heading"
section[pStart:pEnd]      <- "preamble"
section[oStart:oEnd]      <- "operative"
section[eStart:length(y)] <- "endorsement"

y <- data.frame(linenumber = 1:length(y),
                text = y,
                source = "IATF",
                type = "resolution",
                id = 52,
                section = section,
                date = as.Date("06/07/2020", format = "%d/%m/%y"),
                stringsAsFactors = FALSE)

iatfResolution52 <- tibble::tibble(y)

usethis::use_data(iatfResolution52, overwrite = TRUE, compress = "xz")
