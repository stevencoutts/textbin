FROM node:20
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .

# Install netcat and set up entrypoint
RUN apt-get update && apt-get install -y netcat-openbsd && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 3000
CMD ["npm", "start"] 