require "file_utils"
require "onnxruntime"

module Mnist
  # Constants
  MNIST_SIZE = 28
  MODEL_PATH = File.expand_path(ENV["MODEL_PATH"]? || "/app/spec/fixtures/mnist.onnx")

  # Model handling class
  class Model
    # Ensure model directory exists and download model if needed
    def self.prepare_model
      FileUtils.mkdir_p(File.dirname(MODEL_PATH))

      # Download model if it doesn't exist
      unless File.exists?(MODEL_PATH)
        puts "Downloading MNIST model..."
        system("curl -L -o #{MODEL_PATH} https://github.com/microsoft/onnxruntime/raw/master/onnxruntime/test/testdata/mnist.onnx")

        if File.exists?(MODEL_PATH)
          puts "Model downloaded successfully."
        else
          puts "Failed to download model. Please download it manually to #{MODEL_PATH}"
          exit(1)
        end
      end
    end

    # Check if ONNXRuntime is available
    def self.check_onnxruntime
      onnx_available = ENV["ONNXRUNTIMEDIR"]? || system("which onnxruntime_shared_lib.so > /dev/null 2>&1")

      unless onnx_available
        puts "Error: ONNXRuntime not found. Please set ONNXRUNTIMEDIR environment variable."
        puts "Example: export ONNXRUNTIMEDIR=/path/to/onnxruntime-linux-x64-1.21.0"
        return false
      end

      true
    end

    # クラス変数でモデルインスタンスを保持
    @@model : OnnxRuntime::Model? = nil

    # モデルを読み込み、クラス変数に保存するメソッド
    def self.load_model
      return @@model if @@model

      # Check if ONNXRuntime is available
      return nil unless check_onnxruntime

      begin
        @@model = OnnxRuntime::Model.new(MODEL_PATH)
        puts "Model loaded successfully."
        @@model
      rescue ex
        puts "Error loading model: #{ex.message}"
        nil
      end
    end

    # prepare_modelメソッドを拡張してモデルも読み込む
    def self.prepare_model
      FileUtils.mkdir_p(File.dirname(MODEL_PATH))

      # Download model if it doesn't exist
      unless File.exists?(MODEL_PATH)
        puts "Downloading MNIST model..."
        system("curl -L -o #{MODEL_PATH} https://github.com/microsoft/onnxruntime/raw/master/onnxruntime/test/testdata/mnist.onnx")

        if File.exists?(MODEL_PATH)
          puts "Model downloaded successfully."
        else
          puts "Failed to download model. Please download it manually to #{MODEL_PATH}"
          exit(1)
        end
      end

      # モデルを読み込む
      load_model
    end

    # predictメソッドを修正して、保存されたモデルを使用する
    def self.predict(pixel_data)
      # Print pattern visualization
      puts "Input pattern:"
      (0...MNIST_SIZE).each do |y|
        puts (0...MNIST_SIZE).map { |x| pixel_data[y * MNIST_SIZE + x] > 0.5 ? "X" : "." }.join
      end

      # Get or load model
      model = @@model || load_model

      unless model
        return {success: false, error: "Failed to load model"}
      end

      # Make prediction
      begin
        result = model.predict(
          {"Input3" => pixel_data},
          nil,
          shape: {"Input3" => [1_i64, 1_i64, MNIST_SIZE.to_i64, MNIST_SIZE.to_i64]}
        )

        # Get output
        output = result["Plus214_Output_0"].as(Array(Float32))
        prediction = output.index(output.max) || 0

        # Return result
        {
          success:    true,
          prediction: prediction,
          confidence: output.max,
          scores:     output,
        }
      rescue ex
        puts "Error making prediction: #{ex.message}"
        {success: false, error: "Failed to make prediction: #{ex.message}"}
      end
    end
  end
end
