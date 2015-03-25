function runtest(opt)
% Run examples in the reference:
%   B.N. Li, C.K. Chui, S. Chang, S.H. Ong (2011) Integrating spatial fuzzy
%   clustering with level set methods for automated medical image
%   segmentation. Computers in Biology and Medicine 41(1) 1-10.
%--------------------------------------------------------------------------

if opt==1
    info=dicominfo('IM-0001-0012.dcm');
Y = dicomread(info);
img = im2double(Y);
    ncluster=4; %Anv�ndaren f�r v�lja antal kluster, mellan 2-5
elseif opt==2
    info=dicominfo('IM-0001-0011.dcm');
    Y = dicomread(info);
    img = im2double(Y);
    ncluster=4;
else
    error('Invalid opt: 1 or 2 only!')
end

MF = SFCM2D(img,ncluster);

figure
subplot(231); imshow(img,[])
for i=1:ncluster
    imgfi=reshape(MF(i,:,:),size(img,1),size(img,2));
    subplot(2,3,i+1); imshow(imgfi,[])
    title(['Index No: ' int2str(i)])
end

temp=0;
while temp
    nopt = input('Input the Index No that you are interested\n');
    if ~isempty(nopt), temp=0; end
end

close(gcf);

imgfcm=reshape(MF(1,:,:),size(img,1),size(img,2));

fuzzyLSM(img,imgfcm,.5);