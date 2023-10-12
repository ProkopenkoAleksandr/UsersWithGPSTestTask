# UsersWithGPSTestTask

### Technical specifications

It is necessary to develop an application that displays a list of people and the distance from them to the user

**Search screen:**

* Each list element must contain an avatar, name and distance to the user;
* The user's position must be obtained from GPS;
* When you click on a person, information about him is pinned above the list and does not disappear when scrolling;
* While there is a selected person, the distance of other people will be selected relative to the selected one

All data about people and their coordinates must be obtained from the service. A service is an entity that imitates working with a service, that is, a stub for a network layer. Every three seconds, the position of people should change with a random displacement. There are no other requirements for the service, the list of its “requests” and the data format

### Description
#### Architecture
MVVM + Coordinator (preferred as it was indicated in the vacancy)

#### UI
UIKit without Storyboard and XIBs, only layout with code

#### Improvements
Additionally, error handling was made if the user denies access to geolocation
