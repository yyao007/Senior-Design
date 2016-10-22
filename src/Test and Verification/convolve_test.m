bit_rate = 28e9;         %bits-per-second
bit_time = 1/bit_rate;   % second
samples_per_bit = 64;  
sampling_rate = bit_rate * samples_per_bit; 
sample_step = bit_time / samples_per_bit;
seqlength = 10000;   % length of random sequence bits


[B,A] = butter(1,0.1)
[h,t] = impz(B,A,4001,4.000000000000000e+10)
hr = reshape(h,1,4001);


filename = 'waveo.xlsx';
waveo = xlsread(filename)

tinterp = 0:sample_step:5000*sample_step;
[channel_impres, e2, em2] = wavesample(t,hr, tinterp);


test_conv = conv(waveo,channel_impres);


plot(tinterp,channel_impres);title mat