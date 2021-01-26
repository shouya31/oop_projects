require 'date'

# お客さんをモデリングしたクラス
class User
  attr_accessor :name, :password, :age

  def initialize
    puts 'ユーザー登録を行います'
    puts 'ユーザー名を入力してください'
    @name = gets.chomp
    puts 'パスワードを入力してください'
    @password = gets.chomp
    puts '年齢を入力してください'
    @age = gets.chomp.to_i
  end
end

class Ride
  attr_reader :name, :price, :exp_age

  def initialize(name, price, exp_age)
    @name = name
    @price = price
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
  attr_reader :product, :date

  def initialize(product, date)
    @product = product
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
      select_ticket
    elsif num == 1
      exit
    else
      puts '不正な入力です'
    end
  end

  def select_ticket
    puts "どのチケットを購入しますか？\n\n【1】アトラクション\n【2】食べ物\n【3】記念品"
    ticket_number = gets.chomp.to_i
    if ticket_number === 1
      TicketingProduct.new(rides, user).transaction
    elsif ticket_number === 2
      TicketingProduct.new(foods).transaction
    elsif ticket_number === 3
      TicketingProduct.new(goods).transaction
    end
  end
end

class TicketingProduct
  attr_reader :products, :user, :created_at

  def initialize(products, user = {})
    @products = products || []
    @user = user || ''
    @created_at = Date.today
  end

  def transaction
    display_tickets
    ticket = take_order
    serve_ticket(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    limit_age if products[0].respond_to? :exp_age
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    products.each_with_index do |product, i|
      if product.respond_to? :exp_age
        puts "[#{i}] 商品名：#{product.name} 価格：#{product.price}" if user.age > product.exp_age
      else
        puts "[#{i}] 商品名：#{product.name} 価格：#{product.price}"
      end
    end
  end

  def limit_age
    if user.age < 5
      puts '申し訳ございません。お客様のお年齢では選択できるアトラクションはございません。'
      exit
    end
  end

  # チケット発券機能
  def take_order
    ticket = Ticket.new(products[gets.to_i], created_at)
    puts "#{ticket.product.name}が選択されました"
    ticket
  end

  # 決済処理
  def serve_ticket(ticket)
    puts 'お金をいれてください'
    while true
      payment = gets.to_i
      charge = calc_change(payment, ticket.product.price)

      if charge >= 0
        break
      else
        puts '入力金額が不足しています。金額を再入力してください。'
      end
    end

    puts "お釣りは#{charge}円です。ご利用ありがとうございました。"
  end

  # お釣り算出機能
  def calc_change(payment, price)
    payment - price
  end
end

rides = [
  { name: 'roller coaster', price: 1200, exp_age: 8 },
  { name: 'merry-go-round', price: 1000, exp_age: 5 },
  { name: 'jackie coaster', price: 800, exp_age: 15 }
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

@rides = rides.map { |b| Ride.new(b[:name], b[:price], b[:exp_age]) }
@foods = foods.map { |b| Food.new(b[:name], b[:price]) }
@goods = goods.map { |b| Goods.new(b[:name], b[:price]) }

TicketVendingSystem.new(User.new, @rides, @foods, @goods).exec_transaction
