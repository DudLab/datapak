% requires movav and varycolor functions

% get filenames
filepath = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task1/DataBuffer/trialdata/';
filepathp = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task1/DataBuffer/positiondata/';
fnamesp = dir(strcat(filepathp,'*.csv'));
fnames = dir(strcat(filepath,'*.csv'));
nopos = 1;%0 = no positionstuff; 1 = yes
ns = length(fnames);%number of test subjects
ad = zeros(500,13,ns);%alldata
np = zeros(ns);
rprob = [0.1,0.25,0.5, 0.75,0.9];
b = 50; %block
for k = 1:ns
    fname = fnames(k).name;
    ad(:,:,k) = csvread(strcat(filepath,fname), 2,0);
    if nopos == 1
        fnamep = fnamesp(k).name;    
        pd1 = csvread(strcat(filepathp,fnamep), 2,0);
        np(k) = numel(pd1(:,2));
    end
end

% threshes = 2%for old csv
%trial data for task1 and 2
col = size(pd1,2);
mpd = max(np);
rn = numel(unique(ad(:,4,1)));
pn = numel(unique(ad(:,5,1)));
tt = pn*b;
cl = varycolor(rn + 1);

if rn == 2
    version = 1;
end
if rn == 5
    version = 2;
end
chleft = zeros(pn,rn,ns);
avg = zeros(pn,rn);
td = zeros(size(ad,1)/rn,size(ad,2),rn,ns);
correct = zeros(b*pn,rn,ns);
idxc = zeros(rn,ns);
incorrect = zeros(b*pn,rn,ns);% trial number for correct
idxn = zeros(rn,ns);
for k = 1:ns
    for t = 1:rn
        %     separate into thresh 3dim = each separate reach
        td(:,:,t,k) = ad(ad(:,4,k)==t,:,k);

        % sort based on prob
        [y,idx] = sort(td(:,5,t,k));
        td(:,:,t,k) = td(idx,:,t,k);
        
        if version == 1
        %   CORRECT
            idxc(t,k) = numel(find(td(:,6,t,k) == 1));
            correct(1:idxc(t,k),t,k) ...
                = td((td(:,6,t,k) == 1),2,t,k);
            correct(idxc(t,k):tt,t,k) = 0;
        %   INCORRECT
            idxn(t,k) = tt - idxc(t,k);
            incorrect(1:idxn(t,k),t,k) ...
                = td((td(:,6,t,k) == 0),2,t,k);
            incorrect(idxn(t,k):tt,t,k) = 0;
        end
        if version == 2
        %   CORRECT TEST OUT WITH NEW CSV
            idxc(t,k) = numel(find(td(:,6,t,k) == td(:,7,t,k)));
            correct(1:idxc(t,k),t,k) ...
                = td((td(:,6,t,k) == td(:,7,t,k)),2,t,k);
            correct(idxc(t,k):tt,t,k) = 0;
        %   INCORRECT
            idxn(t,k) = tt - idxc(t,k);
            incorrect(1:idxn(t,k),t,k) ...
                = td((td(:,6,t,k) ~= td(:,7,t,k)),2,t,k);
            incorrect(idxn(t,k):tt,t,k) = 0;
        end
        for i = 1:5
            if version == 1
%               PROB CHOOSE LEFT
                chleft(i,t,k) = (numel(td((td(1+(50)*(i-1):50*i,6,t,k) == 1 & td(1+(50)*(i-1):50*i,7,t,k) == 1))) ...
                    + numel(td((td(1+(50)*(i-1):50*i,6,t,k)== 0 & td(1+(50)*(i-1):50*i,7,t,k) == 2))))/50;
            end
            if version == 2
%               PROB CHOOSE LEFT
            %  new "timestamp, trialNum, blockWidth, reach, leftprob, playerpos, Rewpos, forageDist, CollDist, totDist, optdist, diff, score";      
                chleft(i,t,k) = (numel(td((td(1+(50)*(i-1):50*i,6,t)== 1))))/50;
                
            end
        end        
    end
end
for i = 1:rn
    avg(:,i) = (sum(chleft(:,i,:),3)/ns);
end
avg1 = sum(avg,2)/rn;
% ==============================================================
% TASK1positionstuff
% ==============================================================
if nopos == 1
    clearvars tpd
    for k = 1:ns
        if np(k)< mpd
            tpd(1:np(k),:,k) = csvread(strcat(filepathp,fnamep), 2,0);
            tpd(np(k):mpd,:,k) = 0;
        else
            tpd(:,:,k) = csvread(strcat(filepathp,fnamep), 2,0);
        end
        for t = 1:rn%rn
    %         cell col = reach
%             if k<2
%                 rt{t,1} = tpd(ismember(tpd(tpd(:,4,k)==t, 1, k),correct(:,t,k)),:,k);%1,2,etc.
%                 wn{t,1} = tpd(ismember(tpd(tpd(:,4,k)==t, 1, k),incorrect(:,t,k)),:,k);%1,2,etc.
%             else
%                 rt{t,1} = vertcat(rt{t,1},tpd(ismember(tpd(tpd(:,4,k)==t, 1, k),correct(:,t,k)),:,k));
%                 wn{t,1} = vertcat(wn{t,1},tpd(ismember(tpd(tpd(:,4,k)==t, 1, k),incorrect(:,t,k)),:,k));
%             end
            if k<2
                rt{t,1} = tpd(ismember(tpd(:, 1, k),correct(:,:,k)),:,k);%1,2,etc.
                wn{t,1} = tpd(ismember(tpd(:, 1, k),incorrect(:,:,k)),:,k);%1,2,etc.
            else
                rt{t,1} = vertcat(rt{t,1},tpd(ismember(tpd(:, 1, k),correct(:,:,k)),:,k));
                wn{t,1} = vertcat(wn{t,1},tpd(ismember(tpd(:, 1, k),incorrect(:,:,k)),:,k));
            end
        end
    end
end
asdf =  tpd(ismember(tpd(tpd(:,4,2)==2,1,1),correct(:,2,2)),:,2);
% asdf1 =  tpd(ismember(tpd(tpd(:,4,1)==1,1,1),correct(:,2,2)),:,2);
% asdf = tpd(ismember(tpd(tpd(:,4,1)==2, 1, 1),correct(:,2,1)),:,1);
% asdf1 = tpd(ismember(tpd(tpd(:,4,2)==2, 1, 2),correct(:,2,2)),:,2);
% asdfc = vertcat(asdf,asdf1);
% zr = asdfc - rt{2,1};
% sd = numel(unique(rt{1,1}(:,4)));
% sd1 = numel(unique(rt{2,1}(:,4)));
% ==============================================================
% FIGURES
% ==============================================================
figure(1);
    set(gca, 'ColorOrder', cl);
    set(gca,'fontsize',18);
    hold all;
    for i = 1:rn+1
        if i <rn+1
            plot(rprob,avg(:,i));
        else
            plot(rprob,avg1);
        end
    end
    if version == 1
        legend('r1','r2','avg all');
    end
    if version == 2
        legend('r1','r2','r3','r4','r5','avg all');
    end
    
    xlabel('P(reward)');
    ylabel('P(choose left)');
    title('P(choose L) as function of P(reward)');
if nopos == 1
figure(2);
    if version == 1
    s = scatter(asdf(:,6) ,asdf(:,7));
%     subplot(1,2,1);
%     scatter(rt{1,1}(:,6),rt{1,1}(:,7));
%     subplot(1,2,2)
%     scatter(rt{2,1}(:,6),rt{2,1}(:,7));
    end
    if version == 2
        s = scatter(rt{1,1}(rt{1,1}(:,15)==2,6) ,rt{1,1}(rt{1,1}(:,15)==2,7));
    end
%     s.LineWidth = 0.6;
%     s.MarkerEdgeColor = 'b';
%     s.MarkerFaceColor = [0 0.5 0.5];
figure(7);
    subplot(1,2,1);
    scatter(rt{1,1}(:,6),rt{1,1}(:,7));
    subplot(1,2,2)
    scatter(rt{2,1}(:,6),rt{2,1}(:,7));


%     hold on
%     x = rt{1,1}(rt{1,1}(:,16)== 2,6);
%     y = rt{1,1}(rt{1,1}(:,16)== 2,7);
%     [n,c] = hist3([x, y]);
%     contour(c{1},c{2},n)
% asdf = numel(unique(rt{
    for r = 1:rn
        figure((1+2*(r-1))+2);
        xlabel('X');
        ylabel('Y');
        title(['Forage Trajectory(correct choices) reach' num2str(r)]);
        hold all
        for i = 1: 5
            if version == 1
                subplot(5,2,1+2*(i-1));
                scatter(rt{1,1}(rt{1,1}(:,16)== 2 & rt{1,1}(:,5)== rprob(i)& rt{1,1}(:,4)==r,6) ...
                ,rt{1,1}(rt{1,1}(:,16)== 2 & rt{1,1}(:,5)== rprob(i)& rt{1,1}(:,4)==r,7));
                subplot(5,2,2*i);
                n = hist3([rt{1,1}(rt{1,1}(:,16)== 2 & rt{1,1}(:,5)== rprob(i)& rt{1,1}(:,4)==r,6) ...
                ,rt{1,1}(rt{1,1}(:,16)== 2 & rt{1,1}(:,5)== rprob(i)& rt{1,1}(:,4)==r,7)],[10,10]);
                imagesc(n);
                title(['Forage Trajectory(correct choices) reach' num2str(r)]);
            end
            if version == 2
                subplot(5,2,1+2*(i-1));
                scatter(rt{1,1}(rt{1,1}(:,15)== 2 & rt{1,1}(:,5)== rprob(i)& rt{1,1}(:,4)==r,6) ...
                ,rt{1,1}(rt{1,1}(:,15)== 2 & rt{1,1}(:,5)== rprob(i)& rt{1,1}(:,4)==r,7));
                subplot(5,2,2*i);
                n = hist3([rt{1,1}(rt{1,1}(:,15)== 2 & rt{1,1}(:,5)== rprob(i)& rt{1,1}(:,4)==r,6) ...
                ,rt{1,1}(rt{1,1}(:,15)== 2 & rt{1,1}(:,5)== rprob(i)& rt{1,1}(:,4)==r,7)],[10,10]);
                imagesc(n);
            end
        end

        figure((2*r)+2);
        hold all
        xlabel('X');
        ylabel('Y');
        title(['Forage Trajectory(incorrect choices) reach' num2str(r)]);
        for i = 1: 5
            if version == 1
                subplot(5,2,1+2*(i-1));
                scatter(wn{1,1}(wn{r,1}(:,16)== 2 & wn{1,1}(:,5)== rprob(i)& wn{1,1}(:,4)==r,6) ...
                ,wn{1,1}(wn{1,1}(:,16)== 2 & wn{1,1}(:,5)== rprob(i) & wn{1,1}(:,4)==r,7));
                subplot(5,2,2*i);
                nw = hist3([wn{1,1}(wn{1,1}(:,16)== 2 & wn{1,1}(:,5)== rprob(i)& wn{1,1}(:,4)==r,6) ...
                ,wn{1,1}(wn{1,1}(:,16)== 2 & wn{1,1}(:,5)== rprob(i)& wn{1,1}(:,4)==r,7)],[10,10]);
                imagesc(nw);
                title(['Forage Trajectory(incorrect choices) reach' num2str(r)]);
            end
            if version == 2
                subplot(5,2,1+2*(i-1));
                scatter(wn{r,1}(wn{r,1}(:,15)== 2 & wn{r,1}(:,5)== rprob(i),6) ...
                ,wn{r,1}(wn{r,1}(:,15)== 2 & wn{r,1}(:,5)== rprob(i),7));
                subplot(5,2,2*i);
                nw = hist3([wn{r,1}(wn{r,1}(:,15)== 2 & wn{r,1}(:,5)== rprob(i),6) ...
                ,wn{r,1}(wn{r,1}(:,15)== 2 & wn{r,1}(:,5)== rprob(i),7)],[10,10]);
                imagesc(nw);
            end     
        end
    end
end
% figure(3);
% 
% figure(4);