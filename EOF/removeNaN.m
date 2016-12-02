function [CM,y] = removeNaN(M)

x = zeros(size(M,2));

for n = 1:size(M,2)
   %if sum(squeeze(isnan(M(:,n)))) > 0
   if any(isnan(M(:,n)))
       x(n) = n;
   end
end

y = x(x~=0);
CM = M;
CM(:,y) = [];
y = y';

end