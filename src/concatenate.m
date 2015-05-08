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

%% interpolating snpi1 snpi2 into fqi
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

sz1_fq = size(snpi1.freqlist);
sz2_fq = size(snpi2.freqlist);


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

for i = 1:sz1
    s11(i) = snpi1.data(1,1,i);
    s12(i) = snpi1.data(1,2,i);
    s13(i) = snpi1.data(1,3,i);
    s14(i) = snpi1.data(1,4,i);
    s21(i) = snpi1.data(2,1,i);
    s22(i) = snpi1.data(2,2,i);
    s23(i) = snpi1.data(2,3,i);
    s24(i) = snpi1.data(2,4,i);
    s31(i) = snpi1.data(3,1,i);
    s32(i) = snpi1.data(3,2,i);
    s33(i) = snpi1.data(3,3,i);
    s34(i) = snpi1.data(3,4,i);
    s41(i) = snpi1.data(4,1,i);
    s42(i) = snpi1.data(4,2,i);
    s43(i) = snpi1.data(4,3,i);
    s44(i) = snpi1.data(4,4,i);
end
smat1(1,1,:) = interp1(fq1,s11,fqi);
smat1(1,2,:) = interp1(fq1,s12,fqi);
smat1(1,3,:) = interp1(fq1,s13,fqi);
smat1(1,4,:) = interp1(fq1,s14,fqi);
smat1(2,1,:) = interp1(fq1,s21,fqi);
smat1(2,2,:) = interp1(fq1,s22,fqi);
smat1(2,3,:) = interp1(fq1,s23,fqi);
smat1(2,4,:) = interp1(fq1,s24,fqi);
smat1(3,1,:) = interp1(fq1,s31,fqi);
smat1(3,2,:) = interp1(fq1,s32,fqi);
smat1(3,3,:) = interp1(fq1,s33,fqi);
smat1(3,4,:) = interp1(fq1,s34,fqi);
smat1(4,1,:) = interp1(fq1,s41,fqi);
smat1(4,2,:) = interp1(fq1,s42,fqi);
smat1(4,3,:) = interp1(fq1,s43,fqi);
smat1(4,4,:) = interp1(fq1,s44,fqi);
snpi1.data = smat1;
snpi1.freqlist = fqi;

for i = 1:sz2
    s11_2(i) = snpi2.data(1,1,i);
    s12_2(i) = snpi2.data(1,2,i);
    s13_2(i) = snpi2.data(1,3,i);
    s14_2(i) = snpi2.data(1,4,i);
    s21_2(i) = snpi2.data(2,1,i);
    s22_2(i) = snpi2.data(2,2,i);
    s23_2(i) = snpi2.data(2,3,i);
    s24_2(i) = snpi2.data(2,4,i);
    s31_2(i) = snpi2.data(3,1,i);
    s32_2(i) = snpi2.data(3,2,i);
    s33_2(i) = snpi2.data(3,3,i);
    s34_2(i) = snpi2.data(3,4,i);
    s41_2(i) = snpi2.data(4,1,i);
    s42_2(i) = snpi2.data(4,2,i);
    s43_2(i) = snpi2.data(4,3,i);
    s44_2(i) = snpi2.data(4,4,i);
end

smat2(1,1,:) = interp1(fq2,s11_2,fqi);
smat2(1,2,:) = interp1(fq2,s12_2,fqi);
smat2(1,3,:) = interp1(fq2,s13_2,fqi);
smat2(1,4,:) = interp1(fq2,s14_2,fqi);
smat2(2,1,:) = interp1(fq2,s21_2,fqi);
smat2(2,2,:) = interp1(fq2,s22_2,fqi);
smat2(2,3,:) = interp1(fq2,s23_2,fqi);
smat2(2,4,:) = interp1(fq2,s24_2,fqi);
smat2(3,1,:) = interp1(fq2,s31_2,fqi);
smat2(3,2,:) = interp1(fq2,s32_2,fqi);
smat2(3,3,:) = interp1(fq2,s33_2,fqi);
smat2(3,4,:) = interp1(fq2,s34_2,fqi);
smat2(4,1,:) = interp1(fq2,s41_2,fqi);
smat2(4,2,:) = interp1(fq2,s42_2,fqi);
smat2(4,3,:) = interp1(fq2,s43_2,fqi);
smat2(4,4,:) = interp1(fq2,s44_2,fqi);
snpi2.data = smat2;
snpi2.freqlist = fqi;


%%run for-loop for each data point using conc()
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

