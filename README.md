# Software-Engineering-CSU33012
First two assignments (LCA) were initially submitted in other repositories, but the source code will be moved into this repository.
If want to see a commit history check the repos ProjectsInVisualStudioCode (For LCA python Version) and JavaProjects (For LCA Java version, this is the version that can handle DAGs).

The final Two assignments:
Initially attempted to do this assignment in Haskell (see Aceess-GitHub-API-MH in ProjectsInVisualStudioCode repo) but abandoned this approach, as although I was able to get the followers of a user and output this JSON it was taking too much time to get more useful data and I decided to instead do these two assignments in RStudio (all commit history will be present in this repo and project is called SENG Interrogate GitHub API) as I am far more familar with R and can take in the data and create nice plots all in the one environement/program.

For this assignment the data used in my graphs is of the Github user phadej, this can be easily changed to another user at the start of the program.

I created a dashboard using the plot_ly library in R which makes use of D3.js library which should be accessible through the following link: https://plotly.com/~haskinsm/6/software-engineering-measurement-dashboard/ 

This dashboard was created using Plotly API. It contains 3 plots which measure the SE prdocutivity of the entered user, phadej. The plots analyse how productive the user is at different times of the day and how more productive they have become over the years (I used commit count of the user to measure his productivity and made sure I only counted commits by the user and did not include collaboraters). The program is able to handle the paganation of the GitHub API and draws data from phadejs 540 repos and all of the commits to those repos. 
The plots in the dashboard will update automatically if for example one changes the username to another GitHub user (and runs the code) other than phadej or runs the code after phadej has made new commits to some repos.

Please find some other examples of the graphs generated, using the plot_ly library in R which makes use of D3.js library, by my R program in png or html format. The html format should be interactive, but PNG format is just a picture. The data is of the user 'phadej'.
