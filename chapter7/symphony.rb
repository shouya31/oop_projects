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
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
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

  def initialize(user, rides, foods, goods)
    @user = user
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
      select_ticket
    elsif num == 1
      exit
    else
      puts '不正な入力です'
    end
  end

  private

  def select_ticket
    puts "どのチケットを購入しますか？\n\n【1】アトラクション\n【2】食べ物\n【3】記念品"
    ticket_number = gets.chomp.to_i
    if ticket_number === 1
      TicketingProduct.new(rides).transaction
    elsif ticket_number === 2
      TicketingProduct.new(foods).transaction
    elsif ticket_number === 3
      TicketingProduct.new(goods).transaction
    end
  end
end

class TicketingProduct
  attr_reader :tickets

  def initialize(tickets)
    @tickets = tickets
  end

  def transaction
    display_tickets
    ticket = issue_ticket
    run_payment(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    tickets.product.each_with_index do |product, i|
      puts "[#{i}] 商品名：#{product.name} 価格：#{product.price}"
    end
  end

  # チケット発券機能
  def issue_ticket
    ticket = tickets.product[gets.to_i]
    puts "#{ticket.name}が選択されました"
    ticket
  end

  # 決済処理
  def run_payment(ticket)
    puts 'お金をいれてください'
    while true
      payment = gets.to_i
      charge = calc_change(payment, ticket.price)

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
  { name: 'roller coaster', price: 1200 },
  { name: 'merry-go-round', price: 1000 },
  { name: 'jackie coaster', price: 800 }
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

ride_info = rides.map { |b| Ride.new(b[:name], b[:price]) }
food_info = foods.map { |b| Food.new(b[:name], b[:price]) }
goods_info = goods.map { |b| Goods.new(b[:name], b[:price]) }

TicketVendingSystem.new(User.new, Ticket.new(ride_info), Ticket.new(food_info), Ticket.new(goods_info)).exec_transaction
