function matrix = zzag(Y)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
 index=reshape(1:numel(Y),size(Y));
 index=fliplr(spdiags(fliplr(index)));
 index(:,1:2:end)=flipud(index(:,1:2:end));
 index(index==0)=[];
 matrix=Y(index);

end

