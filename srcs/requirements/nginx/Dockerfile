FROM debian:12

RUN apt-get update && \
	apt-get install -y nginx \
	openssl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
	openssl genpkey -algorithm RSA -out /etc/ssl/private/server.key && \
	openssl req -x509 -key /etc/ssl/private/server.key \
	-out /etc/ssl/certs/server.crt \
	-days 365 \
	-subj "/CN=localhost" \
	-addext "subjectAltName=DNS:localhost" && \
	chmod 600 /etc/ssl/private/server.key

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
