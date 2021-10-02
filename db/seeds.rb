# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# テスト用のサーバーの作成
# 同一サブネットは10種類用意し、同一サブネット内にサーバーを２つずつ作成する
10.times do |i|
  main_1 = 10 + i
  main_2 = 20 + i
  main_3 = 30 + i
  main_4 = 0
  sub = Faker::Number.between(from: 1, to: 24)
  2.times do |j|
    main_4 = j + 1
  ip_address = "#{main_1}.#{main_2}.#{main_3}.#{main_4}/#{sub}"
  Server.create(main_1: main_1, main_2: main_2, main_3: main_3, main_4: main_4, sub: sub, ip_address: ip_address)
  end
end

12.times do |k|
  31.times do |i|
    if ((k == 4 || k == 6 || k == 9 || k == 11) && i == 30) || (k == 2 && i >= 29)
      next
    end

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
