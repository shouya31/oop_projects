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
  attr_reader :name, :fee, :exp_age

  def initialize(name, fee, exp_age)
    @name = name
    @fee = fee
    @exp_age = exp_age
  end
end

# 【追加実装】Ticketクラス生成
class Ticket
  attr_reader :ride, :user, :date

  def initialize(ride, user, date)
    @user = user
    @ride = ride
    @date = date
  end
end

# 券売機をモデリングしたクラス
class TicketVendingSystem
  attr_reader :users, :rides, :created_at

  def initialize(rides)
    @rides = rides
    @users = []
    @created_at = Date.today
  end

  # 販売機能実行
  def exec_transaction
    # ユーザーの作成
    new_user = User.new
    @users << new_user
    puts '0. チケットを購入する'
    puts '1. 終了'
    num = gets.chomp.to_i
    if num == 0
      transaction(new_user)
    elsif num == 1
      exit
    else
      puts '不正な入力です'
    end
  end

  # チケット購入機能
  def transaction(user)
    display_tickets(user)
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

  # チケット選択機能
  def take_order
    ticket = Ticket.new(rides[gets.to_i], created_at)
    # 期待されている数の引数が渡せていないため、ArgumentErrorが発生する
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

rides = [
  { name: 'roller coaster', fee: 1200, exp_age: 8 },
  { name: 'merry-go-round', fee: 1000, exp_age: 5 },
  { name: 'jackie coaster', fee: 800, exp_age: 15 }
]

@rides = rides.map { |b| Ride.new(b[:name], b[:fee], b[:exp_age]) }
TicketVendingSystem.new(@rides).exec_transaction
