%Klipp ut en del ur din bild I, manuellt, resten blir svart
imshow(I, [])
[BWI, xii, yii] = roipoly(mat2gray(I));
imshow(BWI, [])
Z=immultiply(BWI, I); %resulterande bild Z
imshow(Z, [])