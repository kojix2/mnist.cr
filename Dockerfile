# ベースイメージとして Crystal の公式イメージを使用
FROM crystallang/crystal:1.15.1-alpine

# 必要なパッケージのインストール
RUN apk add --no-cache wget tar build-base curl

# ONNXRuntime のインストール
WORKDIR /opt
RUN wget https://github.com/microsoft/onnxruntime/releases/download/v1.21.0/onnxruntime-linux-x64-1.21.0.tgz && \
    tar -xzf onnxruntime-linux-x64-1.21.0.tgz && \
    rm onnxruntime-linux-x64-1.21.0.tgz

# 環境変数の設定
ENV ONNXRUNTIMEDIR=/opt/onnxruntime-linux-x64-1.21.0

# アプリケーションのコピー
WORKDIR /app
COPY . .

# MNIST モデルファイルのダウンロード
RUN mkdir -p spec/fixtures && \
    curl -L -o spec/fixtures/mnist.onnx https://github.com/microsoft/onnxruntime/raw/master/onnxruntime/test/testdata/mnist.onnx

# アプリケーションのビルド
RUN shards install && \
    crystal build --release src/mnist.cr

# ポートの公開
EXPOSE 3000

# アプリケーションの実行
CMD ["./mnist"]
