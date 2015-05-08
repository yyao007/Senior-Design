clear
clc
addpath('C:\Users\Julius\Documents\MATLAB\Senior Design A1\impulse_response_oct2012\impulse_response_oct2012');
addpath('C:\Users\Julius\Documents\MATLAB\Senior Design A1\SYZ_conversions\SYZ_conversions');
s4ppath = 'C:\Users\Julius\Documents\MATLAB\Qlogic_Cetus_wrk\data';

z0_t = 50;
z0_r = 50;

SNP_ADSname = 'snpo.s4p';
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
SNP2_s4pstruct0 = snpinsertdc(SNP2_s4pstruct, dcpoint);
fq = SNP2_s4pstruct0.freqlist;

[SNPO_conca,pindex,fq,err,errmsg] = concatenate(SNP1_s4pstruct,SNP2_s4pstruct0,pindex1,pindex2,fq);
[SNPO_conca,pindex,fq,err,errmsg] = concatenate(SNPO_conca,SNP3_s4pstruct,pindex,pindex3,fq);


fq1 = SNP1_s4pstruct.freqlist;
fq2 = SNP3_s4pstruct.freqlist;
sz = size(fq);
sz = sz(1);
maxx = max(fq);
minx = min(fq);

max1 = max(fq1);
max2 = max(fq2);
min1 = min(fq1);
min2 = min(fq2);

CK1 = (fq1 <= maxx & fq1 >= minx);
fq1 = fq1(CK1);

sz1_fq = size(SNP1_s4pstruct.freqlist);
sz2_fq = size(SNP3_s4pstruct.freqlist);


CK2 = (fq2 <= maxx & fq2 >= minx);
fq2 = fq2(CK2);

sz1_fq = size(fq1);
sz2_fq = size(fq2);

SNP1_s4pstruct.data = SNP1_s4pstruct.data(:,:,CK1);
SNP3_s4pstruct.data = SNP3_s4pstruct.data(:,:,CK2);


sz1 = size(SNP1_s4pstruct.data);
sz2 = size(SNP3_s4pstruct.data);
sz1 = sz1(3);
sz2 = sz2(3);

for i = 1:sz1
    s11(i) = SNP1_s4pstruct.data(1,1,i);
    s12(i) = SNP1_s4pstruct.data(1,2,i);
    s13(i) = SNP1_s4pstruct.data(1,3,i);
    s14(i) = SNP1_s4pstruct.data(1,4,i);
    s21(i) = SNP1_s4pstruct.data(2,1,i);
    s22(i) = SNP1_s4pstruct.data(2,2,i);
    s23(i) = SNP1_s4pstruct.data(2,3,i);
    s24(i) = SNP1_s4pstruct.data(2,4,i);
    s31(i) = SNP1_s4pstruct.data(3,1,i);
    s32(i) = SNP1_s4pstruct.data(3,2,i);
    s33(i) = SNP1_s4pstruct.data(3,3,i);
    s34(i) = SNP1_s4pstruct.data(3,4,i);
    s41(i) = SNP1_s4pstruct.data(4,1,i);
    s42(i) = SNP1_s4pstruct.data(4,2,i);
    s43(i) = SNP1_s4pstruct.data(4,3,i);
    s44(i) = SNP1_s4pstruct.data(4,4,i);
end
smat1(1,1,:) = interp1(fq1,s11,fq);
smat1(1,2,:) = interp1(fq1,s12,fq);
smat1(1,3,:) = interp1(fq1,s13,fq);
smat1(1,4,:) = interp1(fq1,s14,fq);
smat1(2,1,:) = interp1(fq1,s21,fq);
smat1(2,2,:) = interp1(fq1,s22,fq);
smat1(2,3,:) = interp1(fq1,s23,fq);
smat1(2,4,:) = interp1(fq1,s24,fq);
smat1(3,1,:) = interp1(fq1,s31,fq);
smat1(3,2,:) = interp1(fq1,s32,fq);
smat1(3,3,:) = interp1(fq1,s33,fq);
smat1(3,4,:) = interp1(fq1,s34,fq);
smat1(4,1,:) = interp1(fq1,s41,fq);
smat1(4,2,:) = interp1(fq1,s42,fq);
smat1(4,3,:) = interp1(fq1,s43,fq);
smat1(4,4,:) = interp1(fq1,s44,fq);
s1.data = smat1;
s11.freqlist = fq;

for i = 1:sz2
    s11_2(i) = SNP3_s4pstruct.data(1,1,i);
    s12_2(i) = SNP3_s4pstruct.data(1,2,i);
    s13_2(i) = SNP3_s4pstruct.data(1,3,i);
    s14_2(i) = SNP3_s4pstruct.data(1,4,i);
    s21_2(i) = SNP3_s4pstruct.data(2,1,i);
    s22_2(i) = SNP3_s4pstruct.data(2,2,i);
    s23_2(i) = SNP3_s4pstruct.data(2,3,i);
    s24_2(i) = SNP3_s4pstruct.data(2,4,i);
    s31_2(i) = SNP3_s4pstruct.data(3,1,i);
    s32_2(i) = SNP3_s4pstruct.data(3,2,i);
    s33_2(i) = SNP3_s4pstruct.data(3,3,i);
    s34_2(i) = SNP3_s4pstruct.data(3,4,i);
    s41_2(i) = SNP3_s4pstruct.data(4,1,i);
    s42_2(i) = SNP3_s4pstruct.data(4,2,i);
    s43_2(i) = SNP3_s4pstruct.data(4,3,i);
    s44_2(i) = SNP3_s4pstruct.data(4,4,i);
end

smat2(1,1,:) = interp1(fq2,s11_2,fq);
smat2(1,2,:) = interp1(fq2,s12_2,fq);
smat2(1,3,:) = interp1(fq2,s13_2,fq);
smat2(1,4,:) = interp1(fq2,s14_2,fq);
smat2(2,1,:) = interp1(fq2,s21_2,fq);
smat2(2,2,:) = interp1(fq2,s22_2,fq);
smat2(2,3,:) = interp1(fq2,s23_2,fq);
smat2(2,4,:) = interp1(fq2,s24_2,fq);
smat2(3,1,:) = interp1(fq2,s31_2,fq);
smat2(3,2,:) = interp1(fq2,s32_2,fq);
smat2(3,3,:) = interp1(fq2,s33_2,fq);
smat2(3,4,:) = interp1(fq2,s34_2,fq);
smat2(4,1,:) = interp1(fq2,s41_2,fq);
smat2(4,2,:) = interp1(fq2,s42_2,fq);
smat2(4,3,:) = interp1(fq2,s43_2,fq);
smat2(4,4,:) = interp1(fq2,s44_2,fq);
s3.data = smat2;
s3.freqlist = fq;


  [s1.data,pindex1] = rowswap(s1.data,pindex1);
  [s2.data,pindex2] = rowswap(SNP2_s4pstruct0.data,pindex2);
  [s3.data,pindex3] = rowswap(s3.data,pindex3);
  
s_params = cascadesparams(s1.data,s2.data,s3.data);
[s_params,pindex] = rowswap(s_params,pindex);


Error = s_params - SNPO_conca.data;
Max_error = max(max(max(abs(Error))))




