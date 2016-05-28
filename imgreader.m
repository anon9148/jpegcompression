close all;
clc;
%reading the image
A=imread('b.png');

%get the number of pixels
[rows,columns] = size(A);
Number_Pixels = rows*columns;
AS = A;
%convert it to grayscale
AS = rgb2gray(A);
%AS = (A(:,:,1)+A(:,:,2)+A(:,:,3));
%imshow(AS);
%figure;

%get the row and col size
rowSize=size(AS,1);
colSize=size(AS,2);

%subtract the bytes from the image
s=int16(AS)-128;
B=[];
Bq=[];
count=1;


blockSize=8;
jump=7;
zzcount=64;
printLimit=8;


%encoding process
for i=1:blockSize:rowSize
     for j=1:blockSize:colSize 
        %performing the DCT
        B(i:i+jump,j:j+jump) = dct2(s(i:i+jump,j:j+jump));
        %performing the quantization
        Bq(i:i+jump,j:j+jump)=quantization(B(i:i+jump,j:j+jump),blockSize);
        zigzag(count,1:zzcount)=zzag(Bq(i:i+jump,j:j+jump));
        count=count+1;
     end
end
%disp('Original Image')
imshow(AS);
figure;
%disp('After level shift')
imshow(s/255);
%disp('After DCT')
figure;
imshow(B*0.01);
%disp('After Quantization')
figure;
imshow(Bq);
zigzag(1,1:zzcount);
figure;
imshow(zigzag);
figure;
%for putting it into a file and compressing
imwrite(zigzag,'rgb.jpg','jpg');
%fid = fopen('magic5.bin', 'r');
%Bq=load('compImg.mat')

Bnew=[];
ASnew=[];
%decoding process
for i=1:blockSize:rowSize
     for j=1:blockSize:colSize 
        %performing the dequantization
        Bnew(i:i+jump,j:j+jump)=invQuantization(Bq(i:i+jump,j:j+jump),blockSize);
        %performing the inverse DCT
        ASnew(i:i+jump,j:j+jump) = round(idct2(Bnew(i:i+jump,j:j+jump)));
     end
end
disp('dequantization')
%Bnew(1:printLimit,1:printLimit)
disp('Inverse DCT')
%ASnew(1:printLimit,1:printLimit)
Anew=ASnew+128;
Anew=uint8(Anew);
rgbImage = cat(3,Anew,Anew,Anew);

subplot(1,2,1)

imshow(A)
title('Original Image')
subplot(1,2,2)

imshow(rgbImage)
title('Reconstructed Image')
imwrite(rgbImage,'rgb1.jpg','jpg');
disp('error value')
error=abs(sum(sum(imsubtract(A,Anew).^2)))/Number_Pixels;