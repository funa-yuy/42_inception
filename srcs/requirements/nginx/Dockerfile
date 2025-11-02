FROM debian:12

RUN apt-get update && \
	apt-get install -y nginx && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# todo: 後で443にする
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
