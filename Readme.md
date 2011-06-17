MSPA Update Detector
====================

The idea
--------

Rather than check mspaintadventures.com several times a day, have a cron job check it and alert you to new updates. The site maintains a list of "Latest Pages," separated by `<br>` elements. The plan is to screenscrape this list and store the first element in a database. Then, whenever the first element changes, grab all the new elements, and store the new first element in the database. Lather, rinse, repeat. Alert subscribers to the existence of a new page either via e-mail, or Twitter, or indeed even just opening a browser window.

The reality
-----------

I kind of have work to do.

Note to self
------------

`rvm use ruby-1.9.2-p180@mspa`

That should probably go in a .rvmrc file...

