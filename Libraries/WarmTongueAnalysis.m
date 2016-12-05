classdef WarmTongueAnalysis
    %WARMTONGUEANALYSIS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        longitude
        latitude
        temperatureData
        WarmTongue
        lonRange
        latRange
    end
    
    methods
        function obj = WarmTongueAnalysis(longitude, latitude, temperatureData)
            obj.longitude = longitude;
            obj.latitude = latitude;
            obj.temperatureData = temperatureData;
        end
        function obj = Run(obj)
            timelen = size(obj.temperatureData, 3);
            obj.WarmTongue = double(zeros(size(obj.temperatureData)));
            for i = 1:timelen
                sst = obj.temperatureData(:,:,i);
                [zonal_grad, merid_grad] = obj.gradientH(sst, obj.longitude, obj.latitude);
                %[dx2, dxdy] = gradientH(zonal_grad, longitude, latitude);
                %[dydx, dy2] = gradientH(merid_grad, longitude, latitude);

                tmp = Plotter(merid_grad, obj.longitude, obj.latitude,[270, 320], [20, 50],8.0,1,0);
                obj.lonRange = tmp.lonRange;
                obj.latRange = tmp.latRange;
                merid_grad_trimmed = tmp.trim();

                tmp = Plotter(zonal_grad, obj.longitude, obj.latitude,[270, 320], [20, 50],8.0,1,0);
                zonal_grad_trimmed = tmp.trim();

                stdGrad_merid = nanstd(merid_grad_trimmed(:));
                %meanGrad_merid = mean(merid_grad_trimmed(:))*0.5;
                stdGrad_zon = nanstd(zonal_grad_trimmed(:));
                %nearZero_1 = ((merid_grad <= stdGrad_merid*0.05));% & (merid_grad >= -stdGrad_merid*0.4)

                %merid_grad_2 = boxAv(merid_grad, 'default', 0.25, 3);

                % WHcih of the following criteria are best?
                %nearZero_1 = (merid_grad >= -stdGrad_merid*0.45);
                nearZero_1 = (abs(merid_grad) < prctile(abs(merid_grad(:)), 50)); 

                nearZero_2 = (zonal_grad <= stdGrad_zon*0.25);


                %nearZero = ((merid_grad <= stdGrad_merid) & (merid_grad >= -stdGrad_merid) & (sst < 25.686 + 273.15));
                %nearZero_2 = ( (zonal_grad <= stdGrad_zon) & (zonal_grad >= -stdGrad_zon));

                preamble = Plotter(sst, obj.longitude, obj.latitude,[270, 320], [20, 50],8.0,1,0);
                trimmedData = preamble.trim();
                tmp = trimmedData(:)-273.15;
                %disp(['Mean: ', num2str(nanmean(tmp))]);
                %disp(['Std: ', num2str(nanstd(tmp))])
                %for i = 25:5:95
                %    disp([num2str(i), 'th per: ', num2str(prctile(tmp, i))])
                %end
                %disp(['99th per: ', num2str(prctile(tmp, 99))])
                nearZero_3 = (sst < prctile(tmp, 65) + 273.15);  %(sst < 23.2719 + 273.15)
                nearZero_4 = (sst > prctile(tmp, 35) + 273.15);  %(sst < 23.2719 + 273.15)
                nearZero34_tmp = nearZero_3 & nearZero_4;
                nearZero_V2 = (nearZero_1 & nearZero34_tmp);
                
                obj.WarmTongue(:,:,i) = nearZero_V2;
            end
        end
    
        function [gradientX, gradientY] = gradientH(obj, field, longitude, latitude)
            R = 6371; % in km

            longitude_grid_km = (longitude/360) * 2 * pi * R * (cosd(latitude)');

            latitude_km = (latitude/360) .* ( R * 2 * pi );

            latitude_grid_km = repmat(latitude_km', [length(longitude), 1]);


            %parpool(8);

            gradientX = double(zeros(size(field)));
            gradientY = double(zeros(size(field)));

            len_lon = length(longitude);
            len_lat = length(latitude);

            % do X grad first
            for i = 1:len_lat
                x = longitude_grid_km(:,i);
                y = field(:, i);
                grad = obj.gradientIrregular1D(x,y); % return m x 1 vec

                gradientX(:,i) = grad;
            end

            % do Y grad
            for i = 1:len_lon
                x = latitude_grid_km(i, :);
                y = field(i,:);
                grad = obj.gradientIrregular1D(x,y); % return m x 1 vector

                gradientY(i,:) = grad';
            end



            %poolobj = gcp('nocreate');
            %delete(poolobj);
        end

    end
    methods (Static)
        function grad = gradientIrregular1D(x,y)
            %{
            delta_x = x(2:end) - x(1:end-1); % this is delta_x_(i) = x_(i+1) - x_(i)
                                             % hence, delta_x_(i) in lab book
                                             % corresponds to delta_x_(i-1) here
            %}

            x = x(:);
            y = y(:);

            delta_x = x(2:end) - x(1:end-1);
            delta_x = [NaN; delta_x];

            delta_x_i_ = delta_x;
            delta_x_ip1_ = [delta_x_i_(2:end); NaN];

            delta_x_i = delta_x_i_(2:end-1);
            delta_x_ip1 = delta_x_ip1_(2:end-1);

            denom = (1./(delta_x_i + delta_x_ip1)).*(1./(delta_x_i .* delta_x_ip1));

            % % %

            y_i = y(2:end-1);
            y_im1 = y(1:end-2);
            y_ip1 = y(3:end);

            part1 = (delta_x_i.^2) .* y_ip1;
            part2 = ( (delta_x_ip1.^2)  - (delta_x_i.^2) ) .* y_i;
            part3 = y_im1 .* ( delta_x_ip1.^2 );

            numer = part1 + part2 - part3;

            grad = numer .* denom;

            % FIRST GRAD
            part1 = y(3) * (x(2) - x(1))^2;
            part2 = y(2) * (x(3) - x(1))^2;
            part3 = y(1) * ( (x(3) - x(1))^2   -  (x(2) - x(1))^2 );
            part4_denom = (x(2)-x(1))*(x(3)-x(1))*(x(3)-x(2));
            grad1 = (-part1 + part2 - part3) / part4_denom;
            grad = [grad1; grad];

            % LAST GRAD
            part1 = y(end-2) * (x(end) - x(end-1))^2;
            part2 = y(end-1) * (x(end) - x(end-2))^2;
            part3 = y(end)   * (  (x(end) - x(end-2))^2  - (x(end)- x(end-1))^2 );
            part4_denom = (x(end)-x(end-1))*(x(end)-x(end-2))*(x(end-1)-x(end-2));
            grad_end = (part1 - part2 + part3) / part4_denom;
            grad = [grad;grad_end];

        end
    end
end

