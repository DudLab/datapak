filepath2 = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task2/DataBuffer/data/trialdata/';
filepathp2 = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task2/DataBuffer/data/posdata/';
fnamesp2 = dir(strcat(filepathp2,'*.csv'));
fnames2 = dir(strcat(filepath2,'*.csv'));
nopos = 1;%0 = no positionstuff; 1 = yes
ns = length(fnames2);%number of test subjects
ad2 = zeros(175*2,11,ns);%alldata 175*2
b = 50; %block
half = 2;

for k = 1:ns
    fname2 = fnames2(k).name;
    ad2(:,:,k) = csvread(strcat(filepath2,fname2), 2,0);
    if nopos == 1
        fnamep2 = fnamesp2(k).name;    
        pd2 = csvread(strcat(filepathp2,fnamep2), 2,0);
        np2(k) = numel(pd2(:,2));
    end
end
mpd = max(np2);
rth = numel(unique(ad2(:,4,1)));%number of reach thresholds
tt2 = ((b*rth)/half);
hd2 = reshape((b/2)+1:b,(b/2),1);
for i = 1:(rth)
    hdx2(1+(b/2)*(i-1):(b/2)*i,1) = hd2(:,1) + b*(i-1);
end
hindex2 = reshape(hdx2,(b/2),rth);
clearvars td2
for k = 1:ns    
    for t = 1:rth
        if half == 2
            td2(:,:,t,k) = ad2(ad2(:,4,k)==(t-1) & ismember(ad2(:,2,k),hindex2(:,t)),:,k);
%             td2(:,:,t,k) = td2a(ismember(td2a(:,2,t,k),hindex2(:,t)),:,k);
        else
            td2(:,:,t,k) = ad2(ad2(:,4,k)==(t-1),:,k);
        end
    end
end
if nopos == 1
    clearvars tpd2
    for k = 1:ns
        if np2(k)< mpd
            tpd2(1:np(k),:,k) = csvread(strcat(filepathp2,fnamep2), 2,0);
            tpd2(np(k):mpd,:,k) = 0;
        else
            tpd2(:,:,k) = csvread(strcat(filepathp2,fnamep2), 2,0);
        end
        for t = 1:rth
            if k<2
                p2{t,1} = tpd2(tpd2(:,3,k)==t-1 & ismember(tpd2(:,2,k),hindex2(:,t)),:,k);%1,2,etc.
            else
                p2{t,1} = vertcat(p2{t,1},tpd2(tpd2(:,4,k)==t-1,:,k));
            end
        end
    end
end
figure(1);
for i = 1:rth
    pmx(i,1) = min(p2{i,1}(:,6));%x
    pmx(i,2) = max(p2{i,1}(:,6));%y
    pmn(i) = mean(p2{i,1}(:,6));
    pmy(i,1) = min(p2{i,1}(:,7));%x
    pmy(i,2) = max(p2{i,1}(:,7));%y
    hold all
    subplot(7,2,1+2*(i-1));
    plot(1:((b/half)),mean(td2(:,9,i,1),4));
    title(['reach' num2str(i) '=' num2str(td2(1,5,i))]);
    xlabel('trial');
    subplot(7,2,2*i);
    scatter(p2{i,1}(:,6),p2{i,1}(:,7));
    title(['trajectory' num2str(i) '=' num2str(td2(1,5,i))]);
    xlabel('x');
end

a = axes;
if half == 2
    t1 = title('Subject distance-optimal dist) second half of blocks');
else
    t1 = title('Subject distance-optimal dist');
end
a.Visible = 'off';
t1.Visible = 'on';

figure(2);
hold all
%     subplot(7,2,1+2*(i-1));
plot(1:rth,pmn,'r',1:rth,pmx(:,1),'g',1:rth, pmx(:,2),'b');
legend('mean','max','min');
% title('reach x mean');
xlabel('reach');
a2 = axes;
if half == 2
    t2 = title('x mean,max,min second half of blocks');
else
    t2 = title('x mean,max,min');
end
a2.Visible = 'off';
t2.Visible = 'on';