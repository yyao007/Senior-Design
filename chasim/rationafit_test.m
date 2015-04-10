
% Read RF data
filepath = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Package_Models';
filename = 'LSI_14p5g_rx_pkg_std.s4p';
file = fullfile(filepath, filename);

orig_data = read(rfdata.data,file);

freq = orig_data.Freq;
data = orig_data.S_Parameters(1,1,:);
% Fit a rational function
fit_data = rationalfit(freq,data);
% Compute the frequency response of the fit
[resp,freq] = freqresp(fit_data,freq);
% Plot S11 magnitude (blue) and fit (red)
figure;
title('Rational fitting of S11 magnitude')
plot(orig_data,'S11','dB');
hold on;
plot(freq/1e9,db(resp),'r');
% Plot S11 angle (blue) and fit (red)
figure;
title('Rational fitting of S11 angle')
plot(orig_data,'S11','Angle (radians)');
hold on;
plot(freq/1e9,unwrap(angle(resp)),'r');