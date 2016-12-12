function [winter_anomaly] = season_average(M,startd,endd)
    
% starts from first november in dataset
    % crop data to include only full years with complete winters    
    % winter months are November - March
    
    start_month = month(startd);
    end_month = month(endd);
    nwinters = year(endd)-year(startd);
    
    X = M(12-start_month:end-end_month+3,:);
                %X = circshift(M,start_month+1);  
    
    winter_data = zeros(nwinters,size(X,2));
    ctr = 1;
    
    for r = 1:12:size(X,1)
        winter_data(ctr,:) = mean(X(r:r+4,:),1);
        ctr = ctr + 1;
    end
    
    winter_anomaly = find_anomaly(winter_data);
    
end