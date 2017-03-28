A portfolio site with AJAX, pushstate, and an admin panel

** INSTALLING **

 - Clone repo
 - Bundle install
 - db:migrate
 - Do note that some features require the AWS S3 ENV variables to be set. The tests that depend on them use stubs
 - In dev/test envs emails are not actually sent.
 - Required variables:
 	- ENV['AWS_ACCESS_KEY_ID']
	- ENV['AWS_SECRET_ACCESS_KEY']
	- ENV['AWS_REGION']
	- ENV['AWS_S3_BUCKET']

 - Rails test should be GREEN

You can access the admin panel home localhost:300/admin - Email: "juan@perez.com", password: "password"
File management requires an AWS bucket configured :(
To pass to production some email solution (eg mailgun) should be used, plus postgres or another SQL DB to replace SQLite
Production also uses ENV["CDN"] for CDN. As this was developed using AWS, this was cloudfront but you're free to use whichever you prefer




