#!/bin/bash

echo "=== WordPress Entrypoint Start ==="

WP_PATH="/var/www/html"
SITE_URL="${WORDPRESS_SITE_URL:-https://localhost}"

# todo: ここ変える
echo "Waiting for MariaDB to be ready..."
  sleep 5

echo "MariaDB is up!"

# WordPressが未インストールならダウンロード
if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "WordPress not found — installing..."

	cd $WP_PATH

	# WordPressコアをダウンロード
	wp core download --allow-root

	# wp-config.phpを生成
	wp config create \
		--dbname="$WORDPRESS_DB_NAME" \
		--dbuser="$WORDPRESS_DB_USER" \
		--dbpass="$WORDPRESS_DB_PASSWORD" \
		--dbhost="$WORDPRESS_DB_HOST" \
		--allow-root

	# WordPressをインストール
	wp core install \
		--url="$SITE_URL" \
		--title="mfunakosのadmin Site" \
		--admin_user="gx7k2m9p" \
		--admin_password="admin_password" \
		--admin_email="admin@example.com" \
		--allow-root

	# 2人目の一般ユーザーを追加
	wp user create normal_user normal@example.com \
		--role=subscriber \
		--user_pass=normal_password \
		--allow-root

	# 日本語設定
	wp language core install --allow-root --activate ja
	# タイムゾーンと日時表記
	wp option update --allow-root timezone_string 'Asia/Tokyo'
	wp option update --allow-root date_format 'Y-m-d'
	wp option update --allow-root time_format 'H:i'

else
	 echo "WordPress already installed, skipping setup."
fi

echo "=== Starting WordPress ==="

exec "$@"
