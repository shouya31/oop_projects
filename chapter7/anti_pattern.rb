require 'date'

# お客さんをモデリングしたクラス
class User
  attr_accessor :name, :password, :age

  def initialize
    puts 'ユーザー登録を行います'
    puts 'ユーザー名を入力してください'
    @name = gets.chomp
    puts '年齢を入力してください'
    @age = gets.chomp.to_i
  end
end

class Ride
  attr_reader :name, :fee, :exp_age

  def initialize(name, fee, exp_age)
    @name = name
    @fee = fee
    @exp_age = exp_age
  end
end

class Goods
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end

class Food
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end

class Ticket
  attr_reader :ride, :date

  def initialize(ride, date)
    @ride = ride
    @date = date
  end
end

# 券売機をモデリングしたクラス
class TicketVendingSystem
  attr_reader :user, :rides, :created_at, :foods, :goods

  def initialize(user, rides, foods, goods)
    @user = user
    @rides = rides || []
    @foods = foods || []
    @goods = goods || []
  end

  # 販売機能実行
  def exec_transaction
    puts '0. チケットを購入する'
    puts '1. 終了'
    num = gets.chomp.to_i
    if num == 0
      prepare_ticket
    elsif num == 1
      exit
    else
      puts '不正な入力です'
    end
  end

  def prepare_ticket
    if select_ticket[0].is_a?(Ride)
      ticket = TicketingRide.new(rides, user).transaction
    elsif elect_ticket[0].is_a?(Food)
      ticket = TicketingFood.new(foods).transaction
    elsif elect_ticket[0].is_a?(Goods)
      ticket = TicketingGoods.new(goods).transaction
    end
  end

  def select_ticket
    puts "どのチケットを購入しますか？\n\n【1】アトラクション\n【2】食べ物\n【3】記念品"
    ticket_number = gets.chomp.to_i
    if ticket_number === 1
      product = rides
    elsif ticket_number === 2
      product = foods
    elsif ticket_number === 3
      product = goods
    end
  end
end

class TicketingRide
  attr_reader :rides, :user, :created_at

  def initialize(rides, user)
    @rides = rides || []
    @user = user || ''
    @created_at = Date.today
  end

  def transaction
    puts 'ride'
    display_tickets
    ticket = take_order
    serve_ticket(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    if user.age < 5
      puts '申し訳ございません。お客様のお年齢では選択できるアトラクションはございません。'
      exit
    end
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    rides.each_with_index do |ride, i|
      puts "[#{i}] 商品名：#{ride.name} 価格：#{ride.fee}" if user.age > ride.exp_age
    end
  end

  # チケット発券機能
  def take_order
    ticket = Ticket.new(rides[gets.to_i], created_at)
    puts "#{ticket.ride.name}が選択されました"
    ticket
  end

  # 決済処理
  def serve_ticket(ticket)
    puts 'お金をいれてください'
    while true
      payment = gets.to_i
      charge = calc_change(payment, ticket.ride.fee)

      if charge >= 0
        break
      else
        puts '入力金額が不足しています。金額を再入力してください。'
      end
    end

    puts "お釣りは#{charge}円です。ご利用ありがとうございました。"
  end

  # お釣り算出機能
  def calc_change(payment, fee)
    payment - fee
  end
end

class TicketingFood
  attr_reader :foods, :created_at

  def initialize(foods)
    @foods = foods || []
    @created_at = Date.today
  end

  def transaction
    display_tickets
    ticket = take_order
    serve_ticket(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    foods.each_with_index do |food, i|
      puts "[#{i}] 商品名：#{food.name} 価格：#{food.price}"
    end
  end

  # チケット発券機能
  def take_order
    ticket = Ticket.new(foods[gets.to_i], created_at)
    puts "#{ticket.food.name}が選択されました"
    ticket
  end

  # 決済処理
  def serve_ticket(ticket)
    puts 'お金をいれてください'
    while true
      payment = gets.to_i
      charge = calc_change(payment, ticket.food.price)

      if charge >= 0
        break
      else
        puts '入力金額が不足しています。金額を再入力してください。'
      end
    end

    puts "お釣りは#{charge}円です。ご利用ありがとうございました。"
  end

  # お釣り算出機能
  def calc_change(payment, fee)
    payment - fee
  end
end

class TicketingGoods
  attr_reader :goods, :created_at

  def initialize(_rides)
    @goods = goods || []
    @created_at = Date.today
  end

  def transaction
    display_tickets
    ticket = take_order
    serve_ticket(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    some_goods.each_with_index do |goods, i|
      puts "[#{i}] 商品名：#{goods.name} 価格：#{goods.price}"
    end
  end

  # チケット発券機能
  def take_order
    ticket = Ticket.new(goods[gets.to_i], created_at)
    puts "#{ticket.goods.name}が選択されました"
    ticket
  end

  # 決済処理
  def serve_ticket(ticket)
    puts 'お金をいれてください'
    while true
      payment = gets.to_i
      charge = calc_change(payment, ticket.goods.price)

      if charge >= 0
        break
      else
        puts '入力金額が不足しています。金額を再入力してください。'
      end
    end

    puts "お釣りは#{charge}円です。ご利用ありがとうございました。"
  end

  # お釣り算出機能
  def calc_change(payment, fee)
    payment - fee
  end
end

rides = [
  { name: 'roller coaster', fee: 1200, exp_age: 8 },
  { name: 'merry-go-round', fee: 1000, exp_age: 5 },
  { name: 'jackie coaster', fee: 800, exp_age: 15 }
]

foods = [
  { name: 'アイスクリーム', price: 500 },
  { name: 'かき氷', price: 300 },
  { name: 'フランクフルト', price: 800 }
]

goods = [
  { name: 'ぬいぐるみ', price: 2300 },
  { name: '記念Tシャツ', price: 3300 },
  { name: 'クリアファイル', price: 800 }
]

@rides = rides.map { |b| Ride.new(b[:name], b[:fee], b[:exp_age]) }
@foods = foods.map { |b| Food.new(b[:name], b[:price]) }
@goods = goods.map { |b| Goods.new(b[:name], b[:price]) }

TicketVendingSystem.new(User.new, @rides, @foods, @goods).exec_transaction
