%% test the function spimpulse1207

% import s-parameter file
[snpFile,snpPath,snpIndex] = uigetfile({'*.*'},'Select S4P File');
if snpFile == 0 % uigetfile is cancelled
    return;
end
snp_file = [snpPath,snpFile];
[spar, err, errmsg] = importtssp(snp_file);

% construct sp column vector
sp = spar.data(:,1,2);

fstep = spar.flist(1); % here we assume fstep = fstart

[ires, tstep, err, errmsg] = spimpulse1207(sp,fstep);

tlist = [0:tstep:tstep*(length(ires)-1)];
irest = ires';  % transpose
plot(tlist(20:50), irest(20:50));
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Quata');
grid on;

pausehere = 1;
