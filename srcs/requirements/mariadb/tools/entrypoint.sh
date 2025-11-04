#!/bin/bash

echo "=== MariaDB Entrypoint Start ==="

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

if [ ! -d "$DATADIR/mysql" ]; then
	echo "Initializing MariaDB database..."

	# データベース初期化
	mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db

	echo "Database initialized."

	# 一時的にmysqldを起動
	mysqld --user=mysql --socket="$SOCKET" &
	pid="$!"

	# todo: ここ変えるサーバが起動するまで待つ
	sleep 5

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
