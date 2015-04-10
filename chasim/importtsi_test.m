


%% -----
[snpFile,snpPath,snpIndex] = uigetfile({'*.*'},'Select SNP File');
% the file may have an arbitrary extension; the file extension has no impact on the operation
if snpFile == 0 % uigetfile is cancelled
    return;
end

snp_file = [snpPath,snpFile];
t0=tic;
[snpi, err, errmsg] = importtsi(snp_file);
te = toc(t0);
% no error checking here for simplicity
% user should implement error checking for robust programming

flist = snpi.freqlist;
nfreq = snpi.nfreq;

% convert to magnitude
snp_mag = abs(snpi.dat);

% assuming the original file is at least four port (if not the following code will not run)
S13mag = snp_mag(:,1,3);
S13dB = 20*log10(S13mag);

S24 = snp_mag(:,2,4);
S24dB = 20*log10(S24);

plot(flist, S13dB, flist, S24dB);
title('S-Parameter Plot');
xlabel('Frequency (Hz)');
ylabel('S13 and S24 (dB)');
legend('S(1,3)', 'S(2,4)');
grid on;





