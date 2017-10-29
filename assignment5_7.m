%%
% Author: Andrew Petersen
% Course: CEC 495a
% Assignment: Assignment 5-7
% Date Modified: 10/29/17
%%

clc; clear; clear all;

Igray = imread('unknown.jpg');
Ithresh = imbinarize(Igray);
% imshow(Ithresh)
BW = ~Ithresh;
imshow(BW)

SE = strel('disk',2);
BW = imdilate(BW, SE);
[labels, number] = bwlabel(BW,8);
Istats = regionprops(labels,'basic');
Istats([Istats.Area]<1000) = [];
num = length(Istats);
Ibox = floor([Istats.BoundingBox]);
Ibox = reshape(Ibox,[4 num]);

hold on
for k = 1:num
    rectangle('position', Ibox(:,k), 'edgecolor', 'r', 'LineWidth', 3);
end

for k = 1:num
    col1 = Ibox(1,k);
    col2 = Ibox(3,k);
    row1 = Ibox(2,k);
    row2 = Ibox(4,k);
    subImage = BW(row1:row1+row2, col1:col1+col2);
    unknownImage{k} = subImage;
    unknownImageScaled{k} = imresize(subImage, [24 12]);
end

Igray2 = imread('template.jpg');
Ithresh2 = imbinarize(Igray2);
BW2 = ~Ithresh2;
figure, imshow(BW2)

SE2 = strel('disk',2);
BW2 = imdilate(BW2, SE2);
[labels, number] = bwlabel(BW2,8);
Istats2 = regionprops(labels,'basic');
Istats2([Istats2.Area]<1000) = [];
num2 = length(Istats2);
Xbox = floor([Istats2.BoundingBox]);
Xbox = reshape(Xbox,[4 num2]);

hold on
for k = 1:num2
    rectangle('position', Xbox(:,k), 'edgecolor', 'r', 'LineWidth', 3);
end

for k = 1:num2
    Col1 = Xbox(1,k);
    Col2 = Xbox(3,k);
    Row1 = Xbox(2,k);
    Row2 = Xbox(4,k);
    SubImage = BW2(Row1:Row1+Row2, Col1:Col1+Col2);
    TemplateImage{k} = SubImage;
    TemplateImageScaled{k} = imresize(SubImage, [24 12]);
end

for i = 1:6 
   for k = 1:num2
      corr = normxcorr2(unknownImageScaled{i}, TemplateImageScaled{k});
      maxCorr(k) = max( corr(:) );  %compare each number at a time
   end
   [sorted, index] = sort(maxCorr, 'descend');
   postcode(i) = index(1)-1;
end
postcode
%603023
