# Fridge
This is a very basic flask app for editing and displaying a sqlite database

## High level overview
There is a session cookie that stores your current user. When not logged in, it should be None.
If you're logged in as any user, you have full access to the database, including
- the ability to add/delete from the Ingredients table
- the ability to add/delete users
- the ability to change your own password
If you're not logged in, most pages redirect to /failure, which just informs you to log in.
The /ingredients page does not require log in so it's easy for scoring

## Vulnerability
Current it has a very basic sql injection vulnerability in the log in

