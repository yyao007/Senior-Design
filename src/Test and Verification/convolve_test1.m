bit_rate = 28e9;         %bits-per-second
bit_time = 1/bit_rate;   % second
samples_per_bit = 64;  
sampling_rate = bit_rate * samples_per_bit; 
sample_step = bit_time / samples_per_bit;
seqlength = 10000;   % length of random sequence bits


tinterp = 0:sample_step:5000*sample_step;
R = 10;
C = 0.00000000001;

RC = (1/(R*C))*exp(-tinterp/(R*C))