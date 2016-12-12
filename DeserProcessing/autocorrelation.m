% AUTOCORRELATION AND CROSS-CORRELATION ANALYSIS

EOF1 = U(:,1);
EOF2 = U(:,2);
EOF3 = U(:,3);

EOF1_with_NaNs = addNaN(EOF1, NaNs);
EOF2_with_NaNs = addNaN(EOF2, NaNs);
EOF3_with_NaNs = addNaN(EOF3, NaNs);

mode1 = reshape(EOF1_with_NaNs, length(Lg), length(Lt));
mode2 = reshape(EOF2_with_NaNs, length(Lg), length(Lt));
mode3 = reshape(EOF3_with_NaNs, length(Lg), length(Lt));

PC1 = sst_data*EOF1;
PC2 = sst_data*EOF2;
PC3 = sst_data*EOF3;

% PC1 autocorrelation
figure();
        %autocorr(PC1,80);
[acor,lag] = xcorr(PC1,PC1,'coeff');
bar(lag,acor);
title('Autocorrelation, Mode 1');

% PC2 autocorrelation
figure();
[acor,lag] = xcorr(PC2,PC2,'coeff');
bar(lag,acor);
title('Autocorrelation, Mode 2');

% PC3 autocorrelation
figure();
[acor,lag] = xcorr(PC3,PC3,'coeff');
bar(lag,acor);
title('Autocorrelation, Mode 3');

% Cross correlation
figure();
[acor,lag] = xcorr(PC1,PC2,'coeff');
bar(lag,acor);
title('Cross-Correlation, Modes 1 and 2');

figure();
[acor,lag] = xcorr(PC1,PC3,'coeff');
bar(lag,acor);
title('Cross-Correlation, Modes 1 and 3');

figure();
[acor,lag] = xcorr(PC2,PC3,'coeff');
bar(lag,acor);
title('Cross-Correlation, Modes 2 and 3');