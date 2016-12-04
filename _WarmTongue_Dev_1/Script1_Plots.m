plot2 = Plotter(merid_grad, longitude, latitude,[270, 320], [20, 50],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Grad _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2 = plot2.Run('linecontour', [20], {'overlay'});

plot2 = Plotter(zonal_grad, longitude, latitude,[270, 320], [20, 50],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Zonal Grad _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2 = plot2.Run('linecontour', [20], {'overlay'});
%%
plot2 = Plotter(abs(merid_grad), longitude, latitude,[270, 320], [20, 50],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Zeroness _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2 = plot2.Run('linecontour', [20], {'overlay'});

plot2 = Plotter(abs(zonal_grad), longitude, latitude,[270, 320], [20, 50],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Zonal Zeroness _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2 = plot2.Run('linecontour', [20], {'overlay'});

%%
plot2 = Plotter(sst-273.15, longitude, latitude,[270, 320], [20, 50],2.2,NaN,0);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'SST _ ERA');
plot2.CaxL=0;
plot2.CaxU=30.0;
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});
colormap(jet(100));

%%

plot2 = Plotter(double(nearZero), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'SST Grad within 0.5std of 0 with\nSST Contours _ ERA');
plot2.CaxL = -1; plot2.CaxU = 1;
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);

plot2.RunData = sst-273.15;
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});


%%

%%
plot2 = Plotter(dy2, longitude, latitude,[270, 320], [20, 50],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Laplace  _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2.RunData = sst-273.15;
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});

%%
plot2 = Plotter(dx2, longitude, latitude,[270, 320], [20, 50],1.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Zonal Laplace  _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2.RunData = sst-273.15;
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});


%%
plot2 = Plotter(dxdy, longitude, latitude,[270, 320], [20, 50],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'DxDy _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2.RunData = sst-273.15;
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});



%%
plot2 = Plotter(abs(dy2), longitude, latitude,[270, 320], [20, 50],8.0,1,NaN);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'Merid Laplace Zeroness  _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2.RunData = sst-273.15;
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});



%%

plot2 = Plotter(double(meridLap_crit1), longitude, latitude,[270, 320], [20, 50],NaN,1,NaN);
plot2.CaxL = -1; plot2.CaxU = 1;
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'regions below the std for Merid Lap  _ ERA');
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);
plot2.RunData = sst-273.15;
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});

%%
figure;
h = histogram(merid_grad_trimmed, 40);
title('Prob. Dis. for Meridional Gradient');
ylabel('counts');
xlabel('gradient size');
%%

%%

plot2 = Plotter(double(nearZero_V2), longitude, latitude,[270, 320], [20, 50],8.0,1,0);
plot2 = plot2.setLabels('Longitude \phi', 'Latitude \theta', 'SST Grad within 0.1std of 0 with\nSST Contours _ ERA \n Version 2 ');
plot2.CaxL = -1; plot2.CaxU = 1;
plot2 = plot2.Run('pcolor', [NaN], {'nan'});
plot2 = plot2.AddLand(sst,1);

plot2.RunData = sst-273.15;
plot2 = plot2.Run('linecontour', [20], {'overlay', 'contourlabels'});


%%