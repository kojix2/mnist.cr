# MNIST Digit Recognition Web App

A web application for MNIST handwritten digit recognition. Implemented using Crystal language, ONNXRuntime, and Kemal framework.

![MNIST Digit Recognition](https://raw.githubusercontent.com/kojix2/mnist.cr/main/screenshot.png)

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

### Installing ONNXRuntime

```bash
# For Linux (x64)
wget https://github.com/microsoft/onnxruntime/releases/download/v1.21.0/onnxruntime-linux-x64-1.21.0.tgz
tar -xzf onnxruntime-linux-x64-1.21.0.tgz
export ONNXRUNTIMEDIR=/path/to/onnxruntime-linux-x64-1.21.0
```

### Installing the Application

```bash
git clone https://github.com/kojix2/mnist.cr.git
cd mnist.cr
shards install
```

## Usage

### Running Locally

```bash
crystal src/mnist.cr
```

Access the application in your browser at http://localhost:3000.

### Running with Docker

```bash
docker build -t mnist-app .
docker run -p 3000:3000 mnist-app
```

Access the application in your browser at http://localhost:3000.

## Deploying to Koyeb

[Koyeb](https://www.koyeb.com/) is a cloud platform that makes it easy to deploy Docker containers.

### Prerequisites

- [Koyeb CLI](https://www.koyeb.com/docs/cli/installation) installed
- Koyeb account

### Deployment Steps

1. Log in to Koyeb CLI

```bash
koyeb login
```

2. Build and deploy the application

```bash
koyeb app init
```

Or, if deploying from a GitHub repository:

```bash
koyeb app init --git github.com/your-username/mnist.cr --git-branch main
```

3. Check deployment status

```bash
koyeb service get
```

4. Access the application in your browser

Once deployment is complete, the application URL will be displayed in the Koyeb dashboard.

## Development

### Setting Up Local Development Environment

```bash
git clone https://github.com/kojix2/mnist.cr.git
cd mnist.cr
shards install
```

### Running in Development Mode

```bash
crystal src/mnist.cr
```

You need to restart the application after making changes.

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

[MIT](LICENSE)

## Author

- [kojix2](https://github.com/kojix2) - creator and maintainer
