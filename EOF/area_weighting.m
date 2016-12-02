function area_weighting(M,weights)
    if size(M,2) ~= length(weights)
        disp('Matrix dimensions do not match!');
        %replace with exception statement later...
    end
    
    for n = 1:size(M,3)
        M(:,:,n) = M(:,:,n)*weights;
    end
end