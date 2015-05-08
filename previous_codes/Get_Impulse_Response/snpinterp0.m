function [ snpo, err, errmsg ] = snpinterp0( snpi, nfp0, interpmethod,fresol ) 
%% snpinterp0: interpolates S-parameter data from DC to max frequency 
%      the number 0 in function name indicates that original data starts from the
%      DC frequency point

%      If snpi does NOT contain DC point, snpinterp0 returns
%      an empty struct snpo with errors
%  
%  input variables:
%      snpi (struct): SNP struct containing S-parameter WITH DC point.
%      nfp0 (integer): number of frequency points including DC
%      interpmethod(string): (optional) interpolation method
%          default is 'linear', allowable values are 
%          'linear', 'cubic','spline'
%      fresol (double): (optional) frequency resolution in Hz. Frequencies less than
%         fresol are considered to be equal to 0. (default is 1 Hz) Two
%         frequencies closer than fresol are considered identical.
%  output variables
%      iseqstep0 (logical): 

%% initialize output variables
snpo = struct;
err = 0;
errmsg = '';
FRESOLDEFAULT = 1;   % Hz

%% verify input arguments
% snpi
if nargin < 2
    err = 11;
    errmsg = 'Error: missing input variable (snpinterp0) !';
    return
end
% snpi.freqlist
freqlisti = snpi.freqlist; 


if ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~iscolumn(freqlisti) || nnz( freqlisti < 0 ) > 0 || numel(freqlisti) < 1
    err = 21;
    errmsg = 'Error: snpi.freqlist error (snpinterp0) !';
    return    
end
nfreq = length(freqlisti);
fstop = freqlisti(nfreq);
np = size(snpi.data, 1);
    
% interpmethod

if nargin < 3 || (nargin >= 3 && isempty(interpmethod) )   % default to 'linear'
    interpmethod = 'linear';
else                                % interpmethod is specified by input variable
    if ~ischar(interpmethod) 
        err = 61;
        errmsg = 'Error: interpmethod error (snpinterp0) !';
        return         
    end
end

interpcellarr = {'linear','cubic','spline'};
interpfindarr =  find( strncmpi( interpmethod, interpcellarr, length(interpmethod) ) ) ;
if length(interpfindarr) ~= 1
    err = 81;
    errmsg = 'Error: invalid interpmethod value (snpinterp0) !';
    return      
end




% fresol is optional (default to FRESOLDEFAULT)
if nargin < 4 || (nargin >=4 && isempty(fresol))  % fresol is not specified or is empty
    fresol = FRESOLDEFAULT;   % Hz
else   % fresol is specified and non-empty
    if ~isnumeric(fresol)  || numel(fresol) ~= 1 || fresol <= 0
        err = 91;
        errmsg = 'Error: fresol error (snpinterp0) !';
        return  
    else
    end
end

if freqlisti(1) >= fresol  % DC point does NOT exist   
    err = 101;
    errmsg = 'Error: DC point does not exist in original freqlist (snpinterp0) !';
    return  
end

% freqlisto 
fstep = fstop / (nfp0 - 1) ;
freqlisto = fstep * (0:nfp0-1);
snpo.freqlist = freqlisto';
snpo.R = snpi.R;

for i = 1:np
    for j = 1:np
        data_reij = reshape(real(snpi.data(i,j,:)), 1, nfreq) ;
        data_imij = reshape(imag(snpi.data(i,j,:)), 1, nfreq) ;
        data_re_interp = interp1(freqlisti',data_reij, freqlisto, interpmethod);
        data_im_interp = interp1(freqlisti',data_imij, freqlisto, interpmethod);
        snpo.data(i,j,:) = complex(data_re_interp, data_im_interp);
    end
end

pausehere = 1;

end

