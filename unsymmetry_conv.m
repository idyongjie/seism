%% Qconv_0.25
% ������Ű�
%% ��ȡ����,�õ��ź�QL
% Ƶ���1��12��С
clear
wenjianshu = 15;

XH = zeros(257,wenjianshu);
for i = 1:wenjianshu
    name = "BF.D"+string(i);
    Z = textread(name);
    XH(:,i) = Z(514:770,3);
end
clear name i Z
%% ����ģ��fs_all,���о��
fs_all = xlsread("fs_all_0.25.xlsm");
% aa = zeros(56,wenjianshu+1);
% aa(:,1) = [2:0.5:29.5]';
% bb = zeros(56,wenjianshu+1);
% bb(:,1) = [2:0.5:29.5]';
for i = 1:wenjianshu
%     feng = zeros(56,1);
%     gu = zeros(56,1);
        xl = zeros(3006,1680);
    for j = 1:56
        hanshu(:,j) = conv(fs_all(:,j),XH(:,i));
%         feng(j) = max(hanshu(1988:2305,j));
%         gu(j) = min(hanshu(1988:2305,j));
        for k = 1:30
            xl(:,j*30-30+k) = hanshu(:,j);
        end  
    name = "lost_gao_140_"+i+"_3006*1680.dat"
    fid = fopen(name,"wb");
        fwrite(fid,xl,'float');
        fclose(fid);
        clear fid;
    % д���ļ�
%         a = [[2:0.5:29.5]',feng,gu];
%     xlswrite("lost_gao140.D"+string(i)+".xlsm",a);
%     aa(:,i+1)= a(:,2);
%     bb(:,i+1)= a(:,3);
    end
% xlswrite("lost_gao140F.xlsm",aa);
% xlswrite("lost_gao140G.xlsm",bb);
% for i = 26:30
%     hold on
%     plot(hanshu(1975:2265,i))
% end
% legend("26","27","28","29","30")
% plot(hanshu(:,1))
% hold on
% plot(hanshu(:,56))
% hold on
% plot(hanshu(:,15))
% legend("1","2","3")