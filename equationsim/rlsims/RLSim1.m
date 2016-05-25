%OPAL sim BH
rewardstate = 1;%0 =constant0reward, 1= varying based probabalistically 
shiftstate = 0;
choicestate = 0;
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
simtot = 1000;%total repetiti
reps = 11;%at different probs
shiftstate = 1;
pp = []; %probability picking
pl = [];
tf = [];
tt = trials + inczero;
st = (tt)*reps; %number of trials per session
cho = 1; %choices (n of solid state action pairs);


%===========================
%===generate structurnumel(f1es=====
%===========================
f1 = cell(simtot,1);%1000,1
f2 = cell(simtot,1);%1000,1
sft = cell(simtot, (tt));
field1 = 'f1'; value1 = f1;
field2 = 'f2'; value2 = f2;
% sim = struc('f1', value1, 'f2', value2);

%=======================
%===prob generation=====
%=======================
probR = rand((st), simtot);%prob for comparing against P(R)
pp = rand((st), simtot);%prob for comparing against P(pick)
pl = zeros(st,1);%probability of reward
for i = 1: st
    pl(i) = (fix((i-1)/(tt)))*0.1;
end

%SIM=======================
%-------------

for i = 1:simtot%for each sim
%     t = 1;
    shiftstate = 1;% check
    for j = 1:st
%     d=[];
    t = j-tt*(shiftstate-1);
%         try
        
        if mod(j,tt)== 0 & j>1%mod(((fix(j-1)/(tt))*0.1),1)
            shiftstate = shiftstate + 1;
%             t = 1;
        end
        if t == 1
            sigmat = 0;
            f1{i,1}(j,1) = vi;
            f1{i,1}(j,2) = gi;
            f1{i,1}(j,3) = ni;
            f1{i,1}(j,4) = bgi*f1{i,1}(j,2)-bni*f1{i,1}(j,3);
            sft{i,shiftstate}(t,1) = f1{i,1}(j,4);
            if choicestate == 0
                f1{i,1}(j,5) = 1;
            end
            f1{i,1}(j,6) = 1;
            
            if probR(j,i) <= pl(j)
                f1{i,1}(j,7) = rewvalue;
            else
                f1{i,1}(j,7) = 0;
            end
        else
            sigmat = (f1{i,1}(j-1,7)- f1{i,1}(j-1,1));%sigmat = r(t-1)-v(t-1)sigmat = (f1{i,1}(j-1,7)- f1{i,1}(j-1,1));
            f1{i,1}(j,1) = f1{i,1}(j-1,1) + aci*(sigmat);%v(t) = v(t-1) + ac*sigmat
            f1{i,1}(j,2) = f1{i,1}(j-1,2) + agi*(sigmat)*(f1{i,1}(j-1,2));%g(t) = g(t-1) + ag*g(t-1)*sigmat
            f1{i,1}(j,3) = f1{i,1}(j-1,3) + ani*(-1*sigmat)*(f1{i,1}(j-1,3));%n(t) = n(t-1) + an*n(t-1)*sigmat
            f1{i,1}(j,4) = (bgi*f1{i,1}(j,2)) - (bni*f1{i,1}(j,3));%act(t) = bg*g(t) - bn*n(t)
            sft{i,shiftstate}(t,1) = f1{i,1}(j,4);%
%             d = softmax(sft{i,shiftstate});%softmax act(t)
            if choicestate == 0
                f1{i,1}(j,5) = 1;
            else    
                f1{i,1}(j,5) = d(t,1);%softmax act(t)
            end
            if pp(j,i) <= f1{i,1}(j,5)%picks the choice
                f1{i,1}(j,6) = 1;%act or not
                if rewardstate == 0
                    f1{i,1}(j,7) = rewvalue;
                end
                if rewardstate == 1
                    if probR(j,i) <= pl(j)
                        f1{i,1}(j,7) = rewvalue;
                    else
                        f1{i,1}(j,7) = 0;
                    end
                end
            else
                if rewardstate == 0
                    f1{i,1}(j,6) = 0;
                    f1{i,1}(j,7) = rewvalue;
                end
                if rewardstate == 1 
                    f1{i,1}(j,6) = 0;
                    f1{i,1}(j,7) = 0;
                end
            end
        end
    end
end
% ===========================
% graph
% ===========================
avg = [];

for i = 1:st
    avg = sum(cat(3,f1{:}),3)/simtot;
end
fv = reshape(avg(:,1),101,11);
fg = reshape(avg(:,2),101,11);
fn = reshape(avg(:,3),101,11);
fact = reshape(avg(:,4),101,11);
% fv = reshape(avg(:,1),101,11);
% fv = reshape(avg(:,1),101,11);
figure(1);
    subplot(4,2,1);
    plot(0:length(fv)-1,fv);
    title(['V(r=' num2str(rewvalue) ', p, increasing)']);

    subplot(4,2,2);
    plot(0:length(fg)-1,fg);
    title(['G(r=' num2str(rewvalue) ', p, increasing)']);

    subplot(4,2,3);
    plot(0:length(fn)-1,fn);
    title(['N(r=' num2str(rewvalue) ', p, increasing)']);

    subplot(4,2,4);
    plot(0:length(fact)-1,fact);
    title(['Act(r=' num2str(rewvalue) ', p, increasing)']);
    xlabel('time');