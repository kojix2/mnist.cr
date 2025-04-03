module Mnist
  # HTML content with improved design
  MNIST_HTML = <<-HTML
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MNIST Digit Recognition</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
      
      body {
        font-family: 'Inter', sans-serif;
      }
      
      .canvas-container {
        touch-action: none;
      }
      
      .prediction-number {
        font-size: 6rem;
        line-height: 1;
      }
      
      @keyframes scale-in {
        0% { transform: scale(0.5); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
      }
      
      .animate-scale-in {
        animation: scale-in 0.3s ease-out forwards;
      }
      
      .bar-outer {
        height: 24px;
        border-radius: 4px;
        overflow: hidden;
        background-color: #f3f4f6;
      }
      
      .dark .bar-outer {
        background-color: #374151;
      }
      
      .bar-inner {
        height: 100%;
        background-color: #6366f1;
        transition: width 0.5s ease-out;
      }
      
      .bar-inner.highlight {
        background-color: #4f46e5;
      }
      
      .dark .bar-inner {
        background-color: #818cf8;
      }
      
      .dark .bar-inner.highlight {
        background-color: #6366f1;
      }
      
      .theme-toggle {
        position: absolute;
        top: 1rem;
        right: 1rem;
      }
    </style>
  </head>
  <body class="min-h-screen bg-gradient-to-br from-indigo-50 to-blue-100 dark:from-gray-900 dark:to-indigo-900 p-4 md:p-8 transition-colors duration-200">
    <button id="theme-toggle" class="theme-toggle p-2 bg-white dark:bg-gray-800 rounded-full shadow-md">
      <svg id="dark-icon" class="w-6 h-6 text-gray-800 hidden dark:block" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"></path>
      </svg>
      <svg id="light-icon" class="w-6 h-6 text-gray-800 block dark:hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path>
      </svg>
    </button>
    
    <div class="max-w-4xl mx-auto bg-white dark:bg-gray-800 rounded-xl shadow-lg overflow-hidden transition-colors duration-200">
      <div class="p-6 md:p-8">
        <header class="text-center mb-8">
          <h1 class="text-3xl md:text-4xl font-bold text-indigo-600 dark:text-indigo-400">MNIST Digit Recognition</h1>
          <p class="mt-2 text-gray-600 dark:text-gray-300">Draw a digit and let AI recognize it</p>
        </header>
        
        <div class="flex flex-col md:flex-row gap-8 items-center">
          <div class="w-full md:w-1/2">
            <div class="canvas-container relative mx-auto" style="width: 280px; height: 280px;">
              <canvas id="canvas" width="280" height="280" 
                class="bg-white border-2 border-indigo-200 dark:border-indigo-700 rounded-lg shadow-md"></canvas>
            </div>
            
            <div class="mt-4 flex flex-col sm:flex-row justify-between gap-4">
              <div>
                <label class="text-sm text-gray-600 dark:text-gray-300 block mb-1">Pen Size:</label>
                <input type="range" min="5" max="25" value="15" class="w-full accent-indigo-500" id="pen-size" />
              </div>
              
              <div class="flex gap-2 justify-center sm:justify-end">
                <button id="clear" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600 rounded-lg transition-colors text-gray-800 dark:text-gray-200">
                  Clear
                </button>
                <button id="predict" class="px-4 py-2 bg-indigo-500 hover:bg-indigo-600 text-white rounded-lg transition-colors">
                  Predict
                </button>
              </div>
            </div>
          </div>
          
          <div class="w-full md:w-1/2">
            <div id="result" class="text-xl font-semibold text-center mb-6 min-h-[2rem] text-gray-700 dark:text-gray-200">
              Draw a digit and click Predict
            </div>
            
            <div id="prediction-display" class="hidden mb-6">
              <div class="text-center">
                <span class="prediction-number font-bold text-indigo-600 dark:text-indigo-400"></span>
              </div>
              <div class="text-center text-gray-600 dark:text-gray-300 mt-2">
                Confidence: <span class="confidence-value font-medium"></span>
              </div>
            </div>
            
            <div id="bar-chart" class="space-y-2"></div>
          </div>
        </div>
      </div>
      
      <footer class="bg-gray-50 dark:bg-gray-900 py-4 px-6 text-center text-gray-500 dark:text-gray-400 text-sm">
        Powered by Crystal, ONNXRuntime, and Kemal
      </footer>
    </div>

    <script>
      // Theme toggle
      const themeToggle = document.getElementById('theme-toggle');
      const htmlElement = document.documentElement;
      
      // Check for saved theme preference or use system preference
      const savedTheme = localStorage.getItem('theme');
      if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        htmlElement.classList.add('dark');
      }
      
      themeToggle.addEventListener('click', () => {
        htmlElement.classList.toggle('dark');
        const isDark = htmlElement.classList.contains('dark');
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
      });
      
      // Setup canvas
      const canvas = document.getElementById('canvas');
      const ctx = canvas.getContext('2d');
      const penSizeInput = document.getElementById('pen-size');
      
      ctx.lineCap = 'round';
      ctx.lineJoin = 'round';
      ctx.fillStyle = 'white';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      
      // Set initial pen size
      ctx.lineWidth = parseInt(penSizeInput.value);
      
      // Update pen size when slider changes
      penSizeInput.addEventListener('input', () => {
        ctx.lineWidth = parseInt(penSizeInput.value);
      });
      
      // Drawing state
      let drawing = false, lastX, lastY;
      
      // Drawing functions for mouse
      canvas.addEventListener('mousedown', e => {
        drawing = true;
        [lastX, lastY] = [e.offsetX, e.offsetY];
      });
      
      canvas.addEventListener('mousemove', e => {
        if (!drawing) return;
        ctx.beginPath();
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(e.offsetX, e.offsetY);
        ctx.stroke();
        [lastX, lastY] = [e.offsetX, e.offsetY];
      });
      
      canvas.addEventListener('mouseup', () => drawing = false);
      canvas.addEventListener('mouseout', () => drawing = false);
      
      // Drawing functions for touch devices
      canvas.addEventListener('touchstart', e => {
        e.preventDefault();
        const touch = e.touches[0];
        const rect = canvas.getBoundingClientRect();
        [lastX, lastY] = [touch.clientX - rect.left, touch.clientY - rect.top];
        drawing = true;
      });
      
      canvas.addEventListener('touchmove', e => {
        e.preventDefault();
        if (!drawing) return;
        
        const touch = e.touches[0];
        const rect = canvas.getBoundingClientRect();
        const x = touch.clientX - rect.left;
        const y = touch.clientY - rect.top;
        
        ctx.beginPath();
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(x, y);
        ctx.stroke();
        [lastX, lastY] = [x, y];
      });
      
      canvas.addEventListener('touchend', e => {
        e.preventDefault();
        drawing = false;
      });
      
      // Clear button
      document.getElementById('clear').addEventListener('click', () => {
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        document.getElementById('result').textContent = 'Draw a digit and click Predict';
        document.getElementById('prediction-display').classList.add('hidden');
        document.getElementById('bar-chart').innerHTML = '';
      });
      
      // Predict button
      document.getElementById('predict').addEventListener('click', async () => {
        // Show loading state
        document.getElementById('result').textContent = 'Analyzing...';
        
        // Get image data
        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        const pixels = imageData.data;
        
        // Resize to 28x28
        const blockSize = canvas.width / 28;
        const resizedData = new Array(28 * 28).fill(0);
        
        for (let y = 0; y < 28; y++) {
          for (let x = 0; x < 28; x++) {
            let sum = 0, count = 0;
            
            // Average the pixels in this block
            for (let dy = 0; dy < blockSize; dy++) {
              for (let dx = 0; dx < blockSize; dx++) {
                const sx = Math.floor(x * blockSize + dx);
                const sy = Math.floor(y * blockSize + dy);
                if (sx < canvas.width && sy < canvas.height) {
                  sum += 255 - pixels[(sy * canvas.width + sx) * 4]; // Invert: white->0, black->255
                  count++;
                }
              }
            }
            
            // Normalize and threshold
            resizedData[y * 28 + x] = count > 0 && (sum / count) > 50 ? 1 : 0;
          }
        }
        
        try {
          // Send to server
          const response = await fetch('/predict', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ data: resizedData })
          });
          
          const result = await response.json();
          
          if (result.success) {
            // Display prediction result
            document.getElementById('result').textContent = 
              `Predicted: ${result.prediction} (Confidence: ${result.confidence.toFixed(2)})`;
            
            // Show prediction number with animation
            const predDisplay = document.getElementById('prediction-display');
            predDisplay.classList.remove('hidden');
            
            const predNumber = predDisplay.querySelector('.prediction-number');
            predNumber.textContent = result.prediction;
            predNumber.classList.remove('animate-scale-in');
            void predNumber.offsetWidth; // Force reflow
            predNumber.classList.add('animate-scale-in');
            
            predDisplay.querySelector('.confidence-value').textContent = 
              `${(result.confidence * 100).toFixed(2)}%`;
            
            // Create bar chart
            const barChart = document.getElementById('bar-chart');
            barChart.innerHTML = '';
            
            // Convert scores to probabilities using softmax
            const softmax = (scores) => {
              const maxScore = Math.max(...scores);
              const exps = scores.map(score => Math.exp(score - maxScore));
              const sumExps = exps.reduce((sum, exp) => sum + exp, 0);
              return exps.map(exp => exp / sumExps);
            };
            
            // Calculate probabilities
            const probabilities = softmax(result.scores);
            
            // Create bars for each digit
            probabilities.forEach((probability, digit) => {
              // Calculate percentage for bar width (0-100%)
              const percentage = probability * 100;
              
              // Create row for this digit
              const row = document.createElement('div');
              row.className = 'flex items-center gap-2 mb-2';
              
              // Add digit label
              const label = document.createElement('div');
              label.className = 'w-6 text-right font-medium text-gray-700 dark:text-gray-300';
              label.textContent = digit;
              row.appendChild(label);
              
              // Add bar container
              const barOuter = document.createElement('div');
              barOuter.className = 'bar-outer flex-grow';
              
              // Add actual bar (start at width 0 for animation)
              const barInner = document.createElement('div');
              barInner.className = 'bar-inner';
              barInner.style.width = '0%';
              barOuter.appendChild(barInner);
              row.appendChild(barOuter);
              
              // Add score value
              const value = document.createElement('div');
              value.className = 'w-16 text-right text-gray-600 dark:text-gray-400';
              value.textContent = probability.toFixed(4);
              row.appendChild(value);
              
              // Highlight the predicted digit
              if (digit === result.prediction) {
                row.classList.add('font-bold');
                barInner.classList.add('highlight');
              }
              
              // Add row to chart
              barChart.appendChild(row);
              
              // Animate the bar after a small delay
              setTimeout(() => {
                barInner.style.width = `${percentage}%`;
              }, digit * 50);
            });
          } else {
            document.getElementById('result').textContent = `Error: ${result.error}`;
          }
        } catch (error) {
          document.getElementById('result').textContent = `Error: ${error.message}`;
        }
      });
    </script>
  </body>
  </html>
  HTML
end
