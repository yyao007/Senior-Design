function [ snpo ] = insertdc(snpi,mat)
temp(:,:,1) = mat;
sz = size(snpi.data);
sz = sz(3);
temp(:,:,2:sz+1) = snpi.data;
snpo = snpi;
snpo.data = temp;

fq(1,1) = 0;
fq(2:sz+1,1) = snpi.freqlist;
snpo.freqlist = fq;


end

