% Parameters
N = 10000;          % Number of samples
xmax = 5;           % Maximum value of input signal
m = 0;              % Shifting constant
n_bits = 2:8;       % Number of bits
SNR_th = zeros(size(n_bits));
SNR_sim = zeros(size(n_bits));

% Generate input signal
input_signal = randn([1, N]) .* exprnd(1, [1, N]);
input_signal = input_signal .* (2 * (rand([1, N]) >= 0.5) - 1);

% Compute theoretical SNR
for i = 1:length(n_bits)
    SNR_th(i) = 6.02 * n_bits(i) + 1.76;
end

% Compute simulated SNR
for i = 1:length(n_bits)
    % Quantize input signal
    q_ind = quantizier(input_signal, n_bits(i), xmax, m);
    % Dequantize quantized signal
    deq_signal = dequantizer(q_ind, n_bits(i), xmax, m);
    % Compute quantization error
    quantization_error = input_signal - deq_signal;
    % Compute simulated SNR
    SNR_sim(i) = 10 * log10(sum(input_signal.^2)/sum(quantization_error.^2));
end

% Plot results
figure;
plot(n_bits, SNR_th, 'o-', 'LineWidth', 2);
hold on;
plot(n_bits, SNR_sim, 's-', 'LineWidth', 2);
xlabel('Number of bits');
ylabel('SNR (dB)');
legend('Theoretical SNR', 'Simulated SNR');
grid on;
