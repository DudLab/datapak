%=============================================================
%SIM OF PROBABALISTIC 2 STATE TASK WITHOUT REACH THRESHOLDS =
%fluid prob shift after x trials test subject has to adapt
cont = 1; each prob separately tested as n(101) trials
%if cont = 2; prob tested successively, one after the other (101*reps) trials
%init = 1; init = 0 choose higher prob side ;init = 1; random 0.5 prob between choice

%=============================================================
choices = 2;
choice = 1;
probstate =1; 1 = incresing prob e.g., 0.1,0.2,0.3... 2= follows prl1
%=====================================================================
prl0 = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
prl1 = [0.1, 0.1, 0.25, 0.25, 0.5, 0.5, 0.75, 0.75, 0.9, 0.9];
prl = [prl0,prl1];
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
inczero = 1;
trials = 100;
reps = 10;%at different probs
simtot = 1000;%total repetitition
shiftstate = 1;
tt = trials + inczero;
st = tt*reps;
ch = cell(simtot,choices);%1000,2 choices
%====================================================================================
%===prob generation==================================================================
%====================================================================================
prob = rand((st)* choices, simtot);% if 2 choices, first 1010rows for choice1 next 1010 for choice 2 etc.
pr = zeros(st,choices);%probability of reward
%first 1000 columns for choice1 next columns.
for i = 1: st
    pr(i,1) = prl(fix((i-1)/(tt)),probstate);
    pr(i,2) = 1-pr(i,1);
end
%====================================================================================
%===simulation=======================================================================
%====================================================================================

for i = 1: simtot%1000 total sim
    for r = 1:reps% 10 different probabilities (10 if probstate = 0)
        for j = 1:tt%101 including 0 trials
            t = ((r-1)*tt + j);
            tiebreaker = randi(choices);
            for c = 1: choices%choices
				%t = ((r-1)*tt + j);
				if (j == 1 && cont == 1) || t == 1%first trial in every rep or first in general
                    sigmat = 0;
                    ch{i,c}(t,1) = vi;
                    ch{i,c}(t,2) = gi;
                    ch{i,c}(t,3) = ni;
                    ch{i,c}(t,4) = bgi*ch{i,c}(t,2)-bni*ch{i,c}(t,3);
                else
                    sigmat = (ch{i,c}(j-1,7) - ch{i,c}(t-1,1));%sigmat = r(t-1)-v(t-1)
                    ch{i,c}(t,1) = ch{i,c}(t-1,1) + aci*sigmat;%v(t) = v(t-1) + ac*sigmat
                    ch{i,c}(t,2) = ch{i,c}(t-1,2) + agi*sigmat*ch{i,c}(t-1,2);%g(t) = g(t-1) + ag*g(t-1)*sigmat
                    ch{i,c}(t,3) = ch{i,c}(t-1,3) + (-1*)agi*sigmat*ch{i,c}(t-1,3);n(t) = n(t-1) + an*n(t-1)*sigmat
                    ch{i,c}(t,4) = bgi*ch{i,c}(t,2)-bni*ch{i,c}(t,3);%act(t) = bg*g(t) - bn*n(t)
                end
            end
            for c = 1: choices
                if (j == 1 && cont == 1) || t == 1 || (all(ch{i,1:choices}(t,4)) == ch{i,1}(t,4))
                    ch{i,c}(t,5)= 1/choices;
                    if c == tiebreaker
                        ch{i,c}(t,6) = 1;
                    else
                        ch{i,c}(t,6) = 0;
                    end
                else
                    ch{i,c}(t,5) = (exp(ch{i,c}(t,4)))/exp(sum(ch{i,1:choices}(t,4)));
                end
            end
            %picks choice with highest softmax prob
            [M,I] = max(ch{i,1;choices}(t,5));
            %I %CHECK
            for c = 1: choices
                if c == I
                    ch{i,c}(t,6) = 1;
                    if prob(j+((c-1)*simtot),i) <= pl(j,c)
                        ch{i,c}(t,7) = rewvalue;
                    else
                        ch{i,c}(t,7) = 0;
                    end
                else
                    ch{i,c}(t,6) = 0;
                    ch{i,c}(t,7) = 0;
                end
            end
        end
    end
end
%====================================================================================
GRAPHING
%====================================================================================
for i = 1: choices


end
