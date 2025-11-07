#!/bin/bash

echo "=== WordPress Entrypoint Start ==="

WP_PATH="/var/www/html"
SITE_URL="${WORDPRESS_SITE_URL:-https://localhost}"

# *_FILE から必ず読み取る。存在しなければ即終了。
if [ -z "${WORDPRESS_DB_PASSWORD_FILE}" ] || [ ! -f "${WORDPRESS_DB_PASSWORD_FILE}" ]; then
    echo "WORDPRESS_DB_PASSWORD_FILE is required and must point to an existing file" >&2
    exit 1
fi
if [ -z "${WORDPRESS_ADMIN_PASSWORD_FILE}" ] || [ ! -f "${WORDPRESS_ADMIN_PASSWORD_FILE}" ]; then
    echo "WORDPRESS_ADMIN_PASSWORD_FILE is required and must point to an existing file" >&2
    exit 1
fi
if [ -z "${WORDPRESS_NORMAL_PASSWORD_FILE}" ] || [ ! -f "${WORDPRESS_NORMAL_PASSWORD_FILE}" ]; then
    echo "WORDPRESS_NORMAL_PASSWORD_FILE is required and must point to an existing file" >&2
    exit 1
fi
export WORDPRESS_DB_PASSWORD="$(cat "${WORDPRESS_DB_PASSWORD_FILE}")"
export WORDPRESS_ADMIN_PASSWORD="$(cat "${WORDPRESS_ADMIN_PASSWORD_FILE}")"
export WORDPRESS_NORMAL_PASSWORD="$(cat "${WORDPRESS_NORMAL_PASSWORD_FILE}")"

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
		--title="${WORDPRESS_SITE_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
		--allow-root

	# 2人目の一般ユーザーを追加
	wp user create "${WORDPRESS_NORMAL_USER}" "${WORDPRESS_NORMAL_EMAIL}" \
		--role=subscriber \
		--user_pass="${WORDPRESS_NORMAL_PASSWORD}" \
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
