function [CM] = remove_seasonality_2(M)
    
    % n.b. goes in cycle from the starting month of M
    
    CM = M;
    means = zeros(size(CM,1),size(CM,2));
    indM = [];
    nt = size(CM,1);
    lim = ceil(nt/12);
    
    % first find the indices for each month within the dataset, i.e. all
    % indices for January, all for February, etc.

    for i = 1:12
        if mod(i,12) == 0
            x = [12:12:nt];
        else
            x = [i:12:nt];
        end
        indM(end+1,:) = padarray(x,[0,lim-length(x)],'post');
    end
        
    for r = 1:size(CM,1)
        for c = 1:size(CM,2)
            
            which_month = mod(r,12);
            
            if which_month == 0     % december; special case as can't have index which is zero
                im = indM(12,:);
                indm = im(find(im,1,'first'):find(im,1,'last'));
                col = CM(:,c);
                mm = mean(col(indm));
            else
                im = indM(mod(r,12),:);
                indm = im(find(im,1,'first'):find(im,1,'last'));
                col = CM(:,c);
                mm = mean(col(indm));
            end
            means(r,c) = mm;
        end
    end
    
    CM = CM - means;
    
end