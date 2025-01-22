#!/usr/bin/env ruby
# coding: UTF-8

print "Content-type: text/html;charset=UTF-8\n\n"

require "cgi"  # CGI ライブラリの読み込み
require "csv"  # CSV ライブラリ読み込み
require "time" # タイムスタンプ
form = CGI.new # formデータを受け取る準備

# デバッグ用のエラーメッセージをHTMLで出力する関数
def error_cgi
    puts "<p style=\"color: red\">"
    puts "*** CGI Error List ***<br />"
    puts "#{CGI.escapeHTML($!.inspect)}<br />"
    $@.each do |x|
        print CGI.escapeHTML(x), "<br />\n"
    end
    puts "</p>"
end

begin
    # 日本語入力の際の文字化け解消
    message = form["message"]

    # 未入力、空白の場合はCSVに保存しない
    if message.nil? || message.strip.empty?
        puts <<-EOS
             <!DOCTYPE html>
             <html lang="ja">
             <head>
             <meta http-equiv="refresh" content="0;URL='/main.html'" />
             </head>
             </html>
        EOS
        exit
    end

    puts message
    # puts form.params

    # IDの自動付与: 既存の行数を数えて次のIDを決定
    current_id = 1
    if File.exist?("data/data.csv")
        current_id = CSV.read("data/data.csv").size + 1
    end

    # 'a'追記モード  |f|ファイル
    CSV.open("data/data.csv", "a") do |csv|
        # id,メッセージ、タイムスタンプ
        csv << [current_id, message, Time.now.iso8601]
    end

    # /chat.htmlへmetaタグを使ったリダイレクト
puts <<-EOS
<!DOCTYPE html>
<html lang="ja">
<head>
<meta http-equiv="refresh" content="0; URL='/main.html'" />
</head>
</html>
EOS

rescue
    error_cgi
end
# http://localhost:8088/chat.html
