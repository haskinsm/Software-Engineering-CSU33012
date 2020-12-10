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
APIResponse <- GET(paste("https://api.github.com/users/", gitHubUsername,"/repos", sep = ""), gtoken)
## The paste function above functions like 

# Take action on http error
stop_for_status(APIResponse)

# Extract content from a request
JSONData = content(APIResponse)

# Convert to a data.frame
gitDataFrame = jsonlite::fromJSON(jsonlite::toJSON(JSONData))

# Subset data.frame
gitDataFrame[gitDataFrame$full_name == paste(gitHubUsername,"/datasharing"), "created_at"] 

data = fromJSON(paste("https://api.github.com/users/",gitHubUsername))
data ## This will display all the info/data that is returned from the get request

## Data can be easily accessed as is done below: 
data$public_repos
data$followers


