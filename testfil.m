OriginalImage = dicomread('IM-0001-0011.dcm');
RescaledImage = mat2gray(OriginalImage);

figure;
% , imshow(RescaledImage);
% h = imfreehand(gca); 

%img = imread('pout.tif');
h_im = imshow(RescaledImage);
h = imfreehand(gca);
%e = imellipse(gca,[55 10 120 120]);
BW = createMask(h,h_im);
imshow(BW);
%close;