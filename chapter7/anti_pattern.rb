require 'date'

# お客さんをモデリングしたクラス
class User
  attr_accessor :name, :age

  def initialize
    puts 'ユーザー登録を行います'
    puts 'ユーザー名を入力してください'
    @name = gets.chomp
    puts '年齢を入力してください'
    @age = gets.chomp.to_i
  end
end

class Ride
  attr_reader :name, :fee

  def initialize(name, fee)
    @name = name
    @fee = fee
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
  attr_reader :product, :date

  def initialize(product)
    @product = product
    @date = Date.today
  end
end

# 券売機をモデリングしたクラス
class TicketVendingSystem
  attr_reader :rides, :foods, :goods

  def initialize(rides, foods, goods)
    @rides = rides
    @foods = foods
    @goods = goods
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

  private

  def prepare_ticket
    genre = select_genre
    if genre[0].is_a?(Ride)
      ticket = TicketingRide.new(rides).transaction
    elsif genre[0].is_a?(Food)
      ticket = TicketingFood.new(foods).transaction
    elsif genre[0].is_a?(Goods)
      ticket = TicketingGoods.new(goods).transaction
    end
  end

  def select_genre
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
  attr_reader :rides

  def initialize(rides)
    @rides = rides
  end

  private

  def transaction
    display_tickets
    ticket = issue_ticket
    run_payment(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    rides.each_with_index do |ride, i|
      puts "[#{i}] 商品名：#{ride.name} 価格：#{ride.fee}"
    end
  end

  # チケット発券機能
  def issue_ticket
    ticket = rides[gets.to_i]
    puts "#{ticket.ride.name}が選択されました"
    ticket
  end

  # 決済処理
  def run_payment(ticket)
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
  attr_reader :foods

  def initialize(foods)
    @foods = foods
  end

  private

  def transaction
    display_tickets
    ticket = issue_ticket
    run_payment(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    foods.each_with_index do |food, i|
      puts "[#{i}] 商品名：#{food.name} 価格：#{food.price}"
    end
  end

  # チケット発券機能
  def issue_ticket
    ticket = foods[gets.to_i]
    puts "#{ticket.food.name}が選択されました"
    ticket
  end

  # 決済処理
  def run_payment(ticket)
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
  attr_reader :goods

  def initialize(goods)
    @goods = goods
  end

  private

  def transaction
    display_tickets
    ticket = issue_ticket
    run_payment(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    some_goods.each_with_index do |goods, i|
      puts "[#{i}] 商品名：#{goods.name} 価格：#{goods.price}"
    end
  end

  # チケット発券機能
  def issue_ticket
    ticket = goods[gets.to_i]
    puts "#{ticket.goods.name}が選択されました"
    ticket
  end

  # 決済処理
  def run_payment(ticket)
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
  { name: 'roller coaster', fee: 1200 },
  { name: 'merry-go-round', fee: 1000 },
  { name: 'jackie coaster', fee: 800 }
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

ride_info = rides.map { |b| Ride.new(b[:name], b[:fee]) }
food_info = foods.map { |b| Food.new(b[:name], b[:price]) }
goods_info = goods.map { |b| Goods.new(b[:name], b[:price]) }

TicketVendingSystem.new(User.new, Ticket.new(ride_info), Ticket.new(food_info), Ticket.new(goods_info)).exec_transaction
