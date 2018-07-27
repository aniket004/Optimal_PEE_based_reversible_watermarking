
my_bpp = 0.1:0.1:0.9;

lena_my_psnr =  [56.5004   52.0209   49.4289   47.6772   45.3447   44.4982   43.1678   41.7312   39.8632];
mandrill_my_psnr = [  55.9746   50.8316   47.6270   45.3530   42.2199   41.0675   39.2529   37.2978   35.1497];
peppers_my_psnr = [56.2066   51.3931   48.5438   46.6317   44.2041   43.3813   42.1550   40.8959   39.3086];
goldhill_my_psnr = [56.2398   51.3920   48.4910   46.5152   43.9367   43.0358   41.1378   39.9029   38.5525];
elaine_my_psnr = [56.3281   51.5989   48.8400   47.0254   44.7920   44.0564   42.5704   41.6101   40.5046];
boat_my_psnr = [ 56.0949   51.2788   48.3995   46.4273   44.9598   42.8693   41.4144   39.8623   38.1411];
barbara_my_psnr = [ 56.4427   51.6375   48.7001   46.6466   43.8573   42.8372   40.5706   38.9965   37.1773];
airplane_my_psnr = [ 55.9395   51.3461   48.6701   46.8664   45.5329   43.6247   42.2696   41.2289   39.3909];


% Lena
lena_OHM_stiched = [56.5  52  49  47  44.5  42.5  41.5  39.5  38 ];
lena_OHM_single = [ 54.5  51   48  46  43  42.5   40   38 37 ];
lena_LP = [ 53.5 49.5 46.5 43.5 42.5 40.5 39 37 36 ];

%mandrill 
mandrill_OHM_single = [ 47.5 43 38.5 36 34.5 31.5 29.5 28 26.5];
mandrill_LP = [ 47.5 42 38 35 33 31 29 27 25];

%goldhill
goldhill_OHM_single  = [ 53 48.5 45.5 43.5 41.5 39.5 37.5 36 34 ];
goldhill_LP = [ 51.5 47.5 43.5 41 38.5 37.5 36 34 32.5 ];

%Boat
boat_OHM_single = [ 55 51 48.5 46 44 42 40 38.5 38 ];
boat_LP = [ 55 50 47 44.5 42.5 41 39.5 38.5 35.5 ];

%Barbara
barbara_OHM_single = [ 53 50 47.5 44.5 42.5 40.5 38.5 37 35.5 ];
barbara_LP = [ 54 49.5 46.5 43.5 41.5 39.5 38 37 35 ];

%airplane
airplane_OHM_single = [ 55.5 52.5 50.5 48.5 46.5 44.5 42.5 41 39.5 ];
airplane_LP = [ 54.5 51.5 48.5 46.5 44 43 41.5 39.5 37 ];

%plot Lena
figure(1), plot(my_bpp,lena_my_psnr,'r');hold on; plot(my_bpp,lena_OHM_single,'b');hold on;plot(my_bpp,lena_LP,'c');hold off;
title('LENA');
xlabel('Embedding rate (bpp)');
ylabel('PSNR');

%plot Mandrill
figure(2), plot(my_bpp,mandrill_my_psnr,'r');hold on; plot(my_bpp,mandrill_OHM_single,'b');hold on;plot(my_bpp,mandrill_LP,'c');hold off;
title('MANDRILL');
xlabel('Embedding rate (bpp)');
ylabel('PSNR');

%plot Goldhill
figure(3), plot(my_bpp,goldhill_my_psnr,'r');hold on; plot(my_bpp,goldhill_OHM_single,'b');hold on;plot(my_bpp,goldhill_LP,'c');hold off;
title('GOLDHILL');
xlabel('Embedding rate (bpp)');
ylabel('PSNR');

%plot Boat
figure(4), plot(my_bpp,boat_my_psnr,'r');hold on; plot(my_bpp,boat_OHM_single,'b');hold on;plot(my_bpp,boat_LP,'c');hold off;
title('BOAT');
xlabel('Embedding rate (bpp)');
ylabel('PSNR');

%plot Barbara
figure(5), plot(my_bpp,barbara_my_psnr,'r');hold on; plot(my_bpp,barbara_OHM_single,'b');hold on;plot(my_bpp,barbara_LP,'c');hold off;
title('BARBARA');
xlabel('Embedding rate (bpp)');
ylabel('PSNR');

%plot Airplane
figure(6), plot(my_bpp,airplane_my_psnr,'r');hold on; plot(my_bpp,airplane_OHM_single,'b');hold on;plot(my_bpp,airplane_LP,'c');hold off;
title('AIRPLANE');
xlabel('Embedding rate (bpp)');
ylabel('PSNR');




