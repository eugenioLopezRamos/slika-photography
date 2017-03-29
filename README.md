A portfolio site with AJAX, pushstate, and an admin panel

**INSTALLING**

 - Clone repo
 - Bundle install
 - db:migrate
 - db:seed
 - Do note that some features require the AWS S3 ENV variables to be set. The tests that depend on them use stubs
 - In dev/test envs emails are not actually sent.
 - Required variables:
 	- ENV['AWS_ACCESS_KEY_ID']
	- ENV['AWS_SECRET_ACCESS_KEY']
	- ENV['AWS_REGION']
	- ENV['AWS_S3_BUCKET']

 - Rails test should be GREEN

You can access the admin panel home localhost:300/admin - Email: "juan@perez.com", password: "password"

Currently the app uses the following structure on the aws buckets:

- images/home -> home-main.jpg is the main image, 1-4 are the thumbnails
- images/peopleSlides
- images/urbanSlides
- images/modelsSlides
- images/eventsSlides
- images/posts (images uploaded when creating or editing a blog post)

Images are fetched with S3's list_objects method and sorted a <=> z
Redis/memcached or a similar solution should be used to cache these results instead of 
hitting s3 every time.

When uploading images different sizes are created and loaded. Those are defined in ApplicationHelper::size_breakpoints

File management requires an configured AWS Bucket

To pass to production some email solution (eg sendgrid) should be used, plus postgres or another SQL DB to replace SQLite

Currently in production the app serves from "public" but you can configure the AWS ENV variables and config.asset_host on "environments/production.rb" to make it use AWS and a CDN




