function [ snpo, err, errmsg ] = snpiconcat( snpi1,snpi2, pindex1, pindex2)
% (c) Jianhua Zhou, 2012
%% concatenates S-parameter networks. Only i-networks having same port counts 
%  can be concatenated using this function. The concatenated network has the 
%  same port count as the original networks. 
%  

% Input variables
%    snpi1 (struct): first SNPi struct containing S-parameter data for 
%        i(nterconnect)-network. See documentation for more information on 
%        SNPi struct and i-network.
%    snpi2 (struct): second SNPi struct to be concatenated with the first.
%        Ports on the left side of snpi2 are connected to ports on the right 
%        side of snpi1, according to the orders listed in pindex1 and pindex2.
%    pindex1 (integer) (optional) port number index matrix of size (N/2, 2) 
%        for snpi1, where N is the port count of snpi1. 
%        The first column represents the "input" ports which become the input 
%        ports of the concatenated network. The second column 
%        represents the "output" ports to be concatenated with the input
%        ports of snpi2. 
%    pindex2 (integer) (optional) port number index matrix of size (N/2, 2) 
%        for snpi1, where N is the port count of snpi2.  
%        The first column represents the "input" ports which are concatenated 
%        with the output ports of snpi1. Second column 
%        represents the "output" ports which become the output ports of the
%        concatenated network. 
%        pindex1 and pindex2 must have the same size.
%
% Output Variables:
%    snpo (struct) concatenated output SNPi struct
%        The left side port numbers are assigned by pindex1(:,1) and,
%        right side port numbers are assigned by pindex2(:,2)

%% initialize variables
snpo = struct;
err = 0;
errmsg = '';

%% verify input variables
% snpi1 and snpi2 must both be present
if nargin < 2
    err = 11;
    errmsg = 'Error: missing input variables(snpconcat)!';
    return
end

% they must be valid SNPi struct of same port count
% ......

% they must also have same number of frequency points and same freqlist
% ......

[np1,np1a,nfreq1] = size(snpi1.data);
[np2,np2a,nfreq2] = size(snpi2.data);

if isodd(np1)
    err = 21;
    errmsg = 'Error: port count is odd (snpconcat)!';
    return
end
if np1 ~= np2
    err = 31;
    errmsg = 'Error: input S-parameter matrix size mismatch (snpconcat)!';
    return
end

% if pindex1 and pindex2 are absent, assign default (H-scheme)
if nargin < 3 || nargin >=3 && isempty(pindex1)
    pindex1 = reshape(1:np1,np1/2,2);
end
if nargin < 3 || nargin >=4 && isempty(pindex2)
    pindex2 = reshape(1:np2,np2/2,2);
end

% verify that pindex1 and pindex2 must be self-consistent
% meaning once sorted, they must start from 1 and end at port count, increment 1
portnumbers1 = sortrows(reshape(pindex1,np1,1));
portnumbers2 = sortrows(reshape(pindex2,np2,1));
if ~isequal(portnumbers1, (1:np1)')  ||  ~isequal(portnumbers2, (1:np2)')
    err = 51;
    errmsg = 'Error: inconsistent port number sequence (snpiconcat) !';
    return
end

[ snpo, err, errmsg ] = snpiconcat_1208a( snpi1,snpi2, pindex1, pindex2)  ;
% pauseanchor=1;
end

