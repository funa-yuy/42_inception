FROM debian:12

RUN apt-get update && \
	apt-get install -y curl \
	php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip && \
	rm -rf /var/lib/apt/lists/*

# php-fpm の設定を TCP:9000 に変更
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

# WP-CLIをインストール
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# 初期化スクリプトをコピー&実行
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm8.2", "-F"]
