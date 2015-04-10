%% differential only serdes channel simulation

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
Rp1 = 0.2 / 0.035 * 0.0175;
Rp2 = 0.2;
R1 = z0_t;
R2 = z0_r;
dcpoint = []
fq = SNP2_s4pstruct.freqlist;

[SNPO_conca,pindex,fq,err,errmsg] = concatenate(SNP1_s4pstruct,SNP2_s4pstruct,pindex1,pindex2,fq);
[SNPO_conca,pindex,fq,err,errmsg] = concatenate(SNPO_conca,SNP3_s4pstruct,pindex,pindex3,fq);

%% get channel impulse response 
% znp1 = s2z(SNPO_conca);
% 
% mv = [1 0 -1 0; 0 1 0 -1; 0.5 0 0.5 0; 0 0.5 0 0.5];
% mi = [0.5 0 -0.5 0; 0 0.5 0 -0.5; 1 0 1 0; 0 1 0 1];
% for i=1:800
%    zm(:,:,i) = (mv * znp1.data(:,:,i)) * inv(mi);
% end
% 
% zdd = zm(1:2,1:2,:);
% u = [1 0;0 1];
% zt = [-2*z0_t 0;0 -2*z0_r];
% for i=1:800
%     Htrans(:,:,i) = inv(u - zt * inv(zdd(:,:,i)));
% end
% Htrans1 = Htrans(2, 1, :); % channel transfer function H(jw)
% hac_t = ifft(Htrans1); % channel impulse response hAC(t)
% %channel_impres = hac_t(:,1,:);
% channel_impres = reshape(real(hac_t), 1, 800);
% 
% tinterp = 0:sample_step:799*sample_step;
% plot(tinterp, channel_impres);
% 
%  
% 
% %% IBIS AMI_Init
% amipari = txt2str( tx_amifile );
% 
% if isrow(channel_impres)
%     channel_impres = channel_impres';
% end
% 
% [dllpath, dllname, dllext] = fileparts(tx_dllfile);
% addpath(dllpath);
% 
% lload = loadlibrary(tx_dllfile);
% isloadedok = libisloaded(dllname);
% libfun = libfunctions(dllname, '-full');
% 
% 
% [row_size,aggressors] = size(channel_impres);
% 
% amiparo_ptrptr = libpointer('stringPtrPtr', {''});
% amimemhdl_ptrptr = libpointer('voidPtrPtr', []);
% amimsg_ptrptr = libpointer('stringPtrPtr', {''});
% 
% [ret0, impreso, pario, amiparo, amimemhdl, amimsg ] = ...
%     calllib(dllname, 'AMI_Init', channel_impres, row_size, aggressors-1, sample_step, bit_time, ...
%             amipari, amiparo_ptrptr, amimemhdl_ptrptr, amimsg_ptrptr);
%         
% %[long, doublePtr, cstring, stringPtrPtr, voidPtrPtr, stringPtrPtr
% pauseanchor=1;
% % [ impresotx, amiparotx, mhtx, initmsgtx, errtx, errmsgtx ] = amiinit_1207a(tx_amifile, tx_dllfile, channel_impres, sample_step, bit_time);
% 
% plot(tinterp, channel_impres,'--rs', tinterp, impreso','-.bo');
% title('Impulse Response');
% xlabel('Time');
% ylabel('Impulse');
% legend('Whatever');
% grid on;
% 
% % [ impresorx, amiparorx, mhrx, initmsgrx, errrx, errmsgrx ] = amiinit_1207a(rx_amifile, rx_dllfile, impresotx, sample_step, bit_time);
% % 
% % plot(tinterp, channel_impres,'--rs', tinterp, impresotx','-.bo', tinterp, (impresorx - 0.05)',':md');
% % title('Impulse Response');
% % xlabel('Time');
% % ylabel('Impulse');
% % %legend('Modified');
% % grid on;
% 
% % %% IBIS AMI_GetWave, Tx
% % seqi = prbs1(seqlength);
% % [wavei,sample_step_txgw, tlistt, etxgw,emtxgw] = bnrzmod(seqi, bit_rate, samples_per_bit);
% % wave_time = tlistt; 
% % 
% % clk_count = seqlength + 2;
% % clki = rand(1, clk_count) * seqlength * bit_time;
% % 
% % 
% % [ waveo, clko, amiparo, amimemhdl, err, errmsg ] = amigetwave_1208a(tx_dllfile, mhtx, wavei, clki);
% % 
% % plot(wave_time, wavei,'--rs', wave_time, waveo,'-.bo');
% % title('Impulse Response');
% % xlabel('Time');
% % ylabel('Impulse');
% % %legend('Whatever');
% % grid on;
% % 
% % %% convolution with channel impulse response
% % 
% % wave_rxin = conv(waveo, impresorx');
% % wave_time_rxin = ( 0: (length(wave_rxin)-1) ) * sample_step_txgw;
% % plot(wave_time, wavei,'--ms', wave_time, waveo,'--rd', wave_time_rxin, wave_rxin*0.1,'-.bo');
% % title('Impulse Response');
% % xlabel('Time');
% % ylabel('Impulse');
% % %legend('Whatever');
% % grid on;
% % 
% % %% IBIS AMI_GetWave, Rx
% % seqlength_rxin = length(wave_rxin) / samples_per_bit ;
% % clk_count = int64(seqlength_rxin + 10);
% % clki = rand(1, clk_count) * seqlength_rxin * bit_time;
% % 
% % [ wave_rxo, clk_rxo, amipar_rxo, amimemhdl_rxo, errrxo, errmsgrxo ] = amigetwave_1208a(rx_dllfile, mhrx, wave_rxin*0.1, clki);
% % %plot(wave_time, wavei,'--ms', wave_time, waveo,'--rd', wave_time_rxin, wave_rxin,'-.bo');
% % %plot( wave_time, waveo,'--rd', wave_time_rxin, wave_rxin,'-.bo', wave_time_rxin, wave_rxo,'-.ms');
% % % % plot(  wave_time_rxin, wave_rxin*0.1,'-.bo', wave_time_rxin, wave_rxo,'-.ms');
% % % % title('Impulse Response');
% % % % xlabel('Time');
% % % % ylabel('Impulse');
% % % % legend('Whatever');
% % % % grid on;
% % 
% % clf;
% % wave_time_rxin_12 = wave_time_rxin(2000:(2000+samples_per_bit*100));
% % wave_rxin_12      = wave_rxin(2000:(2000+samples_per_bit*100));
% % wave_rxo_12       = wave_rxo(2000:(2000+samples_per_bit*100));
% % plot(  wave_time_rxin_12, wave_rxin_12*0.1,'-.bo', wave_time_rxin_12, wave_rxo_12,'-.ms');
% % title('Impulse Response');
% % xlabel('Time');
% % ylabel('Impulse');
% % %legend('Whatever');
% % grid on;
% % 
% % h = eyediagram(wave_rxo(2000:(2000+samples_per_bit*100)), 2*samples_per_bit);
% % 
% % pausehere=1;
% % 
% 
% 