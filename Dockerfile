FROM node:19-alpine3.15
WORKDIR /redit-clone
COPY . /redit-clone
RUN npm install
EXPOSE 3000
CMD [ "npm", "run", "dev" ]