A portfolio site with AJAX, pushstate, and an admin panel

** INSTALLING **


 - Clone repo
 - Bundle install
 - db:setup
 - db:migrate
 - Do note that the site requires the AWS S3 ENV variables to be set. The tests that depend on them are skipped in case any of them is nil.
 - The checked variables are
 	- ENV['AWS_S3_BUCKET']
	- ENV['AWS_SECRET_ACCESS_KEY']
	- ENV['AWS_S3_REGION']
	- ENV['AWS_S3_BUCKET']
	- You can also confirm this is the case in /test/integration/admin_integration_test.rb

 - Rails test should be GREEN(provided you have set your AWS S3 ENV variables correctly, otherwise it will be yellow - 1 skip)



**TO DO**
- Add folder downloads to file manager
- Add staging env to test the app in the same condition as the production env.
- Add error messages for AJAX requests

- scrollbar click to take to that point
- There's a bug with blog tab JS where it incorrectly goes remembers the first post that you load - probably has something to do with replaceState, but haven't taken the time to look at it more closely


** IN PROGRESS **




- Add checks for error messages display on tests

- Use css height instead of the animation thingy on contact tab mobile
- Make scrollbar fadeout + disappear, then reappear when moved or its area clicked

- remove ability of non admins to see the delete psot button for other users' posts
- Chrome 54 beta has a weird bug with image height: auto when setting a width(should be proportional but is now setting height to the minimum) - Need to check if it happens on win Chrome 53 (doesnt on linux Chrome 53 nor firefox latest stable) -> probably happens in IE/edge too, better set explicit minheight
- Polish the formatting on the non admin user pages
- stop hiding non active-Tab -> its not necessary anymore and can help with perceived load times
- Add 100% minheight to content-Tab CSS and explicit 100% height to slide images
- lazy load images
- Related to ^, add SendGrid for mails, postgres for DB and whatever other production env changes are necessary to pass to production
- reassemble the manifest files for the asset pipeline into 2 files: main and admin



- clean up the file manager javascript, it looks awful right now
- Add file manager mobile controls
- See permission stuff for buckets (ACL, IIRC)
- deselect all but one folder when uploading?

- Add friendly forwarding on admin pages
- Add size limit on uploads/downloads client side and server side

- Server side verification of file -> image
- Disable upload button for 1sec or so to avoid double clicks

**DONE**

- verify that :slug params are safe (or if they need sanitization/parameterization)
- fix posts slug redirecter, it always queries the posts model
- Images are shown according to the first integer on their filename (filename.to_i)
- Test images in production using name instead of a number.
- Make AJAX request for active-post not fail
- I should probably make the touch evt listeners always work and just constrain the menu height modifications on the menuToggle() func to clWidth<481
- add stop propagation to scrollbutton;
- Slide picker numbers after load fixed (no longer gives undefined when going from X tab to Y tab that contains a slider)
- File manager done (includes unit & live integration tests)
- añadir requisito login a file manager
- Multiple files uploads added
- center flash messages/error messages
- need to check what's up with the post model requests in admin pages (it was the Post model reference in the routes file)
- Add image uploading (given heroku's conditions, it might be best to use S3 from the start) 
- make flashes respond to different messages (ok message, info, danger, etc) and style them appropiately
- Add the correct partial to display error messages to admin pages
- Unselect files after a download/deletion is done
- correct bug with going back to root dir on directorize script
- Fix weird symbols on the file names (CGI escape/whatever is needed)
- AJAX reaction on upload success
- Now the app serves CSS/JS from the uglified compiled assets in the repo and image files from an S3 bucket.Both cases use CloudFront as CDN
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