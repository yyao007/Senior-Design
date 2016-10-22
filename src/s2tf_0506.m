function [ tlist, impresi, err, errmsg ] = s2tf_0506( snp, z0_t,z0_r)
%   s2tf_0506 Calculate transfer function from 4-port S-parameters
%   TF = s2tf_0506(snpi, z0_t, z0_r) calculates a voltage or power
%   wave transfer function from 4-port scattering parameters S_PARAMS
%   

err = [];
errmsg = [];

%% Calculation and derivation follows: 
%  document channel_analysis_derivation_2015_02_24_0005.pdf

znp1 = s2z(snp);
ynp = npmatinv(znp1.data);
fq = snp.freqlist;
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

Htrans_mix1 = 2*(Htrans_mix(2,1,:));%+ Htrans_mix(4,1,:));

Hmirror = conj( Htrans_mix1( :, :, nfp:-1:2)); % contains nfp-1 data
Htransv(:, :, 1:nfp) = Htrans_mix1;
Htransv(:, :,(nfp+1):2*nfp-1 ) = Hmirror;

h_n = ifft(Htransv); % channel impulse response hAC(t)
h_n = reshape(h_n,4001,1);
hac_t = h_n;
impresi = reshape(hac_t,1,4001);

fstop = fq(nfp);
fstep = fstop / (nfp - 1);
fq = 0:fstep:(nfp-1)*fstep;
fspan = 2*fstop;
tstep = 1/fspan;    % in seconds
tspan = 1/fstep;    % in seconds 

tlist = 0:tstep:(2*nfp-2)*tstep;

end

