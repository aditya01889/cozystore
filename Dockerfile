# Build stage
FROM node:18-alpine as builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY packages/evershop/package*.json ./packages/evershop/

# Install root dependencies
RUN npm install

# Install Evershop dependencies
RUN cd packages/evershop && npm install

# Copy application files
COPY . .

# Build the application
RUN cd packages/evershop && npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Copy built assets and production dependencies
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/packages/evershop ./packages/evershop

# Create necessary directories
RUN mkdir -p /app/media

# Environment variables (can be overridden in Render)
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]