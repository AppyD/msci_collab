% mixed layer depth climatology - de boyer montagut
% ARGO mixed layers
% mixed layer depth through time (200m, 300m etc)
% autocorrelate function (between the diff levels)
% EOF analysis without the detrend as well
% download hadley data with SLP -- MCA between SST and SLP

%%%%% PARAMETERS %%%%%
NModes = 6;

Latitude_min = 10.5; %5.5;
Latitude_max = 70.5; %55.5;     %latitude ranges for analysis
Longitude_min = 10.5;% -40.5;
Longitude_max = -100.5;  %longitude ranges for analysis

% nb. date format is MM-dd-YYYY
start_date = '10-01-1900';
end_date = '05-01-1991';
abs_start = '01-01-1870';
abs_end = '01-01-2015';

%%%%%%%% CODE %%%%%%%%

load('HadleySSTVars', 'SST', 'latitude', 'longitude');

% clean data --- missing values inserted as -999.99999999999999 originally
% are now changed to NaN
SST(SST < -200) = NaN;

% crop data - Ltmin,Lgmin etc are the indices corresponding to Latitude_min etc 
[Lt,Ltmin,Ltmax] = cropped(latitude,Latitude_min,Latitude_max);
[Lg,Lgmin,Lgmax] = cropped(longitude,Longitude_min,Longitude_max);
[tmin,tmax] = date_indices(start_date,end_date,abs_start,abs_end);
SST_cropped = SST(Lgmin:Lgmax, Ltmin:Ltmax, tmin:tmax);

% cosine area weighting on latitude
weights = diag(cos(Lt));
area_weighting(SST_cropped,weights);

% reshape the SST (reduce spatial dims. to 1) and remove NaN columns
% store NaN columns in NaNs for recreating data matrix later

SST_2D = reshape_for_EOF(Lg,Lt,SST_cropped);
[sst,NaNs] = removeNaN(SST_2D);

% detrend data and remove seasonality
sstAnom = find_anomaly(sst);
sstAnom1 = detrend(sstAnom);
CMM = remove_seasonality_2(sstAnom1);
sst_data = season_average(CMM,start_date,end_date);

    % keep the workspace tidy!
    clearvars -except sst_data NaNs Lg Lt NModes start_date end_date SST_cropped;

dates = linspace(datenum(start_date), datenum(end_date), size(sst_data,1));

%compute SVD
covariance = (1/(size(sst_data,1)-1))*(sst_data'*sst_data);
[U,Lambda,UT] = svd(covariance);

%normalised eigenvalues
norm = sum(diag(Lambda));
mean_orig_field = mean(SST_cropped,3);

% plot the modes
figure();
for i = 1:NModes
    totrows = ceil(NModes/3);
    subplot(totrows, 3, i); 
    
    EOF = U(:,i);
    EOF_with_NaNs = addNaN(EOF, NaNs);
    mode = reshape(EOF_with_NaNs, length(Lg), length(Lt));
    
    pcolor(Lg, Lt, mode');
    caxis([-0.05,0.05]);
    colormap(jet(100));
    colorbar;
    shading interp;
    
    hold on;
    [C,h] = contour(Lg,Lt,mean_orig_field','black');
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
figure()
for i = 1:NModes
    totrows = ceil(NModes/2);
    subplot(totrows, 2, i); 
    
    EOF = U(:,i);
    PC = sst_data*EOF;
    
    plot(dates,PC,'bo-');
    datetick('x','yyyy');
    %title(string('Time Series for Mode ') + i + string(' - ') + round(diag(Lambda(i,i))/(norm/100),1) + string('%'));
    xlabel('Year');
    ylabel('SST Anomaly');
    xlim([dates(1)-1,dates(end)+1]);
end
