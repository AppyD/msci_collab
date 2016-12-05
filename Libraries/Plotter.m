classdef Plotter
    %%Plotter provides a standard and quick way of make 'pcolor' type plots
    % for this project.
    % Created by Krishna (Gavin) Seegoolam
    
    properties
        FigureHandle
        AxisHandle
        Title
        XLabel
        YLabel
        CaxU
        CaxL
        field
        longitude
        latitude
        RunData
        STDFactorValue
        Anomaly %Boolean
        lonRange %the indicies
        latRange %the indicies
        CentreZero
    end
    
    methods
        function obj = Plotter(field, longitude, latitude, lonRange, latRange, STDFactor, CentreZero, Anomalise)
            if sum(isnan(longitude)) > 0
                obj.longitude = 1:size(field, 1);
            else
                obj.longitude = longitude;
            end
            if sum(isnan(latitude)) > 0
                obj.latitude = 1:size(field, 2);
            else
                obj.latitude = latitude;
            end
            
            if sum(isnan(lonRange)) > 0
                obj.lonRange = 1:size(field, 1);
            elseif sum(isnan(longitude)) == 0
                lowerBound_s = min(longitude(longitude>=lonRange(1)));
                lowerBound = find(longitude==lowerBound_s);
                upperBound_s = max(longitude(longitude<=lonRange(2)));
                upperBound = find(longitude==upperBound_s);
                obj.lonRange = lowerBound:upperBound;
            end
            
            
            
            if sum(isnan(latRange)) > 0
                obj.latRange = 1:size(field, 2);
                disp('Auto pick Latitude Range');
            elseif sum(isnan(latitude)) == 0
                
                lowerBound_s = min(latitude(latitude>=latRange(1)));
                lowerBound = find(latitude==lowerBound_s);
                upperBound_s = max(latitude(latitude<=latRange(2)));
                upperBound = find(latitude==upperBound_s);
                if upperBound > lowerBound
                    obj.latRange = lowerBound:upperBound;
                else
                    
                    obj.latRange = upperBound:lowerBound;
                end
            end
            
            obj.field = field;
            obj.RunData = field;
            
            obj = obj.setLabels('','','');
            
            if sum(isnan(STDFactor)) > 0
                obj.STDFactorValue = 1.7;
            else
                obj.STDFactorValue = STDFactor;
            end
            
            if sum(isnan(CentreZero)) > 0
                CentreZero = 0;
            end
            
            obj = obj.STDFactor(obj.STDFactorValue, CentreZero);
            
            if ( (sum(isnan(Anomalise)) > 0) || Anomalise == 0)
                obj.Anomaly = 0;
            else
                obj = obj.anomalise();
            end
            
            obj.FigureHandle=NaN;
            
        end
        
        function obj = STDFactor(obj, STDFactorValue, CentreZero)
            themean = nanmean(obj.RunData(:));
            thestd = nanstd(obj.RunData(:));
            obj.STDFactorValue = STDFactorValue;
            obj.CaxU = themean + (STDFactorValue*thestd);
            obj.CaxL = themean - (STDFactorValue*thestd);
            
            if CentreZero == 1
                tmp = max([abs(obj.CaxU), abs(obj.CaxL)]);
                obj.CaxU = tmp;
                obj.CaxL = -tmp;
            end
        end
            
            
        
        function obj = setLabels(obj, XLabel, YLabel, Title)
            if sum(isnan(XLabel)) > 0
                obj.XLabel = obj.XLabel;
            else
                obj.XLabel = XLabel;
            end
            if sum(isnan(YLabel)) > 0
                obj.YLabel = obj.YLabel;
            else
                obj.YLabel = YLabel;
            end
            if sum(isnan(Title)) > 0
                obj.Title = obj.Title;
            else
                obj.Title = Title;
            end
        end
        
        function obj = anomalise(obj)
            % Zonally Anomalise the Data
            obj.RunData = obj.RunData - repmat(nanmean(obj.RunData, 1), [size(obj.RunData, 1), 1]);
            obj.Anomaly = 1;
            obj = obj.STDFactor(obj.STDFactorValue, 1);
        end
        
        
        function obj = reset(obj)
            % Zonally Anomalise the Data
            obj.RunData = obj.field;
            %obj.RunData = obj.RunData - repmat(nanmean(obj.RunData, 1), [size(obj.RunData, 1), 1]);
            obj.Anomaly = 0;
            obj = obj.STDFactor(obj.STDFactorValue);
        end
        
        function obj = Run(obj, type, param, mode)
            thetitle = obj.Title;
            if obj.Anomaly == 1
                disp(thetitle);
                thetitle = [thetitle, '\nZonal Anomaly'];
            end
            thetitle = sprintf(thetitle);
            
            if sum(strcmp(mode, 'nan')) == 0 && sum(strcmp(mode, 'overlay')) >= 1
                disp('Use existing figure');
            else
                obj.FigureHandle = figure;
            end
            
                
            if (strcmp(type, '')==1 || strcmp(type, 'pcolor')==1)
                obj.AxisHandle = pcolor(obj.longitude, obj.latitude, obj.RunData');
                colormap(redblue(100));
            elseif (strcmp(type,'linecontour')==1 || strcmp(type, '')==0)
                if sum(isnan(param))>0
                    noLines = 20;
                else
                    noLines = param(1);
                end
                
                [C,obj.AxisHandle] = contour(obj.longitude, obj.latitude, obj.RunData',noLines, 'LineColor', 'black');
                
            end
            caxis([obj.CaxL, obj.CaxU]);
            colorbar('eastoutside');
            shading interp;
            grid off;
            xlim(sort([obj.longitude(obj.lonRange(1)), obj.longitude(obj.lonRange(end))]));
            ylim(sort([obj.latitude(obj.latRange(1)), obj.latitude(obj.latRange(end))]));
            xlabel(obj.XLabel);
            ylabel(obj.YLabel);
            title(thetitle);
            hold on;
            set(gcf, 'Color', 'white');
            box on;
            ax = gca;
            ax.XColor = 'black';
            ax.YColor = 'black';
            
            if sum(strcmp(mode, 'nan')) == 0
                if sum(strcmp(mode, 'contourlabels')) >= 1
                    clabel(C);
                end
            end
        end
        function obj = AddLand(obj, data, calculate)
            v = get(obj.FigureHandle);
            s = get(obj.AxisHandle);
            if calculate == 1
                land = zeros(size(data));
                land(~isnan(data))=1;
            else
                land = data;
            end
            
            contour(obj.longitude, obj.latitude, land', [1], 'LineColor', 'black');
        end
        function obj = AddLand_filled(obj, data, calculate)
            v = get(obj.FigureHandle);
            s = get(obj.AxisHandle);
            if calculate == 1
                land = zeros(size(data));
                land(~isnan(data))=1;
            else
                land = data;
            end
            land = double(~land);
            land(land==0) = NaN;
            contour(obj.longitude, obj.latitude, land', [1], 'LineColor', 'black');
            set(gca, 'Color', [0.8, 0.8, 0.8]);
        end
        function trimmedData = trim(obj)
            trimmedData = obj.RunData(obj.lonRange, obj.latRange);
        end
    end
end