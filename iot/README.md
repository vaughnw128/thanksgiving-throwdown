put stuff for iot devices here

## Fridge
There is a setup.py that needs to be run to create the sqlite database and fill the tables.
You can edit the tables for whatever you want to be scored.
This should then be removed since it makes recovery too easy for blue team.

You need to kill the www service so app can bind to port 80.

By default it creates a user `root:root` for logging in.

## Oven
Similar to fridge, there's a setup.py that needs to be run to create the necessary files.
It's super basic but still shouldn't be given to blue team.


You need to kill the www service so app can bind to port 80.

By default it creates a user `root:root` for logging in.

