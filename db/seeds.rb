# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Identity.destroy_all
Vote.destroy_all
User.destroy_all
Post.destroy_all
Comment.destroy_all

user = User.create(email:"gonzalo@desafiolatam.com", password:"12345678")

100.times do |i|
  post = user.posts.build(title:Faker::Hacker.abbreviation, content:Faker::Hacker.say_something_smart)
  10.times do   
    comment = post.comments.build(user:user, content:"Soy el comentario XYZ")
    comment.save
  end
  post.save
end
