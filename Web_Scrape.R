library(rvest)
library(stringr)

Scraping <- function(htmlObject) { 
  linkrow <- htmlObject %>% html_nodes(xpath = '//h3[@class="c-teaser__title"]/a/@href') %>%  html_text()
  return (linkrow)
}

Scraping_final <- function(page){
   DOI1 <- page %>% html_nodes(xpath = '//p[@class="ArticleDOI"]/a') %>% html_text()
   DOI <- strsplit(DOI1, "https://doi.org/")[[1]][2]
   download_html(DOI1, basename(paste(DOI,".html",sep = "")))
   name <- strsplit(DOI, "/")[[1]][2]
   name <- paste(name,".html",sep = "")
   file.rename(from = name, paste0(strsplit(DOI, "/")[[1]][1], name))
   Title <- page %>% html_nodes(xpath = '//h1[@class="ArticleTitle"]') %>% html_text()
   B <- page %>% html_nodes(xpath = '//ul[@class="u-listReset"]/li/span') %>% html_text()
   Authors <- vector()
   for(i in 1:length(B)){
     Authors = c(Authors, B[i])
   }
   Author_Affiliations <- NA
   A <- page %>% html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "hasAffil", " " ))]') %>% html_text()
   Corresponding_Author <- vector()
   for(i in 1:length(A)){
     if(length(str_subset(A[i], "Email"))>0){
        Corresponding_Author = c(Corresponding_Author,strsplit(A[i],"[0-9]+(.*)?Email")[[1]][1])
     }
   }
   Corresponding_Author_Email <- page %>% html_nodes(xpath = '//a[@class="EmailAuthor"]/@href') %>% html_text()
   Publication_Date <- page %>% html_nodes(xpath = '//li[@class="History HistoryOnlineDate"]/span') %>% html_text()
   Abstract <- page %>% html_nodes(xpath = '//*[(@id = "Abs1")]') %>% html_text()
   Keywords <- page %>% html_nodes(xpath = '//li[@class="c-keywords__item"]') %>% html_text()
   Full_Text <- page %>% html_nodes(xpath = '//article') %>% html_text()
   final1<-cbind(DOI,Title,Authors,Author_Affiliations,Corresponding_Author,Corresponding_Author_Email,Publication_Date,Abstract,Keywords,Full_Text)
   return(final1)
}

url = "https://bmcmedgenet.biomedcentral.com/articles"
Page01 <- read_html(url)
links = Scraping(Page01)
for (i in 1:length(links)) {
  links[i] = strsplit(links[i], "/articles")[[1]][2]
  links[i] = paste(url, links[i], sep = "")
  page <- read_html(links[i])
  D<-Scraping_final(page)
  final2<-rbind(final2,D)
  print(i)
}
final3<-rbind(c("DOI", "Title", "Authors", "Author_Affiliations", "Corresponding_Author", "COrresponding_Author_Email", "Publication_Date", "Abstract", "Keywords", "Full_Text"),final2)
dput(final3, "BMC Medical Genetics.txt")
