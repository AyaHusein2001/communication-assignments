% Parameters
N = 10000;          % Number of samples
xmax = 5;           % Maximum value of input signal
m = 0;              % Shifting constant
n_bits = 2:8;       % Number of bits
mu_values = [0, 5, 100, 200];
SNR_th = zeros(length(mu_values), length(n_bits));
SNR_sim = zeros(length(mu_values), length(n_bits));

% Generate input signal
input_signal = randn([1, N]) .* exprnd(1, [1, N]);
input_signal = input_signal .* (2 * (rand([1, N]) >= 0.5) - 1);

% Compute theoretical SNR
for j = 1:length(mu_values)
    for i = 1:length(n_bits)
        SNR_th(j, i) = 10 * log10((xmax^2) / (2 * (mu_values(j)/xmax)^2 * (3 * 2^(2*n_bits(i)-1) - 2 + 4 / (2^(2*n_bits(i)-1) - 1))));
    end
end

% Compute simulated SNR
for j = 1:length(mu_values)
    for i = 1:length(n_bits)
        % Quantize input signal
        q_ind = mu_law_quantizer(input_signal, n_bits(i), xmax, mu_values(j));
        % Dequantize quantized signal
        deq_signal = mu_law_dequantizer(q_ind, n_bits(i), xmax, mu_values(j));
        % Compute quantization error
        quantization_error = input_signal - deq_signal;
        % Compute simulated SNR
        SNR_sim(j, i) = 10 * log10(sum(input_signal.^2)/sum(quantization_error.^2));
    end
end

% Plot results
figure;
for j = 1:length(mu_values)
    plot(n_bits, SNR_th(j,:), 'o-', 'LineWidth', 2);
    hold on;
end
for j = 1:length(mu_values)
    plot(n_bits, SNR_sim(j,:), 's-', 'LineWidth', 2);
end
xlabel('Number of bits');
ylabel('SNR (dB)');
legend('\mu = 0', '\mu = 5', '\mu = 100', '\mu = 200', 'Location', 'southwest');
