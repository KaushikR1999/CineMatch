# CineMatch_v1

1. To use CineMatch, clone from Github. Open XCode and click “Clone an existing project” and paste the repository URL. 
2. If the following message shows up when running the simulator:  “"No supported iOS devices are available. Connect a device to run your application or choose a simulated device as the destination”, check if XCode version is up to date. Else, change iOS version to relevant version (i.e. 14.3 or lower)
3. Build and run the project
4. Below are the relevant descriptions of each page of the app to support new users


**Login Page**

*User either logs into account / clicks on sign up here to go to Sign up Page*

| Text fields   | Functions |
| -----------   | ----------- |
| Email Address | User types in email address|
| Password      | User types in password|

| Buttons     | Functions   |
| ----------- | ----------- |
| Login   | Leads User to Home Page if login successful       |
| Sign up here   | New User clicks here to go to Sign Up Page to create new Account       |


**Sign Up Page**

*New User registers for an account*

| Text fields   | Functions |
| -----------   | ----------- |
| Username | New User types in username|
| Email Address | New User types in email address|
| Password      | New User types in password|

| Buttons     | Functions   |
| ----------- | ----------- |
| Sign up here   | Leads New User to Home Page if sign up successful       |


**Profile Page**

*Account details of User (Profile picture, Username, Email, Region)*
*Able to log out of account from this page*

| Text fields     | Functions   |
| ----------- | ----------- |
| Username     | User is able to modify Username       |

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | -       |
| Log Out   | Logs User out of account and leads to Home Page        |


**Home Page**

*Friends of User displayed here (Click on friend to start new session / click on restore button to go to access past sessions)*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | -       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Restore   | Leads to Past Sessions Page        |
| Friends     | Leads to Movie Swipe Page (Creating a new session with respective users)       |


**Search Page**

*Via Search Bar, search up friends of User to add as friend*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | -        |
| Profile     | Leads to Profile page       |


**Past Sessions Page**

*Past sessions with friends displayed here (Data & Name of friend serve as labels)*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Back   | Returns to Home Page       |
| Sessions (Date of Session & Username of Friend)     | Leads to relevant Past Session Info Page       |


**Past Sessions Info Page**

*Matches made during previous session displayed here*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Back   | Returns to Past Sessions Page       |
| Delete      | Deletes the session for both users in question & returns to Past Sessions Page       |
| Rejoin     | Leads to Movie Swipe Page to resume session       |
| Movies (Matches made during session)      | Leads to relevant Movie Info Page       |


**Movie Swipe Page**

*User swipes left on movies they don’t like, & right on movie they do like*
*Button on top right hand corner displays number of matches made during session*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Back   | Returns to Past Sessions Info Page       |
| Movie      | Leads to relevant Movie Info Page       |
| Matches      | Displays number of Matches during sessions & leads to Movie Matches Page       |


**Movie Info Page**

*Displays further relevant details about movie i.e. Directors, Cast*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Back   | Returns to Past Sessions Info Page       |


**Movie Matches Page**

*Matches made during session displayed here*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Back   | Returns to Movie Swipe Page       |
| Movies (Matches made during session)      | Leads to relevant Movie Info Page       |
