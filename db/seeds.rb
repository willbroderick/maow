# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# default admin user
user = User.find_or_initialize_by(email: 'willbroderick@gmail.com')
if user.new_record?
  user.password = 'password'
  user.password_confirmation = 'password'
  user.is_admin = true
  user.is_enabled = true
  user.save
end