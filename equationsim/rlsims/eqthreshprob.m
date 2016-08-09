%=============================================================
%REQUIRES DATA GENERATION FROM OTHER FILE

%=============================================================
choices = 2;
cho = [1,2]
choice = 1;
probstate =1; %1 = incresing prob e.g., 0.1,0.2,0.3... 2= follows prl1
%=====================================================================
aci = 0.1;
agi = 0.1;
ani = 0.1;
bgi = 1;
bni = 1;
% func, v, g, n, act, prob1
vi = 0.5;
gi = 1;
ni = 1;
acti = 0;
rewvalue = 1;
inczero = 0;
trials = 50;
subji = 1;
prs = ad(diff([ad(:,5,subji)' 0])~=0,5);%prob subject
chs = (ad(:,(6+version),subji));
cls = (ad(:,(6+version),subji)==1);
crs = (ad(:,(6+version),subji)==2);
xs1 = [(ad(:,4,subji)==2),(ad(:,4,subji)==1),cls,crs];
ccs = reshape((ad(:,(6+version),subji)==1),1,size(ad,1));
reps = length(prs);
%at different probs
simtot = 1000;%total repetitition
tt = trials + inczero;
st = tt*reps;
% ch = cell(simtot);%1000,2 choices
ch = zeros(st,7,choices,simtot);
sm = zeros(st,choices,simtot);
color = varycolor(reps);
%====================================================================================
%===simulation=======================================================================
%====================================================================================

for i = 1: simtot%1000 total sim
    for r = 1:reps% 10 different probabilities (10 if probstate = 0)
        for j = 1:tt%101 including 0 trials
            t = ((r-1)*tt + j);
            for c = 1: choices%choices
                %t = ((r-1)*tt + j);
               if t ==1 %first trial in every rep or first in general
                    sigmat = 0;
                    ch(t,1,c,i) = vi;
                    ch(t,2,c,i) = gi;
                    ch(t,3,c,i) = ni;
                    ch(t,4,c,i) = bgi*ch(t,2,c,i)-bni*ch(t,3,c,i);
                else
                    sigmat = (ch(t-1,7,c,i) - ch(t-1,1,c,i));%sigmat = r(t-1)-v(t-1)
                    ch(t,1,c,i) = ch(t-1,1,c,i) + aci*sigmat;%v(t) = v(t-1) + ac*sigmat
                    ch(t,2,c,i) = ch(t-1,2,c,i) + agi*sigmat*ch(t-1,2,c,i);%g(t) = g(t-1) + ag*g(t-1)*sigmat
                    ch(t,3,c,i) = ch(t-1,3,c,i) + (-1)*ani*sigmat*ch(t-1,3,c,i); %n(t) = n(t-1) + an*n(t-1)*sigmat
                    ch(t,4,c,i) = bgi*ch(t,2,c,i)-bni*ch(t,3,c,i);%act(t) = bg*g(t) - bn*n(t)
                end
            end
%====================================================================================
% DEFINE A SOFTMAX RULE
%====================================================================================
            sm = softmax([ch(t,4,1,i),ch(t,4,2,i)]');%correct softmax
            ch(t,5,1,i) = sm(1);
            ch(t,5,2,i) = sm(2);
            pick = cho(find(rand<cumsum(sm),1,'first'));
            for c = 1: choices
                if c == pick
                    ch(t,6,c,i) = 1;
                    if c == chs(t)
                        ch(t,7,c,i) = rewvalue;
                    else
                        ch(t,7,c,i) = 0;
                    end
                else
                    ch(t,6,c,i) = 0;
                    ch(t,7,c,i) = 0;
                end
            end
        end
    end
end
%====================================================================================
% GRAPHING
%====================================================================================
avg = sum(ch,4)/simtot;
choicemean = avg(:,6,1);
figure(9)
    hold all
    (shade(xs1,0,hv, ht, col,lt));
        avgval = 20;
        plot(moveavg(ccs,avgval), 'c');%
        plot(moveavg(pta(subji,:),avgval),'k');
        plot(1:length(choicemean),choicemean,'r');
        l = legend(['reach' num2str(halfac(1,subji))],' ',['reach' num2str(halfac(2,subji))],' ','Reward target: left', ' ', 'Reward target: right' ,'', ...
            'P(reward|left) moving avg','Choice moving avg', ['OPAL, ac =' num2str(aci)]);
        l.FontSize = 16;
        xlabel('Trials');
        ylabel('Probability');
        xlim([0, size(ad,1)]);
        ylim([-0.2,1.3]);
        ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
        t = text(0.5, 1,['P(choose L) over time, usr' num2str(subji) ',movavg= ' num2str(avgval) ' trials'],'HorizontalAlignment' ...
        ,'center','VerticalAlignment', 'top');
        t.FontSize = 22;
      