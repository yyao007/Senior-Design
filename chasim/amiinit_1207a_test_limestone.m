%% test limestone ami model

%% setup channel parameters
bit_rate = 14.5e9;         %bits-per-second
bit_time = 1/bit_rate;   % second
samples_per_bit = 64;  
sampling_rate = bit_rate * samples_per_bit; 
sample_step = bit_time / samples_per_bit;


% specify the dll file path and name:
dllpath = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\Limestone\dll_lib';

         % C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\HILDA_AMI_5.0\ti_houdini_40nm_v0p6\rx_ibis_ami
dllfilename = 'ibmhsstx_104_win.dll';

dllfile = fullfile(dllpath, dllfilename);

dllfileexist = exist(dllfile, 'file');

if dllfileexist == 2
    msgbox('Info: dll DOES exist!');
else
     msgbox('Error: dll does NOT exist!');   
end

% check that the header file exists
addpath(dllpath)
%[notfound,warnmsg] = loadlibrary(dllfile);

pausehere = 1;
% get the impulse response of the channel, including sample_interval and bit_time
addpath('C:\Users\Jianhua\Documents\MATLAB\_develop\_jz_SNP_importer');

s4ppath = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Channel_Models';
s4pname = 'sample_channel.s4p';
s4pfile = fullfile(s4ppath, s4pname);
s4pstruct = snpimport(s4pfile);
s4pstruct0 = snpinsertdc(s4pstruct);

flist = s4pstruct0.freqlist;
nfp = length(flist);
s12 = reshape( s4pstruct0.data(1,2,:), nfp, 1) ;

fstep = 10e6;

[tlist, impresi, tstep, tspan, err, errmsg] = spimpres(flist, s12);

tinterp = 0:sample_step:(5000*sample_step);
[channel_impres, e2, em2] = wavesample(tlist, impresi, tinterp);
plot(tinterp, channel_impres,'--rs', tlist, impresi,'-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;


pausehere = 1;

%  get the ami parameters
amiFilename = 'houdini_40nm_rx.ami';
amiFile = fullfile(dllpath, amiFilename);

%amiparin = getAMI( amiFile );
amiparin = '';
% calls the amiinit function: 
%[ impreso, amiparoout, mhandle, initmsg, err, errmsg ] = amiinit_1207a(dllfile, impresi', tstep, 32*tstep, amiparin);

pausehere=1;

[ impreso, amiparoout, mhandle, initmsg, err, errmsg ] = amiinit_1207a(dllfile, channel_impres, sample_step, bit_time, amiparin);

plot(tlist, impresi,'--rs', tlist, impreso,'-.bo');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Whatever');
grid on;



pausehere=1;
%   