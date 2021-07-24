# CineMatch

## **NUS Orbital (CP2106 Independent Software Development Project)**

Kaushik Rangaraj & Kaushik Kumar

# Table of Contents

- Status
- Tech Stack
- How to Setup
- Features

# Status

App is in the development stage

# Tech Stack

- iOS Storyboard
- Firebase

# **How to Setup**

1. To use CineMatch, clone from Github. Open XCode and click “Clone an existing project” and paste the repository URL. 
2. If the following message shows up when running the simulator:  “"No supported iOS devices are available. Connect a device to run your application or choose a simulated device as the destination”, check if XCode version is up to date. Else, change iOS version to relevant version (i.e. 14.3 or lower)
3. On the top left corner of XCode, change the iOS Simulator to iPhone 11 for optimal experience.
4. Build and run the project
5. Below are the relevant descriptions of each page of the app to support new users

# **Features**

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
| Back   | Leads User back to Login Page       |


**Profile Page**

*Account details of User (Profile picture, Username, Email, Region)*
*Able to log out of account from this page*

| Text field     | Function   |
| ----------- | ----------- |
| Username     | User is able to modify Username       |

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | -       |
| Log Out   | Logs User out of account and leads to Home Page        |

| Image View     | Functions   |
| ----------- | ----------- |
| Profile Picture     | User is able to add & modify profile picture       |

| Pickerview     | Function   |
| ----------- | ----------- |
| Region     | User is able to select & modify region of user       |

**Home Page**

*Friends of User displayed here (Click on friend to start new session / click on restore button to go to access past sessions)*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | -       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Friend Requests   | Leads to Friend Requests Page        |
| Swipe   | Leads to Movie Swipe Page        |
| Friends     | Leads to Matches Page      |


**Search Page**

*Via Search Bar, search up friends of User to add as friend*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | -        |
| Profile     | Leads to Profile page       |
| Add button on respective user (displayed only if users are not friends)  | Sends friend request to user if users are not friends / friend request not sent before   |

**Friend Requests Page**

*Friend Requests Received displayed here (Username & Profile Picture of other user serve as labels)*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Back   | Returns to Home Page       |
| Add button on respective friend request     | Accepts friend request of user       |
| Decline button on respective friend request     | Declines friend request of user       |

**Movie Matches Page**

*Matches made with friend displayed here*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Back   | Returns to Home Page       |
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

**Movie Info Page**

*Displays further relevant details about movie i.e. Directors, Cast*

| Buttons     | Functions   |
| ----------- | ----------- |
| Home     | Leads to Home Page       |
| Search   | Leads to Search Page        |
| Profile     | Leads to Profile page       |
| Back   | Returns to Past Sessions Info Page       |
