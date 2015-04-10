% test dbnrzmod.m

sequence1 = prbs1(10000);
[seqout,tstep, tlist, e1,em1] = bnrzmod(sequence1, 1e9, 16);

lenseqout = length(seqout);
x = [0:lenseqout-1] * tstep ;
plot(x,seqout,'.')




pausehere = 1;
