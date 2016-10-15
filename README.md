A portfolio site with AJAX, pushstate, and an admin panel

** INSTALLING **


 - Clone repo
 - Bundle install
 - db:setup
 - db:migrate
 - Do note that the site requires the AWS S3 ENV variables to be set. The tests that depend on them are skipped in case any of them is nil.
 - Required variables:
 	- ENV['AWS_ACCESS_KEY_ID']
	- ENV['AWS_SECRET_ACCESS_KEY']
	- ENV['AWS_S3_REGION']
	- ENV['AWS_S3_BUCKET']
	- You can also confirm this is the case in /test/integration/admin_integration_test.rb

 - Rails test should be GREEN(provided you have set your AWS S3 ENV variables correctly)



**TO DO**

- Add staging env to test the app in the same condition as the production env.

** IN PROGRESS **

_s3_
- See permission stuff for buckets (ACL, IIRC)

_heroku_
- Related to ^, add SendGrid for mails, postgres for DB and whatever other production env changes are necessary to pass to production

_public front end_


- Tab indexes en las paginas en contactTab
- change the bottom bar and contact tab logos to something on the server.
- Same treatment for touch scrollbtn move as for mousedrag
- scrollbar focus evt listener works weird when clicking

_admin panel front end_

- Sort files into files and folders, right now it looks messy.
- Working.... type of message when AJAX is sent but in process.
- Make an option to just upload(instead of creating 9001 versions of the img)

**DONE**

- Change the images on the home tab
- Theres a small bug when moving the slides to the left and to the right or viceversa (to be fixed later, its a small bug.) - Fixed anyway
- when there are too many posts, the bar becomes very slow to drag, need to adjust that
- Scrollbar click not working correctly when theres too many posts, cant get to lower half
- Move scrollbar to focus (post sidebar menu)
- There's a bug with image assignation on blog posts (reproduce by loading post w/ incorrect img route -> load a post with correct img route -> go back to first post, the src of the previous valid post is incorrectly assigned)
Fixed -> Just had to add the getResizedImages function to the ajax calls
- Add ajax tests on staticController (for post_retriever and tabs_retriever)
- Test optimized image creations (in admin integration controller test)
- Add tests on post controller to test that the data-* tabs are added on @post.content
- Polishing the new post page, the inline editor looks weird and the normal editor looks too big.
- Make it not add anything in case aws list objects finds nothing (to handle external imgs)
- Img responsivizer for posts? (check all img tags in the post, remove source, calc appropiate size, fill src) - Done, didnt remove source, it's dynamically replaced in the client so its easier when handling editing
- Add img upload link to post/new(these would be sent to s3/posts/) - slug removed -> Images are uploaded before the post is submitted, so there is no slug // Done, need to responsivize the iamges still though
- Add staticController testing (for the slides). - Done, completes the moving of logic from slidersContent to controller
- Move logic from slidersContent (view) to staticController - Done, testing still to go
- In the spirit of DRYness, change the tab_ getter and post_api routes to use the normal tab/blog routes and respond to format: JS to do their current jobs. Result: tried to do it but I cant specify GET request contentType (http://stackoverflow.com/questions/17725110/jquery-ajax-get-and-contenttype) So I'll be keeping this as it is.
- initial presentation of file manager is wrong (subfolders shown but files hidden)
- clicking the "logo" on mobile should show the full height menu
- on mobile the menu should start expanded -> changed jquery load to after CSS, gets better, and will probably get even better w/uglification/minification
- See someway of not loading the fb script on tab load, its really really slow (probably just load it when clicking the fb button) - Kind of done, loads on startup, but can be reloaded correctly when revisiting (without reloading on every fb button click)
- bug: clicking folders hides subfolders even when not appropiate - Fixed, but code is a bit convoluted
- Add a link to the file manager on the admin panel
- deselect all but one folder when uploading - Done, with confirmations.
- Clears the upload preparation area on xhr end
- Add created files to the file manager (front end)
- Add image slide event listener a los dots tambien - Done, the normal evt listener works since increasing the dots' div minheight (that uses a transparent div) also increses the size of the peopleSlide div (its parent), where the evt listener is, and triggers it because of evt bubbling
- Add loading message to the tab getter requests - Done and fixed a bug about referencing a nonexistant DOM object (the msg banners when changing tabs)
- check the animations on image load, seems like they arent working quite right on first load. - They seem to be working fine now.
- Contact tab is bad. Review - Fixed. Changed animations.
- check the accuracy of the image resizer method on admin controller. -> rray){
Done, refactored the function a bit.
- change |file| to temp_file later (admin controller ln. 240, currently it's called file, same as the iterator of its parent block)
- Use application_ helper size_breakpoints in admin controller instead of own method.
- Server side verification of file -> image
- There's a bug with blog tab JS where it incorrectly goes remembers the first post that you load -> Checked, couldn't make it bug.
- Nav menu looks a bit off on nexus 7 (contact us button) -> done, changed font-size from .navMenu a to .navMenu span then added a declaration on the /* tablet css */ part of the file
- check mid size responsive image loader (nexus 7 doesnt load peopleSlider/1.jpg -> returns "undefined") <- done, refactored function a bit
- Make the slide picker bigger, esp. on mobile <- Took a look at this, in review seems a fine size. Leaving it as is.
- Add error messages for AJAX requests -> done, created something similar to the flash message of the admin pages
- Add fullscreen for the other browsers too -> Added fullscreen API use on the mobile layout for IE/Edge/webkit/moz.
- medium sizes blog tab CSS fixes.
- pointer events none durante la animacion inicial del menu - changed. Couldn't stop touch detection on the whole document, so instead I made it so the evt listeners are assigned after the animation.
- Add error handlers for failed AJAX requests and failed image fetches
- It isn't needed to delete the loading dots, it seems. Also they give a console error when they are removed and it tries to remove them again <- removed the dot-removed :)
- There might be a small bug where the tab flickers due to the active-Tab assignation, need to check it out
- Add folder downloads to file manager
- Add file manager mobile controls
- file manager mobile css
- clear uploads staging zone after request done
- Lazy load images
- Optimizing images w/ imagemagick + frontend
- Convert all dev machine images and S3 images to new formats (just batch the converter on the dirs)
- scrollbar click to take to that point
- **SCRAPPED** Make scrollbar fadeout + disappear, then reappear when moved or its area clicked - I think it'd look weird/would be annoying. Scrapping this idea.
- Use css height instead of the animation thingy on contact tab mobile (turned em units into % and vh's)
- stop hiding non active-Tab -> its not necessary anymore and can help with perceived load times
- Add 100% minheight to content-Tab CSS and explicit 100% height to slide images (correction: it was just too much minheight.)
- Polish the formatting on the non admin user pages
- remove ability of non admins to see the delete psot button for other users' posts
- Sanitize contact form input before sending the email
- Add checks for error messages display on tests (seems to be done)
- Activation email controller test -> integrated into users_signup_test "on valid creation". Probably improvable though.
- Disable choose file for 1sec or so to avoid double clicks (originally said "upload button" - That's already disabled until the AJAX request is resolved)
- clean up the file manager javascript, it looks awful right now (could probably use a refactor though)
- Add size limit on uploads/downloads client side and server side
- Chrome 54 beta has a weird bug with image height: auto when setting a width(should be proportional but is now setting height to the minimum) - Need to check if it happens on win Chrome 53 (doesnt on linux Chrome 53 nor firefox latest stable) -> probably happens in IE/edge too, better set explicit minheight :::::::: 30/09/2016 update seems to have been fixed? Not sure what happened, working correctly in chrome 54 beta & Edge (with which I had height:auto problems before)
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
- Resque queues for upload/convert?
- reassemble the manifest files for the asset pipeline into 2 files: main and admin
- Check if I can use cloudflare instead of cloudFront.
- Add friendly forwarding on admin pages