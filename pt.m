%输入:源图 左上右上左下右下坐标 
%输出变换后的图像
 function Imgout = pt(imgIn,LT,RT,LB,RB)
    outWidth=round(sqrt((LT(1)-RT(1))^2+(LT(2)-RT(2))^2));     %从原四边形获得新矩形宽
    outHeight=round(sqrt((LT(1)-LB(1))^2+(LT(2)-LB(2))^2));     %从原四边形获得新矩形高
    [H,W,D] = size(imgIn);
    %为了中心投影变换，需要将4个点转化为三个向量
    v1 = LB - LT;
    v2 = RT - LT;
    v3 = RB - LT;
    %把v3表示成v1和v2的线性组合，以使三个向量共面
    A = [v1', v2'];
    B = v3';
    S = A\B;
    a0 = S(1);
    a1 = S(2);
    
    %输出矩形
    Imgout = uint8(zeros(outHeight,outWidth,D));
   
    %利用循环操作来对每个像素点赋值
    for heightLoop = 1:outHeight
        for widthLoop = 1:outWidth
            x0 = heightLoop/outHeight;
            x1 = widthLoop/outWidth;
            deno = a0+a1-1+(1-a1)*x0+(1-a0)*x1;     %分母
            y0 = a0*x0/deno;
            y1 = a1*x1/deno;
            
            %根据得到的参数找到对应的源图像中的坐标位置，并赋值
            co = y0*v1 + y1*v2 + LT;
            hC = round(co(1));
            wC = round(co(2));
                if (hC > H || hC <= 0 || wC >W || wC <=0 )
                    disp(['超出范围' num2str(hC) num2str(wC)]);
                    pause();
                    return;
                end
            for dimentionLoop = 1:D
                %使用最近邻域插值，使用高级插值方法效果会更好
                Imgout(heightLoop,widthLoop,dimentionLoop) = imgIn(hC,wC,dimentionLoop);
            end
        end
    end
    
    [m,n] = size(Imgout);
    last_col = Imgout(:,end);
    last_row = Imgout(end,:);
    for i = 1:m
        if(last_col(i)==0)
            Imgout(i,end) = Imgout(i,end-1);
        end
    end
    for i = 1:n
        if(last_row(i)==0)
            Imgout(end,i) = Imgout(end-1,i);
        end
    end
    
   Imgout = Imgout(:,2:end-1);
    
  % figure; imshow(Imgback); title('投影变换的结果');
 end