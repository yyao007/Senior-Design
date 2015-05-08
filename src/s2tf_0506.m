function [ tlist, impresi, err, errmsg ] = s2tf_0506( snp, z0_t,z0_r)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

err = [];
errmsg = [];


znp1 = s2z(snp);
ynp = npmatinv(znp1.data);
fq = snp.freqlist;
nfp = length(fq);
mv = [1 0 -1 0; 0 1 0 -1; 0.5 0 0.5 0; 0 0.5 0 0.5];
mi = [0.5 0 -0.5 0; 0 0.5 0 -0.5; 1 0 1 0; 0 1 0 1];
for i=1:nfp
   ym(:,:,i) = mi * ynp(:,:,i) * inv(mv);
end

% ydd = ym(1:2,1:2,:);
% u = [1 0;0 1];
% zt = [-2*z0_t 0;0 -2*z0_r];
ztm = [-2*z0_t 0 0 0;0 -2*z0_r 0 0;0 0 -0.5*z0_t 0; 0 0 0 -0.5*z0_r];
u = eye(4);
% for i=1:nfp
%     Htrans(:,:,i) = 2*inv(u - zt * ydd(:,:,i));
% end
for i=1:nfp
    Htrans_mix(:,:,i) = 2*inv(u - ztm * ym(:,:,i) * inv(mv));
end
Htrans_mix1 = (Htrans_mix(2,1,:) + Htrans_mix(4,1,:));

Hmirror = conj( Htrans_mix1( :, :, nfp:-1:2)); % contains nfp-1 data
Htransv(:, :, 1:nfp) = Htrans_mix1;
Htransv(:, :,(nfp+1):2*nfp-1 ) = Hmirror;



SMM = s2smm(snp.data);
TF = s2tf(SMM);
tmirror = conj( TF(nfp:-1:2,1)); % contains nfp-1 data
TFv(1:nfp,1) = TF;
TFv((nfp + 1):(2*nfp-1),1 ) = tmirror;

% s12 = reshape( snp.data(1,2,:), nfp, 1);
% [tlist, h_n1, tstep, tspan, err, errmsg] = spimpres(fq, s12);

h_n = ifft(TFv); % channel impulse response hAC(t)
h_n = reshape(h_n,4001,1);
hac_t = h_n;
impresi = reshape(hac_t,1,4001);


fstop = fq(nfp);
fstep = fstop / (nfp - 1);
fq = 0:fstep:(nfp-1)*fstep;
fspan = 2*fstop;
tstep = 1/fspan;    % in seconds
tspanm = 1/fstep;    % in seconds 

tlist = 0:tstep:(2*nfp-2)*tstep; 


% htemp1 = hac_t(3502:4001);
% hac_t1(1:500) = htemp1;
% htemp2 = hac_t;
% hac_t1(501:4501) = htemp2;
% hac_t1(4502:5002) = htemp2(1:501);







end

