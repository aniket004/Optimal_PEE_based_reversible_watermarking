function [ psnr_t lenwm_t ] = color_watermark( image, len_wm, j )
%function [ psnr_rgb psnr_ybr lenwm_rgb lenwm_ybr ] = Color_watermark_data( image, len_wm )
%To Collect PSNR Results of color image watermarking

if ( ischar( image ) == 1 )
    % If input image is the name of the image file
    rgb = imread( image );
    rgb = double( rgb );
else
    % If input image is the pixel matrix itself
    rgb = double( image );
end 
[ nr nc nl ] = size( rgb );

watermark = randi( [0 1], 1, len_wm );

%---------------------- Watermark RGB space--------------------------------
%--------------------------------------------------------------------------

wm_rgb = rgb;
[ wm_rgb(:,:,3) lenwm_rgb_3 ov3 ] = EmbedWatermarkInterpolation( rgb(:,:,3), watermark );

if( lenwm_rgb_3 < len_wm )
    watermark = randi( [0 1], 1, ( len_wm - lenwm_rgb_3 ) );
    [ wm_rgb(:,:,1) lenwm_rgb_1 ov1 ] = EmbedWatermarkInterpolation( rgb(:,:,1), watermark );
else
    lenwm_rgb_1 = 0;
end
if( ( lenwm_rgb_3 + lenwm_rgb_1 ) < len_wm )
    watermark = randi( [0 1], 1, ( len_wm - lenwm_rgb_3 - lenwm_rgb_1 ) );
    [ wm_rgb(:,:,2) lenwm_rgb_2 ov2 ] = EmbedWatermarkInterpolation( rgb(:,:,2), watermark );
else
    lenwm_rgb_2 = 0;
end
lenwm_rgb = lenwm_rgb_1 + lenwm_rgb_2 + lenwm_rgb_3;
disp( ['Watermarked RGB space: ', num2str(lenwm_rgb), ' pure watermark bits.']  );

psnr_rgb = PSNR( rgb, wm_rgb );

%----------------------t_j color space---------------------------------
%--------------------------------------------------------------------------

%rgb2t = strcat('rgb2t_',int2str(j));
%t2rgb = strcat('t_',int2str(j),'_2rgb');

% Transform color space
t = rgb2t( rgb , j );

% Separate integer and fractional parts
t_i = floor( t );
t_f = t - t_i;

watermark = randi( [0 1], 1, len_wm );

% Watermark YCoCg space, integer part
wm_t = t_i;
[ wm_t(:,:,2) lenwm_t_2 ov2 ] = EmbedWatermarkInterpolation( t_i(:,:,2), watermark );
if( lenwm_t_2 < len_wm )
    watermark = randi( [0 1], 1, ( len_wm - lenwm_t_2 ) );
    [ wm_t(:,:,3) lenwm_t_3 ov3 ] = EmbedWatermarkInterpolation( t_i(:,:,3), watermark );
else
    lenwm_t_3 = 0;
end
if( ( lenwm_t_3 + lenwm_t_2 ) < len_wm )
    watermark = randi( [0 1], 1, ( len_wm - lenwm_t_3 - lenwm_t_2 ) );
    [ wm_t(:,:,1) lenwm_t_1 ov1 ] = EmbedWatermarkInterpolation( t_i(:,:,1), watermark );
else
    lenwm_t_1 = 0;
end
lenwm_t = lenwm_t_1 + lenwm_t_2 + lenwm_t_3;
disp( ['Watermarked colorspace: ', num2str(lenwm_t), ' pure watermark bits.'] );

% Combine watermarked integer part and original fractional part
wm_t1 = wm_t + t_f;
% Convert to RGB
t_rgb = t2rgb( wm_t1 , j ); % This is actual output

psnr_t = PSNR( rgb, t_rgb );

end
