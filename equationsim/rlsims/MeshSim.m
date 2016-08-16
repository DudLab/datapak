%% StimBias modded
sessionData1=[];
sessionData2=[];
picklist = [];
stimNum1=[];
stimNum2=[];

sizeD=10000;
reps=300;
stimThresh=2.5
weightChange=1;
setChange=.25
changeFactor=100;


for j = 1:reps
%D1    
reachD=randn(sizeD,1);
reachD2 = reachD;
rm = mean(reachD2);
reachStats1=[0,mean(reachD)];

for i =1:100
   pick=round(rand(1)*(sizeD-1))+1; %select a reach from the distribution.  +- 1 because you round allows you to pick reachD(0).
   thisReach = reachD(pick);
   picklist = [0,pick];
   reachDiff=thisReach-mean(reachD);
   fromSet=2*((thisReach-reachStats1(1,2))>0)-1;
   stimChange=0;
   if i<51
%      if rem(pick,3)==0 % random
  if thisReach>stimThresh
      stimChange=.15; %affects amt of change
    %changeD=randn(sizeD/changeFactor,1)*.1 +thisReach;
%reachDprime=[reachD; changeD];
%goodbye=round([1:(size(reachDprime)/size(changeD)) :size(reachDprime)]);
%reachDprime(goodbye)=[];
%reachD=reachDprime;
       stimNum1=[stimNum1,i];
   end
   end
%   reachD=reachD+(reachDiff*weightChange)-(fromSet*setChange)+stimChange*fromSet; %could institute punish signal here, but no failed trials
 reachD=reachD+1.8*(2*((thisReach-mean(reachD)>0))-1)-(fromSet*setChange)+stimChange*fromSet; %could institute punish signal here, but no failed trials

   %attractor to set point
   reachStats1=[reachStats1;[thisReach,mean(reachD)]];
end
sessionData1=[sessionData1,reachStats1(:,1)];

%D2
reachD=randn(sizeD,1);
reachStats2=[0,mean(reachD)];
weightChange=1;


for i =1:100
   pick=round(rand(1)*(sizeD-1))+1; %select a reach from the distribution.  +- 1 because you round allows you to pick reachD(0).
   thisReach = reachD(pick);
   reachDiff=thisReach-mean(reachD);
   fromSet=2*((thisReach-reachStats2(1,2))>0)-1;
   stimChange=0;
   if i<51
     if rem(pick,3)==0
       %if thisReach>stimThresh
     stimChange=-.15; %affects amt of change
    changeD=randn(sizeD/changeFactor,1)*.1 +2;
reachDprime=[reachD; changeD];
goodbye=round([1:(size(reachDprime)/size(changeD)) :size(reachDprime)]);
reachDprime(goodbye)=[];
reachD=reachDprime;
       stimNum2=[stimNum2,i];
   end
   end
   reachD=reachD+(reachDiff*weightChange)-(fromSet*setChange)+stimChange*fromSet; %could institute punish signal here, but no failed trials
    %attractor to set point
   reachStats2=[reachStats2;[thisReach,mean(reachD)]];
end
sessionData2=[sessionData2,reachStats2(:,1)];
end


%% PLOT RESULTS
figure(456)
[mm1,ss1_1]=semline(sessionData1(1:50,:)',25);
[mm2,ss2_1]=semline(sessionData2(1:50,:)',25);
[mm1,ss1_2]=semline(sessionData1(1:101,:)',25);
[mm2,ss2_2]=semline(sessionData2(51:101,:)',25);
close 456 

%figure(333); hold off
%plot(ss1_1,'g'); hold on
%plot(ss2_1,'r');

[stimR1,b]=hist(stimNum1);
[stimR2,b]=hist(stimNum2);
figure(335);hold off
set(gca,'Box','off')
plot(b,stimR1/reps,'g','LineWidth',4);
hold on
plot(b,stimR2/reps,'r', 'LineWidth',4)
set(gca,'Box','off')
set(gca,'YTick',[0.2 0.4 0.6 0.8 1],'FontSize',16)
set(gca,'XTickLabel',{'10','30','50'},'XTick',[10 30 50],'FontSize',16);
xlabel('Reach # (stim)',  'FontSize',26)
ylabel('Stims (per 5 reaches)',  'FontSize',26)
xlim([1,50])
close(335)
%% TREND FIGURE
figure(336);
subplot(121); hold off
plot([0 50],[0 0],'k--', 'LineWidth', 2.5); hold on
xlim([1,50])
%normalized to initial zero for first 5 trials
[a1,b1]=semline(100*(sessionData1(1:50,:)'-mean(mean(sessionData1(1:15,:)))),10);
[a2,b2]=semline(100*(sessionData2(1:50,:)'-mean(mean(sessionData2(1:15,:)))),10,'r');

%raw
%[a1,b1]=semline(100*sessionData1(1:50,:)',35);
%[a2,b2]=semline(100*sessionData2(1:50,:)',35,'r');

%ylabel('Peak V (au)', 'FontSize',26)
%xlabel('Reach # (stim)',  'FontSize',26)
set(gca, 'YTickLabel',{'-2'  '0' '2' },'YTick',[ -40  0  40  ],'FontSize',26) %was 50 to 2, 25 to 1
set(gca,'XTickLabel',{'10','30','50'},'XTick',[10 30 50],'FontSize',26);
ylim([-60 60])
set(gca,'Box','on')

subplot(122); hold off
plot([0 50],[0 0],'k--', 'LineWidth', 2.5); hold on

%[aa1,bb1]=semline(100*(sessionData1(51:101,:)'),25);
%[aa2,bb2]=semline(100*(sessionData2(51:101,:)'),25,'r');
[aa1,bb1]=semline(100*(sessionData1(51:101,:)'-mean(mean(sessionData1(86:101,:)))),10);
[aaer2,bb2]=semline(100*(sessionData2(51:101,:)'-mean(mean(sessionData2(86:101,:)))),10,'r');

%aa1=aa1-mean(aa1(46:50));
%aa2=aa2-mean(aa2(46:50));

%shadedErrorBar(1:length(aa1), aa1,bb1,'g',1);
%shadedErrorBar(1:length(aa2), aa2,bb2,'r',2);
set(gca,'Box','on')
xlim([1,50])
%xlabel('Reach # (no-stim)',  'FontSize',26)
set(gca,'XTickLabel',{'10','30','50'},'XTick',[10 30 50],'FontSize',26);
set(gca, 'YTickLabel',{'x'},'YTick',[ 120 ],'FontSize',26)
ylim([-60 60])



%without attractor, SEM rises as exp decay (100 reachs = 1, 1000=3, 10000=10 with weight of 1
% figure(333); plot(reachStats(:,1),'k');
 %hold on
  %plot(reachStats(:,1),'m')
  %hold off