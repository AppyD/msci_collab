function reshaped_data = reshape_Had_SLP(data_matrix)

    num_rows = 37;    %37 different latitude values
    num_cols = size(data_matrix,2);
    num_months = size(data_matrix,1)/num_rows;
    
    reshaped_data = zeros(num_rows,num_cols,num_months);
    page = 0;
    
    for i = 1:37:size(data_matrix,1)
        page = page + 1;
        reshaped_data(:,:,page) = data_matrix(i:i+36,:);
    end
    
end