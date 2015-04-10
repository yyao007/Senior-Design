function [ s ] = getAMI( amiFile )
% (c) Jianhua Zhou, 2012
% read ami file and returns the string
%   

fid = fopen(amiFile);
% error checking

str = textscan(fid, '%s', 'delimiter', '', 'whitespace', '');
s1 = str{1};
[ncol, nrow] = size(s1);
s = '';
for i = 1:ncol
    s = sprintf('%s\n%s', s, s1{i});
end

end

