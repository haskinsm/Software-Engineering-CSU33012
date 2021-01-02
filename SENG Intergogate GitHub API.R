
##Below are packages necessary for program, installs only need to be run once:
#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)


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
  ## Not yet sure if will have to put the above in toString(<.....>) func.
  
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

colnames(usersRepoDataFrame) ## Lists the colnames present in the data frame for each repo




## Now will Visualize the data. 

#install.packages("plotly")     
## Note it is very important that library(plotly) is called after no longer need to use the httr library 
##  As they have conflicting name types (E.g. config). If library(plotly) is called before the httr requests 
## the project will fail to execute.
library(plotly)
# ?plot_ly
## plot_ly is commonly used to plot data coming from data frame in R. 

## Immediatly below are my credentials for Plotly API, I will be creating a dashboard of all the generated plots.
## The dashboard will change automatically if any of the plots in it are changed. i.e if I run the same plot again with different 
## data the new plot will replace the old one automatically. 
# **********Decided against including the following 6 graphs in the dashboard

#Sys.setenv("plotly_username" = "haskinsm")
#Sys.setenv("plotly_api_key" = "UfGcCx74or1XPr1ZDhzo") 

plotRepoData1 = plot_ly(data = usersRepoDataFrame, x = ~watchers_count, y = ~size, type = "scatter", mode="markers") %>% layout(title="Repo Size (in Kb) vs Repo Watcher Count")
plotRepoData1
#api_create(plotRepoData1, filename = "Repo Size (in Kb) vs Repo Watcher Count")

plotRepoData2 = plot_ly(data = usersRepoDataFrame, x = ~created_at, y = ~size) %>% layout(title="Repo Size (in Kb) vs Repo creation Date")
plotRepoData2
#api_create(plotRepoData2, filename = "Repo Size (in Kb) vs Repo creation Date")

plotRepoData3 = plot_ly(data = usersRepoDataFrame, x = ~created_at, y = ~watchers_count) %>% layout(title="Repo Watchers Count vs Repo creation Date")
plotRepoData3
#api_create(plotRepoData3, filename = "Repo Watchers Count vs Repo creation Date")

plotRepoData4 = plot_ly(data = usersRepoDataFrame, x = ~forks_count, y = ~watchers_count) %>% layout(title="Repo Watchers Count vs Repo Forks Count")
plotRepoData4
#api_create(plotRepoData4, filename = "Repo Watchers Count vs Repo Forks Count")

plotRepoData5 = plot_ly(data = usersRepoDataFrame, x = ~open_issues, y = ~size) %>% layout(title="Repo Size (in Kb) vs Repo open issues")
plotRepoData5
#api_create(plotRepoData5, filename = "Repo Size (in Kb) vs Repo open issues")

plotRepoData6 = plot_ly(data = usersRepoDataFrame, x = ~created_at, y = ~open_issues) %>% layout(title="Repo open issues vs Repo creation date")
plotRepoData6
#api_create(plotRepoData6, filename = "Repo open issues vs Repo creation date")



userAccData = fromJSON(paste("https://api.github.com/users/",gitHubUsername, sep=""))
# userAccData ## This will display all the info/data that is returned from the get request

## Data can be easily accessed as is done below: 
# userAccData$public_repos
# userAccData$followers

## Will print basic summary info of account
print( paste(userAccData$name, "whose GitHub username is", userAccData$login, "created his/her account on", userAccData$created_at,
              ".", userAccData$name, "has", userAccData$public_repos, "public repos and", userAccData$followers, "followers.") )
## i.e.: "Oleg Grenrus whose GitHub username is phadej created his/her account on 2009-02-02T11:18:45Z . Oleg Grenrus has 537 public repos and 422 followers."
GHUsersFullName = userAccData$name


colnames(usersRepoDataFrame) 
dim(usersRepoDataFrame)[1]
usersRepoDataFrame$name[[1]][1]
requesturl = paste("https://api.github.com/repos/", gitHubUsername, "/", usersRepoDataFrame$name[[1]][1],"/commits", sep = "")
GHAPIResponse <- GET( requesturl, gtoken)
stop_for_status(GHAPIResponse)

CommitDataFrame = list()
CommitDataFrame = jsonlite::fromJSON(jsonlite::toJSON( (content(GHAPIResponse)) ) )
colnames(CommitDataFrame)
dim(CommitDataFrame)
CommitDataFrame$commit$author$name
CommitDataFrame$commit$author$date


allCommitsDataFrame = list()
allCommitsDataFrame = data.frame(
  commitDate = integer(),
  commitTime = integer(),
  commitTimeMin = integer(),
  commitTimeHr = integer()
)

requesturl = ""
for( i in 1:dim(usersRepoDataFrame)[1]){ ## Will iterate 538 times (the num of repos user phadej has)
  
  requesturl = paste("https://api.github.com/repos/", gitHubUsername, "/", usersRepoDataFrame$name[[i]][1],"/commits", sep = "")
  GHAPIResponse <- GET( requesturl, gtoken)
  stop_for_status(GHAPIResponse)
  
  CommitDataFrame = list()
  CommitDataFrame = jsonlite::fromJSON(jsonlite::toJSON( (content(GHAPIResponse)) ) )
  i= i + 1
  for( j in 1:dim(CommitDataFrame)[1]){
    if( CommitDataFrame$commit$author$name[[j]] == GHUsersFullName){ ## Only account for the commit if its by Oleg Genru the owner of account Phadej
      ## Example of commit date&time: "2017-03-05T21:30:30Z"
       date = strsplit(CommitDataFrame$commit$author$date[[j]], "T")[[1]][1]
       time = strsplit(strsplit(CommitDataFrame$commit$author$date[[j]], "T")[[1]][2], "Z" )[[1]][1]
       timeNearestMin = substr(strsplit(CommitDataFrame$commit$author$date[[j]], "T")[[1]][2], start = 1, stop = 5)
       timeNearestHr = substr(strsplit(CommitDataFrame$commit$author$date[[j]], "T")[[1]][2], start = 1, stop = 2)
       ## or to give to nearest min: substr(strsplit(CommitDataFrame$commit$author$date[[j]], "T")[[1]][2], start = 1, stop = 5)
       allCommitsDataFrame[nrow(allCommitsDataFrame)+1, ] = c( date, time, timeNearestMin, timeNearestHr)
    }
    j = j + 1
  }
}
dim(allCommitsDataFrame)
##allCommitsDataFrame$commitDate = as.Date(allCommitsDataFrame$commitDate, format = "%Y/%m/%d")
##allCommitsDataFrame[order(allCommitsDataFrame$commitDate), ]

plotCommitsDate = plot_ly(x = as.Date(allCommitsDataFrame$commitDate, format = "%Y-%m-%d"), type = 'histogram') %>% layout(title="Count of Commit history by user", yaxis = list(title = "Count"))
plotCommitsDate
api_create(plotCommitsDate, filename = "Commit History of user")

plotCommitsTimeMin = plot_ly(data = allCommitsDataFrame, x = ~commitTimeMin, type = 'histogram' ) %>% layout(title="Productivity", yaxis = list(title = "Count"))
plotCommitsTimeMin
api_create(plotCommitsTimeMin, filename = "Productivity")

plotCommitsTimeHr = plot_ly(data = allCommitsDataFrame, x = ~commitTimeHr, type = 'histogram' ) %>% layout(title="Count of commits at different hours of the day", yaxis = list(title = "Count"))
plotCommitsTimeHr
api_create(plotCommitsTimeHr, filename = "Count of commits at different hours of the day")


#install.packages("dash")
#library(dash)
#library(dashCoreComponents)
#library(dashHtmlComponents)


