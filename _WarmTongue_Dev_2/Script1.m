%% USER DEFINED
addpath(genpath('../Libraries'));
%addpath(genpath('../../../Gavin/Code/Libraries'));
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
timeSnapshots = [3,96,96,102,107, 384, 390,395, 247, 249, 259];
WarmTongue = WarmTongueAnalysis(longitude, latitude, sst_full(:,:,timeSnapshots));
WarmTongue = WarmTongue.Run();
%%
%{
figurehandle = figure;
for i=1:3 % row number
    for j=1:3 % column number
        n = (3*(i-1))+j;
        
        
        subplot(3,3,n);
        
        
        
        plot2 = Plotter(double(WarmTongue.WarmTongue(:,:,n)), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
        plot2.FigureHandle = figurehandle;
        plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', ['Snapshot: ', num2str(timeSnapshots(n))]);
        plot2.CaxL = -1; plot2.CaxU = 1;
        plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
        plot2 = plot2.AddLand(sst_full(:,:,1),1);

        plot2.RunData = sst_full(:,:,timeSnapshots(n))-273.15;
        plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});

    end
end
mtit(figurehandle, sprintf('SST Grad within 0.5std of 0 with\nSST Contours _ ERA'));
%}

%%
% Create antoher plot which is for each time snapshot
for i=1:length(timeSnapshots) % row number
    n = timeSnapshots(i);
    figurehandle = figure;
    subplot(3,4,1); % SST, Merid Grad, Zonal Grad, Merid Lap, Zonal Lap, Cross Lap, Warm Tongue, Other Diagnostics
    
    plot2 = Plotter(double(WarmTongue.temperatureData(:,:,i)-273.15), longitude, latitude,[270, 320], [20, 50],3.0,0,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'SST');
    plot2.CaxL = 0; plot2.CaxU = 30;
    
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'}); colormap(jet(100));
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = sst_full(:,:,n)-273.15;
    plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});
    
    
    subplot(3,4,2); % SST, Merid Grad, Zonal Grad, Merid Lap, Zonal Lap, Cross Lap, Warm Tongue, Other Diagnostics
    
    plot2 = Plotter(double(WarmTongue.MeridGrad(:,:,i)), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Grad');
    plot2.CaxL = -0.04; plot2.CaxU = 0.04;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = WarmTongue.MeridGrad(:,:,i);
    plot2 = plot2.Run('linecontour', [20], {'overlay'});
    
    
    subplot(3,4,3); % SST, Merid Grad, Zonal Grad, Merid Lap, Zonal Lap, Cross Lap, Warm Tongue, Other Diagnostics
    
    plot2 = Plotter(double(WarmTongue.ZonalGrad(:,:,i)), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Zonal Grad');
    plot2.CaxL = -0.02; plot2.CaxU = 0.02;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = WarmTongue.ZonalGrad(:,:,i);
    plot2 = plot2.Run('linecontour', [40], {'overlay'});
    
    
    
    subplot(3,4,4); % SST, Merid Grad, Zonal Grad, Merid Lap, Zonal Lap, Cross Lap, Warm Tongue, Other Diagnostics
    
    plot2 = Plotter(double(WarmTongue.CrossLap(:,:,i)), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'DxDy');
    plot2.CaxL = -7e-5; plot2.CaxU = 7e-5;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = WarmTongue.CrossLap(:,:,i);
    plot2 = plot2.Run('linecontour', [40], {'overlay'});
    
    
    subplot(3,4,6); % SST, Merid Grad, Zonal Grad, Merid Lap, Zonal Lap, Cross Lap, Warm Tongue, Other Diagnostics
    
    plot2 = Plotter(double(WarmTongue.MeridLap(:,:,i)), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Lap');
    plot2.CaxL = -8e-5; plot2.CaxU = 8e-5;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = WarmTongue.MeridLap(:,:,i);
    plot2 = plot2.Run('linecontour', [20], {'overlay'});
    
    
    
    subplot(3,4,7); % SST, Merid Grad, Zonal Grad, Merid Lap, Zonal Lap, Cross Lap, Warm Tongue, Other Diagnostics
    
    plot2 = Plotter(double(WarmTongue.ZonalLap(:,:,i)), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Zonal Lap');
    %plot2.CaxL = -1; plot2.CaxU = 1;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = WarmTongue.ZonalLap(:,:,i);
    plot2 = plot2.Run('linecontour', [60], {'overlay'});
    
    
    %{
    subplot(3,4,9);
    data = double(WarmTongue.WarmTongue(:,:,i));
    data(data==0)=NaN;
    toPlot = WarmTongue.MeridGrad(:,:,i);
    toPlot = toPlot .* data;
   
    plot2 = Plotter(toPlot, longitude, latitude,[270, 320], [20, 50],2.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Point for interrogation\nMerid Grad Overlap');
    plot2.CaxL = -0.01; plot2.CaxU = 0.01;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'}); colormap(jet(100));
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = WarmTongue.MeridGrad(:,:,i);
    plot2 = plot2.Run('linecontour', [20], {'overlay'});
    
    toPlot = toPlot .* WarmTongue.regionMatrix();
    themin = abs(toPlot(:));
    [min_val,idx]=min(themin);
    [row,col]=ind2sub(size(toPlot),idx);
    hold on;
    plot([longitude(row)],[latitude(col)], 'kx', 'MarkerSize', 30,'LineWidth', 300);
    %}
    
    
    
    
    
    subplot(3,4,5);
    data = double(WarmTongue.WarmTongue(:,:,i));
    data(data==0)=NaN;
    toPlot = WarmTongue.MeridGrad(:,:,i);
    toPlot = toPlot .* data;
   
    plot2 = Plotter(WarmTongue.MeridGrad(:,:,i), longitude, latitude,[270, 320], [20, 50],2.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Point for interrogation\nMerid Lap Overlap');
    plot2.CaxL = -0.01; plot2.CaxU = 0.01;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'}); colormap(jet(100));
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = WarmTongue.MeridLap(:,:,i);
    plot2 = plot2.Run('linecontour', [20], {'overlay'});
    
    toPlot = toPlot .* WarmTongue.regionMatrix();
    themin = abs(toPlot(:));
    [min_val,idx]=min(themin);
    [row,col]=ind2sub(size(toPlot),idx);
    hold on;
    plot([longitude(row)],[latitude(col)], 'kx', 'MarkerSize', 30,'LineWidth', 300);
    
    
    % - Using a point, calculated the normalised u, then plotting curvature
    x_grad = WarmTongue.MeridGrad(longitude(row),latitude(col), i);
    y_grad = WarmTongue.ZonalGrad(longitude(row),latitude(col), i);
    
    
    subplot(3,4,10); 
    
    plot2 = Plotter(double(WarmTongue.temperatureData(:,:,i)-273.15), longitude, latitude,[270, 320], [20, 50],3.0,0,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'SST with Grad Arrows');
    plot2.CaxL = 0; plot2.CaxU = 30;
    
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'}); colormap(jet(100));
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = sst_full(:,:,n)-273.15;
    plot2 = plot2.Run('linecontour', [20], {'overlay'});
    
    hold on;
    longitude_interp = 0:2:359;
    latitude_interp = -90:2:90;
    quiver(longitude, latitude, WarmTongue.MeridGrad(:,:,i)', WarmTongue.ZonalGrad(:,:,i)',6, 'Color', 'black');
    
    
    %{
    subplot(3,4,11); 
    
    plot2 = Plotter(double((WarmTongue.MeridGrad(:,:,i)*u(2))+(WarmTongue.ZonalGrad(:,:,i)*u(1))), longitude, latitude,[270, 320], [20, 50],3.0,0,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Divergence with SST contour');
    plot2.CaxL = -0.025; plot2.CaxU = 0.025;
    
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'}); colormap(jet(100));
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = sst_full(:,:,n)-273.15;
    plot2 = plot2.Run('linecontour', [20], {'overlay'});
    %}
    %{
    hold on;
    longitude_interp = 0:2:359;
    latitude_interp = -90:2:90;
    [longitudeMesh, latitudeMesh] = meshgrid(longitude, latitude);
    [longitude_interpMesh, latitude_interpMesh] = meshgrid(longitude_interp, latitude_interp);
    merid_grad_interp = interp2(longitudeMesh,latitudeMesh,WarmTongue.MeridGrad(:,:,i)',longitude_interpMesh,latitude_interpMesh);
    zonal_grad_interp = interp2(longitudeMesh,latitudeMesh,WarmTongue.ZonalGrad(:,:,i)',longitude_interpMesh,latitude_interpMesh);
    quiver(longitude_interp, latitude_interp, merid_grad_interp, zonal_grad_interp ,6, 'Color', 'black');
    %}
    
    
    
    
    
    
    %split figure into 5 across, 3 down? or 4 * 3?
    subplot(3,4,8);
    plot2 = Plotter(double(WarmTongue.WarmTongue(:,:,i)), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', '');
    plot2.CaxL = -1; plot2.CaxU = 1;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = sst_full(:,:,n)-273.15;
    plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});
    hold on;
    
    [u,grad,incp] = WarmTongue.arrow(i);
    y = (grad .* longitude) + incp;
    plot(longitude, y, 'k-');
    
    
    
    subplot(3,4,9);
    curvature = (WarmTongue.ZonalLap(:,:,i) .* (u(1).^2)) + (2*WarmTongue.CrossLap(:,:,i) .* u(1) .* u(2)) + (WarmTongue.MeridLap(:,:,i) .* (u(2).^2));
    plot2 = Plotter(curvature, longitude, latitude,[270, 320], [20, 50],8.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Curvature (Para)');
    plot2.CaxL = -5e-5; plot2.CaxU = 5e-5;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = sst_full(:,:,n)-273.15;
    plot2 = plot2.Run('linecontour', [20], {'overlay'});
    hold on;
    
    
    
    subplot(3,4,12);
    uold = u;
    u(2) = u(1);
    u(1) = (1 - (u(1)^2))^0.5;
    curvature = (WarmTongue.ZonalLap(:,:,i) .* (u(1).^2)) + (2*WarmTongue.CrossLap(:,:,i) .* u(1) .* u(2)) + (WarmTongue.MeridLap(:,:,i) .* (u(2).^2));
    plot2 = Plotter(curvature, longitude, latitude,[270, 320], [20, 50],8.0,1,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Curvature (Perp)');
    plot2.CaxL = -5e-5; plot2.CaxU = 5e-5;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
    plot2 = plot2.AddLand(sst_full(:,:,1),1);

    plot2.RunData = sst_full(:,:,n)-273.15;
    plot2 = plot2.Run('linecontour', [20], {'overlay'});
    hold on;
    
    
    

    subplot(3,4,11);

    plot2 = Plotter(double((WarmTongue.MeridGrad(:,:,i)*u(2))+(WarmTongue.ZonalGrad(:,:,i)*u(1))), longitude, latitude,[270, 320], [20, 50],3.0,0,0);
    plot2.FigureHandle = figurehandle;
    plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Grad T dot U');
    plot2.CaxL = -0.015; plot2.CaxU = 0.015;
    plot2 = plot2.Run('pcolor', [NaN], {'overlay'}); colormap(jet(100));
    plot2 = plot2.AddLand(sst_full(:,:,1),1);
    plot2.RunData = sst_full(:,:,n)-273.15;
    plot2 = plot2.Run('linecontour', [20], {'overlay'});




    
    mtit(figurehandle, sprintf(['Snapshot: ', num2str(timeSnapshots(i))]));
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    
    
    print(['WarmTongue_Dev_Snapshot_',num2str(n) ,'.png'],'-dpng');
    
    close gcf;
    

end




%%
%{




land = zeros(size(sst_full(:,:,1)));
land(~isnan(sst_full(:,:,1)))=1;

playback = Animator(WarmTongue.WarmTongue(WarmTongue.lonRange, WarmTongue.latRange, :),longitude(WarmTongue.lonRange),latitude(WarmTongue.latRange),[-1,1],0);
%xlabelling, ylabelling, titling, savefile,fps, plotLand, land
playback.overlay = 1;
playback.overlayData = sst_full(WarmTongue.lonRange, WarmTongue.latRange, :);
%%
playback = playback.recordanimation('long', 'lat', 'warm tongue', '../../../Gavin/Results/WarmTongue.avi', 9, 1, land(WarmTongue.lonRange, WarmTongue.latRange));

%%



%TEST

i=1;
%split figure into 5 across, 3 down? or 4 * 3?
subplot(3,4,8);
plot2 = Plotter(double(WarmTongue.WarmTongue(:,:,i)), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
plot2.FigureHandle = figurehandle;
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', '');
plot2.CaxL = -1; plot2.CaxU = 1;
plot2 = plot2.Run('pcolor', [NaN], {'overlay'});
plot2 = plot2.AddLand(sst_full(:,:,1),1);

plot2.RunData = sst_full(:,:,n)-273.15;
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});
hold on;

[u,grad,incp] = WarmTongue.arrow(i);
y = (grad .* longitude) + incp;
plot(longitude, y, 'k-');



mtit(figurehandle, sprintf(['Snapshot: ', num2str(timeSnapshots(i))]));
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
%}
