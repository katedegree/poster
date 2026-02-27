FROM ubuntu:24.04
WORKDIR /poster
COPY . .
RUN apt-get update && apt-get install -y curl jq && rm -rf /var/lib/apt/lists/*
RUN chmod +x ./start.sh
CMD ["bash", "./start.sh"]
