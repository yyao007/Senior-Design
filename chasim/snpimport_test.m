


%% -----
[snpFile,snpPath,snpIndex] = uigetfile({'*.*'},'Select S4P File');
if snpFile == 0 % uigetfile is cancelled
    return;
end

snp_file = [snpPath,snpFile];

[sp, err, errmsg] = snpimport(snp_file);

[np, np2, nfreq] = size(sp.data);
flist = sp.freqlist;

s4p_mag = abs(sp.data);
diff_IL = reshape( s4p_mag(1,2,:), nfreq, 1) ;
diff_IL_dB =  20*log10(diff_IL) ;

IL34 = reshape( s4p_mag(3,4, :), nfreq, 1) ;
IL34dB =  20*log10(IL34) ;

plot(flist, diff_IL_dB, flist, IL34dB);
title('Insertion Loss');
xlabel('Frequency (GHz)');
ylabel('Insertion Loss (dB)');
legend('Quata', 'Yuga');
grid on;
pausehere=1;




