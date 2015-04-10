%% test the function spimpulse1207

% s-parameter contains all 1's


% construct sp column vector
sp = ones(1,11)';

fstep = 1; % here we assume fstep = fstart

[ires, tstep, err, errmsg] = spimpulse1207(sp,fstep);

tlist = [0:tstep:tstep*(length(ires)-1)];
irest = ires';  % transpose
plot(tlist, irest);
title('Impulse Response');
xlabel('Time');
ylabel('Impulse');
legend('Quata');
grid on;

pausehere = 1;
