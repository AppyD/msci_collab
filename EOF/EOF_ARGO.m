%%%%% PARAMETERS %%%%%
NModes = 3;     %number of modes to be computed

Latitude_min = 10.5; %5.5;
Latitude_max = 64.5; %55.5;     %latitude ranges for analysis
Longitude_min = 369.5;% -40.5;
Longitude_max = 270.5;  %longitude ranges for analysis

% NB dates are in MM-dd-yyyy format!!!
start_date = '01-01-2004';
end_date = '12-01-2015';
abs_start = '01-01-2004';
abs_end = '01-01-2016';

%%%%%%%% CODE %%%%%%%%

%load('HadleySSTVars', 'SST', 'latitude', 'longitude');
longitude = ncread('RG_ArgoClim_Temp.nc','LONGITUDE');
latitude = ncread('RG_ArgoClim_Temp.nc','LATITUDE');
SST = ncread('RG_ArgoClim_Temp.nc','ARGO_TEMPERATURE_ANOMALY');
SST = squeeze(SST(:,:,1,:));

% clean data --- missing values inserted as -999.99999999999999 originally
% are now changed to NaN
SST(SST < -200) = NaN;
SST(SST > 200) = NaN;
SST(SST == -999) = NaN;

% crop data - Ltmin,Lgmin etc are the indices corresponding to Latitude_min etc 
[Lt,Ltmin,Ltmax] = cropped(latitude,Latitude_min,Latitude_max);
[Lg,Lgmin,Lgmax] = cropped(longitude,Longitude_min,Longitude_max);
%[tmin,tmax] = date_indices(SST,start_date,end_date,abs_start,abs_end);
SST_cropped = SST(Lgmin:Lgmax, Ltmin:Ltmax,:);

% cosine area weighting on latitude
weights = diag(sqrt(cos(Lt*2*pi/360)));
area_weighting(SST_cropped,weights);

% reshape the SST (reduce spatial dims. to 1) and remove NaN columns
% store NaN columns in NaNs for recreating data matrix later
SST_2D = reshape_for_EOF(Lg,Lt,SST_cropped);
[sst,NaNs] = removeNaN(SST_2D);

% detrend data and remove seasonality
sstAnom = find_anomaly(sst);
sstAnom = detrend(sstAnom);
[sst_data,mm,ctrs] = remove_seasonality(sstAnom);

    % keep the workspace tidy!
    clearvars -except sst_data mm NaNs Lg Lt NModes start_date end_date SST_cropped;

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
dates = linspace(datenum(start_date), datenum(end_date), size(sst_data,1));
figure()

for i = 1:NModes
    totrows = ceil(NModes/3);
    subplot(totrows, 3, i); 
    
    EOF = U(:,i);
    PC = sst_data*EOF;
    
    plot(dates,PC);
    datetick('x','yyyy');
    title(string('Time Series for Mode ') + i + string(' - ') + round(diag(Lambda(i,i))/(norm/100),1) + string('%'));
    xlabel('Year');
    ylabel('SST Anomaly');
    xlim([dates(1)-1,dates(end)+1]);
end
