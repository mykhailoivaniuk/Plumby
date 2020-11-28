# Plumby

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)
3. [Update on the Project](#Update-on-The-Project)

## Overview
### Description
Plumby - prototype of the app for the services that ordinary users can request from professionals in order to fix problems that are related to their households. The app would function as a marketplace where professionals such as plumbers, carpenters will offer their service and user will choose the service provider that is best choice for user depending on the user financial situtation, location of the professional and ratings of the service provider. We believe that right now is the best time for this app because of Covid people will reimagine working places or continue working remotely. Thus the ability to effortlessly solve the problems that arise around the house will be essential in near future.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Marketplace
- **Mobile:** This app would be primarily developed for mobile but it will be just as viable on a computer. Functionality wouldn’t be limited to mobile devices, however mobile version would be the main one as it would be the esaiest way for user to request the service.
- **Story:** App connects professionals with people who need to fix some problem in the household(plumbing, renovation etc) but can't do these tasks on their own.
- **Market:** Homeowners, apartment owners.
- **Habit:** People will use this app if they need to do some work around the house tht they can't do on their own. Possible examples are cleaning services, plumbing, tree cutting.
- **Scope:** First we will start with offering only one type of service in some location and later will expand the functionality to include different services.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* [x] Signup - will be one for both users and service providers
* [x] Users stay logged in across app restarts
* [x] Professionals can post their services - post tab: bio info, services that can be provided with prices
* [x] Professionals can discards all changes in the post tab.
* [ ] Users can scroll down the feed with announcements
* [ ] Users can leave reviews for the professional - after they requested the job
* [ ] Users can see personal/contact information of the professional
* [ ] Users can request this job (working as a like button)
* [ ] Users can track requested jobs in tab with current request (also leave reviews there)
* [ ] Professionals can see the history of of their postings - another feed 
* [ ] Professionals contact users through user's personal information given in my publications view

**Optional Nice-to-have Stories**

* [ ] Users can filter for the jobs, prices, choose an area
* [ ] Allow to edit one own's publications
* [ ] Professionals can see the views by the users
* [ ] Specific sign up for professionals and their other screen (login and logout)
* [ ] Direct messaging of the user and the professional
* [ ] Expand on bio - photos, choose from sections and types of work
* [ ] Save to favorites openings and have the saved screen
* [ ] Pay through the app 
* [ ] Expand on the services offered - plumbing, carpeting, etc. 
* [ ] Add profile section with account information
* [ ] Add settings section with notification, my reviews for users

### 2. Screen Archetypes

* Sign Up / Login Screen
   * Both users and professionals can login into existing account or sign up and create a new one

* Feed Screen:
   * Users can see the feed of all possible service they can request
   * Users can see the rating/reviews(it will depepnd on the implementation)
   * Users can request a job

* Creating a publication Screen:
   * Created for professionals to post their services. Porfessionals input description of the job they can do, price, their contact information and location

* My Publications Screen:
   * Users(professionals who provide the service) can see their publications and see all the comments/reviews and contact information of the person who requested their service
   * Professionals later can contact the person who requested their service
* My Requests Screen:
   * Users can see the current status of the service they requested.
   * Users can review the job
 
  

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Feed  
* My Requests
* Create a Publication
* My Publications

**Flow Navigation** (Screen to Screen)

* For ordinary user:
   * Forced Log-in -> Account creation if no log in is available
   * Service Selection in Feed tab -> My Requests Screen
* For Professional:
   * Forced Log-in -> Account creation if no log in is available
   * Feed tab -> Creata a Publication Tab
   * Create a Publication tab -> My publications Tab



## Wireframes
<img src="https://user-images.githubusercontent.com/65302583/99138039-695e4b00-25f3-11eb-8336-6a536ba9dba5.jpg" width=600>

## Schema 
### Models
#### Job Publications

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| name of the author of the publication |
   | title	| String | Title/short summary for the job |
   | price         | Number     | to put on the job posting  |
   | location	| String	| where the author is located |
   | rating       | Array of Numbers   | to calculate the average and put on the job posting |
   | description | String   | to explain what type of job is performed |
   | requests    | Array of Pointers to Requests   | to pull the requests |
   
#### Users

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | userId      | String   | unique id for the user (default field) |
   | username        | String| needed for login, and created at signup |
   | phoneNumber         | String     | needed for login, and created at signup |
   | password       | String   | needed for login, and created at signup |
   | description | String   | to explain what type of job is performed |
   | myPublications    | Array of Pointers to user's job publications   | to see my publications |
   | requestedPublications    | Array of Pointers to user's job publications   | to see requested by me publications |

#### Requests
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the request (default field) |
   | requester        | Pointer to User | reference the customer who requests the work order |
   | requestee         | Pointer to User     | reference the person who will complete the work order |
   | requested_on       | Date object   | the time & date on which the job is requested (epoch in seconds) |
   | post | Pointer to Job Post   | reference the original job posting that is requested |

### Networking
#### List of network requests by screen
   - Home Feed Screen
      - (Read/GET) Query all posts for the general feed
      ``` swift
      	let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "price", "rating"])
        query.limit = 20
        query.findObjectsInBackground{
            (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
      ```
      - (Update/PUT)Request a Job
      ``` swift
      let cell = tableView.dequeueReusableCell(withReuseIdentifier: "PostCell") as! PostTableViewCell
      
      // get the post
      let post = posts[indexPath.row]
      
      // create new request object
      let newRequest = new PFObject(className: "Requests")
      newRequest["requester"] = PFUser.current()!
      newRequest["post"] = post
      newRequest["requestee"] = post["author"]
      newRequest["requested_on"] = Date() // return epoch time in seconds
      
      // add the new request to the post's array of requests
      post["requests"].append(newRequest)
      // save the new request in its table
      newRequest.saveInBackground{
      	(success, error) in
	  if success {
	    // do something
	  } else {
	    // raise error alert
	  }
	 }			
      ```
      
   - My Publications Screen
      - (Read/GET) Query the publications made by me
      ``` swift
      let query = PFQuery(className:"Publication")
      query.whereKey("author", equalTo:"currentUser")
      query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
          if let error = error {
              // Log details of the failure
              print(error.localizedDescription)
          } else if let objects = objects {
              // The find succeeded.
              print("Successfully retrieved \(objects.count) publications.")
              // Do something with the found objects
              for object in objects {
                  print(object.objectId as Any)
              }
          }
      }
      ```
   - Create a Publication Screen
      - (Create/POST) Creating a new job publication
      ```swift
        let publication = PFObject(className:"Publication")
        publication["author"] = "milstetsenko"
        publication["price"] = 75
        publication["description"] = "String"
        publication.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
          }
       ```
  - Requested Publications Screen
    - (Read/GET) Query publications requested by me
    ```swift
    let query = PFQuery(className:"Publication")
    query.whereKey("Requests", equalTo:"currentUser")
    query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
        if let error = error {
            // Log details of the failure
            print(error.localizedDescription)
        } else if let objects = objects {
            // The find succeeded.
            print("Successfully retrieved \(objects.count) publications.")
            // Do something with the found objects
            for object in objects {
                print(object.objectId as Any)
            }
        }
     }
     ```
    -  (Update/PUT) Rate the job after receiving the services
    ```swift
    let query = PFQuery(className:"Publication")
    query.getObjectInBackground(withId: "ObjectId") { (publication: PFObject?, error: Error?) inif let error = error {
        print(error.localizedDescription)
    } else if let publication = publication {
        publication["Rating"].append(Number)
        publication.saveInBackground()
    }
    }
    ```
    
    ## Update on The Project
    ### Sprint 2

    
    
    
    ### Create a Publication Screen:
      #### Coded by Thu
    <img src="" width=600>
    
      ### Login and Signup Screen:
      #### Coded by Mykhailo
    <img src="" width=600>


