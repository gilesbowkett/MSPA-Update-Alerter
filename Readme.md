MSPA Update Detector
====================

The idea
--------

Rather than check mspaintadventures.com several times a day, have a cron job check it and alert you to new updates.

How It Works
------------

The site maintains a list of "Latest Pages," separated by `<br>` elements. The code screenscrapes this list and stores the first element in a database. Then, whenever the first element changes, it grabs all the new elements, opens them in your web browser, and then throws them all away, storing only the newest update in the database.

Installation & Setup
--------------------

First run initialize_database.rb to create a SQLite DB with the appropriate schema, and populate it with the latest update from mspaintadventures.com. Then set up a cron job to run read_mspa.rb on some periodic interval. I recommend once a week, on Saturday, because it kind of gives you a Saturday morning cartoons from beyond the Mountains of Madness experience, but your mileage may vary, so season to taste.

