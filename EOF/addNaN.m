function [CM] = addNaN(M,NN)   %NN = NaN List
    CM = M;
    for n = 1:length(NN)
         tp = CM(NN(n):end);
         CM(NN(n)) = NaN;
         CM(NN(n)+1:NN(n)+length(tp)) = tp;
    end

%     CM = M;
%     for n = 1:length(NN)
%         tp = CM(NN(n):end,:);
%         CM(NN(n),:) = NaN;
%         CM(NN(n)+1:end+1,:) = tp;
%     end
end