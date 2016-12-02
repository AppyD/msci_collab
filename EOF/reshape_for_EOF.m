function dataMatrix = reshape_for_EOF(longi, lati, sst)
    
    reduced = length(longi)*length(lati);
    dataMatrix = reshape(sst(:,:,1), 1, reduced);
    
    for n = 2:length(sst(1,1,:))
       dataMatrix(n,:) = reshape(sst(:,:,n), 1, reduced); 
    end
    
end