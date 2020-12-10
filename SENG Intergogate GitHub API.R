
##Below are packages necessary for program, installs only need to be run once:
#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
#install.packages("plotly")
library(plotly)


gitHubUsername = "phadej" ##Makes it easy to change the username of base GitHub user we want to interrogate

GitHubSENGMeasApp <- oauth_app(appname = "SENG_Meas_App", ## My GitHub App Link: https://github.com/settings/applications/1429513
                   key = "b9f9199e609b083310c1", ##Client ID of APP
                   secret = "d3c7fe1b7ca7f782f82bc798f3cdab4c0c9e1e5b") ##Client secret genereated from the SENG_Meas_App page on GitHub

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), GitHubSENGMeasApp)

# Use API
gtoken <- config(token = github_token)

## Below Code aims to deal with pagnation aspect of GitHub API
lastPageNumber = 1 ## This will be changed should there be more pages
JSONDataPagesDataFrame = list()
i = 0 ## Will be used to index the list
address = paste("https://api.github.com/users/", gitHubUsername,"/repos", sep = "") 
## The paste function above concats the strings

while( i <  lastPageNumber ){ 
  i = i + 1 ## List has to start at index 1 in R
  APIResponse <- GET( address, gtoken)
  
  ## Take action on http error
  stop_for_status(APIResponse)
  
  # APIResponse$headers$link
  ## This will yield the following output for example:
  ## [1] "<https://api.github.com/user/51087/repos?page=2>; rel=\"next\", <https://api.github.com/user/51087/repos?page=18>; rel=\"last\""
  ## Need to break the above down to get out the first link with the help of strsplit function
  
  ## #strsplit(APIResponse$headers$link, "<") will result in e.g. : 
  ## [[1]]
  ## [1] ""                                                               
  ## [2] "https://api.github.com/user/51087/repos?page=2>; rel=\"next\", "
  ## [3] "https://api.github.com/user/51087/repos?page=18>; rel=\"last\"" 
  
  ## strsplit(APIResponse$headers$link, "<")[[1]][2] will result in e.g. :
  ## [1] "https://api.github.com/user/51087/repos?page=2>; rel=\"next\", "
  
  ## strsplit( strsplit( (strsplit(APIResponse$headers$link, "<")[[1]][2]) , ">")[[1]][1] , " ")[[1]][1] will result in e.g.:
  ## [1] "https://api.github.com/user/51087/repos?page=2"
  ## Can not send the above as a get request to GitHub V3 API
  ## Not yet sure if will have to put the above in toString(<.....>) func
  
  ## On first pass will set the last page number if there is more than one page of repos and address for 2nd page
  if( i == 1 && !is.null(APIResponse$headers$link) ){
    lastPageNumber = strtoi( strsplit( (strsplit(APIResponse$headers$link, "=")[[1]][4]) , ">")[[1]][1]  ) ## Returns last page number and changes to int
    address = strsplit( strsplit( (strsplit(APIResponse$headers$link, "<")[[1]][2]) , ">")[[1]][1] , " ")[[1]][1] ## Find explanation for this func above
  } else if (!is.null(APIResponse$headers$link)){ ## Set the page number for remaining pages
    address = paste( strsplit(address, "=")[[1]][1], "=", (i + 1) , sep = "") ## Will increment address to next page
  }
  
  # Pages will be stored in below list as seperate data frames and later binded outside of this while loop using rbind_pages()
  JSONDataPagesDataFrame[[i]] = jsonlite::fromJSON(jsonlite::toJSON( (content(APIResponse)) ))
}

usersRepoDataFrame = rbind_pages( JSONDataPagesDataFrame )

# usersRepoDataFrame$name[[100]]## Outputs name of 100th repo
# usersRepoDataFrame$name ## Outputs all names of users repos

# usersRepoDataFrame$size ## The size var lacks documentation in GitHub API Doc, 
## but from research I beleive it approximates the size of a repo in Kb
## This could be used as a crude approx of prpject size/complexity

# usersRepoDataFrame$watchers_count ## Count of watchers

# usersRepoDataFrame$created_at

## usersRepoDataFrame$owner$login ##  Yields useful unfort, all repos owners login details are phadej
## So will assume he created all the projects

#colnames(usersRepoDataFrame) ## Lists the colnames present in the data frame for each repo

# ?plot_ly
## plot_ly is specifically used to plot data coming from data frame in R
plotRepoData1 = plot_ly(data = usersRepoDataFrame, x = ~watchers_count, y = ~size) %>% layout(title="Repo Size vs Repo Watcher Count")
plotRepoData1

plotRepoData2 = plot_ly(data = usersRepoDataFrame, x = ~created_at, y = ~size) %>% layout(title="Repo Size vs Repo creation Date")
plotRepoData2

plotRepoData3 = plot_ly(data = usersRepoDataFrame, x = ~created_at, y = ~watchers_count) %>% layout(title="Repo Watchers Count vs Repo creation Date")
plotRepoData3

plotRepoData4 = plot_ly(data = usersRepoDataFrame, x = ~forks_count, y = ~watchers_count) %>% layout(title="Repo Watchers Count vs Repo Forks Count")
plotRepoData4

plotRepoData5 = plot_ly(data = usersRepoDataFrame, x = ~open_issues, y = ~size) %>% layout(title="Repo Size vs Repo open issues")
plotRepoData5

plotRepoData6 = plot_ly(data = usersRepoDataFrame, x = ~created_at, y = ~open_issues) %>% layout(title="Repo open issues vs Repo creation date")
plotRepoData6



userAccData = fromJSON(paste("https://api.github.com/users/",gitHubUsername, sep=""))
# userAccData ## This will display all the info/data that is returned from the get request

## Data can be easily accessed as is done below: 
# userAccData$public_repos
# userAccData$followers

## Will print basic summary info of account
print( paste(userAccData$name, "whose GitHub username is", userAccData$login, "created his/her account on", userAccData$created_at,
              ".", userAccData$name, "has", userAccData$public_repos, "public repos and", userAccData$followers, "followers.") )
