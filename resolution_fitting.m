M =xlsread( '分辨率.xlsx');
N1 = M(2:2:end,3:end);
N2 = M(1:2:end,3:end);
for i = 1 :8
    [a(i,:),~] = polyfit(N2(i,1:i+4),N1(i,1:i+4),1);
end
%非重心求曲线
ajun = sum(a(:,1))/length(a(:,1)); 
%重心求曲线
len = [5,6,7,8,9,10,11,12];
ajun1 = len*a(:,1)/sum(len); 
Y = 70:10:140;
% yba = len*a(:,2)/sum(len);
% xba = len*Y'/sum(len);
% bjun = ((len.*Y)*a(:,2)/sum(len)-8*xba*yba)/(Y*Y'-length(Y)*xba*xba);
% cjun = yba-bjun*xba;
[m,~] = polyfit(Y',a(:,2),1);
bjun = m(1);
cjun = m(2);
% %% 生成拟合曲面
% x =1:30;
% y =70:3:160;
% z = ajun*x+bjun(1)*y+bjun(2);
% ezsurf(ajun*x+bjun(1)*y+bjun(2));
% hold on 
%% 绘制数据点图
for i = 1 :8
    scatter3(N2(i,1:i+4),repmat(Y(i),1,i+4),N1(i,1:i+4))
    hold on 
end
%% 对原数据进行作图
% for i = 1 :8
%     plot(N1(i,1:i+4));
%     name = (i+6)*10;
%     hold on
% end
% legend("70","80","90","100","110","120","130","140");
%% 对拟合曲线绘图
[x,y]=meshgrid([1:30],[70:140]);
z=ajun*x+bjun*y+cjun;
mesh(x,y,z);
%% 模型分析
%z为ajun1重心，z0是ajun平均
z= zeros(8,12);
for j = 70:10:140
    for i = 1:12

        z((j-60)/10,i) = ajun1*N2((j-60)/10,i)+bjun*j+cjun;
    end
end
s = 0;
z0= zeros(8,12);
for j = 70:10:140
    for i = 1:12
        z0((j-60)/10,i) = ajun*N2((j-60)/10,i)+bjun*j+cjun;
    end
end
zz0 = z0-N1;
s0 = 0;
for i = 1 :8
    s0 = s0+zz0(i,1:i+4)*zz0(i,1:i+4)';
end
R0 = s0/(sum(len)-1);
zz = z-N1;
s = 0;
for i = 1 :8
    s = s+zz(i,1:i+4)*zz(i,1:i+4)';
end
R= s/(sum(len)-1);