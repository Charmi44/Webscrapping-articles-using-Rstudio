Brief explanation of code ---

Lines 4-7: 

This function takes url of main page as argument and returns a vector containing the urls of all the articles.


Lines 9-37: 

Argument - HTML link for all urls of all the articles

Return - Matrix containing values for all the specified fields



The vectors DOI1, Title and B were all scraped from the HTML text of the article url. 
The DOI was formatted to the correct output using strsplit. 
In order to transform B into a vector, a for loop was used to traverse over the length of B. Each value in B was appended to the vector Authors. 
The field Author_Affiliation was assigned value NA because the affiliation does not appear on the web-version of any article.

In order to find corresponding authors, vector A was first created and contains a list of all of the authors. 

Using a for loop, we travese through the length of character vector A. If the string 'Email' appears in one or more of the names, 
the name is added to Corresponding_Author.

The fields Corresponding_Author_Email, Publication_Date, Abstract, Keywords and Full_Text were all also scrapped from the HTML
text of the article url and stored in their respective vectors.


To merge all of the scraped data into a matrix (final1), 



cbind was used to bind all values of the 10 field vectors and this matrix is returned


Lines 39-49: 


For all the article links, 'strsplit' discards 'articles' and store latter data in links[i].
Ex. 10.1186/s12881-018-0705-7


After that 'paste' function will concatenate url with output of links[i].
Ex. 10.1186/s12881-018-0705-7 is appended to https://bmcmedgenet.biomedcentral.com/articles

/10.1186/s12881-018-0705-7

.
After getting all article links.
read_html function will read contents of .html file(articles) and store it into 
variable page. 
page is then passed as an argument of function Scrapping_final to extract required fields.


The result of 
Scrapping_final is stored in D. The contents of D are then appended to matrix final2, which was created to store the Scrapping_final results for all articles. 

Lines 50-51: 

A matrix final3 is created to add column names as the first row, using rbind. Lastly, dput allows storage of the R Object final3 as a txt file in the directory. 
