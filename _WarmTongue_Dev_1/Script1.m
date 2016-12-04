addpath(genpath('../Libraries/'));

%% IMPORT DATA
dataLocation = '../../../Shared/Data/ARGO/';

sst_mean = ncread([dataLocation, 'Data_Temperature.nc'], 'ARGO_TEMPERATURE_MEAN');
longitude = ncread([dataLocation, 'Data_Temperature.nc'], 'LONGITUDE');
latitude = ncread([dataLocation, 'Data_Temperature.nc'], 'LATITUDE');
time = ncread([dataLocation, 'Data_Temperature.nc'], 'TIME');


tmp = sst_mean(:,:,1);
% field, long, lat, longRa, latRan, STDFa, CentreZero, Anom
plot1 = Plotter(tmp, longitude, latitude,[250, 360], [10, 60], NaN,NaN, NaN);
plot1 = plot1.setLabels('Longitude \phi', 'Latitude \theta', NaN);
plot1 = plot1.Run('linecontour', [40], 'nan');
plot1 = plot1.AddLand(tmp,1);


%%

[zonal_grad, merid_grad] = gradientH(tmp, longitude, latitude);
plot2 = Plotter(merid_grad, longitude, latitude,[275, 350], [25, 45],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Grad');
plot2 = plot2.Run('linecontour', [20], {'nan'});
plot2 = plot2.AddLand(tmp,1);
plot2 = plot2.Run('pcolor', [NaN], {'overlay'});

%%

[zonal_grad, merid_grad] = gradientH(tmp, longitude, latitude);
plot2 = Plotter(merid_grad, longitude, latitude,[275, 350], [25, 45],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Grad');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(tmp,1);
plot2 = plot2.Run('linecontour', [20], {'overlay'});
%%

plot3 = Plotter(zonal_grad, longitude, latitude,[250, 360], [10, 60],8.0,1,NaN);
plot3 = plot3.setLabels('Longitude \phi', 'Latitude \theta', 'Zonal Grad');
plot3 = plot3.Run('linecontour', [20], {'contourlabels'});
plot3 = plot3.AddLand(tmp,1);

%%
%merid_grad
zeroness = abs(merid_grad);
plot2 = Plotter(zeroness, longitude, latitude,[275, 350], [25, 45],12.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Grad Zeroness');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(tmp,1);
plot2 = plot2.Run('linecontour', [20], {'overlay'});


%%
%%%%%%%%%%%%%%%%%%%%%%%NEW METHOD%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

dataLocation_era = '../../Results/_WarmTongue_Dev_1/era_surface.nc';
ncdisp(dataLocation_era);
sst_full = ncread(dataLocation_era, 'sst');
sst = nanmean(sst_full, 3);
longitude = ncread(dataLocation_era, 'longitude');
latitude = ncread(dataLocation_era, 'latitude');
%pcolor(longitude, latitude, sst'); grid off; shading interp;
%%
[zonal_grad, merid_grad] = gradientH(sst, longitude, latitude);
[dx2, dxdy] = gradientH(zonal_grad, longitude, latitude);
[dydx, dy2] = gradientH(merid_grad, longitude, latitude);

%%
preamble_meridLap = Plotter(dy2, longitude, latitude,[270, 320], [20, 50],8.0,1,0);
trimmedData_meridLap = preamble_meridLap.trim();
meridLap_std = nanstd(trimmedData_meridLap(:));
disp(['Std Dev of the Merid Laplace: ', num2str(meridLap_std)]);
meridLap_crit1 = abs(dy2)<meridLap_std;

%%
preamble = Plotter(sst, longitude, latitude,[270, 320], [20, 50],8.0,1,0);
trimmedData = preamble.trim();
tmp = trimmedData(:)-273.15;
disp(['Mean: ', num2str(nanmean(tmp))]);
disp(['Std: ', num2str(nanstd(tmp))])
for i = 25:5:95
    disp([num2str(i), 'th per: ', num2str(prctile(tmp, i))])
end
disp(['99th per: ', num2str(prctile(tmp, 99))])
%%
stdGrad_merid = nanstd(merid_grad(:))*0.5;
stdGrad_zon = nanstd(zonal_grad(:))*0.75;
nearZero_1 = ((merid_grad <= stdGrad_merid) & (merid_grad >= -stdGrad_merid));
%nearZero = ((merid_grad <= stdGrad_merid) & (merid_grad >= -stdGrad_merid) & (sst < 25.686 + 273.15));
nearZero_2 = ( (zonal_grad <= stdGrad_zon) & (zonal_grad >= -stdGrad_zon));
%nearZero_3 = (sst < prctile(tmp, 50) + 273.15);  %(sst < 23.2719 + 273.15)
%nearZero_4 = (sst > prctile(tmp, 40) + 273.15);  %(sst < 23.2719 + 273.15)
nearZero = (nearZero_1 & nearZero_2);

%%
tmp = Plotter(merid_grad, longitude, latitude,[270, 320], [20, 50],8.0,1,0);
merid_grad_trimmed = tmp.trim();

tmp = Plotter(zonal_grad, longitude, latitude,[270, 320], [20, 50],8.0,1,0);
zonal_grad_trimmed = tmp.trim();
%%
%%
stdGrad_merid = nanstd(merid_grad_trimmed(:))*0.1;
meanGrad_merid = mean(merid_grad_trimmed(:))*0.5;
stdGrad_zon = nanstd(zonal_grad_trimmed(:))*0.75;
nearZero_1 = ((merid_grad <= stdGrad_merid) & (merid_grad >= -stdGrad_merid));


%nearZero = ((merid_grad <= stdGrad_merid) & (merid_grad >= -stdGrad_merid) & (sst < 25.686 + 273.15));
nearZero_2 = ( (zonal_grad <= stdGrad_zon) & (zonal_grad >= -stdGrad_zon));
%nearZero_3 = (sst < prctile(tmp, 50) + 273.15);  %(sst < 23.2719 + 273.15)
%nearZero_4 = (sst > prctile(tmp, 40) + 273.15);  %(sst < 23.2719 + 273.15)
nearZero_V2 = (nearZero_1);
%%
zonal