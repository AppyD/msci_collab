function [MA] = find_anomaly(M)

    MA = M;
    for i = 1:size(M,2)
        time_mean = mean(M(:,i));
        MA(:,i) = M(:,i) - time_mean;
    end
    
end