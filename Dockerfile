# Stage 1: Build Node.js app
FROM node:latest as build

WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies including node-pre-gyp
RUN npm install && npm install node-pre-gyp

# Rebuild bcrypt module
RUN npm rebuild bcrypt --build-from-source

# Copy the rest of the application code
COPY . .


# Stage 2: Final image with only Node.js runtime
FROM node:latest as final

WORKDIR /usr/src/app

COPY --from=build /usr/src/app .

# Expose port 3000 for Node.js application
EXPOSE 3000

# Start the Node.js application
CMD ["node", "app.js"]
