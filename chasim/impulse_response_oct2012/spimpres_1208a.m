
function [tlist, impres, tstep, tspan, err, errmsg] = spimpres_1208a(freqlisti, sparam)
% (c) Jianhua Zhou, 2012
%% Description: generates impulse response of an S-parameter element. 

% input variables
%   freqlisti(double): list of frequencies in column. 
%      Requirements include:
%       (1) must contain DC point
%       (2) must contain at least one non-DC  point
%       (3) all frequencies must be equally stepped
%       (4) must be real numbers
%
%   sparam (double): complex values of S-parameter element in column,
%         corresponding to freqlisti
%         must have same size as freqlisti.
%   
%        
%   Notes: 
%     this function does not process the input data for non-compliance.
%     if input data is non-compliant, error will be returned with empty
%     impres value

%  Output variables
%     tlist (double): vector containing list of time ticks in second
%     impres (double): impulse response vector of size 2*fpoints
%              where fpoints are number of freq points excluding DC
%     tstep (double): time step in seconds. 
%     tspan (double): time span in seconds.

%% assign initial value of output variables
tlist = [];
impres = [];
tstep = [];
tspan = [];
err = 0;
errmsg = '';

%% this function does NOT verify input variables
%   all input variables are verified by calling functions

nfp = length(freqlisti);

fstop = freqlisti(nfp);   % in Hz
fstep = fstop / (nfp - 1);  % in Hz

% mirror the "sp" array with respect to the Nyquist frequency
% Note the last frequency point (nfp) is not mirrored. It is the "anchor"
% of the mirror
% Example: if the original sp has 101 points including one DC point, the
% mirrored sp has 99 points. The total points is 101+99 = 2*(nfp-1) where
% nfp = 101 in this case
% this convention is a convenient way to calculate frequency points. 
% for example, in most practical cases, the stop frequency is at a major
% tick, such as 10GHz, 20GHz, or 25GHz. the fstep is usually a minor tick
% such as 10MHz, 50MHz, etc. AS a result, the total number of frequencies
% including DC is alway some major integer plus 1, such as 2001, 1001, etc.
% As a result, by not mirroring the last frequency point, we always end up
% with a major integer such as 2*(2001-1) = 4000, or 2*(101-1) = 200. 
sp_mirror = conj( sparam( (nfp-1):-1:2, 1));  % contains nfp-2 data points
sp1(1:nfp,1) = sparam;
sp1(nfp+1:2*nfp-2,1) = sp_mirror;


%ir = sqrt(2*nfp+1) * ifft(sp1);
impres = real(ifft(sp1)');
fspan = 2*fstop;  % frequency span in Hz
% the factor of 2*nfp+1 is calculated according to following: 
% (1) nfp is total frequency points in "sp" not including DC; 
%     the single-sideband bandwidth of "sp" is nfp*fstep (not including DC point)
% (2) the double-sideband bandwidth is 2*nfp*fstep (not including DC point)
% (3) the DC point has a bandwidth from -0.5*fstep to +0.5*fstep
% As a result, the total bandwidth is 2*nfp*fstep + fstep

tstep = 1/fspan;    % in seconds
tspan = 1/fstep;    % in seconds 
tlist = 0:tstep:( 2*(nfp-1) - 1 + 0.1 )*tstep;  
% due to tlist starting from 0 instead of 1, the last time point is
% 2*(nfp-1) - 1 instead of 2*(nfp-1)


pauseanchor=1;        
        
end