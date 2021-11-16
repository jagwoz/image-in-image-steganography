image = imread('image.bmp');
r = image(:, :, 1);
g = image(:, :, 2);
b = image(:, :, 3);

secret = imread('secret.png');
gray = secret(:, :, 1);

key = input('key: ','s');
rng(sum(double(key)))

[numRowsPixels, numColsPixels] = size(r);
fullR = r(1, :); fullG = g(1, :); fullB = b(1, :);
for i = 2 : numRowsPixels
    fullR = [fullR, r(i, :)]; 
    fullG = [fullG, g(i, :)]; 
    fullB = [fullB, b(i, :)]; 
end

[numRowsPixel, numColsPixel] = size(gray);
info = flip(reshape(dec2bin(numRowsPixel, 16).'-'0',1,[]));
info = uint8([info, flip(reshape(dec2bin(numColsPixel, 16).'-'0',1,[]))]);

fullGray =  gray(1, :);
for i = 2 : numRowsPixel, fullGray = [fullGray, gray(i, :)]; end

if(length(fullGray) > length(fullR) || length(fullR) < 32), disp('To little space'); return; end

indexes = randperm(length(fullR), length(fullGray));

for i = 1 : 32
    rBin = de2bi(fullR(1, i), 8);
    rBin(3) = info(1, i);
    fullR(1, i) = bi2de(rBin);
end

for j = 1 : length(indexes)
    i = indexes(j);
    rBin = de2bi(fullR(1, i), 8);
    gBin = de2bi(fullG(1, i), 8);
    bBin = de2bi(fullB(1, i), 8);
    
    grayBin = de2bi(fullGray(1, j), 8);
    rBin(1 : 2) = grayBin(1 : 2);
    gBin(1 : 3) = grayBin(3 : 5);
    bBin(1 : 3) = grayBin(6 : 8);
    fullR(1, i) = bi2de(rBin);
    fullG(1, i) = bi2de(gBin);
    fullB(1, i) = bi2de(bBin);   
end

[numRowsPixels, numColsPixels] = size(r);
j = 1;
for i = 0 : numColsPixels : length(fullR) - 1
    r(j, :) = fullR(i + 1 : i + numColsPixels);
    g(j, :) = fullG(i + 1 : i + numColsPixels);
    b(j, :) = fullB(i + 1 : i + numColsPixels);
    j = j + 1;
end

image(:, :, 1) = r;
image(:, :, 2) = g;
image(:, :, 3) = b;
imwrite(image, 'image_with_secret.bmp');
disp('Image saved as image_with_secret.bmp')
clear