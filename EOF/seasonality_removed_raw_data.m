%%%%% PARAMETERS %%%%%
NModes = 6;     %number of modes to be computed

Latitude_min = 10.5; %10.5;
Latitude_max = 55.5; %55.5;     %latitude ranges for analysis
Longitude_min = -40.5;%
Longitude_max = -100.5;  %longitude ranges for analysis

% NB dates are in MM-dd-yyyy format!!!
start_date = '01-01-2004';
end_date = '12-01-2014'; %'10-01-2006'; 
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
weights = diag(sqrt(cos(Lt*2*pi/360)));
area_weighting(SST_cropped,weights);

% reshape the SST (reduce spatial dims. to 1) and remove NaN columns
% store NaN columns in NaNs for recreating data matrix later

SST_2D = reshape_for_EOF(Lg,Lt,SST_cropped);
%SST_2D = reshape(SST_cropped,size(SST_cropped,3),length(Lg)*length(Lt));
[sst,NaNs] = removeNaN(SST_2D);

% detrend data and remove seasonality
sstAnom = find_anomaly(sst);
sstAnom1 = detrend(sstAnom);
sst_data = remove_seasonality_2(sstAnom1);

dates = linspace(datenum(start_date), datenum(end_date), size(sstAnom,1));


nc = 1;
figure();
plot(dates,sstAnom(:,nc));
hold on;
plot(dates,sstAnom1(:,nc));
hold on;
plot(dates,sst_data(:,nc),'o-');

xlabel('Date')
datetick('x','yyyy');
ylabel('SST');
legend('SST Anomaly', 'Detrended Anomaly','Seasonality-removed');