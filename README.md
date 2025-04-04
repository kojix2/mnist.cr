# ![MNIST Digit Recognition](https://raw.githubusercontent.com/kojix2/mnist.cr/main/screenshot.png)

## Features

- Beautiful modern UI design (using Tailwind CSS)
- Dark mode support
- Responsive design (mobile-friendly)
- Pen size adjustment
- Touch screen support
- Visual feedback with animations
- Probability distribution bar chart

## Installation

### Prerequisites

- Crystal 1.15.1 or higher
- ONNXRuntime 1.21.0

## Usage

#### Using Docker Compose

```bash
docker compose up
```

Or to run in detached mode:

```bash
docker compose up -d
```

Access the application in your browser at http://localhost:3000.

## Development

### Setting Up Local Development Environment

```
# For Linux (x64)
wget https://github.com/microsoft/onnxruntime/releases/download/v1.21.0/onnxruntime-linux-x64-1.21.0.tgz
tar -xzf onnxruntime-linux-x64-1.21.0.tgz
export ONNXRUNTIMEDIR=$(pwd)/onnxruntime-linux-x64-1.21.0

# Download model
mkdir -p spec/fixtures
curl -L -o spec/fixtures/mnist.onnx https://github.com/microsoft/onnxruntime/raw/main/onnxruntime/test/testdata/mnist.onnx
```

```bash
git clone https://github.com/kojix2/mnist.cr.git
cd mnist.cr
shards install

crystal run src/mnist.cr
```

## Contributing

1. Fork it (<https://github.com/kojix2/mnist.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits

- [MNIST Dataset](http://yann.lecun.com/exdb/mnist/) - Handwritten digit dataset
- [ONNXRuntime](https://github.com/microsoft/onnxruntime) - Machine learning model inference engine
- [Kemal](https://kemalcr.com/) - Web framework for Crystal
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework

## License

The code was generated entirely by VSCode+CLINE+claude-3.7-sonnet.
[MIT](LICENSE)
