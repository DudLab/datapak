

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
    legendcell{k} = ['usr' num2str(k)];
    fname = fnames(k).name;
    ad(:,:,k) = csvread(strcat(filepath,fname), 2,0);
    if nopos == 1
        fnamep = fnamesp(k).name;    
        pd1 = csvread(strcat(filepathp,fnamep), 2,0);
        np(k) = numel(pd1(:,2));
    end
end
legendcell{k+1} = 'avg';
% threshes = 2%for old csv
%trial data for task1 and 2
half = 2;
colp = size(pd1,2);
mpd = max(np);
rn = numel(unique(ad(:,4,1)));
pn = numel(unique(ad(:,5,1)));
col = size(ad,2);
tt = pn*b/half;
cl = varycolor(4);
poscl = varycolor(500);
if half == 2
    hd = reshape((b/2)+1:b,(b/2),1);
    for i = 1:(rn*pn)
        hdx(1+(b/2)*(i-1):(b/2)*i,1) = hd(:,1) + b*(i-1);
    end

    hindex = reshape(hdx,tt,rn);
else
    hindex = reshape(1:500,tt,rn);
end
if colp == 16
    version = 1;
end
if colp == 15
    version = 2;
end
chleft = zeros(pn,rn,ns);
avg = zeros(pn,rn);
td = zeros((size(ad,1)/rn)/half,size(ad,2),rn,ns);
td1 = zeros((size(ad,1)/rn),size(ad,2),rn,ns);
correct = zeros(tt,rn,ns);
idxc = zeros(rn,ns);
incorrect = zeros(tt,rn,ns);% trial number for correct
idxn = zeros(rn,ns);
for k = 1:ns
%=================================================================================
%=================================================================================
% HANDLING ALL TRIAL DATA
%=================================================================================
%=================================================================================
    if version == 1
        pta(k,:) = reshape(((ad(:,6,k)==1 & ad(:,7,k)==1) ...
            | (ad(:,6,k)==0 & ad(:,7,k)==2)),1,(size(ad,1)));
    end
    if version == 2
        pta(k,:) = reshape(((ad(:,6,k)==1)),1,(size(ad,1)));
    end
%=================================================================================
%=================================================================================
    for t = 1:rn
        %     separate into thresh 3dim = each separate reach
        td1(:,:,t,k) = ad(ad(:,4,k)==t,:,k);

        % sort based on prob
        [y,idx] = sort(td1(:,5,t,k));
        td1(:,:,t,k) = td1(idx,:,t,k);
        if half == 2
            td(:,:,t,k) = td1(ismember(td1(:,2,t,k),hindex(:,t)),:,t,k);
        else
            td(:,:,t,k) = td1(:,:,t,k);
        end
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
            idxc(t,k) = numel(find(td(:,7,t,k) == 1));
            correct(1:idxc(t,k),t,k) ...
                = td((td(:,7,t,k) == 1),2,t,k);
            correct(idxc(t,k):tt,t,k) = 0;
        %   INCORRECT
            idxn(t,k) = tt - idxc(t,k);
            incorrect(1:idxn(t,k),t,k) ...
                = td((td(:,7,t,k) == 0),2,t,k);
            incorrect(idxn(t,k):tt,t,k) = 0;

        end
        for i = 1:5
            sl1 = b;%take all trials
            sdx1 = 1+(b)*(i-1);
            if half == 2% take 2nd half
                sl = (b/2);
                sdx = 1+ (i-1)*25;
            else
                sl = b;%take all trials
                sdx = 1+(b)*(i-1);
            end
            if version == 1
%               PROB CHOOSE LEFT
% old "timestamp, trialNum, blockWidth, position_number, LeftTriggerProbability, rightORwrong, Rewardposition, forageDistance, collectionDistance, totalDistance, optimalTotalDistance, Totaldifference, score"
                chleft(i,t,k) = ((sum((td(sdx:sl*i,6,t,k) == 1 & td(sdx:sl*i,7,t,k) == 1))) ...
                    + (sum((td(sdx:sl*i,6,t,k)== 0 & td(sdx:sl*i,7,t,k) == 2))))/sl;
                pt(k,:,t,i) = reshape(((td1(sdx1:sl1*i,6,t,k)==1 & td1(sdx1:sl1*i,7,t,k)==1) ...
                    | (td1(sdx1:sl1*i,6,t,k)==0 & td1(sdx1:sl1*i,7,t,k)==2)),1,b);
%                 pt(k,:,t,i) = reshape(cumsum((td1(sdx1:sl1*i,6,t,k)==1 & td1(sdx1:sl1*i,7,t,k)==1) ...
%                     | (td1(sdx1:sl1*i,6,t,k)==0 & td1(sdx1:sl1*i,7,t,k)==2))./reshape(1:(b),b,1),1,b); 
%
            end
            if version == 2
%               PROB CHOOSE LEFT
            %            // "timestamp, trialNum, blockWidth, reach4, leftprob5, playerpos6, Rightorwrong7, rpos8, forageDist, totDist, optdist, diff, score";
                chleft(i,t,k) = (numel(td((td(sdx:sl*i,6,t)== 1))))/sl;
                pt(k,:,t,i) = reshape((td(sdx1:sl1*i,6,t,k)==1),1,sl1);
%                 pt(k,:,t,i) = reshape(cumsum(td(sdx1:sl1*i,6,t,k)==1)./reshape(1:(sl1),sl1,1),1,sl1);
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
            for i = 1:5
%                Newpos="trialNum, blockWidth, MillisTime, rpos, reach, leftprob, MouseX, MouseY, startdiameter, targetdiameter, x0,y0, x1, y1,trialstate";
                rt{t,k} = tpd(ismember(tpd(:, 1, k),correct(:,t,k)) & tpd(:,4,k)==t,:,k);
                wn{t,k} = tpd(ismember(tpd(:, 1, k),incorrect(:,t,k)) & tpd(:,4,k)==t,:,k);
            end
        end
    end
end
%=================================================================================
%=================================================================================
% OPAL MODEL STUFF
%=================================================================================
%=================================================================================

%=================================================================================
%=================================================================================

%=================================================================================
%=================================================================================
% FIGURES
%=================================================================================
%=================================================================================
figure(1);
    subplot(2,1,1);
    set(gca, 'ColorOrder', cl);
    set(gca,'fontsize',18);
    hold all;
    for i = 1:ns+1
        if i <ns+1
            plot(rprob,chleft(:,1,i));
        else
            plot(rprob,avg(:,1));
        end
    end
    legend(legendcell);
    
    xlabel('P(reward)');
    ylabel('P(choose left)');
    if half == 2
        title('P(choose L) as function of P(Leftreward) (R1) 2ndhalf');
    else
        title('P(choose L) as function of P(Leftreward) (R1)');
    end
    
    subplot(2,1,2);
    set(gca, 'ColorOrder', cl);
    set(gca,'fontsize',18);
    hold all;
    for i = 1:ns+1
        if i <ns+1
            plot(rprob,chleft(:,2,i));
        else
            plot(rprob,avg(:,2));
        end
    end
        legend(legendcell);
    
    xlabel('P(reward)');
    ylabel('P(choose left)');
    if half == 2
        title('P(choose L) as function of P(Leftreward) (R2) 2ndhalf');
    else
        title('P(choose L) as function of P(Leftreward) (R2)');
    end
if nopos == 1 
    for t = 1:rn
        figure(t+1);
%         hold all
        for i = 1:pn
%         hold on            
            subplot(5,2,i);
            x = 1:length(pt(:,:,t,i));
            semline(pt(:,:,t,i),10,'r');
%             shadedErrorBar(x,pt(:,:,t,i),{@mean, @(x) 1*std(x)},'r',0);
            hold all
%             plot(1:length(pt(:,:,t,i)),pt(:,:,t,i));
            title(['p(r)=' num2str(rprob(i))]);
            xlabel('trials');
            ylabel('choice prob');
        end
            a = axes;
            t1 = title(['P(choose L) at reach' num2str(t)]);
            a.Visible = 'off';
            t1.Visible = 'on';
    end
    for r = 1:rn
        figure((r+rn+1));
        for k = ns
        xlabel('X');
        ylabel('Y');
            for i = 1: pn
                set(gca, 'ColorOrder', poscl);
                hold all
                if version == 1
                    for p = 1:tt
        %               CORRECT & rt{r,k}(:,4)==r ,'color', poscl(p+(r-1)*tt,:)
                        
                        subplot(5,4,1+4*(i-1));
                        hold on
                        plot(rt{r,k}(rt{r,k}(:,colp) == 2 & rt{r,k}(:,5) == rprob(i) ...
                            & rt{r,k}(:,1) == hindex(p,r),6) ...
                        ,rt{r,k}(rt{r,k}(:,colp)== 2 & rt{r,k}(:,5) == rprob(i)...
                            & rt{r,k}(:,1) == hindex(p,r),7),'color', poscl(p+(r-1)*tt,:));
                        title(['correct choices p(r)=' num2str(rprob(i))]);
                        
        %               INCORRECT
                        subplot(5,4,3+4*(i-1));
                        hold on
                        plot(wn{r,k}(wn{r,k}(:,colp) == 2 & wn{r,k}(:,5) == rprob(i)...
                            & wn{r,k}(:,1) == hindex(p,r),6) ...
                        ,wn{r,k}(wn{r,k}(:,colp) == 2 & wn{r,k}(:,5) == rprob(i) ...
                            & wn{r,k}(:,1) == hindex(p,r),7),'color', poscl(p+(r-1)*tt,:));
                        title(['incorrect choices p(r)=' num2str(rprob(i))]);
                    end
%                   CORRECT
                    subplot(5,4,2+4*(i-1));
                    n = hist3([rt{r,k}(rt{r,k}(:,colp)== 2 & rt{r,k}(:,5)== rprob(i),6)...
                    ,rt{r,k}(rt{r,k}(:,16)== 2 & rt{r,k}(:,5)== rprob(i),7)],[10,10]);
                    imagesc(n);
%                   INCORRECT
                    subplot(5,4,4+4*(i-1));                   
                    nw = hist3([wn{r,k}(wn{r,k}(:,colp)== 2 & wn{r,k}(:,5)== rprob(i),6)...
                    ,wn{r,k}(wn{r,k}(:,colp)== 2 & wn{r,k}(:,5)== rprob(i),7)],[10,10]);
                    imagesc(nw);
                end
                if version == 2
                    for p = 1:tt
    %               CORRECT  
                        subplot(5,4,1+4*(i-1));
                        hold on
                        hold all
                        plot(rt{r,k}(rt{r,k}(:,15)== 2 & rt{r,k}(:,5)== rprob(i)...
                            & rt{r,k}(:,1) == hindex(p,r),6) ...
                        ,rt{r,k}(rt{r,k}(:,15)== 2 & rt{r,k}(:,5)== rprob(i)...
                            & rt{r,k}(:,1) == hindex(p,r),7));
                        title(['correct choices p(r)=' num2str(rprob(i))]);
        %               INCORRECT
                        subplot(5,4,3+4*(i-1));
                        hold on
                        hold all
                        plot(wn{r,k}(wn{r,k}(:,15)== 2 & wn{r,k}(:,5)== rprob(i)... 
                            & wn{r,k}(:,1) == hindex(p,r),6)...
                        ,wn{r,k}(wn{r,k}(:,15)== 2 & wn{r,k}(:,5)== rprob(i)...
                            & wn{r,k}(:,1) == hindex(p,r),7));
                        title(['incorrect choices p(r)=' num2str(rprob(i))]);
                    end
%                   CORRECT
                    subplot(5,4,2+4*(i-1));
                    n = hist3([rt{r,k}(rt{r,k}(:,15) == 2 & rt{r,k}(:,5) == rprob(i),6) ...
                    ,rt{r,k}(rt{r,k}(:,15) == 2 & rt{r,k}(:,5) == rprob(i),7)],[10,10]);
                    imagesc(n);
%                   INCORRECT
                    subplot(5,4,4+4*(i-1));
                    nw = hist3([wn{r,k}(wn{r,k}(:,15) == 2 & wn{r,k}(:,5) == rprob(i),6) ...
                    ,wn{r,k}(wn{r,k}(:,15)== 2 & wn{r,k}(:,5) == rprob(i),7)],[10,10]);
                    imagesc(nw);
                    
                end
            end
        end
        ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
        t = text(0.5, 1,['Forage trajectories (second half of trials) reach =' num2str(r)],'HorizontalAlignment' ...
        ,'center','VerticalAlignment', 'top');
        t.FontSize = 18;
    end
end
for i = 1:ns
    figure(((2*rn)+1)+i);
    hold on
        if version == 1
            %==================================================================================
            %==================================================================================
%             lcorr = ((ad(:,6,i)==1 & ad(:,7,i)==1));%actual left reward port rewarded
%             lwro = ((ad(:,6,i)==0 & ad(:,7,i)==1));%actual left reward port unrewarded            
%             rcorr = ((ad(:,6,i)==1 & ad(:,7,i)==2));%actual right reward port rewarded
%             rwro  = ((ad(:,6,i)==0 & ad(:,7,i)==2));%actual right reward port unrewarded
            cl = (ad(:,7,i)==1);
            cr = (ad(:,7,i)==2);
            cc = reshape((ad(:,7,i)==1),1,size(ad,1));
            %==================================================================================
            %==================================================================================
%             xs = [(ad(:,4,i)==2),(ad(:,4,i)==1),lwro,lcorr,rcorr,rwro];%with right or wrong
%             ht = [0.1,0.1,0.05,0.075,-0.05,-0.75];
%             hv = [1.3,1.3,1.15,1.10,-0.15,-0.10];
%             col = [1 0 0; 0 0 1; .8 .4 0; 1 .5 0;0 .2 0; 0 .8 0];
            xs = [(ad(:,4,i)==1),(ad(:,4,i)==2),cl,cr];
            ht = [0.1,0.1,0.075,-0.075];
            hv = [1.3,1.3,1.10,-0.10];
            col = [1 0 0; 0 0 1; 1 .5 0;0 .8 0];
            lt = [2,2,1,1,1,1];
            (shade(xs,0,hv, ht, col,lt));
            %==================================================================================
            %==================================================================================   
        end
        if version == 2
            %==================================================================================
            %==================================================================================
%             lcorr = find((ad(:,6,i)==1 & ad(:,7,i)==1))*1.1;%actual left reward port rewarded
%             lwro = find((ad(:,6,i)==2 & ad(:,7,i)==0))*1.15;%actual left reward port unrewarded
%             rcorr = find((ad(:,6,i)==2 & ad(:,7,i)==1))*(-0.1);%actual right reward port rewarded
%             rwro  = find((ad(:,6,i)==1 & ad(:,7,i)==0))*(-0.15);%actual right reward port unrewarded
            cl = (ad(:,8,i)==1);
            cr = (ad(:,8,i)==2);
            cc = reshape((ad(:,8,i)==1),1,size(ad,1));
            %==================================================================================
            %==================================================================================
%             xs = [(ad(:,4,i)==2),(ad(:,4,i)==1),lwro,lcorr,rcorr,rwro];%with right or wrong
%             ht = [0.1,0.1,0.05,0.075,-0.05,-0.75];
%             hv = [1.3,1.3,1.15,1.10,-0.15,-0.10];
%             col = [1 0 0; 0 0 1; .8 .4 0; 1 .5 0;0 .2 0; 0 .8 0];
            xs = [(ad(:,4,i)==2),(ad(:,4,i)==1),cl,cr];
            ht = [0.1,0.1,0.075,-0.075];
            hv = [1.3,1.3,1.10,-0.10];
            col = [1 0 0; 0 0 1; 1 .5 0;0 .8 0];
            lt = [2,2,1,1,1,1];
            (shade(xs,0,hv, ht, col,lt));
            
            %==================================================================================
            %==================================================================================
            
        end
%         plot(find(pta(i,:)==1),1,'Color', [0 0.2 0]); %plot the 1's
%         plot(find(pta(i,:)==0),0,'Color', [0 0.8 0]); %plot the 0's
        avgval = 20;
        plot(moveavg(cc,avgval), 'c');
        plot(moveavg(pta(i,:),avgval),'k');
        l = legend('reach1',' ','reach2',' ','Reward target: left', ' ', 'Reward target: right' ,'', ...
            'P(reward|left) moving avg','Choice moving avg');
        l.FontSize = 16;
        xlabel('Trials');
        ylabel('Probability');
        xlim([0, size(ad,1)]);
        ylim([-0.2,1.3]);
        ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
        t = text(0.5, 1,['P(choose L) over time, usr ' num2str(i) ',movavg= ' num2str(avgval) ' trials'],'HorizontalAlignment' ...
        ,'center','VerticalAlignment', 'top');
        t.FontSize = 22;
end