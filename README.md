A portfolio site with AJAX, pushstate, and an admin panel

**INSTALLING**

 - Clone repo
 - Bundle install
 - db:migrate
 - db:seed
 - Do note that some features require the AWS S3 ENV variables to be set. The tests that depend on them use stubs

 - Required variables:
 	- ENV['AWS_ACCESS_KEY_ID']
	- ENV['AWS_SECRET_ACCESS_KEY']
	- ENV['AWS_REGION']
	- ENV['AWS_S3_BUCKET']

 - Rails test should be GREEN

You can access the admin panel home localhost:3000/admin - Email: "juan@perez.com", password: "password"

Currently the app uses the following structure on the aws bucket:

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

File management requires a configured AWS Bucket

To pass to production some email solution (eg sendgrid) should be used, plus postgres or another SQL DB to replace SQLite

Currently in production the app serves from "public" but you can configure the AWS ENV variables and config.asset_host on "environments/production.rb" to make it use AWS and a CDN

Do note that if for some reason you want to run tests on the S3 bucket, you should try to replicate the structure in tests/mock_objects.rb



