clear
%% add path to SYZconversions and data
addpath('XXXwhere your files for tsnimporti\impulse_response_oct2012\impulse_response_oct2012');
addpath('XXX\SYZ_conversions\SYZ_conversions');
s4ppath = 'XXX your data path\Qlogic_Cetus_wrk\data';
%% get data from s4p files
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

fq = SNP2_s4pstruct.freqlist;

%% Using concatenate function
[SNPO_conca,pindex,fq,err,errmsg] = concatenate(SNP1_s4pstruct,SNP2_s4pstruct,pindex1,pindex2,fq);
[SNPO_conca,pindex,fq,err,errmsg] = concatenate(SNPO_conca,SNP3_s4pstruct,pindex,pindex3,fq);

%% extracting data from SONPO_conca.struct for plotting purpose
for i=1:4
        for k=1:2000
            x(i,k) = SNPO_conca.data(1,i,k);
        end
        for k = 1:400
            ADS(i,k) = SNP_ADS.data(1,i,k);
        end
end
for i=1:4
        for k=1:2000
            x(i+4,k) = SNPO_conca.data(2,i,k);
        end
        for k = 1:400
            ADS(i+4,k) = SNP_ADS.data(2,i,k);
        end
end
for i=1:4
        for k=1:2000
            x(i+8,k) = SNPO_conca.data(3,i,k);
        end
        for k = 1:400
            ADS(i+8,k) = SNP_ADS.data(3,i,k);
        end
end
for i=1:4
        for k=1:2000
            x(i+12,k) = SNPO_conca.data(4,i,k);
        end
        for k = 1:400
            ADS(i+12,k) = SNP_ADS.data(4,i,k);
        end
end

%% Insertion loss(IL), Return loss(RL), Near-end crosstalk(NEXT), Far-end Crosstalk(FEXT)
%Matlab data
IL = x([3 8],:);
RL = x([1 6 11 16],:);
NEXT = x([2 12],:);
FEXT = x([4 7],:);

%ADS data
ILa = ADS([3 8],:);
RLa = ADS([1 6 11 16],:);
NEXTa = ADS([2 12],:);
FEXTa = ADS([4 7],:);

%% Matlab
figure
subplot(3,1,1)
plot(fq,real(IL))
title('Insertion Loss')
xlabel('freq')
ylabel('Real')

subplot(3,1,2)
plot(fq,20*log(IL))

xlabel('freq')
ylabel('Magnitude')

subplot(3,1,3)
plot(fq,angle(IL))

xlabel('freq')
ylabel('Phase')

figure
subplot(3,1,1)
plot(fq,real(RL))
title('Return Loss')
xlabel('freq')
ylabel('Real')

subplot(3,1,2)
plot(fq,20*log(RL))

xlabel('freq')
ylabel('Magnitude')

subplot(3,1,3)
plot(fq,angle(RL))

xlabel('freq')
ylabel('Phase')

figure
subplot(3,1,1)
plot(fq,real(NEXT))
title('Near-End Crosstalk')
xlabel('freq')
ylabel('Real')

subplot(3,1,2)
plot(fq,20*log(NEXT))
xlabel('freq')
ylabel('Magnitude')

subplot(3,1,3)
plot(fq,angle(NEXT))
xlabel('freq')
ylabel('Phase')

figure
subplot(3,1,1)
plot(fq,real(FEXT))
title('Far-End Crosstalk')
xlabel('freq')
ylabel('Real')

subplot(3,1,2)
plot(fq,20*log(FEXT))
xlabel('freq')
ylabel('Magnitude')

subplot(3,1,3)
plot(fq,angle(FEXT))
xlabel('freq')
ylabel('Phase')



%% ADS
fqa = SNP_ADS.freqlist(1:400);
figure
subplot(3,1,1)
plot(fqa,real(ILa))
title('ADS Insertion Loss')
xlabel('freq')
ylabel('Real')

subplot(3,1,2)
plot(fqa,20*log(ILa))

xlabel('freq')
ylabel('Magnitude')

subplot(3,1,3)
plot(fqa,angle(ILa))

xlabel('freq')
ylabel('Phase')

figure
subplot(3,1,1)
plot(fqa,real(RLa))
title('ADS Return Loss')
xlabel('freq')
ylabel('Real')

subplot(3,1,2)
plot(fqa,20*log(RLa))

xlabel('freq')
ylabel('Magnitude')

subplot(3,1,3)
plot(fqa,angle(RLa))

xlabel('freq')
ylabel('Phase')

figure
subplot(3,1,1)
plot(fqa,real(NEXTa))
title('ADS Near-End Crosstalk')
xlabel('freq')
ylabel('Real')

subplot(3,1,2)
plot(fqa,20*log(NEXTa))
xlabel('freq')
ylabel('Magnitude')

subplot(3,1,3)
plot(fqa,angle(NEXTa))
xlabel('freq')
ylabel('Phase')

figure
subplot(3,1,1)
plot(fqa,real(FEXTa))
title('ADS Far-End Crosstalk')
axis([0 2*10^10 -0.05 0.05])
xlabel('freq')
ylabel('Real')

subplot(3,1,2)
plot(fqa,20*log(FEXTa))
xlabel('freq')
ylabel('Magnitude')

subplot(3,1,3)
plot(fqa,angle(FEXTa))
xlabel('freq')
ylabel('Phase')


