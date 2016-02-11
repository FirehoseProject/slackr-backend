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

**Authneticate a user**.  


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

### Chat Messages

**Create a message**  The following API command will both create a chat message in the database and push it into Firebase as well.

| *HTTP Verb* | *URL*           |
|-------------|:---------------:|
| POST        |  /chat_messages |

Expects a payload in the following format (with dummy data loaded in it):

```
{
  "user": {
    "body" : "Hello!",
    "user_id": 1
  }
}
```

The following CURL command will trigger the action.

```
curl -H "Content-type: application/json" -d '{ "chat_message": { "body" : "Hello!", "user_id": 1} }' 'http://localhost:3000/chat_messages'
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
