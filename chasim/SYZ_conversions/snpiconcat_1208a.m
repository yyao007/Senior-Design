function [ snpo, err, errmsg] = snpiconcat_1208a( snpi1,snpi2, pindex1, pindex2)
%% concatenates S-parameter networks. Only i-networks having same port counts 
%  can be concatenated using this function. The concatenated network has the 
%  same port count as the original networks. 
%  

% Input variables
%    snpi1 (struct): first SNP struct containing S-parameter data for 
%        i(nterconnect)-network. See documentation for more information on 
%        SNPi struct and i-network.
%    snpi2 (struct): second SNP struct to be concatenated with the first.
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
err=0;
errmsg ='';
snpo = struct;

tnp1 = snpi2t(snpi1,pindex1);
tnp2 = snpi2t(snpi2,pindex2);    
tnpo = tnpiconcat(tnp1,tnp2);
[snpo, err, errmsg] = tnpi2s(tnpo);
%     fsnp = fullfile(snppath, 'LSI_14p5g_SNPout_in_snpiconcat_pkg_std.s4p');
%     [e1, em1] = snpexport(fsnp, snpo );  
% pauseanchor=1;
end

