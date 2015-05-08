function [ mato ] = thrdmatmult(mat1,mat2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
sz1 = size(mat1);
sz1 = sz1(3);
sz2 = size(mat2);
sz2 = sz2(3);

if(sz1 == sz2)
    for i = 1:sz1
        mato(:,:,i) = mat1(:,:,i).*mat2(:,:,i);
    end
end



end

