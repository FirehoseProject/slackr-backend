# Slackr Backend

The Slackr application is broken into two separate applications.  First there is the front-end, where most of the logic in the application lives.

This application is the backend of the application.  This is a standalone rails application that implements a simple API.

## Getting the app up and running.

To start with, on GitHub.com, click the fork button in the top-right corner.  This will make a copy of the project in your GitHub profile.

Next, on the the GitHub page for your copy, copy the URL in the textbox.

Clone the repo by running the command:

```
git clone PASTE-IN-URL
```

Change the directory into the project directory.

```
cd slackr-backend
```

Run the bundle command to install all the relevant gems.

```
bundle install
```

Create the database:

```
rake db:create:all
```

Run the migrations:

```
rake db:migrate
```

Each application will need a unique firebase URL.  Create an account with [Firebase](https://www.firebase.com/).  Create an app, and get a URL that looks like this:

> https://firehose-slackr.firebaseio.com/

Then enter that URL in `config/firebase.yml`.  Then start the rails server by running the following command:

```
rails server -b 0.0.0.0
```

When you go to [http://localhost:4000](http://localhost:4000) you should be presented a landing page for the backend of our application.  That means it's up and running.

## API Documentation

### User Authentication

**Create a user**.  

| *HTTP Verb* | *URL*         |
|-------------|:-------------:|
| POST        |  /users       |

Expects a payload in the following format (with dummy data loaded in it):

```
{
  "user": {
    "email" : "someone@someplace.com",
    "nickname": "someone",
    "password": "secretPassword111"
  }
}
```

The following curl command will trigger the action.

```
curl -H "Content-type: application/json" -d '{ "user": { "email" : "someone@someplace.com", "nickname": "someone", "password": "secretPassword111" } }' 'http://localhost:3000/users'
```

**Authenticate a user**.  


| *HTTP Verb* | *URL*           |
|-------------|:---------------:|
| POST        |  /user_sessions |

Expects a payload in the following format (with dummy data loaded in it):

```
{
  "user": {
    "email" : "someone@someplace.com",
    "password": "secretPassword111"
  }
}
```

The following curl command will trigger the action.

```
curl -H "Content-type: application/json" -d '{ "user": { "email" : "someone@someplace.com", "password": "secretPassword111" } }' 'http://localhost:3000/user_sessions'
```

The response will either include the full user information or if the authentication fails it will return the following JSON message.

```
{"errors":{"email":["Unable to authenticate"]}}
```

The response will include the API key for the authenticated user in the following format.

```
{
  "id": 11,
  "email": "someonekjkkjk@someplace.com",
  "nickname": "someone",
  "created_at": "2016-02-23T01:19:12.544Z",
  "updated_at": "2016-02-23T01:19:12.544Z",
  "gravatar_url": "http://www.gravatar.com/avatar/3534f789c8238f3d3383ccd67e178163?d=http%3A%2F%2Fi.imgur.com%2FUPWvbDz.jpg",
  "api_key": "924c8286905bd0f5b81a26524449783e"
}
```

Passing the user's API key to the service will treat them as the logged in user.

**Logging Out**.  

To logout running the following HTTP request well set the user's API key to `nil`, preventing them from interacting with the application until they login again (when a new API key will be generated).

| *HTTP Verb* | *URL*                              |
|-------------|:----------------------------------:|
| DELETE      |  /user_sessions?api_key=USERAPIKEY |

The following CURL command will trigger the request (adjust the api_key for your specific user):

```
curl -H "Content-type: application/json" -X DELETE 'http://localhost:3000/user_sessions?api_key=USERAPIKEY'
```
### Chat Messages

**Create a message**  The following API command will both create a chat message in the database and push it into Firebase as well.

| *HTTP Verb* | *URL*                              |
|-------------|:----------------------------------:|
| POST        |  /chat_messages?api_key=USERAPIKEY |

Expects a payload in the following format (with dummy data loaded in it):

```
{
  "chat_message": {
    "body" : "Hello!"
  }
}
```

The following CURL command will trigger the action.

```
curl -H "Content-type: application/json" -d '{ "chat_message": { "body" : "Hello!"} }' 'http://localhost:3000/chat_messages?api_key=USERAPIKEY'
```


**List out all chat messages**


| *HTTP Verb* | *URL*           |
|-------------|:---------------:|
| GET         |  /chat_messages |

The following CURL command will trigger it.

```
curl -H "Content-type: application/json" http://localhost:3000/chat_messages
```

The API will clump multiple messages created by the same author into a single message.  The following is an example of the result from the API request.

```
[{
	"user_id": 1,
	"body": "Hello!",
	"nickname": "someone",
	"id": 2,
	"avatar_url": "http://www.gravatar.com/avatar/50e8e8da10dfdfe6169289a99891cfc6?d=http%3A%2F%2Fi.imgur.com%2FUPWvbDz.jpg",
	"messages": ["Hello!", "Second message"],
	"time": "02:08 PM"
}, {
	"user_id": 2,
	"body": "New Author",
	"nickname": "someone",
	"id": 4,
	"avatar_url": "http://www.gravatar.com/avatar/47542a928b78888d91f3b08372e9de61?d=http%3A%2F%2Fi.imgur.com%2FUPWvbDz.jpg",
	"messages": ["New Author"],
	"time": "02:12 PM"
}]
```
