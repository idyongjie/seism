%% 	Hconv_0.25
%% 读取数据,得到低通滤波矩阵QL
clear
Z = textread("BF.D13.txt");
HL = zeros(513,12);
HL(:,1) = Z(1:513,3);
gongju = Z(1:513,3);
for i = 12:-1:2
    name = "BF.D"+string(i)+".txt";
    lin = textread(name);
    gongju(36:70) = lin(36:70,3);
    HL(:,14-i) = gongju;
end
clear name lin i gongju Z
% 从1→12，频宽变窄
%% 对低通滤波矩阵进行傅里叶变换得到XL信号矩阵
HL1 = HL(1:513,:);            
Hlx = flipud(HL(2:512,:));
QL2 = [HL1;Hlx];
XL = zeros(257,12);
for i = 1:12
    B = ifft(QL2(:,i),1024);
    B1 = flipud(real(B(2:129)));
    XL(:,i) = 32*[B1;real(B(1:129))];
end
clear HL1 B B1 QC HL QL2 Hlx
%% 导入模型fs_all,进行卷积
fs_all = xlsread("fs_all_0.25.xlsm");
aa = zeros(56,13);
aa(:,1) = [2:0.5:29.5]';
bb = zeros(56,13);
bb(:,1) = [2:0.5:29.5]';
for i = 1:12
    feng = zeros(56,1);
    gu = zeros(56,1);
    for j = 1:56
        hanshu(:,j) = conv(fs_all(:,j),XL(:,i));
        feng(j) = max(hanshu(1988:2305,j));
        gu(j) = min(hanshu(1988:2305,j));
    end
        a = [[2:0.5:29.5]',feng,gu];
    xlswrite("HX140.D"+string(i)+".xlsm",a);
    aa(:,i+1)= a(:,2);
    bb(:,i+1)= a(:,3);
end
xlswrite("HX140F.xlsm",aa);
xlswrite("HX140G.xlsm",bb);
%% 观测结果
% for i = 2:5
%     hold on
%     plot(hanshu(490+34:610-51,i))
% end
% legend("2","3","4","5")
% m = hanshu(524:570,1:10)
% plot(hanshu(:,1))
% hold on
% plot(hanshu(:,56))
% hold on
% plot(hanshu(:,15))
% legend("1","2","3")