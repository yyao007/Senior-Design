function [ SNPO,PINDEX,fqo,err,errmsg ] = concatenate( snpi1,snpi2,pindex1,pindex2,fqi)
%%function concatenate() links 2 s parameters to be concatenated.
% In this function, snpi1 and snpi2 are interpolated to match with the
% dimension of fqi, then call on conc() to concatenate term by term.
% Input variables:
%   snpi1,snpi2    -> S matrices to be concatenated
%   pindex1,pindex2 -> their pindex respectively
%   fqi -> desired result of the resulting fq of the output SNP 
%   ****Note that this code does not extrapolate, therefore, freq list
%   range of SNP1 and SNP2 must be greater than or equal to fqi*****
% Output variables:
%   SNPO   -> final concatenated S matrix
%   PINDEX -> final pindex
%   fqo = fqi
err = 0;
errmsg = '';
%% Swaping rows to obtain pindex of [1 3;2 4]

  [snpi1.data,pindex1] = rowswap(snpi1.data,pindex1);
  [snpi2.data,pindex2] = rowswap(snpi2.data,pindex2);
sz1 = size(snpi1.data);
sz2 = size(snpi2.data);
sz1 = sz1(3);
sz2 = sz2(3);

%% multiply the resulting RX and TX T matrix
fq1 = snpi1.freqlist;
fq2 = snpi2.freqlist;
sz = size(fqi);
sz = sz(1);
maxx = max(fqi);
minx = min(fqi);

max1 = max(fq1);
max2 = max(fq2);
min1 = min(fq1);
min2 = min(fq2);

CK1 = (fq1 <= maxx & fq1 >= minx);
fq1 = fq1(CK1);

sz1_fq = size(snpi1.freqlist)
sz2_fq = size(snpi2.freqlist)


CK2 = (fq2 <= maxx & fq2 >= minx);
fq2 = fq2(CK2);

sz1_fq = size(fq1);
sz2_fq = size(fq2);

snpi1.data = snpi1.data(:,:,CK1);
snpi2.data = snpi2.data(:,:,CK2);


sz1 = size(snpi1.data);
sz2 = size(snpi2.data);
sz1 = sz1(3);
sz2 = sz2(3);



if(sz1>sz)
    j = 1;
    for i = 1:sz1_fq(1)
        if(fq1(i)==fqi(j))
            ck(i) = 1;
            j = j+1;
        else
            ck(i) = 0;
        end
    end
    ck = logical(ck);
    snpi1.data = snpi1.data(:,:,ck);
elseif(sz1<sz)
    err = 1;
    errmsg = 'please change fq value, or extrapolation is necessary'
    return;
end
if(sz2>sz)
    j = 1;
    for i = 1:sz2_fq(1)
        if(fq2(i)==fqi(j))
            ck(i) = 1;
            j = j+1;
        else
            ck(i) = 0;
        end
    end
    ck = logical(ck);
    snpi2.data = snpi2.data(:,:,ck);
elseif(sz2<sz)
    err = 1;
    errmsg = 'please change fq value, or extrapolation is necessary'
    return;
end



%% Converting back to S matrix after concatenation
for i = 1:sz
    SNPistruct.data(:,:,i) = conc(snpi1.data(:,:,i),snpi2.data(:,:,i));
end
SNPistruct.nport = 4;
SNPistruct.nfreq = sz;
SNPistruct.R = 50;
SNPistruct.parameter = 'S';
SNPistruct.freqlist = fqi;
fqo = fqi;
SNPO = SNPistruct;
PINDEX = [1 3; 2 4];


end

