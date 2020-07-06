%输入:img_deal(需处理的图片),dis:扫描个数,th:区分阈值 
%输出:d:检测到的点坐标,count:检测点个数,img_res:识别结果展示图
function [d,count,img_res] = scan(img_deal,dis,th)
[m,n] = size(img_deal);%638*178
count = 0;
d = zeros(1000,2);
%dis = 9;
%th = 50;
for i = 1:round(m/dis)
    for j = 1:round(n/dis)
        if(i<round(m/dis) & j<round(n/dis))
        area = double(img_deal((i-1)*dis+1:(i)*dis,(j-1)*dis+1:j*dis));
          if(sum(sum(area))<th)
            count = count + 1;
            d(count,1) = i;
            d(count,2) = j;
          end
        end
        if(i==round(m/dis) & j<round(n/dis))
                area = double(img_deal((i-1)*dis+1:end,(j-1)*dis+1:j*dis));
                if(sum(sum(area))<(numel(area).*th/(dis.*dis)))
                    count = count + 1;
                    d(count,1) = i;
                    d(count,2) = j;
                end
        end
  
         if(i<round(m/dis) & j==round(n/dis))
                area = double(img_deal((i-1)*dis+1:i*dis,(j-1)*dis+1:end));
                if(sum(sum(area))<(numel(area).*th/(dis*dis)))
                    count = count + 1;
                    d(count,1) = i;
                    d(count,2) = j;
                end
         end

         if(i==round(m/dis) & (j==round(m/dis)))
             area = double(img_deal((i-1)*dis+1:end,(j-1)*dis+1:end));
             if(sum(sum(area))<(numel(area).*th/(dis*dis)))
                   count = count + 1;
                    d(count,1) = i;
                    d(count,2) = j;
             end
         end
         
    end
end

d = d(1:count,:);
%d(:,1) = 92-d(:,1);

img_res = ones(round(m/dis)*dis,round(n/dis)*dis);
for i = 1:count
    a = d(i,1);
    b = d(i,2);
    img_res((a-1)*dis+1:a*dis,(b-1)*dis+1:b*dis) = 0;
end
%figure(42);
%imshow(img_res);
end



