A portfolio site with AJAX, pushstate, and an admin panel

** INSTALLING **


 - Clone repo
 - Bundle install
 - db:setup
 - db:migrate
 - Rails test should be GREEN





**TO DO**




- Add error messages for AJAX requests
- Slide picker numbers after load
- scrollbar click to take to that point
- There's a bug with blog tab JS where it incorrectly goes remembers the first post that you load - probably has something to do with replaceState, but haven't taken the time to look at it more closely




** IN PROGRESS **

- I should probably make the touch evt listeners always work and just constrain the menu height modifications on the menuToggle() func to clWidth<481

- Add the correct partial to display error messages to admin pages
- Add checks for error messages display on tests
- Make AJAX request for active-post not fail
- Use css height instead of the animation thingy on contact tab mobile
- Make scrollbar fadeout + disappear, then reappear when moved or its area clicked
- add stop propagation to scrollbutton;
- make flashes respond to different messages (ok message, info, danger, etc) and style them appropiately


- remove ability of non admins to see the delete psot button for other users' posts
- center flash messages/error messages

-Chrome 54 beta has a weird bug with image height: auto when setting a width(should be proportional but is now setting height to the minimum) - Need to check if it happens on win Chrome 53 (doesnt on linux Chrome 53 nor firefox latest stable)

- Polish the formatting on the non admin user pages


- Add image uploading (given heroku's conditions, it might be best to use S3 from the start)
- Related to ^, add SendGrid for mails, postgres for DB and whatever other production env changes are necessary to pass to production
- reassemble the manifest files for the asset pipeline into 2 files: main and admin

**DONE**

- Styled users index, new/edit user, edit profile
- Add blog post 404 message
- Post previews on admin page  
- Make URLs case insensitive
- Add vanity URLs to blog posts (slugs are unique, and are automatically created from title (with tags stripped & w/ 	  parameterize)
- Show posts on blog tab from newest to oldest (currently its oldest to newest)
- Decide on a css for the active post, since the one I have right now is not viable to use on different screen sizes
- Correctly assign the "active-post" class to the active post so it gets the correct css
- Fix blog tab mobile formatting
- Add redirection tests for case insensitive URLs
- Make scrollbar event listeners go to content-Tabs[0] instead of doc so they're taken out by the garbage collector when loading a different tab
- Fix post-sidebar-link CSS (Needs to overflow and keep size instead of becoming smaller w/ every post)
-login page styling
- Make the checkbox on login modify the remember state
- Fixed remember login related problems (now remembers/forgets as intended

- Add account activation and password forget to users + tests
- contact mailer test
- Format the admin pages somewhat decently

** OPTIONAL **


These are "would be nice to have"s  

- Facebook comments on blog posts  
- JSON based AJAX translations  
- Polishing the new post page, the inline editor looks weird and the normal editor looks too big.