function [choicemean] = opal(ad, version, ns, aci)
    %=============================================================
    choices = 2;
    cho = [1,2];
    %=====================================================================
    % aci = 0.1;
    agi = 0.1;
    ani = 0.1;
    bgi = 1;
    bni = 1;
    % func, v, g, n, act, prob1
    vi = 0.5;
    gi = 1;
    ni = 1;
    % acti = 0;
    rewvalue = 1;
    simtot = 1000;%total repetitition
    chs = (ad(:,(6+version)));
    ch = zeros(500*ns,7,choices,simtot);
%     choicemean = zeros(500,ns);
    %====================================================================================
    %===simulation=======================================================================
    %====================================================================================
    i = int32(1);
    for i = 1: simtot%1000 total sim
        for t = 1:500*ns%j = 1:tt%101 including 0 trials
            for c = 1: choices%choices
                    %t = ((r-1)*tt + j);
                if mod(t-1,500)==0 %first trial in every rep or first in general
%                     sigmat = 0;
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
    
%             sm = softmax([ch(t,4,1,i); ch(t,4,2,i)]);%correct softmax
%             ch(t,5,1,i) = sm(1);
%             ch(t,5,2,i) = sm(2);
            pick = pickc([ch(t,4,1,i); ch(t,4,2,i)]);
%             pick = cho(find(rand<cumsum(sm),1,'first'));
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
    choicemean = reshape((sum(ch(:,6,1,:),4)/simtot),500,ns);
end
function [pk]= pickc(ch)%[ch(1,4,1,i); ch(1,4,2,i)]
    pk = (find(rand<cumsum(softmax(ch)),1,'first'));
end