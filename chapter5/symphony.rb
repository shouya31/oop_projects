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

class Ticket
  attr_reader :ride, :date

  def initialize(ride)
    @ride = ride
    @date = Date.today
  end
end

# 券売機をモデリングしたクラス
class TicketVendingSystem
  attr_reader :user, :tickets

  def initialize(user, tickets)
    @user = user
    @tickets = tickets
  end

  # チケット購入機能
  def transaction
    display_tickets
    ticket = take_order
    serve_ticket(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    tickets.ride.each_with_index do |ticket, i|
      puts "[#{i}] 商品名：#{ticket.name} 価格：#{ticket.fee}"
    end
  end

  # チケット発券機能
  def take_order
    ticket = tickets.ride[gets.to_i]
    puts "#{ticket.name}が選択されました"
    ticket
  end

  # 販売機能実行
  def exec_transaction
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

  # 決済処理
  def serve_ticket(ticket)
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

@rides = rides.map { |b| Ride.new(b[:name], b[:fee]) }
TicketVendingSystem.new(User.new, Ticket.new(@rides)).exec_transaction
