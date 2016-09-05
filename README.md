A portfolio site with AJAX, pushstate, and an admin panel

** INSTALLING **


 - Clone repo
 - Bundle install
 - db:setup
 - db:migrate
 - Rails test should be GREEN





**TO DO**


- Format the admin pages somewhat decently
- Add the correct partial to display error messages to admin pages
- Add checks for error messages display on tests
- Add account activation and password forget to users
- Add image uploading (given heroku's conditions, it might be best to use S3 from the start)
- Related to ^, add SendGrid for mails, postgres for DB and whatever other production env changes are necessary to pass to production
- Fix post-sidebar-link CSS (Needs to overflow and keep size instead of becoming smaller w/ every post)
- Add error messages for AJAX requests
- Post previews on admin page


** IN PROGRESS **






**DONE**

- Make URLs case insensitive
- Add vanity URLs to blog posts (slugs are unique, and are automatically created from title (with tags stripped & w/ 	  parameterize)
- Show posts on blog tab from newest to oldest (currently its oldest to newest)
- Decide on a css for the active post, since the one I have right now is not viable to use on different screen sizes
- Correctly assign the "active-post" class to the active post so it gets the correct css
- Fix blog tab mobile formatting
- Add redirection tests for case insensitive URLs


** OPTIONAL **

These are "would be nice to have"s
- Facebook comments on blog posts
- JSON based AJAX translations





