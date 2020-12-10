## Reference: The first 30 or so lines were modified from the src:
## https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08

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
pagination = TRUE 
JSONDataPagesDataFrame = list()
i = 0 ## Will be used to index the list
address = paste("https://api.github.com/users/", gitHubUsername,"/repos", sep = "") 
## The paste function above concats the strings

while(pagination){
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
  
  if( !is.null(APIResponse$headers$link) || APIResponse == "" ){ ## APIResponse$headers$link Will be null if no further pages to get
      address = strsplit( strsplit( (strsplit(APIResponse$headers$link, "<")[[1]][2]) , ">")[[1]][1] , " ")[[1]][1] ## Find explanation for this func above
  } else{
    pagination = FALSE
  }
  # Pages will be stored in below list as seperate data frames and later binded outside of this while loop using rbind_pages()
  JSONDataPagesDataFrame[[i]] = jsonlite::fromJSON(jsonlite::toJSON( (content(APIResponse)) ))
  APIResponse = "" ## Ressetting as trying to fix bug where data repeats
}

usersRepoDataFrame = rbind_pages( JSONDataPagesDataFrame )

# Convert to a data.frame
##usersRepoDataFrame = jsonlite::fromJSON(jsonlite::toJSON(JSONData))
usersRepoDataFrame$name ## Outputs name of repos
##usersRepoDataFrame$size ## The size var lacks documentation in GitHub API Doc, 
## but from research I beleive it approximates the size of a repo in Kb
## This could be used as a crude approx of prpject size/complexity

#plotRepoData = 




userAccData = fromJSON(paste("https://api.github.com/users/",gitHubUsername, sep=""))
userAccData ## This will display all the info/data that is returned from the get request

## Data can be easily accessed as is done below: 
userAccData$public_repos
userAccData$followers

userRepos = fromJSON(paste("https://api.github.com/users/",gitHubUsername, "/repos?per_page=100;", sep=""))
userRepos$size

repoNames = c(userRepos$name)
repoNames
