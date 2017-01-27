figure();
PC_sst = sst_data(:,1).'*sst_data;
std_sst = std(PC_sst);
PC_sst1 = PC_sst*scf(1)/std_sst;
PC_sst1 = mapminmax(PC_sst1);
PC_sst = movmean(PC_sst1,5);


plot(dates,PC_sst1,'bo--', 'Linewidth', 0.1);
hold on
plot(dates, PC_sst, 'r-',  'Linewidth', 2);
plot(dates,zeros(1,length(dates)),'k--');
hold off

datetick('x','yyyy');
ylim([-1.2,1.2]);
title(string('Time Series for Mode 1') + string(' - ') + round(scf(1),2) + string('%'));
xlabel('Year');
ylabel('SST Anomaly');
xlim([dates(1)-1,dates(end)+1]);
legend;

%%
figure(2);
PC_sst = sst_data(:,2).'*sst_data;
std_sst = std(PC_sst);
PC_sst1 = PC_sst*scf(2)/std_sst;
PC_sst = movmean(PC_sst1,5);

plot(dates,PC_sst1,'bo--', 'Linewidth', 0.1);
hold on
plot(dates, PC_sst, 'r-',  'Linewidth', 2);
plot(dates,zeros(1,length(dates)),'k--');
hold off

datetick('x','yyyy');
ylim([-1.2,1.2]);
title(string('Time Series for Mode 2') + string(' - ') + round(scf(2),2) + string('%'));
xlabel('Year');
ylabel('SST Anomaly');
xlim([dates(1)-1,dates(end)+1]);
legend;