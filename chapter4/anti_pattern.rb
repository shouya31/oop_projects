require 'date'

# 券売機をモデリングしたクラス
class TicketVendingSystem
  attr_reader :ride_info, :created_at

  def initialize
    @ride_info = [
      { name: 'roller coaster', fee: 1200 },
      { name: 'merry-go-round', fee: 1000 },
      { name: 'jackie coaster', fee: 800 }
    ]
    @created_at = Date.today
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

  # チケット購入機能
  def transaction
    display_tickets
    ticket = issue_ticket
    run_payment(ticket)
  end

  # チケット一覧表示機能
  def display_tickets
    puts '購入したいチケットを以下から選んで、金額を入力してください'
    ride_info.each_with_index do |ride, i|
      puts "[#{i}] 商品名：#{ride[:name]} 価格：#{ride[:fee]}"
    end
  end

  # チケット選択機能
  def issue_ticket
    ride = ride_info[gets.to_i]
    puts "#{ride[:name]}が選択されました"
    ride
  end

  # 決済処理
  def run_payment(ticket)
    puts 'お金をいれてください'
    while true
      payment = gets.to_i
      charge = calc_change(payment, ticket[:fee])

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

TicketVendingSystem.new.exec_transaction
