#!/usr/bin/env ruby
# coding: UTF-8

print "Content-type: text/html;charset=UTF-8\n\n"

require "cgi" # CGI ライブラリの読み込み
require "csv"
require "time" # タイムスタンプ
form = CGI.new # formデータを受け取る準備

htmlPrefix = <<-EOS
    <!DOCTYPE html>
    <html lang="ja">
    <head>
    <meta charset="UTF-8">
    <title>ChatRead</title>
    </head>
    <body>
EOS
htmlSuffix = <<-EOS
    </body>
    </html>
EOS

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
puts htmlPrefix

# CSVファイルの読み込みとHTMLの生成
if File.exist?("data/data.csv")
    CSV.foreach("data/data.csv", headers: false, encoding: "UTF-8") do |row|
        # CSVの1行をカンマで結合してHTMLに出力
        message = row[1] # メッセージ
        timestamp = Time.parse(row[2]).strftime("%H:%M") # タイムスタンプから時間部分を取得
        puts <<-EOS
             <div style="display: flex; justify-content: space-between; align-items: center;">
                <span>#{CGI.escapeHTML(message)}</span>
                <span style="margin-left: auto; color: gray; font-size: smaller;">#{CGI.escapeHTML(timestamp)}</span>
             </div>
            EOS
    end
else
    puts "<p>メッセージがまだありません。</p>"
end

# HTMLの末尾を出力
puts htmlSuffix

rescue
    error_cgi
end
