%   s2tf_0506 Calculate transfer function from 4-port S-parameters
%   TF = s2tf_0506(snpi, z0_t, z0_r) calculates a voltage or power
%   wave transfer function from 4-port scattering parameters S_PARAMS
%   
clear
err = [];
errmsg = [];


z0_t = 50;
z0_r = 50;
%% Loading Testing S parameter 

rootpath = pwd;
s4ppath = fullfile(rootpath, '../../Model_File');
addpath(fullfile(rootpath, '../../previous_codes'));
addpath(fullfile(rootpath, '../../previous_codes/Get_Impulse_Response'));
addpath(fullfile(rootpath, '../../previous_codes/SYZ_conversions'));



SNPTest_s4pname = '20cm_sparam.s4p';
SNPTest_s4pfile = fullfile(s4ppath, SNPTest_s4pname);
SNPTest = tsnpimporti(SNPTest_s4pfile);

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
SNPTest0 = snpinsertdc(SNPTest, dcpoint);



znp1 = s2z(SNPTest0);
ynp = npmatinv(znp1.data);
fq = SNPTest0.freqlist;
nfp = length(fq);
mv = [1 0 -1 0; 0 1 0 -1; 0.5 0 0.5 0; 0 0.5 0 0.5];
mi = [0.5 0 -0.5 0; 0 0.5 0 -0.5; 1 0 1 0; 0 1 0 1];
ym = zeros(4,4,nfp);

for i=1:nfp
   ym(:,:,i) = mi * ynp(:,:,i) * inv(mv);
end

ztm = [-2*z0_t 0 0 0;0 -2*z0_r 0 0;0 0 -0.5*z0_t 0; 0 0 0 -0.5*z0_r];
u = eye(4);
for i=1:nfp
    Htrans_mix(:,:,i) = inv(u - ztm * ym(:,:,i));
end

Htrans_mix1 = 2*(Htrans_mix(2,1,:));

Hmirror = conj( Htrans_mix1( :, :, nfp:-1:2)); % contains nfp-1 data
Htransv(:, :, 1:nfp) = Htrans_mix1;
Htransv(:, :,(nfp+1):2*nfp-1 ) = Hmirror;
Htransv = reshape(Htransv,4001,1);


SMM = s2smm(SNPTest0.data);
TF = s2tf(SMM);
tmirror = conj( TF(nfp:-1:2,1)); % contains nfp-1 data
TFv(1:nfp,1) = TF;
TFv((nfp + 1):(2*nfp-1),1 ) = tmirror;


Diff = TFv - Htransv;


fstop = fq(nfp);
fstep = fstop / (nfp - 1);
fspan = 2*fstop;
flist = reshape(fq,1,nfp);

tstep = 1/fspan;    % in seconds
tspan = 1/fstep;    % in seconds 
tlist = 0:tstep:(2*nfp-2)*tstep;

tstop_test = tlist(2*nfp-1);
tstep_test = tstop_test / (2*nfp-2);
tspan_test = 2*tstop_test;

fstep_test = 1/tspan_test;
fspan_test = 1/tstep_test;
flist_test = 0:fstep:(2*nfp-2)*fstep_test;



Max_TF_error = max(Diff)
Transfer_function_test_pass = Max_TF_error <= 10e-14
Time_conversion_error = max(flist - flist_test)
Time_conversion_test_pass = Time_conversion_error <= 10e-14




