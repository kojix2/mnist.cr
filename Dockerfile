# Use a minimal glibc-based image
FROM debian:bullseye-slim

# Install minimal required dependencies and Crystal
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates build-essential libssl-dev libxml2-dev libyaml-dev libgmp-dev git && \
    curl -fsSL https://crystal-lang.org/install.sh | bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and extract ONNX Runtime
WORKDIR /opt
RUN curl -LO https://github.com/microsoft/onnxruntime/releases/download/v1.21.0/onnxruntime-linux-x64-1.21.0.tgz && \
    tar -xzf onnxruntime-linux-x64-1.21.0.tgz && rm onnxruntime-linux-x64-1.21.0.tgz

# Set ONNX Runtime environment path
ENV ONNXRUNTIMEDIR=/opt/onnxruntime-linux-x64-1.21.0

# Copy application code
WORKDIR /app
COPY . .

# Download the MNIST ONNX model
RUN mkdir -p spec/fixtures && \
    curl -L -o spec/fixtures/mnist.onnx https://github.com/microsoft/onnxruntime/raw/main/onnxruntime/test/testdata/mnist.onnx

# Install dependencies and build the Crystal application
RUN shards install && crystal build --release src/mnist.cr

# Expose port for the application
EXPOSE 3000

# Run the application
CMD ["./mnist"]
