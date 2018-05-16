# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'securerandom'

75.times do
  Post.create(
    :title => "My Post #{SecureRandom.hex(2)}",
    :author => SecureRandom.hex(6),
    :body => SecureRandom.hex(32)
  )
end
