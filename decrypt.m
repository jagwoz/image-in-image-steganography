image = imread('image_with_secret.bmp');
r = image(:, :, 1);
g = image(:, :, 2);
b = image(:, :, 3);

key = input('key: ','s');
rng(sum(double(key)))

[numRowsPixels, ~] = size(r);
fullR =  r(1, :);
fullG =  g(1, :);
fullB =  b(1, :);
for i = 2 : numRowsPixels
    fullR = [fullR, r(i, :)]; 
    fullG = [fullG, g(i, :)]; 
    fullB = [fullB, b(i, :)]; 
end

info = [];
index = 1;
for i = 1 : 32
    rBin = de2bi(fullR(1, i), 8);
    info = [info, rBin(3)];
end

numRowsPixels = double(bi2de(info(1:16), 'right-msb'));
numColsPixels = double(bi2de(info(17:end), 'right-msb'));

indexes = randperm(length(fullR), numRowsPixels * numColsPixels);

fullS = uint8(zeros(1, numRowsPixels * numColsPixels));
for j = 1 : length(indexes)
    i = indexes(j);
    rBin = de2bi(fullR(1, i), 8);
    gBin = de2bi(fullG(1, i), 8);
    bBin = de2bi(fullB(1, i), 8);

    sBin = rBin(1 : 2);
    sBin = [sBin, gBin(1 : 3), bBin(1 : 3)];

    fullS(1, j) = bi2de(sBin);
end

secret = uint8(zeros(numRowsPixels, numColsPixels));

index = 1; 
for i = 1 : numRowsPixels
    for j = 1 : numColsPixels
        secret(i, j) = fullS(1, index);
        index = index + 1;
    end
end

imwrite(secret, 'decrypted_secret.png');
disp('Image decrypted and saved as decrypted_secret.png')
clear