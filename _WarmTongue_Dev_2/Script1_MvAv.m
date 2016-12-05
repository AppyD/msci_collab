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
%{
for i = 1:size(sst_full, 1)
    for j= 1:size(sst_full, 2)
        sst_full(i,j,:) = smooth(squeeze(sst_full(i,j,:)));
    end
end
%}
%%
WarmTongue = WarmTongueAnalysis(longitude, latitude, sst_full);
WarmTongue = WarmTongue.Run();

%%


land = zeros(size(sst_full(:,:,1)));
land(~isnan(sst_full(:,:,1)))=1;

playback = Animator(WarmTongue.WarmTongue(WarmTongue.lonRange, WarmTongue.latRange, :),...
    longitude(WarmTongue.lonRange),latitude(WarmTongue.latRange),[-1,1],0);
%xlabelling, ylabelling, titling, savefile,fps, plotLand, land
playback.overlay = 1;
playback.overlayData = sst_full(WarmTongue.lonRange, WarmTongue.latRange, :);
%%
playback = playback.recordanimation('long', 'lat', 'warm tongue', '../../../Gavin/Results/WarmTongue_newCon_2prcMeth.avi', 9, 1, land(WarmTongue.lonRange, WarmTongue.latRange));

%%