% AUTOCORRELATION AND CROSS-CORRELATION ANALYSIS

EOF1 = U(:,1);
EOF2 = U(:,2);


EOF1_with_NaNs = addNaN(EOF1, NaNs);
EOF2_with_NaNs = addNaN(EOF2, NaNs);

mode1 = reshape(EOF1_with_NaNs, length(Lg), length(Lt));
mode2 = reshape(EOF2_with_NaNs, length(Lg), length(Lt));

PC1 = sst_data*EOF1;
PC2 = sst_data*EOF2;

% PC1 autocorrelation
autocorr(PC1,80);
title('Autocorrelation, Mode 1');

% PC2 autocorrelation
autocorr(PC2,80);
title('Autocorrelation, Mode 2');

% Cross correlation
[acor,lag] = xcorr(PC1,PC2,'coeff');
plot(lag,acor);
title('Cross-Correlation, Modes 1 and 2');
hold on;
plot([0,0],[-0.6,0.6],'r-');
