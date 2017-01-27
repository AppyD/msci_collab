%%%%%%%% PARAMETERS %%%%%%%%%%%
NModes = 6;

Latitude_min = 10.5;
Latitude_max = 70.5;
Longitude_min = 10.5;
Longitude_max = -100.5;

% nb. date format is MM-dd-YYYY
start_date = '10-01-1900';
end_date = '05-01-1991';
abs_start_SLP = '01-01-1850';
abs_end_SLP = '01-01-2004';

%%%%%%%% CODE %%%%%%%%

SLP = reshape_Had_SLP(dlmread('hadslp2_data.asc'));
lonSLP = -180:5:175;     % from notes accompanying data
latSLP = -90:5:90;
%SLP data is interpolated so no missing values

[LtSLP, Ltmin, Ltmax] = cropped(latSLP, round(Latitude_min/5)*5, round(Latitude_max/5)*5);
[LgSLP, Lgmin, Lgmax] = cropped(lonSLP, round(Longitude_min/5)*5, round(Longitude_max/5)*5);
[tmin, tmax] = date_indices(start_date, end_date, abs_start_SLP, abs_end_SLP);
SLP_cropped = SLP(Lgmin:Lgmax, Ltmin:Ltmax, tmin:tmax);

weights = diag(cos(LtSLP));
area_weighting(SLP_cropped,weights);

SLP_2D = reshape_for_EOF(LgSLP, LtSLP, SLP_cropped);
 
slpAnom = find_anomaly(SLP_2D);
slpAnom1 = detrend(slpAnom);
slpA2 = remove_seasonality_2(slpAnom1);
slp_data = season_average(slpA2, start_date, end_date);
 
dates = linspace(datenum(start_date), datenum(end_date), size(slp_data,1));
 
%clearvars -except slp_data SLP_cropped NaNs_SLP LgSLP LtSLP NModes dates;
 
covariance = (1/(size(slp_data,1)-1))*(slp_data'*slp_data);
[U,Lambda,UT] = svd(covariance,0);

%normalised eigenvalues
norm = sum(diag(Lambda));
mean_orig_field = mean(SLP_cropped,3);

% plot the modes
figure();
for i = 1:NModes
    totrows = ceil(NModes/3);
    subplot(totrows, 3, i); 
    
    EOF = U(:,i);
    mode = reshape(EOF, length(LgSLP), length(LtSLP));
    
    pcolor(LgSLP, LtSLP, mode');
    caxis([-0.15,0.15]);
    colormap(jet(100));
    colorbar;
    shading interp;
    
    hold on;
    [C,h] = contour(LgSLP,LtSLP,mean_orig_field','black');
    clabel(C,h);
    
    title(string('EOF Mode ') + i + string(' - ') + round(diag(Lambda(i,i))/(norm/100),1) + string('%'));
end

% %plot eigenvalues
% figure();
% plot(diag(Lambda(1:NModes,1:NModes))/(norm/100), 'x');
% title('Normalised eigenvalues');
% ylabel('Percentage contribution');
% xlabel('Mode number k');

%plot time series for data
figure();
for i = 1:NModes
    totrows = ceil(NModes/2);
    subplot(totrows, 2, i); 
    
    EOF = U(:,i);
    PC = slp_data*EOF;
    
    plot(dates,PC,'bo-');
    datetick('x','yyyy');
    %title(string('Time Series for Mode ') + i + string(' - ') + round(diag(Lambda(i,i))/(norm/100),1) + string('%'));
    xlabel('Year');
    ylabel('SST Anomaly');
    xlim([dates(1)-1,dates(end)+1]);
end
