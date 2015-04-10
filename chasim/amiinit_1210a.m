function [ impreso, amiparo, amimemhdl, amimsg, err, errmsg ] = amiinit_1210a(amipari, dllfile, impresi, tstep, bittime)
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

err = 0;
errmsg = '';

lload = loadlibrary(dllfile);
isloadedok = libisloaded(dllname);
libfun = libfunctions(dllname, '-full');

[row_size,aggressors1] = size(impresi);
aggressors = aggressors1 - 1;

amiparo_ptrptr = libpointer('stringPtrPtr', {''});
amimemhdl_ptrptr = libpointer('voidPtrPtr', []);
amimsg_ptrptr = libpointer('stringPtrPtr', {''});

[ret0, impreso, pario, amiparo, amimemhdl, amimsg ] = ...
    calllib(dllname, 'AMI_Init', impresi, row_size, aggressors, tstep, bittime, ...
            amipari, amiparo_ptrptr, amimemhdl_ptrptr, amimsg_ptrptr);
        
%[long, doublePtr, cstring, stringPtrPtr, voidPtrPtr, stringPtrPtr
pauseanchor=1;

end

