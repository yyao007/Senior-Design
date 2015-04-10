


%% -----
[tsnpFile,tsnpPath,tsnpIndex] = uigetfile({'*.*'},'Select Touchstone File');
if tsnpFile == 0 % uigetfile is cancelled
    return;
end

tsnp_file = [tsnpPath,tsnpFile];

[sp, err, errmsg] = tsnpimporti(tsnp_file);

[np, np2, nfreq] = size(sp.data);
flist = sp.freqlist;

s4p_mag = abs(sp.data);
IL31 = reshape( s4p_mag(3,1,:), nfreq, 1) ;
IL31dB =  20*log10(IL31) ;

XT21 = reshape( s4p_mag(2,1, :), nfreq, 1) ;
XT21dB =  20*log10(XT21) ;

%plot(flist, IL31dB, flist, XT21dB);
[ax,p1,p2] = plotyy(flist, IL31dB, flist, XT21dB);
title('IL & XT');
xlabel('Frequency (GHz)');
ylabel(ax(1), 'IL (dB)');
ylabel(ax(2), 'XT (dB)');
legend('IL31', 'XT21');
grid on;
pausehere=1;




