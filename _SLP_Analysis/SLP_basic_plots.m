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

pcolor(LgSLP,LtSLP,SLP_cropped(:,:,1).');
colormap(jet(100));
colorbar;
shading interp;
xlabel('Longitude');
ylabel('Latitude');
title('SLP in Gulf Stream region');