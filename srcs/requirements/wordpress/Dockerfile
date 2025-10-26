FROM debian:12

RUN apt-get update && \
	apt-get install -y wget \
	php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip && \
	rm -rf /var/lib/apt/lists/*

# 初期化スクリプトをコピー&実行
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm8.2", "-F"]
