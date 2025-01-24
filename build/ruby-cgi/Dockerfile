# Rubyのコンテナをベースとする
FROM ruby:3.3

# ApacheとApache設定ツールのインストール
RUN apt-get update && apt-get install -y \
    apache2 \
    apache2-utils \
    libapache2-mod-fcgid

# 作業ディレクトリを変更
WORKDIR /usr/src/cgi-bin

# Apache の設定ファイルの変更（CGIを有効にする）
RUN a2enmod cgi

# Apache のポート設定
EXPOSE 80

# デフォルトのサイト設定を更新
RUN echo 'ScriptAlias /cgi-bin/ /usr/src/cgi-bin/' > /etc/apache2/conf-available/cgi-bin.conf
RUN echo '<Directory "/usr/src/cgi-bin">\nOptions +ExecCGI\nAddHandler cgi-script .rb\nRequire all granted\n</Directory>' >> /etc/apache2/conf-available/cgi-bin.conf
RUN a2enconf cgi-bin

# Apache を前面で実行
CMD ["apachectl", "-D", "FOREGROUND"]