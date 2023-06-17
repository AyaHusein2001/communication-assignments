% Generating input signal
x = -6 : 0.01 : 6;

% Preparing quantization parameters
n_bits = 3;
xmax = 6;

% Mid-rise quantization
m = 0;

% Quantizing input signal
q_ind = quantizier(x, n_bits, xmax, m);

% De-quantizing quantized signal
x_hat = dequantizer(q_ind, n_bits, xmax, m);

% Plotting input/output signals
figure;
plot(x, x, 'b', x, x_hat, 'r--');
xlabel('Input Signal');
ylabel('Output Signal');
title('Mid-Rise Quantization');

% Mid-tread quantization
m = 1;

% Quantize input signal
q_ind = quantizier(x, n_bits, xmax, m);

% De-quantize quantized signal
x_hat = dequantizer(q_ind, n_bits, xmax, m);

% Plot input/output signals
figure;
plot(x, x, 'b', x, x_hat, 'r--');
xlabel('Input Signal');
ylabel('Output Signal');
title('Mid-Tread Quantization');% Generate input signal


