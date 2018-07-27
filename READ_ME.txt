READ ME file
#################################################################

%%%% BCDM problem solution using CVX Library

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%steps for cvx setup
% 1. cd C:\personal\cvx-w64\cvx  %%% setup the path in which CVX exists
% 2. cvx_setup
% 3. then run this code
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Steps:
% 1. Read the image
% 2. Create error histogram using DCT distribution
% 3. Convex optimization based threshold finding
% 4. Distortion calculation for given embedding capacity
% 5. Plot bpp vs. PSNR.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sample output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
CVX Warning:
   Models involving "entr" or other functions in the log, exp, and entropy
   family are solved using an experimental successive approximation method.
   This method is slower and less reliable than the method CVX employs for
   other models. Please see the section of the user's guide entitled
       The successive approximation method
   for more details about the approach, and for instructions on how to
   suppress this warning message in the future.
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 9.752e-01  5.825e-02  0.000e+00 | Solved
  1/  1 | 9.178e-02  5.280e-04  0.000e+00 | Solved
  1/  1 | 1.281e-02  1.026e-05  0.000e+00 | Solved
  1/  1 | 1.829e-03  2.092e-07  0.000e+00 | Solved
  0/  1 | 2.603e-04  4.050e-09  0.000e+00 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -108.168
 

echo off

T =

     1


cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 9.131e-01  5.114e-02  0.000e+00 | Solved
  1/  1 | 1.549e-01  1.506e-03  0.000e+00 | Solved
  1/  1 | 2.132e-02  2.842e-05  0.000e+00 | Solved
  1/  1 | 3.050e-03  5.814e-07  0.000e+00 | Solved
  0/  1 | 4.339e-04  1.176e-08  0.000e+00 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -106.352
 

echo off

T =

     2


cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 7.524e-01  3.484e-02  0.000e+00 | Solved
  1/  1 | 1.241e-01  9.663e-04  2.052e-11 | Solved
  1/  1 | 1.720e-02  1.849e-05  0.000e+00 | Solved
  1/  1 | 2.457e-03  3.777e-07  0.000e+00 | Solved
  0/  1 | 3.498e-04  7.658e-09  6.471e-12 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -103.179
 

echo off

T =

     3


cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 5.688e-01  2.000e-02  0.000e+00 | Solved
  1/  1 | 9.076e-02  5.162e-04  5.094e-13 | Solved
  1/  1 | 1.266e-02  1.003e-05  0.000e+00 | Solved
  1/  1 | 1.808e-03  2.044e-07  1.160e-11 | Solved
  0/  1 | 2.575e-04  4.146e-09  0.000e+00 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -98.4543
 

echo off

T =

     4


cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 3.544e-01  7.800e-03  0.000e+00 | Solved
  1/  1 | 5.427e-02  1.844e-04  0.000e+00 | Solved
  1/  1 | 7.632e-03  3.643e-06  0.000e+00 | Solved
  1/  1 | 1.088e-03  7.401e-08  0.000e+00 | Solved
  0/  1 | 1.548e-04  1.474e-09  0.000e+00 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -91.916
 

echo off

T =

     6


cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 9.591e-02  5.743e-04  0.000e+00 | Solved
  1/  1 | 1.393e-02  1.214e-05  0.000e+00 | Solved
  1/  1 | 1.975e-03  2.441e-07  0.000e+00 | Solved
  0/  1 | 2.812e-04  4.936e-09  0.000e+00 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -83.1975
 

echo off

T =

     7


cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 2.313e-01  3.364e-03  2.196e-12 | Solved
  1/  1 | 3.125e-02  6.105e-05  0.000e+00 | Solved
  1/  1 | 4.476e-03  1.253e-06  0.000e+00 | Solved
  1/  1 | 6.361e-04  2.530e-08  0.000e+00 | Solved
  0/  1 | 9.051e-05  4.916e-10  0.000e+00 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -71.7431
 

echo off

T =

     9


cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 6.814e-01  2.946e-02  0.000e+00 | Solved
  1/  1 | 8.243e-02  4.244e-04  0.000e+00 | Solved
  1/  1 | 1.194e-02  8.921e-06  0.000e+00 | Solved
  1/  1 | 1.695e-03  1.796e-07  0.000e+00 | Solved
  0/  1 | 2.413e-04  3.528e-09  0.000e+00 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -56.6094
 

echo off

T =

    12


cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end
 
Successive approximation method to be employed.
   For improved efficiency, SDPT3 is solving the dual problem.
   SDPT3 will be called several times to refine the solution.
   Original size: 4 variables, 2 equality constraints
   1 exponentials add 8 variables, 5 equality constraints
-----------------------------------------------------------------
 Cones  |             Errors              |
Mov/Act | Centering  Exp cone   Poly cone | Status
--------+---------------------------------+---------
  1/  1 | 1.423e+00  1.303e-01  0.000e+00 | Solved
  1/  1 | 1.381e-01  1.190e-03  0.000e+00 | Solved
  1/  1 | 2.026e-02  2.569e-05  0.000e+00 | Solved
  1/  1 | 2.873e-03  5.161e-07  0.000e+00 | Solved
  0/  1 | 4.097e-04  1.047e-08  0.000e+00 | Solved
-----------------------------------------------------------------
Status: Solved
Optimal value (cvx_optval): -35.81
 

echo off

T =

    17

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 