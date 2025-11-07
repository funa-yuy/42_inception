#!/bin/bash

echo "=== MariaDB Entrypoint Start ==="

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

# *_FILE から必ず読み取る。存在しなければ即終了。
if [ -z "${MARIADB_ROOT_PASSWORD_FILE}" ] || [ ! -f "${MARIADB_ROOT_PASSWORD_FILE}" ]; then
    echo "MARIADB_ROOT_PASSWORD_FILE is required and must point to an existing file" >&2
    exit 1
fi
if [ -z "${MARIADB_PASSWORD_FILE}" ] || [ ! -f "${MARIADB_PASSWORD_FILE}" ]; then
    echo "MARIADB_PASSWORD_FILE is required and must point to an existing file" >&2
    exit 1
fi
export MARIADB_ROOT_PASSWORD="$(cat "${MARIADB_ROOT_PASSWORD_FILE}")"
export MARIADB_PASSWORD="$(cat "${MARIADB_PASSWORD_FILE}")"

if [ ! -d "$DATADIR/mysql" ]; then
	echo "Initializing MariaDB database..."

	# データベース初期化
	mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db

	echo "Database initialized."

	# 一時的にmysqlを起動
	mysqld --user=mysql --datadir="$DATADIR" --socket="$SOCKET" &
	pid="$!"

	# サーバーが起動するまで待つ
	echo "Waiting for MariaDB server to be ready..."
	until mysql --socket="$SOCKET" -u root -e "SELECT 1" >/dev/null 2>&1; do
		sleep 1
	done
	echo "MariaDB server is ready!"

	 # データベースとユーザーを作成
	mysql --socket="$SOCKET" -u root <<-EOSQL
			ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
			CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
			CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
			GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
			FLUSH PRIVILEGES;
	EOSQL

	# 一時サーバーを停止
	mysqladmin --socket="$SOCKET" -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
	wait "$pid"
else
    echo "Database already initialized, skipping initialization."

fi

echo "=== Starting MariaDB ==="

exec mysqld --user=mysql --datadir="$DATADIR" --socket="$SOCKET"
