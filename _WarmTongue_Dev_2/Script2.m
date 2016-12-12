%% USER DEFINED
addpath(genpath('../Libraries'));
addpath(genpath('../../../Gavin/Code/Libraries'));
dataLocation_era = '../../../Gavin/Results/_WarmTongue_Dev_1/era_surface.nc';
%%

ncdisp(dataLocation_era);
sst_full = ncread(dataLocation_era, 'sst');
%sst = nanmean(sst_full, 3);
%sst = nanmean(sst_full(:,:,107:118), 3);
longitude = ncread(dataLocation_era, 'longitude');
latitude = ncread(dataLocation_era, 'latitude');
timeSeries = ncread(dataLocation_era, 'time');
%pcolor(longitude, latitude, sst'); grid off; shading interp;
%%
timeSnapshots = 1:size(sst_full,3);

us = zeros(2, length(timeSnapshots));
grads = zeros(1, length(timeSnapshots));
incps = zeros(1, length(timeSnapshots));

for i=1:length(timeSnapshots)
    disp(i);
    WarmTongue = WarmTongueAnalysis(longitude, latitude, sst_full(:,:,i));
    WarmTongue = WarmTongue.Run();
    [u,grad,incp] = WarmTongue.arrow(1);
    us(:,i) = u;
    grads(i) = grad;
    incps(i) = incp;
end
%%

angles = atand(grads);

figurehandle = figure;
plot(angles, 'DisplayName', 'Angle of Warm Tongue');
ylabel('Angle of the Warm Tongue');
xlabel('Time (months since Jan 1978)');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);

    savefig('anglevariation.fig');
    print(['WarmTongue_Dev_Angles.png'],'-dpng');
