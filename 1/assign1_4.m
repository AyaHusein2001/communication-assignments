% Parameters
N = 10000;          % Number of samples
xmax = 5;           % Maximum value of input signal
m = 0;              % mid-rise quantizier
n_bits = 2:1:8;       % Number of bits
SNR_th = zeros(size(n_bits));
SNR_sim = zeros(size(n_bits));

% Generate input signal
input_signal = unifrnd(-xmax, xmax, [1, N]);

% Compute theoretical SNR
for i = 1:length(n_bits)
    SNR_th(i) = 6.02 * n_bits(i) + 1.76;
    %SNR_th(i) =(mean(input_signal.^2)*(3* (2^n_bits(i))^2 / xmax^2));
    %SNR_th(i) =db(SNR_th(i));
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
    SNR_sim(i) =  10*log10(sum(input_signal.^2)/sum(quantization_error.^2));
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

