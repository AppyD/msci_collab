NModes = 6;
Latitude_min = 10.5; %5.5;
Latitude_max = 70.5; %55.5;     %latitude ranges for analysis
Longitude_min = 10.5;% -40.5;
Longitude_max = -100.5;  %longitude ranges for analysis
start_date = '10-01-1900';
end_date = '05-01-1920';
abs_start = '01-01-1870';
abs_end = '01-01-2015';
%load('HadleySSTVars', 'SST', 'latitude', 'longitude');
SST(SST < -200) = NaN;
% crop data - Ltmin,Lgmin etc are the indices corresponding to Latitude_min etc 
[Lt,Ltmin,Ltmax] = cropped(latitude,Latitude_min,Latitude_max);
[Lg,Lgmin,Lgmax] = cropped(longitude,Longitude_min,Longitude_max);
[tmin,tmax] = date_indices(start_date,end_date,abs_start,abs_end);
SST_cropped = SST(Lgmin:Lgmax, Ltmin:Ltmax, tmin:tmax);


figure
axis tight manual
ax = gca;
ax.NextPlot = 'replaceChildren';

loops = size(SST_cropped,3);
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    pcolor(Lg,Lt,SST_cropped(:,:,j).');
    caxis([-30,30]);
    colormap(jet(100));
    colorbar;
    shading interp;
    F(j) = getframe;
end