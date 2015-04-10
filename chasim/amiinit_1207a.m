function [ impreso, amiparo, amimemhdl, amimsg, err, errmsg ] = amiinit_1207a(amifile, dllfile, impresi, tstep, bittime)
% amiinit runs the AMI_Init function contained in dllfile
%   
% input variables: 
%    impresi (double precision matrix): impulse response
%       based on IBIS BIRD120,
%       first column represents  primary impulse response
%       the rest of the columns represent aggressors
%       number of aggressors equals number of columns minus one
%    tstep (double): time step (aka sample interval) in seconds
%    bittime (double): bit_time in seconds
%    amipari (string): AMI_parameters_in
%
% output variables: 
%    impreso (double precision matrix): impulse response, returned by the AMI_Init function
%    amiparo (string): AMI_parameters_out
%    amimemhdl (integer): memory handle
%    amimsg (string): message returned by AMI_Init function 
%    err (integer): error number
%    errmsg (string): error message

err = 0;
errmsg = '';
%% process input 

amipari = txt2str( amifile );

if isrow(impresi)
    impresi = impresi';
end

[dllpath, dllname, dllext] = fileparts(dllfile);
addpath(dllpath);

lload = loadlibrary(dllfile);
isloadedok = libisloaded(dllname);
libfun = libfunctions(dllname, '-full');


[row_size,aggressors] = size(impresi);

amiparo_ptrptr = libpointer('stringPtrPtr', {''});
amimemhdl_ptrptr = libpointer('voidPtrPtr', []);
amimsg_ptrptr = libpointer('stringPtrPtr', {''});

[ret0, impreso, pario, amiparo, amimemhdl, amimsg ] = ...
    calllib(dllname, 'AMI_Init', impresi, row_size, aggressors-1, tstep, bittime, ...
            amipari, amiparo_ptrptr, amimemhdl_ptrptr, amimsg_ptrptr);
      
%[long, doublePtr, cstring, stringPtrPtr, voidPtrPtr, stringPtrPtr
pauseanchor=1;

end

