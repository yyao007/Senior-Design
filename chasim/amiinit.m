function [ impreso, amiparo, amimemhdl, amimsg, err, errmsg ] = amiinit(amipari, dllfile, impresi, tstep, bittime)
% amiinit runs the AMI_Init function contained in dllfile
%   
% input variables: 
%    amipari (string): input parameters for ami model
%    dllfile (string): path, name and extension of DLL file
%    impresi (double precision matrix): impulse response matrix.
%       first column represents  primary impulse response
%       the rest of the columns represent aggressors
%       number of aggressors equals number of columns minus one
%    tstep (double): time step (aka sample interval) in seconds
%    bittime (double): bit_time in seconds
%
% output variables: 
%    impreso (double precision matrix): impulse response, returned by the AMI_Init function
%    amiparo (string): model parameters returned 
%    amimemhdl (integer): memory handle
%    amimsg (string): message returned by AMI_Init function 
%    err (integer): error number
%    errmsg (string): error message

% verify that all input variables exist and contain valid values
if nargin < 5 || isempty(dllfile) || isempty(impressi) || isempty(tstep) || isempty(bittime)
    err = 1;
    errmsg = 'Error: missing or empty input variables!';
    return
end

if ~ischar(amipari) || ~ischar(dllfile) || ~isnumeric(impresi) || ~isnumeric(tstep) || ~isnumeric(bittime)
    err = 11;
    errmsg = 'Error: incorrect variable type!';
    return
end

if  ( exist(dllfile, 'file') ~= 2) 
    err = 21;
    errmsg = 'Error: DLL file does not exist!';
    return    
end

if tstep < 0 || bittime < 0 || tstep >= bittime
    err = 31;
    errmsg = 'Error: incorrect tstep/bittime range!';
    return
end    

[dllpath, dllname, dllext] = fileparts(dllfile);
addpath(dllpath);

[ impreso, amiparo, amimemhdl, amimsg, err, errmsg ] = amiinit_1210a(amipari, dllfile, impresi, tstep, bittime);
