# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Notification.destroy_all
Enrollment.destroy_all
Course.destroy_all
User.destroy_all



PASSWORD = '123'

super_user = User.create(
    first_name: "Admin",
    last_name: "User",
    email: "admin@user.com",
    password: PASSWORD,
    is_admin: true
)

hung = User.create(first_name: "Hung",
    last_name: "Nguyen",
    email: "hung@123.com",
    password: PASSWORD,
    is_admin: false)

20.times do 
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    User.create(
        first_name:first_name,
        last_name: last_name,
        email: "#{first_name}@#{last_name}.com",
        password: PASSWORD
    )
end


users = User.all

5.times do 
    user_sample = users.shuffle.slice(0, 2)
    Notification.create(
        message: Faker::Hacker.say_something_smart,
        sender: user_sample[0],
        receiver: user_sample[1]
    )
end

user_sample = users.shuffle.slice(0, 10)

5.times do 
    t = Tag.create(
        name: Faker::Educator.subject,
        category: "Interest"
    )
    c = Course.create(
        title: Faker::Educator.course_name,
        description: Faker::Lorem.sentence(word_count: 150),
    )
    if c.valid?
        Enrollment.create(
        course: c,
        user: User.first,
        is_teacher: true
        )
        Tagging.create(
            tag: t,
            course: c
        )
        5.times do
            Enrollment.create(
                course: c,
                user: user_sample[1..10].sample
            )
        end
    end
end


courses = Course.all

10.times do
    t = Tag.create(
        name: Faker::Address.city,
        category: "Location"
    )
    f = Facility.create(
        full_address: Faker::Address.full_address,
        features: Faker::Lorem.sentence(word_count: 15),
    )
    if f.valid? 
        user_sample = users.shuffle.slice(0, 10)
        #byebug
        Tagging.create(
            tag: t,
            facility: f
        )
        Booking.create(
            course: courses.sample,
            facility: f,
            start_time: Date.yesterday,
            end_time: Date.yesterday 
        )
    end
end

facilities = Facility.all

puts "generated #{facilities.count} facilities"
puts "generated #{users.count} users"
puts "generated #{courses.count} courses"
