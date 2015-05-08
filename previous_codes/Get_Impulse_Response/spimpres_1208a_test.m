%% test the function spimpulse1207

                    % % s-parameter contains all 1's
                    % % construct sp column vector
                    % sp = ones(1,11)';
                    % 
                    % fstep = 1; % here we assume fstep = fstart
                    % 
                    % [ires, tstep, err, errmsg] = spimpulse1207(sp,fstep);
                    % 
                    % tlist = [0:tstep:tstep*(length(ires)-1)];
                    % irest = ires';  % transpose

% import s-parameter file
%[snpFile,snpPath,snpIndex] = uigetfile({'*.*'},'Select S4P File');
snpPath = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Package_Models';
snpFile = 'LSI_14p5g_rx_pkg_std.s4p';
snp_file = fullfile(snpPath,snpFile);
[spar, err, errmsg] = snpimport(snp_file);
[nport,np2,nfreq] = size(spar.data);

% construct sp column vector
sp = reshape( spar.data(1,2,:), nfreq, 1);
sp11 = reshape( spar.data(1,1,:), nfreq, 1);
flst = spar.freqlist;

[flist0, sp0] = spinsertdc(flst,sp);
[flist0, sp110] = spinsertdc(flst,sp11);
[tlist1, impres1, tstep1, tspan1, err1, errmsg1] = spimpres(flist0, sp0);
[tlist2, impres2, tstep2, tspan2, err2, errmsg2] = spimpres(flist0, sp110);
ntp = length(tlist1);

tinterp1 = 0:tstep1*0.4:200*tstep1;

%wfo1 = wavesample(tlist1, impres1, tinterp1);
%wfo2 = wavesample(tlist2, impres2, tinterp2);

%plot(tlist1, impres1','--rs',tlist1,impres2','--bo');
%plot(tlist1, impres1','--rs',tinterp1,wfo1,'--bo');
plot(tlist1, impres1','--rs');
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Quata');
grid on;

pausehere = 1;
