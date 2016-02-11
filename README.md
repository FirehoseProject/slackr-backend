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

*Create a user*.  

| *HTTP Verb* | *URL*         |
|-------------|:-------------:|
| POST        |  /users       |
