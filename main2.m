%对第二张图片的识别处理
clear;%清除无关变量
clc;%清空命令行
close all
%set(0,'defaultfigurecolor','w')%使面板颜色为白色

img = imread('芯片载板图片2.jpg');%读取图片
img_gray = rgb2gray(img);%将图片转为灰度图
[m,n] = size(img_gray);%获取图片的长和宽

img_l = img_gray(:,1:round(n/2));%左边部分
img_r = img_gray(:,ceil(n/2):end);%右边部分

figure(1);
imshow(img);
title('原始的芯片载板图片2');

figure(2);
imshow(img_gray);
title('芯片载板图片2灰度图');

figure(3);
subplot(121);
imshow(img_l);
title('左边部分');
subplot(122);
imshow(img_r);
title('右边部分');

[lx,ly] = size(img_l);
img_c = zeros(floor(lx/2),floor(ly/2));
xx = zeros(2,2);%进行重采样
for i = 1:floor(lx/2)
    for j = 1:floor(ly/2)
        xx = img_l((((i-1)*2+1):(((i-1)*2+2))),((j-1)*2+1):((j-1)*2+2));
        img_c(i,j) = max(max(xx));
    end
end
img_c = uint8(img_c);%转为uint8类型

figure(4);
imshow(img_c);
title('重采样后的结果');

%[gs,ts] = edge(img_c,'sobel',[],'both');%使用sobel算子

U = double(img_c);
[H,W] = size(U);
sn = U;
%tt = zeros(H,W);
for i = 2:H-1
    for j = 2:W-1
        %sobel算子
        Gx=(U(i+1,j-1)+2*U(i+1,j)+U(i+1,j+1))-(U(i-1,j-1)+2*U(i-1,j)+U(i-1,j+1));
        Gy=(U(i-1,j+1)+2*U(i,j+1)+U(i+1,j+1))-(U(i-1,j-1)+2*U(i,j-1)+U(i+1,j-1));
        sn(i,j) = sqrt((Gx.^2+Gy.^2));
    end
end

sn = uint8(sn);
so = im2bw(sn,graythresh(sn));%OTSU方法
figure(5);
imshow(so);%阈值为0.4745*255=120
title('最大类间方差法得到的二值图');

so2 = so;
dd = 3;
xx = zeros(dd,dd);
for i = 1:floor(H/dd)
    for j = 1:floor(W/dd)
        xx = so2(((i-1)*dd+1):(i*dd),((j-1)*dd+1):(j*dd));
        %去除白色像素点
        if(sum(sum(xx))<3)
            so2(((i-1)*dd+1):(i*dd),((j-1)*dd+1):(j*dd)) = 0;
        end
    end
end

figure(8);
imshow(so2);
title('最大类间方差法(去除白色像素点)得到的二值图');


%筛选直线
%----------------------------------------------------------------------------------------------

%筛选上面的直线
l1 = zeros(200,2);
cnt = 0;%筛选边缘直线点
for i = 3:round(0.07*H)
    for j = 1:W
        if(so2(i,j)==1 & so2(i+1:i+6,j)==0)%如果该点像素为1且下面几行为0则认为该点为边缘点
            cnt = cnt + 1;
            l1(cnt,1) = i;
            l1(cnt,2) = j;
        end
    end
end
l1 = l1(1:cnt,:);
l1_s = mean(l1,1);
l1_n = zeros(cnt,2);
cnt = 0;
for i = 1:length(l1)
    if(abs(l1(i,1)-l1_s(1))<3)
        cnt = cnt + 1;
        l1_n(cnt,:) = l1(i,:);
    end
end
l1_n = l1_n(1:cnt,:);%边缘点

lc = so2.*0;
for i = 1:cnt
    lc(l1_n(i,1),l1_n(i,2)) = 1;
end

l1_n(:,1) = H - l1_n(:,1);
l1_a = polyfit(l1_n(:,2),l1_n(:,1),1);%线性拟合
 

%筛选右边的直线
l2 = zeros(200,2);
cnt = 0;%筛选边缘直线点
for j = round(0.8*W):0.95*W
    for i = 3:H
        if(so2(i,j)==1 & so2(i,j-6:j-1)==0)%如果该点像素为1且下面几行为0则认为该点为边缘点
            cnt = cnt + 1;
            l2(cnt,1) = i;
            l2(cnt,2) = j;
        end
    end
end
l2 = l2(1:cnt,:);
%l2_n = l2;
l2_s = mean(l2,1);
l2_n = zeros(cnt,2);
cnt = 0;
for i = 1:length(l2)
    if(abs(l2(i,2)-l2_s(2))<4)
        cnt = cnt + 1;
        l2_n(cnt,:) = l2(i,:);
    end
end
l2_n = l2_n(1:cnt,:);%边缘点

lc2 = so2.*0;
for i = 1:cnt
    lc2(l2_n(i,1),l2_n(i,2)) = 1;
end

l2_n(:,1) = H - l2_n(:,1);
l2_a = polyfit(l2_n(:,2),l2_n(:,1),1);%线性拟合

%筛选下边的直线
l3 = zeros(200,2);
cnt = 0;%筛选边缘直线点
for i = round(0.95.*H):H-5
    for j = 1:W
        if(so2(i,j)==1 & so2(i-5:i-1,j)==0)%如果该点像素为1且下面几行为0则认为该点为边缘点
            cnt = cnt + 1;
            l3(cnt,1) = i;
            l3(cnt,2) = j;
        end
    end
end
l3 = l3(1:cnt,:);
l3_s = mean(l3,1);
l3_n = zeros(cnt,2);
cnt = 0;
for i = 1:length(l3)
    if(abs(l3(i,1)-l3_s(1))<3)
        cnt = cnt + 1;
        l3_n(cnt,:) = l3(i,:);
    end
end
l3_n = l3_n(1:cnt,:);%边缘点

lc3 = so2.*0;
for i = 1:cnt
    lc3(l3_n(i,1),l3_n(i,2)) = 1;
end

l3_n(:,1) = H - l3_n(:,1);
l3_a = polyfit(l3_n(:,2),l3_n(:,1),1);%线性拟合

%筛选左边的直线
l4 = zeros(200,2);
cnt = 0;%筛选边缘直线点
for j = round(0.18*W):0.23*W
    for i = 3:H
        if(so2(i,j)==1 & so2(i,j+1:j+6)==0)%如果该点像素为1且下面几行为0则认为该点为边缘点
            cnt = cnt + 1;
            l4(cnt,1) = i;
            l4(cnt,2) = j;
        end
    end
end
l4 = l4(1:cnt,:);
%l2_n = l2;
l4_s = mean(l4,1);
l4_n = zeros(cnt,2);
cnt = 0;
for i = 1:length(l4)
    if(abs(l4(i,2)-l4_s(2))<3)
        cnt = cnt + 1;
        l4_n(cnt,:) = l4(i,:);
    end
end
l4_n = l4_n(1:cnt,:);%边缘点

lc4 = so2.*0;
for i = 1:cnt
    lc4(l4_n(i,1),l4_n(i,2)) = 1;
end

l4_n(:,1) = H - l4_n(:,1);
%l4_a = polyfit(l4_n(:,2),l4_n(:,1),1);
l4_a = [0,round(l4_s(2))];

%绘制筛选出的四条直线
figure(9);
%subplot(221);
imshow(lc);
title('筛选出的上边直线点');
%subplot(222);
figure(10);
imshow(lc2);
title('筛选出的右边直线点');
%subplot(223);
figure(11);
imshow(lc3);
title('筛选出的下边直线点');
%subplot(224);
figure(12);
imshow(lc4);
title('筛选出的左边直线点');

figure(13);
plot(l1_n(:,2),l1_n(:,1),'*');
t = 30:170;
y = l1_a(1).*t + l1_a(2);
hold on;
plot(t,y);

plot(l2_n(:,2),l2_n(:,1),'*');
t = 30:170;
y2 = l2_a(1).*t + l2_a(2);
hold on;
plot(t,y2);

plot(l3_n(:,2),l3_n(:,1),'*');
t = 30:180;
y3 = l3_a(1).*t + l3_a(2);
hold on;
plot(t,y3);

plot(l4_n(:,2),l4_n(:,1),'*');
t = ones(1,500).*l4_a(2);
y4 = 1:500;
hold on;
plot(t,y4);
axis([0 200 0 500]);
title('拟合出的四条边缘直线');
%-------------------------------------------------------------------------------------

%利用上面的筛选直线代码可以求出四个交点坐标近似为顶点坐标
lh = [32,39];%左上顶点
ll = [493,40];%左下顶点
rh = [33,172];%右上顶点
rl = [488,173];%右下顶点

img_rec = pt(img_c,lh,rh,ll,rl);%进行透视变换
figure(14);
imshow(img_rec);
title('透视变换后的图片');

U2 = double(img_rec);
[H2,W2] = size(U2);
sn2 = U2;
%s2 = sn2;
%sn_t2 = 120;
for i = 2:H2-1
    for j = 2:W2-1
        %使用sobel算子
        Gx=(U2(i+1,j-1)+2*U2(i+1,j)+U2(i+1,j+1))-(U2(i-1,j-1)+2*U2(i-1,j)+U2(i-1,j+1));
        Gy=(U2(i-1,j+1)+2*U2(i,j+1)+U2(i+1,j+1))-(U2(i-1,j-1)+2*U2(i,j-1)+U2(i+1,j-1));
        sn2(i,j) = sqrt((Gx.^2+Gy.^2));
%        s2(i,j) = sn2(i,j);
%         if(sn2(i,j)>sn_t2)
%             sn2(i,j) = 0;
%         else
%             sn2(i,j) = 255;
%         end
    end
end


s2_o = im2bw(uint8(sn2),120./255);%二值化处理
dd = 3;
xx = zeros(dd,dd);
for i = 1:floor(H2/dd)
    for j = 1:floor(W2/dd)
        xx = s2_o(((i-1)*dd+1):(i*dd),((j-1)*dd+1):(j*dd));
        %去除白色像素点
        if(sum(sum(xx))<3)
            s2_o(((i-1)*dd+1):(i*dd),((j-1)*dd+1):(j*dd)) = 0;
        end
    end
end

s2_o = ~s2_o(:,2:end-1);
dis = 4;%4*4的模板
th = 11;%阈值
[d,count,img_res] = scan(s2_o,dis,th);%直接进行识别

figure(15);
imshow(s2_o);
title('OTSU法(去掉白色像素点)');
figure(16);
imshow(img_res);
title('直接识别出的芯片结果');

%对图像进行形态学运算,再进行识别
se2 = strel('disk', 2);%圆形结构元素
Ie = imopen(s2_o,se2);%开运算
figure(17);
imshow(Ie);
title('不完整边界芯片载板最终处理结果');

dis2 = 5;%4*4的模板
th2 = 20;%阈值
[d2,count2,img_res2] = scan(s2_o,dis2,th2);%进行识别
figure(18);
imshow(img_res2);
title('最终识别出的芯片结果');