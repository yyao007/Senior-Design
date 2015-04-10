
function [ir, tstep, err, errmsg] = spimpulse1207(sp,fstep,sdc)
%% returns impulse response of S-parameter "sp"

% input variables
%     sp: (column vecotor of complex double numbers) 
%         S-parameter.
%         must contain at least two data points.
%         must start from non-DC frequency.
%         data contained in sp are assumed to be equally stepped.
%        
%     fstep: (double) frequency step in "Hz"
%    
%     sdc: (double) DC value (optional)


%% assign initial value of output variables

ir = [];
tstep = 0;
err = 0;
errmsg = '';

% verify input variables

% if sdc is not provided by input, assign it to 1
sdc = 1;

% number of frequency points in "sp", not including DC
nfp = length(sp);

% mirror the "sp" array with respect to the Nyquist frequency
    
sp_mirror = conj(sp(nfp:-1:1,1));
sp1(1,1) = sdc;
sp1(2:nfp+1,1) = sp;
sp1(nfp+2:2*nfp+1,1) = sp_mirror;

%ir = sqrt(2*nfp+1) * ifft(sp1);
ir = ifft(sp1);
fspan = fstep * (2*nfp + 1);  % frequency span in Hz
% the factor of 2*nfp+1 is calculated according to following: 
% (1) nfp is total frequency points in "sp" not including DC; 
%     the single-sideband bandwidth of "sp" is nfp*fstep (not including DC point)
% (2) the double-sideband bandwidth is 2*nfp*fstep (not including DC point)
% (3) the DC point has a bandwidth from -0.5*fstep to +0.5*fstep
% As a result, the total bandwidth is 2*nfp*fstep + fstep

tstep = 1/fspan;    % in seconds
        
  pauseanchor=1;  
        
        
        
        
    end