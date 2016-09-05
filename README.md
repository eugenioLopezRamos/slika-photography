
```
#!python

,-----.,--.                  ,--. ,---.   ,--.,------.  ,------.
    '  .--./|  | ,---. ,--.,--. ,-|  || o   \  |  ||  .-.  \ |  .---'
    |  |    |  || .-. ||  ||  |' .-. |`..'  |  |  ||  |  \  :|  `--, 
    '  '--'\|  |' '-' ''  ''  '\ `-' | .'  /   |  ||  '--'  /|  `---.
     `-----'`--' `---'  `----'  `---'  `--'    `--'`-------' `------'
    ----------------------------------------------------------------- 
```



Welcome to your Rails project on Cloud9 IDE!

To get started, just do the following:

1. Run the project with the "Run Project" button in the menu bar on top of the IDE.
2. Preview your new app by clicking on the URL that appears in the Run panel below (https://rails-implementation-e0plus.c9users.io/).

Happy coding!
The Cloud9 IDE team


## Support & Documentation

Visit http://docs.c9.io for support, or to learn more about using Cloud9 IDE. 
To watch some training videos, visit http://www.youtube.com/user/c9ide



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
- Make URLs case insensitive
- Fix post-sidebar-link CSS (Needs to overflow and keep size instead of becoming smaller w/ every post)
- Add error messages for AJAX requests
- Post previews on admin page


** IN PROGRESS **
 -> Need to do validations on slugs(maybe make titles unique) and make slugs all lowercase (also use parameterize to save slugs taking title as input)


**DONE**
- Add vanity URLs to blog posts (slugs are unique, and are automatically created from title (with tags stripped & w/ 	  parameterize)
- Show posts on blog tab from newest to oldest (currently its oldest to newest)
- Decide on a css for the active post, since the one I have right now is not viable to use on different screen sizes
- Correctly assign the "active-post" class to the active post so it gets the correct css
- Fix blog tab mobile formatting

** OPTIONAL **
These are "would be nice to have"s
- Facebook comments on blog posts





