function [snpo, err, errmsg] = tnpi2s(tnpi)
% (c) Jianhua Zhou, 2012
%% converts T-parameters to S-parameters

% input variables
%   tnpi(struct): TNP struct containing T-parameters of the network
%
% output variables
%   snpo (struct): SNP struct containing S-parameters of the network



if nargin < 1
    err = 11;
    errmsg = 'Error: missing input argument!';
    snpo = struct;
    return
end

% verify that tnpi is a compliant TNP struct
% ...

% call the primitive function:

[snpo, err, errmsg] = tnpi2s_1208a(tnpi);

