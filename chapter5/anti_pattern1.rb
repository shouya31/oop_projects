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

# アトラクションをモデリングしたクラス
class Ride
  attr_reader :name, :fee

  def initialize(name, fee)
    @name = name
    @fee = fee
  end
end

# 券売機をモデリングしたクラス
class TicketVendingSystem
  attr_reader :products, :users, :created_at

  def initialize(products)
    @products = products
    @users = []
    @created_at = Date.today
  end

  # 発券機能実行
  def exec_transaction
    # ユーザーの作成
    new_user = User.new
    @users << new_user
    puts '0. チケットを購入する'
    puts '1. 終了'
    num = gets.chomp.to_i
    if num == 0
      transaction
    elsif num == 1
      exit
    else
      puts '不正な入力です'
    end
  end

  # チケット購入機能
  def transaction
    display_tickets
    ticket = issue_ticket
    run_payment(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    products.each_with_index do |product, i|
      puts "[#{i}] 商品名：#{product.name} 価格：#{product.fee}"
    end
  end

  # チケット発券機能
  def issue_ticket
    ride = products[gets.to_i]
    puts "#{ride.name}が選択されました"
    ride
  end

  # 決済処理
  def run_payment(ticket)
    puts 'お金をいれてください'
    while true
      payment = gets.to_i
      charge = calc_change(payment, ticket.fee)

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

rides_info = rides.map { |b| Ride.new(b[:name], b[:fee]) }
TicketVendingSystem.new(rides_info).exec_transaction
