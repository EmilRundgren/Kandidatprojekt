function fuzzy(bild, antalKluster) %ladda in bild i dicom format och antal
% önskade kluster
% Run examples in the reference:
%   B.N. Li, C.K. Chui, S. Chang, S.H. Ong (2011) Integrating spatial fuzzy
%   clustering with level set methods for automated medical image
%   segmentation. Computers in Biology and Medicine 41(1) 1-10.
%--------------------------------------------------------------------------


info=dicominfo(bild);
Y = dicomread(info);
img = im2double(Y);


MF = SFCM2D(img,antalKluster);

% figure
% subplot(231); imshow(img,[])
% for i=1:antalKluster
%     imgfi=reshape(MF(i,:,:),size(img,1),size(img,2));
%     subplot(2,3,i+1); imshow(imgfi,[])
%     title(['Index No: ' int2str(i)])
% end

% temp=0;
% while temp
%     nopt = input('Input the Index No that you are interested\n');
%     if ~isempty(nopt), temp=0; end
% end

% close(gcf);

imgfcm=reshape(MF(1,:,:),size(img,1),size(img,2));

fuzzy2(img,imgfcm,0.5);