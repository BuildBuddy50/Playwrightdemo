# Base Playwright image with all browsers + deps
FROM mcr.microsoft.com/playwright:v1.55.0-noble

# Set working directory inside container
WORKDIR /app

# Copy dependency files first (for caching)
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install

# Copy the rest of the project
COPY . .

# Run tests by default
CMD ["npx", "playwright", "test"]