NModes = 6;

Latitude_min = 10.5;
Latitude_max = 70.5;
Longitude_min = 10.5;
Longitude_max = -100.5;

% nb. date format is MM-dd-YYYY
start_date = '10-01-1900';
end_date = '05-01-1991';

abs_start_SST = '01-01-1870';
abs_end_SST = '01-01-2015';

abs_start_SLP = '01-01-1850';
abs_end_SLP = '01-01-2004';

%%%%%%%% CODE %%%%%%%%

load('HadleySSTVars', 'SST', 'latitude', 'longitude');
SLP = reshape_Had_SLP(dlmread('hadslp2_data.asc'));
lonSLP = -180:5:175;
latSLP = -90:5:90;

SST(SST < -200) = NaN;
%SLP data is interpolated so no missing values

[LtSST, Ltmin, Ltmax] = cropped(latitude, Latitude_min, Latitude_max);
[LgSST, Lgmin, Lgmax] = cropped(longitude, Longitude_min, Longitude_max);
[tmin, tmax] = date_indices(start_date, end_date, abs_start_SST, abs_end_SST);
SST_cropped = SST(Lgmin:Lgmax, Ltmin:Ltmax, tmin:tmax);

[LtSLP, Ltmin, Ltmax] = cropped(latSLP, round(Latitude_min/5)*5, round(Latitude_max/5)*5);
[LgSLP, Lgmin, Lgmax] = cropped(lonSLP, round(Longitude_min/5)*5, round(Longitude_max/5)*5);
[tmin, tmax] = date_indices(start_date, end_date, abs_start_SLP, abs_end_SLP);
SLP_cropped = SLP(Lgmin:Lgmax, Ltmin:Ltmax, tmin:tmax);

weights = diag(cos(LtSST));
area_weighting(SST_cropped,weights);

weights = diag(cos(LtSLP));
area_weighting(SLP_cropped,weights);

SST_2D = reshape_for_EOF(LgSST, LtSST, SST_cropped);
[sst, NaNs_SST] = removeNaN(SST_2D);

SLP_2D = reshape_for_EOF(LgSLP, LtSLP, SLP_cropped);
[slp, NaNs_SLP] = removeNaN(SLP_2D);

sstAnom = find_anomaly(sst);
sstAnom1 = detrend(sstAnom);
sstA2 = remove_seasonality_2(sstAnom1);
sst_data = season_average(sstA2, start_date, end_date).';

slpAnom = find_anomaly(slp);
slpAnom1 = detrend(slpAnom);
slpA2 = remove_seasonality_2(slpAnom1);
slp_data = season_average(slpA2, start_date, end_date).';

dates = linspace(datenum(start_date), datenum(end_date), size(sst_data,1));

clearvars -except sst_data slp_data NaNs_SST NaNs_SLP LgSST LgSLP LtSST LtSLP NModes dates;

C_xy = (1/(size(sst_data,2)-1))*sst_data*slp_data.';
[U,Lambda,VT] = svd(C_xy);

norm = sum(diag(Lambda));

PCA_sst = sst_data.'*U(:,1);
PCA_slp = slp_data.'*VT(:,1);

figure();
plot(dates,PCA_sst,'bo-');
datetick('x','yyyy');
%title(string('Time Series for Mode ') + i + string(' - ') + round(diag(Lambda(i,i))/(norm/100),1) + string('%'));
xlabel('Year');
ylabel('Anomaly');
hold on;
plot(dates,PCA_slp,'rx-');
xlim([dates(1)-1,dates(end)+1]);
legend;

% u1 = sst_data(:,1);
% v1 = slp_data(:,1);
% cmax = u1.'*C_xy*v1;