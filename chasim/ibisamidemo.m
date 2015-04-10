%% IBIS AMI channel simulation demo

%% matlab initialization and IBIS AMI configuration
addpath('C:\Users\Jianhua\Documents\MATLAB\_develop\_jz_SNP_importer');
amimodel_path = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\SerDes_Models';
addpath(amimodel_path);
tx_dll_filename = 'G40_14p5G_LR_Tx_1p65_tt.dll';
rx_dll_filename = 'G40_14p5G_LR_Rx.dll';
tx_ami_filename = 'G40_14p5G_LR_Tx.ami';
rx_ami_filename = 'G40_14p5G_LR_Rx.ami';

tx_dll_file = fullfile(amimodel_path, tx_dll_filename);
rx_dll_file = fullfile(amimodel_path, rx_dll_filename);
tx_ami_file = fullfile(amimodel_path, tx_ami_filename);
rx_ami_file = fullfile(amimodel_path, rx_ami_filename);


%% setup channel parameters
bit_rate = 14.5e9;         %bits-per-second
bit_time = 1/bit_rate;   % second
samples_per_bit = 64;  
sampling_rate = bit_rate * samples_per_bit; 
sample_step = bit_time / samples_per_bit;

%% generate bit sequence
seq_length = 1e3;
bit_sequence = prbs1(seq_length);

%% binary NRZ modulation with level shifting
[mod_out,tstep, e1,em1] = bnrzmod(bit_sequence, bit_rate, samples_per_bit);

%% impulse response of channel

channel_s4p_file = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Channel_Models\sample_channel.s4p';
channel_s4p_struct = snpimport(channel_s4p_file);
channel_s4p_struct0 = snpinsertdc(channel_s4p_struct);

flist = channel_s4p_struct0.freqlist;
nfp = length(flist);   % number of frequency points
s12 = reshape( s4pstruct0.data(1,2,:), nfp, 1) ;

[tlisti, impresi, tstepi, tspani, err, errmsg] = spimpres(flist, s12);
tinterp = 0:sample_step:(tspani-tstep);
[channel_impres, e2, em2] = wavesample(tlisti, impresi, tinterp);




%% channel initialization
tx_ami_param_in = getAMI( tx_ami_file );
rx_ami_param_in = getAMI( rx_ami_file );

% calls the amiinit function: 
% [ tx_impreso, tx_amiparamo, tx_mhdl, tx_initmsg, et, emt ] = ...
%     amiinit_1207a(tx_dll_file, channel_impres, sample_step, bit_time, tx_ami_param_in);
[ tx_impreso, tx_amiparamo, tx_mhdl, tx_initmsg, et, emt ] = ...
    amiinit_1207a(tx_dll_file, impresi, tstepi, 100*tstepi, tx_ami_param_in);
pausehere=1;



