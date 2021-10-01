# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

12.times do |k|
  28.times do |i|
    4.times do |j|
      month = k + 1
      day = i + 1
      sec = j * 10
      checked_at = Time.new(2020, month, day, 12, 0, sec, 0)
      interval = Faker::Number.between(from: 0, to: 10)
      if interval != 0
        interval = interval = Faker::Number.between(from: 1, to: 300).to_s
      else
        interval = "-"
      end
      Log.create(server_id: (j + 1), checked_at: checked_at, interval: interval)
    end
  end
end
