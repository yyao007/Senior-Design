function [mat1,pino] = rowswap(mat,pin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sz = size(pin);
if(sz(1) ~= sz(2))
    err = 1;
    errmsg = 'pindex must be squar';
    return;
end
    
pindex = reshape(pin,4,1);


for i = 1:4
    if (pindex(i)~= i)
        tempr(pindex(i),:,:) = mat(i,:,:);
    else
        tempr(i,:,:) = mat(i,:,:);
    end
end
for i = 1:4
    if (pindex(i)~= i)
        tempc(:,pindex(i),:) = tempr(:,i,:);
    else
        tempc(:,i,:) = tempr(:,i,:);
    end
end


        

% tempr = mat(r1,:,:);
% mat(r1,:,:) = mat(r2,:,:);
% mat(r2,:,:) = tempr;
% 
% tempc = mat(:,r1,:);
% mat(:,r1,:) = mat(:,r2,:);
% mat(:,r2,:) = tempc;

pino = [1 3;2 4];
mat1 = tempc;
end

