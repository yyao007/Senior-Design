function [wfo, err, errmsg] = wavesample(tlisti, wfi, tinterp)
err=0;
errmsg = '';

wfo = interp1(tlisti, wfi, tinterp);
pausehere=1;