require "kemal"
require "json"
require "onnxruntime"
require "./html"
require "./model"

module Mnist
  # Default port
  PORT = 3000

  # Server setup
  class Server
    # Set up routes
    def self.setup_routes
      # Home page
      get "/" do
        MNIST_HTML
      end

      # Prediction endpoint
      post "/predict" do |env|
        begin
          # Parse request
          body = env.request.body.try &.gets_to_end
          next unless body

          json_data = JSON.parse(body)
          pixel_data = json_data["data"].as_a.map { |v| v.as_i.to_f32 }

          # Make prediction
          result = Model.predict(pixel_data)

          # Return result
          result.to_json
        rescue ex
          puts "Error: #{ex.message}"
          env.response.status_code = 400
          {success: false, error: ex.message}.to_json
        end
      end
    end

    def self.setup
      # Prepare model
      Model.prepare_model

      # Set up Kemal routes
      setup_routes

      # Configure Kemal
      Kemal.config.port = PORT
    end

    # Start server
    def self.start
      puts "Server running at http://localhost:#{PORT}"
      Kemal.run
    end
  end
end
