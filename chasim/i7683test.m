%% setup channel parameters
bit_rate = 28e9;         %bits-per-second
bit_time = 1/bit_rate;   % second
samples_per_bit = 64;  
sampling_rate = bit_rate * samples_per_bit; 
sample_step = bit_time / samples_per_bit;
seqlength = 10000;   % length of random sequence bits
z0_t = input('Enter the reference impedance: ');
z0_r = input('Enter the terminal impedance: ');

%% setup IBIS AMI model path and filename
modelpath = 'C:\Users\younger\Documents\MATLAB\_develop\_chasim\Qlogic_Cetus_wrk';

tx_amifilename = 'g28_28g_tx.ami';
rx_amifilename = 'g28_28g_rx.ami';
tx_dllfilename = 'G28_28G_Tx_32.dll';
rx_dllfilename = 'G28_28G_Rx_32.dll';

tx_amifile = fullfile(modelpath, tx_amifilename);
rx_amifile = fullfile(modelpath, rx_amifilename);
tx_dllfile = fullfile(modelpath, tx_dllfilename);
rx_dllfile = fullfile(modelpath, rx_dllfilename);

addpath(modelpath)

%% concatenation
addpath('C:\Users\younger\Documents\MATLAB\_develop\_chasim\impulse_response_oct2012');
addpath('C:\Users\younger\Documents\MATLAB\_develop\_chasim\SYZ_conversions');
s4ppath = 'C:\Users\younger\Documents\MATLAB\_develop\_chasim\Qlogic_Cetus_wrk';

SNP_ADSname = 'spara1.s4p';
SNP_ADSfile= fullfile(s4ppath, SNP_ADSname);

SNP1_s4pname = 'm_qlogic_baker_e049_fc_tx0_shrt.s4p';
SNP1_s4pfile = fullfile(s4ppath, SNP1_s4pname);

SNP2_s4pname = '20cm_sparam.s4p';
SNP2_s4pfile = fullfile(s4ppath, SNP2_s4pname);

SNP3_s4pname = 'm_qlogic_baker_e049_fc_rx0_shrt.s4p';
SNP3_s4pfile = fullfile(s4ppath, SNP3_s4pname);

SNP_ADS = tsnpimporti(SNP_ADSfile);
SNP1_s4pstruct = tsnpimporti(SNP1_s4pfile);
SNP2_s4pstruct = tsnpimporti(SNP2_s4pfile);
SNP3_s4pstruct = tsnpimporti(SNP3_s4pfile);
%input pindex1 pindex2 pindex 3
%need to be chosen accorinding the pin index of the networks
pindex1 = [1 2;3 4];
pindex2 = [1 2;3 4];
pindex3 = [1 2;3 4];

% calculate DC point of S-parameter in 20cm_sparam.s4p
Rp = 0.2 / 0.035 * 0.0175;
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

%% get channel impulse response 

flist = SNPO_conca.freqlist;
nfp = length(flist);
s12 = reshape( SNPO_conca.data(1,2,:), nfp, 1) ;

fstep = 10e6;

[tlist, impresi, tstep, tspan, err, errmsg] = spimpres(flist, s12);

tinterp = 0:sample_step:5000*sample_step;
[channel_impres, e2, em2] = wavesample(tlist, impresi, tinterp);
plot(tinterp, channel_impres,'--rs', tlist, impresi,'-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Resampled');
grid on;


pausehere = 1;