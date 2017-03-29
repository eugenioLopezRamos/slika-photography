# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "Juan Perez", email: "juan@perez.com", admin: true,password: "password", password_confirmation: "password")
Post.create!([{title: "Test post", content: "This is a test post! Use the editor in the admin panel to add more interesting ones", user_id: "1", slug: "test-post"}])
