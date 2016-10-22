%% differential only serdes channel simulation

%% setup channel parameters
z0_t = input('Enter the reference impedance: ');
z0_r = input('Enter the terminal impedance: ');
bit_rate = 28e9;         %bits-per-second
bit_time = 1/bit_rate;   % second
samples_per_bit = 64;  
sampling_rate = bit_rate * samples_per_bit; 
sample_step = bit_time / samples_per_bit;
seqlength = 10000;   % length of random sequence bits


%% setup IBIS AMI model path and filename:

rootpath = pwd;
modelpath = fullfile(rootpath, '../Model_File');
tx_amifilename = 'g28_28g_tx.ami';
rx_amifilename = 'g28_28g_rx.ami';
tx_dllfilename = 'G28_28G_Tx_32.dll';
rx_dllfilename = 'G28_28G_Rx_32.dll';

tx_amifile = fullfile(modelpath, tx_amifilename);
rx_amifile = fullfile(modelpath, rx_amifilename);
tx_dllfile = fullfile(modelpath, tx_dllfilename);
rx_dllfile = fullfile(modelpath, rx_dllfilename);

addpath(modelpath)

%% get channel impulse response 
addpath(fullfile(rootpath, '../previous_codes'));
addpath(fullfile(rootpath, '../previous_codes/Get_Impulse_Response'));
addpath(fullfile(rootpath, '../previous_codes/SYZ_conversions'));

s4ppath = modelpath;
SNP1_s4pname = 'm_qlogic_baker_e049_fc_tx0_shrt.s4p';
SNP1_s4pfile = fullfile(s4ppath, SNP1_s4pname);

SNP2_s4pname = '20cm_sparam.s4p';
SNP2_s4pfile = fullfile(s4ppath, SNP2_s4pname);

SNP3_s4pname = 'm_qlogic_baker_e049_fc_rx0_shrt.s4p';
SNP3_s4pfile = fullfile(s4ppath, SNP3_s4pname);

SNP1_s4pstruct = tsnpimporti(SNP1_s4pfile);
SNP2_s4pstruct = tsnpimporti(SNP2_s4pfile);
SNP3_s4pstruct = tsnpimporti(SNP3_s4pfile);
%input pindex1 pindex2 pindex 3
%need to be chosen accorinding the pin index of the networks
pindex1 = [1 2;3 4];
pindex2 = [1 2;3 4];
pindex3 = [1 2;3 4];

% calculate DC point of S-parameter in 20cm_sparam.s4p
Rp = 0.3556 / 0.035 * 0.0175;
Rpg = 0.2;
R1 = z0_t;
R2 = z0_r;
totR = Rp + Rpg + R1 + R2;
dcpoint = zeros(4, 4);
dcpoint(1, 1) = 1 - (2 * R1) / totR;
dcpoint(1, 2) = (2 * sqrt(R1 * R2)) / totR;
dcpoint(2, 1) = dcpoint(1, 2);
dcpoint(2, 2) = 1 - (2 * R2) / totR;
dcpoint(3, 3) = dcpoint(1, 1);
dcpoint(3, 4) = dcpoint(1, 2);
dcpoint(4, 3) = dcpoint(2, 1);
dcpoint(4, 4) = dcpoint(2, 2);

% insert DC point
SNP2_s4pstruct0 = snpinsertdc(SNP2_s4pstruct, dcpoint);
fq = SNP2_s4pstruct0.freqlist;

[SNPO_conca,pindex,fq,err,errmsg] = concatenate(SNP1_s4pstruct,SNP2_s4pstruct0,pindex1,pindex2,fq);
[SNPO_conca,pindex,fq,err,errmsg] = concatenate(SNPO_conca,SNP3_s4pstruct,pindex,pindex3,fq);
[SNPO_conca.data,pindex1] = rowswap(SNPO_conca.data,pindex1);

%% get channel impulse response 

[tlist,impresi,errtf,errmsgtf] = s2tf_0506(SNPO_conca, z0_t, z0_r);

tinterp = 0:sample_step:5000*sample_step;
[channel_impres, e2, em2] = wavesample(tlist,impresi, tinterp);

plot(tinterp, channel_impres,'--rs', tlist, impresi,'-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Resampled');

%% IBIS AMI_Init


amipari = txt2str( tx_amifile );

if isrow(channel_impres)
    channel_impres = channel_impres';
end

[dllpath, dllname, dllext] = fileparts(tx_dllfile);
addpath(dllpath);
if (~libisloaded(dllname)) 
lload = loadlibrary(tx_dllfile);
isloadedok = libisloaded(dllname);
libfun = libfunctions(dllname, '-full');


[row_size,aggressors] = size(channel_impres);

amiparo_ptrptr = libpointer('stringPtrPtr', {''});
amimemhdl_ptrptr = libpointer('voidPtrPtr', []);
amimsg_ptrptr = libpointer('stringPtrPtr', {''});
end

[ret0, impresotx, pario, amiparo, mhtx, amimsg ] = ...
    calllib(dllname, 'AMI_Init', channel_impres, row_size, aggressors-1, sample_step, bit_time, ...
            amipari, amiparo_ptrptr, amimemhdl_ptrptr, amimsg_ptrptr);
pauseanchor=1;

% [ impresotx, amiparotx, mhtx, initmsgtx, errtx, errmsgtx ] = amiinit_1207a(tx_amifile, tx_dllfile, channel_impres, sample_step, bit_time);

plot(tinterp, channel_impres,'--rs', tinterp, impresotx','-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;

% [ impresorx, amiparorx, mhrx, initmsgrx, errrx, errmsgrx ] = amiinit_1207a(rx_amifile, rx_dllfile, impresotx, sample_step, bit_time);

amipari = txt2str( rx_amifile );

if isrow(impresotx)
    impresotx = impresotx';
end

[dllpath_rx, dllname_rx, dllext_rx] = fileparts(rx_dllfile);
addpath(dllpath_rx);

if (~libisloaded(dllname_rx)) 
lload = loadlibrary(rx_dllfile);
isloadedok = libisloaded(dllname_rx);
libfun = libfunctions(dllname_rx, '-full');


[row_size,aggressors] = size(impresotx);

amiparo_ptrptr1 = libpointer('stringPtrPtr', {''});
amimemhdl_ptrptr1 = libpointer('voidPtrPtr', []);
amimsg_ptrptr1 = libpointer('stringPtrPtr', {''});
end
[ret0, impresorx, pario, amiparo, mhrx, amimsg ] = ...
    calllib(dllname_rx, 'AMI_Init', impresotx, row_size, aggressors-1, sample_step, bit_time, ...
            amipari, amiparo_ptrptr1, amimemhdl_ptrptr1, amimsg_ptrptr1);
pauseanchor=1;

plot(tinterp, channel_impres,'--rs', tinterp, impresotx','-.bo', tinterp, impresorx,':md');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Modified');
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
grid on;

%% convolution with channel impulse response

wave_rxin = conv(waveo, channel_impres');
wave_time_rxin = ( 0: (length(wave_rxin)-1) ) * sample_step_txgw;
plot(wave_time, wavei,'--ms', wave_time, waveo,'--rd', wave_time_rxin, wave_rxin*0.1,'-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
grid on;

%% IBIS AMI_GetWave, Rx
seqlength_rxin = length(wave_rxin) / samples_per_bit ;
clk_count = int64(seqlength_rxin + 10);
clki = rand(1, clk_count) * seqlength_rxin * bit_time;

[ wave_rxo, clk_rxo, amipar_rxo, amimemhdl_rxo, errrxo, errmsgrxo ] = amigetwave_1208a(rx_dllfile, mhrx, wave_rxin*0.1, clki);

clf;
wave_time_rxin_12 = wave_time_rxin(200000:(200000+samples_per_bit*100));
wave_rxin_12      = wave_rxin(200000:(200000+samples_per_bit*100));
wave_rxo_12       = wave_rxo(200000:(200000+samples_per_bit*100));
plot(wave_time_rxin_12, 0.1*wave_rxin_12,'-.bo', wave_time_rxin_12, wave_rxo_12,'-.ms');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
grid on;

h = plotEye(wave_rxo(200000:(200000+samples_per_bit*100)), 2*samples_per_bit);

pausehere=1;


