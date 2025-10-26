#!/bin/bash

echo "=== WordPress Entrypoint Start ==="

WP_PATH="/var/www/html"

# WordPressが未インストールならダウンロード
if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "WordPress not found — installing..."

	# WordPress最新版をダウンロード
	wget -q https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
	tar -xzf /tmp/wordpress.tar.gz -C /tmp
	cp -R /tmp/wordpress/* "$WP_PATH"

	# wp-config.phpを自動生成
    cp "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php"

 	# 環境変数を使ってDB接続設定を自動置換
	sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" "$WP_PATH/wp-config.php"
	sed -i "s/username_here/${WORDPRESS_DB_USER}/" "$WP_PATH/wp-config.php"
	sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" "$WP_PATH/wp-config.php"
	sed -i "s/localhost/${WORDPRESS_DB_HOST}/" "$WP_PATH/wp-config.php"

else
	 echo "WordPress already installed, skipping setup."
fi

echo "=== Starting WordPress ==="

exec "$@"
