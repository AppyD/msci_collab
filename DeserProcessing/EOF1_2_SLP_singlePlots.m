figure(1);
PC_slp = slp_data(:,1).'*slp_data;
std_slp = std(PC_slp);
PC_slp1 = PC_slp*scf(1)/std_slp;
PC_slp = movmean(PC_slp1,5);

plot(dates,PC_slp1,'bo--', 'Linewidth', 0.1);
hold on
plot(dates, PC_slp, 'r-',  'Linewidth', 2);
plot(dates,zeros(1,length(dates)),'k--');
hold off

datetick('x','yyyy');
ylim([-1.2,1.2]);
title(string('Time Series for Mode 1') + string(' - ') + round(scf(1),2) + string('%'));
xlabel('Year');
ylabel('SLP Anomaly');
xlim([dates(1)-1,dates(end)+1]);
legend;

figure(2);
PC_slp = slp_data(:,2).'*slp_data;
std_slp = std(PC_slp);
PC_slp1 = PC_slp*scf(2)/std_slp;
PC_slp = movmean(PC_slp1,5);

plot(dates,PC_slp1,'bo--', 'Linewidth', 0.1);
hold on
plot(dates, PC_slp, 'r-',  'Linewidth', 2);
plot(dates,zeros(1,length(dates)),'k--');
hold off

datetick('x','yyyy');
ylim([-1.2,1.2]);
title(string('Time Series for Mode 2') + string(' - ') + round(scf(2),2) + string('%'));
xlabel('Year');
ylabel('SLP Anomaly');
xlim([dates(1)-1,dates(end)+1]);
legend;