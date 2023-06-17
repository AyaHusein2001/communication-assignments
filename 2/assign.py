import numpy as np
import matplotlib.pyplot as plt
import scipy.special

# defining signal to noise ratio , number of bits , samples per bit
SNR, nbits, s_p_b = 10, 100, 10
# generating random_bits
random_bits = np.random.randint(2, size=nbits)
# shaping pulses
signal = np.zeros(nbits * s_p_b)
for i in range(nbits):
    if random_bits[i] == 1:
        signal[i * s_p_b:(i + 1) * s_p_b] = 1
    else:
        signal[i * s_p_b:(i + 1) * s_p_b] = -1
# Adding Gaussian noise with zero mean and variance N0/2
noisy_signal = np.copy(signal)
E = 1
No = E / (10 ** (SNR / 10))
variance = No / 2  # N0/2
for i in range(nbits):
    n = np.sqrt(variance) * np.random.randn(s_p_b)
    noisy_signal[i * s_p_b:(i + 1) * s_p_b] += n
# Receiver filters
# 1-The receiver filter h(t) is a matched filter with unit energy.
h1 = np.ones(s_p_b)
# 2-The receiver filter h(t) is not existent (i.e. h(t) = δ(t).
h2 = np.zeros(10)
h2[5] = 1
# 3-The receiver filter h(t) is a filter with linearly increasing amplitude.
h3 = np.zeros(s_p_b)
for i in range(1, s_p_b):
    h3[i] = h3[i - 1] + np.sqrt(3) / s_p_b

# Receiver outputs
out1 = np.convolve(noisy_signal, h1)
out2 = np.convolve(noisy_signal, h2)
out3 = np.convolve(noisy_signal, h3)

# shaped pulses
plt.figure(1)
plt.plot(signal)
plt.ylabel('pure signal')
plt.show()

# noised signal
plt.figure(2)
plt.plot(noisy_signal)
plt.ylabel('signal with noise')
plt.show()

# received signal from filter1
plt.figure(3)
plt.plot(out1)
plt.ylabel('The receive filter h(t) is a matched filter with unit energy')
plt.show()

# received signal from filter2
plt.figure(4)
plt.plot(out2)
plt.ylabel('The receiver filter h(t) is not existent (i.e. h(t) = δ(t)')
plt.show()

# received signal from filter3
plt.figure(5)
plt.plot(out3)
plt.ylabel('The receiver filter has given specific h(t)')
plt.show()

sig1 = np.zeros(nbits, dtype=int)
sig2 = np.zeros(nbits, dtype=int)
sig3 = np.zeros(nbits, dtype=int)
bit_error_rate = np.zeros(3, dtype=float)
bit_error_rate_theo = np.zeros(3, dtype=float)

for i in range(nbits):
    if out1[i * s_p_b] > 0:
        sig1[i] = 1
    else:
        sig1[i] = 0
    if out2[i * s_p_b] > 0:
        sig2[i] = 1
    else:
        sig2[i] = 0

    if out3[i * s_p_b] > 0:
        sig3[i] = 1
    else:
        sig3[i] = 0

bit_error_rate[0] = bit_error_rate[0] + np.logical_xor(sig1[i], random_bits[i])
bit_error_rate[1] = bit_error_rate[1] + np.logical_xor(sig2[i], random_bits[i])
bit_error_rate[2] = bit_error_rate[2] + np.logical_xor(sig3[i], random_bits[i])
bit_error_rate = bit_error_rate/len(random_bits)

bit_error_rate_theo[0] = 0.5*(1 - scipy.special.erf(np.sqrt(2/No)))
bit_error_rate_theo[1] = 0.5*(1 - scipy.special.erf(np.sqrt(2/No)))
bit_error_rate_theo[2] = 0.5*(1 - scipy.special.erf(np.sqrt(3/(2*No))))

