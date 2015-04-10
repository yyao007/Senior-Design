%% test amiinit_1207a using LSI AMI model

%% setup channel parameters
bit_rate = 5e9;         %bits-per-second
bit_time = 1/bit_rate;   % second
samples_per_bit = 32;  
sampling_rate = bit_rate * samples_per_bit; 
sample_step = bit_time / samples_per_bit;
seqlength = 10000;   % length of random sequence bits


%% setup IBIS AMI model path and filename:
modelpath = 'C:\Users\younger\Documents\MATLAB\_develop\_chasim\i7683_OPUS_SERDES_16GFC\data';

tx_amifilename = 'IBIS_AMI_CHGAIN.ami';
rx_amifilename = 'IBIS_AMI_RX_CTF.ami';
tx_dllfilename = 'IBIS_AMI_CHGAIN.dll';
rx_dllfilename = 'IBIS_AMI_RX_CTF.dll';

tx_amifile = fullfile(modelpath, tx_amifilename);
rx_amifile = fullfile(modelpath, rx_amifilename);
tx_dllfile = fullfile(modelpath, tx_dllfilename);
rx_dllfile = fullfile(modelpath, rx_dllfilename);

addpath(modelpath)

%% get channel impulse response 
addpath('C:\Users\younger\Documents\MATLAB\_develop\_chasim\impulse_response_oct2012');

s4ppath = 'C:\Users\younger\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Channel_Models';
s4pname = 'sample_channel.s4p';
s4pfile = fullfile(s4ppath, s4pname);
s4pstruct = tsnpimporti(s4pfile);
s4pstruct0 = snpinsertdc(s4pstruct);

flist = s4pstruct0.freqlist;
nfp = length(flist);
s12 = reshape( s4pstruct0.data(1,2,:), nfp, 1) ;

fstep = 10e6;

[tlist, impresi, tstep, tspan, err, errmsg] = spimpres(flist, s12);

tinterp = 0:sample_step:5000*sample_step;
[channel_impres, e2, em2] = wavesample(tlist, impresi, tinterp);
plot(tinterp, channel_impres,'--rs', tlist, impresi,'-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;


pausehere = 1;

%% IBIS AMI_Init
[ impresotx, amiparotx, mhtx, initmsgtx, errtx, errmsgtx ] = amiinit_1207a(tx_amifile, tx_dllfile, channel_impres, sample_step, bit_time);

plot(tinterp, channel_impres,'--rs', tinterp, impresotx','-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;


[ impresorx, amiparorx, mhrx, initmsgrx, errrx, errmsgrx ] = amiinit_1207a(rx_amifile, rx_dllfile, impresotx, sample_step, bit_time);

plot(tinterp, channel_impres,'--rs', tinterp, impresotx','-.bo', tinterp, (impresorx+0.1)',':md');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;

%% IBIS AMI_GetWave, Tx
seqi = prbs1(seqlength);
[wavei,sample_step_txgw, tlistt, etxgw,emtxgw] = bnrzmod(seqi, bit_rate, samples_per_bit);
wave_time = tlistt; 

clk_count = seqlength + 2;
clki = rand(1, clk_count) * seqlength * bit_time;


[ waveo, clko, amiparo, amimemhdl, err, errmsg ] = amigetwave_1208a(tx_dllfile, mhtx, wavei, clki);

plot(wave_time, wavei,'--rs', wave_time, waveo,'-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;

%% convolution with channel impulse response

wave_rxin = conv(waveo, impresorx');
wave_time_rxin = ( 0: (length(wave_rxin)-1) ) * sample_step_txgw;
plot(wave_time, wavei,'--ms', wave_time, waveo,'--rd', wave_time_rxin, wave_rxin,'-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;

%% IBIS AMI_GetWave, Rx
seqlength_rxin = length(wave_rxin) / samples_per_bit ;
clk_count = int64(seqlength_rxin + 10);
clki = rand(1, clk_count) * seqlength_rxin * bit_time;

[ wave_rxo, clk_rxo, amipar_rxo, amimemhdl_rxo, errrxo, errmsgrxo ] = amigetwave_1208a(rx_dllfile, mhrx, wave_rxin, clki);
%plot(wave_time, wavei,'--ms', wave_time, waveo,'--rd', wave_time_rxin, wave_rxin,'-.bo');
plot( wave_time, waveo,'--rd', wave_time_rxin, wave_rxin*1e4,'-.bo', wave_time_rxin, wave_rxo,'-.ms');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;

pausehere=1;