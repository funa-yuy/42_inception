FROM debian:12

RUN apt-get update && \
	apt-get install -y nginx && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# 後で443にする
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
