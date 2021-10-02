# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
14.times do |a|
  main_1 = 10
  main_2 = 20
  main_3 = 30
  main_4 = a + 1
  sub = 16
  ip_address = "#{main_1}.#{main_2}.#{main_3}.#{main_4}/#{sub}"
  Server.create(main_1: main_1, main_2: main_2, main_3: main_3, main_4: main_4, sub: sub, ip_address: ip_address)
end

22.times do |a|
  main_1 = 192
  main_2 = 168
  main_3 = 1
  main_4 = a + 1
  sub = 24
  ip_address = "#{main_1}.#{main_2}.#{main_3}.#{main_4}/#{sub}"
  Server.create(main_1: main_1, main_2: main_2, main_3: main_3, main_4: main_4, sub: sub, ip_address: ip_address)
end

12.times do |k|
  28.times do |i|
    Server.all.each do |server|
      month = k + 1
      day = i + 1
      hour = 12
      min = 0
      sec = server.id - 1
      if sec > 60
        sec = sec % 60
        min += sec / 60
      end
      if min > 60
        min = min % 60
        hour += min / 60
      end
      checked_at = Time.new(2020, month, day, hour, min, sec, 0)
      interval = Faker::Number.between(from: 0, to: 4)
      if interval != 0
        interval = interval = Faker::Number.between(from: 1, to: 300).to_s
      else
        interval = "-"
      end
      Log.create(server_id: server.id, checked_at: checked_at, interval: interval)
    end
  end
end
