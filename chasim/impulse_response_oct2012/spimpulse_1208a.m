
function [impres, tstep, err, errmsg] = spimpres_1208a(spmat,varargin)
%% Description: generate impulse response of an S-parameter element. 
%      For example, the impulse response of S(2,1) is the output at port 2
%      when port 1 is excited by an impulse function.

% input variables
%     spmat (double): s-parameter matrix of size (nfreq,2) where nfreq is 
%         the number frequency points. The first column is the frequency in
%         Hz. Second column is S-parameter at corresponding frequencies.
%         S-parameters are in the format of complex numbers.

%         What this function can and will do to amend conditions in spmat: 
%         (1) if DC point is missing, the function automatically 
%             inserts a DC value 
%         (2) if the frequecny steps are unequal, the s-parameters will be 
%             interpolated using the average fstep: 
%             fstep(average) = fstop/nfreq1
%             where nfreq1 is the number of frequency points excluding DC
%         (3) the user may specify the number of frequency points for interpolation. 
%             the 'fpoints' value does not include the DC point
%         (4) if the input S-parameter's DC value has a non-zero imaginary
%             part, it will be set to zero. Systems having a real impulse
%             response must not have a non-zero imaginary parts at DC.
%         What this function will NOT do: 
%         (a) The stop frequency in the s-parameters is accepted as is and 
%             cannot be changed in this function. If it is desirable to
%             change the stop frequency in spmat, it must be done before calling
%             this function.
%         (*) For all practical purposes, s-parameters must have at least one 
%             data point beyond DC.
%        
%     varargin
%         'ftol' (double): frequency tolerance in Hz (default 1Hz).
%             If the difference of two frequencies is smaller than ftol,
%             they are considered to be the same frequency.
%             This parameter is used to determine if a frequency is "close enough" 
%             to another frequency such that they are practically the same.
%         'interpl' (string): interpolation method (default 'linear'). 
%             Supported values are:
%             'linear', 'spline', 'cubic'
%             Note that extrapolation is not supported. If it is desirable
%             to extrapolate the S-parameters beyond the highest frequency
%             point, it must be performed before calling this function.
%         'fpoints' (integer): number of frequency points excluding DC

%  Output variables
%     impres (double): impulse response vector of size (2*fpoints+1)


%% assign initial value of output variables

impres = [];
tstep = 0;
err = 0;
errmsg = '';

%% verify input variables
% spmat is present and, is numeric type
if nargin < 1
    err = 11;
    errmsg = 'Error: missing input S-parameter (snpimpres_1208a)!';
    return
end

if ~isnumeric(spmat)
    err = 21;
    errmsg = 'Error: input S-parameter is not numeric (snpimpres_1208a)!';
    return
end
if ndims(spmat) > 2
    err = 23;
    errmsg = 'Error: spmat dimension greater than 2 (spimpres_1208a)!';
    return
end

[nfreq,nc] = size(spmat);
% first point in spmat could be DC or non-DC which will be determined later
% using ftol value
if nfreq < 1 || nc ~= 2
    err = 25;
    errmsg = 'Error: incorrect spmat size (spimpres_1208a)!';
    return    
end


%% process varargin
% default values
ftol = 1;   % frequency tolerance in Hz
interpl = 'linear';
fpoints = 0;
DCValue = 0.999;

% vararg string 
varstr = {'ftol', 'interpl', 'fpoints'};

vararginCount = size(varargin,2);
if isodd(vararginCount)
    err = 31;
    errmsg = 'Error: odd number of variable argument entries (snpimpres_1208a)!';
    return
end

if vararginCount > 0   % varargin does exist in input list
    for i = 1:2:vararginCount
        varname = varargin{i};
        varfindarr = find( strncmpi( varname, varstr, length(varname) ) );
        if length(varfindarr) > 1
            err = 101;
            errmsg = 'Error: invalid varargin name (spimpres_1208a)!';
            return
        end
        switch varfindarr
            case 1   % ftol
                ftolvalue = varargin{i+1};
                if isnumeric(ftolvalue)
                    ftol = double(ftolvalue);  % cast to double precision
                else
                    err = 111;
                    errmsg = 'Error: invalid varargin (ftol) value type (spimpres_1208a)!';
                    return
                end
            case 2  % interpl
                interplvalue = varargin{i+1};
                if ischar(interplvalue)
                    interpl = interplvalue;
                else
                    err = 121;
                    errmsg = 'Error: invalid varargin (interpl) value type (spimpres_1208a)!';
                    return
                end                
                
            case 3
                fpointsvalue = varargin{i+1};
                if isinteger(fpointsvalue)
                    fpoints = fpointsvalue;
                else
                    err = 131;
                    errmsg = 'Error: invalid varargin (fpoints) value type (spimpres_1208a)!';
                    return
                end                    
            case 4
                dcvaluevalue = varargin{i+1};
                if isnumeric(dcvaluevalue)
                    dcvalue = dcvaluevalue;
                else
                    err = 141;
                    errmsg = 'Error: invalid varargin (dcvalue) value type (spimpres_1208a)!';
                    return
                end                 
            otherwise
                err = 201;
                errmsg = 'Error: unknown varargin (spimpres_1208a)!';
                return                
        end
    end
end

%% Now that all varargin are processed, process frequency list and fpoints
% frequency list (it has been verified that there is at least one frequency point in spmat array:
freqlist = spmat(:,1);
% if the only frequency point is DC, error and return
if nfreq == 1 && freqlist(1) < ftol
    err = 241;
    errmsg = 'Error: there are no frequency points beyond DC (snpimpres_1208a)!';
    return     
end
% verify freqlist is positive and monotonic
if nnz( freqlist < 0 ) > 0
    err = 231;
    errmsg = 'Error: negative frequency (snpimpres_1208a)!';
    return  
end
% now that we have determined that there is at least one frequency point beyond DC
% process the DC value
% (a) if the original data does not have DC, insert DC point
% (b) if the original data does have DC, modify the DC value using 'dcvalue' variable
dc_point_is_present_in_original = freqlist(1) < ftol; 
if dc_point_is_present_in_original && new_dc_value_is_provided_in_varargin
    % modify original dc value
    
end


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