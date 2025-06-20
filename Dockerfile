# Use a full Debian image for compatibility with LibreOffice
FROM python:3.9

# Install required tools and LibreOffice dependencies
RUN apt-get update && apt-get install -y \
    libreoffice \
    fonts-dejavu \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose port (Render listens on 0.0.0.0:$PORT)
EXPOSE 8000

# Start Gunicorn
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000", "--timeout", "300"]
