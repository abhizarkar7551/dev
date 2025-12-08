# Use the official Nginx image as base
FROM nginx:latest

# Set working directory inside container
WORKDIR /usr/share/nginx/html

# Remove the default Nginx static files
RUN rm -rf ./*

# Copy your web content from local 'html/' folder to container
COPY html/ .

# Expose port 80
EXPOSE 80

# Start Nginx in foreground (required for container to stay running)
CMD ["nginx", "-g", "daemon off;"]

