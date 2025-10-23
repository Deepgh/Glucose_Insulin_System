 clear;

format long

global E Vp Vi Vg tp ti td Rm Rg C1 C2 C3 C4 C5 k a1 Ub U0 Um a b G K 
Vp = 3;
Vi = 11;
Vg = 10;
E  = .2;
tp = 6;
ti = 100;
td = 12;
%k  = 0.5;
Rm = 209;
a1 = 6.6;
C1 = 300;
C2 = 144;
C3 = 100;
C4 = 80;
C5 = 26;
Ub = 72;
U0 = 4;
Um = 94;
Rg = 180;
a  = 7.5;
b  = 1.772;
G = 0;
%K = 15;

%NN = 200;
TT = 1:100;%interkick times
%TT = 20;
Y = length(TT);
d0 = 1E-8;
%AA = [100,500,1000];

%AA = 1000:1000:30000;

%Y = length(AA);
N = 10;%no of iterations

LL = zeros(Y,1);%avg lya exp for each inter kick time

% = zeros(N-1,Y);

states = ["Low","Medium","High"];
%[100,500,5000]

% Possiblible sequences of events
transitionName = ["LL" "LM" "LH"; "ML" "MM" "MH"; "HL" "HM" "HH"];

%Probabilities matrix (transition matrix)
transitionmatrix = [0.6 0.1 0.3; 0.55 0.1 0.35; 0.5 0.3 0.2];

% A function that implements the Markov model to forecast the state/mood.
% Choose the starting state
%activitylist=zeros(1,1000);
%B=zeros(1,1000);
%Initializing state
activityToday = "Low";

% Shall store the sequence of states taken. So, this only has the starting state for now.
activitylist = [activityToday];
%B=[100];


for i=1:10
    if activityToday == "Low"
        change = randsample(["LL" "LM" "LH"],1,true,[0.6 0.1 0.3]);
        if change == "LL"
            activitylist(i)="Low";
            B(i)=200;
        elseif change == "LM" 
            activityToday = "Medium";
            activitylist(i)="Medium";
            B(i)=1000;
        else
            activityToday = "High";
            activitylist(i)="High";
            B(i)=5000;
        end
    elseif activityToday == "Medium"
        change = randsample(["ML" "MM" "MH";],1,true,[0.55 0.1 0.35]);
        if change == "MM"
            activitylist(i)="Medium";
            B(i)=1000;
        elseif change == "ML"
            activityToday = "Low";
            activitylist(i)="Low";
            B(i)=200;
        else
            activityToday = "High";
            activitylist(i)="High";
            B(i)=5000;
        end
    elseif activityToday == "High"
        change = randsample(["HL" "HM" "HH"],1,true,[0.5 0.3 0.2]);
        if change == "HH"
            activitylist(i)="High";
            B(i)=5000;   
        elseif change == "HL"
            activityToday = "Low";
            activitylist(i)="Low";
            B(i)=200;
        else
            activityToday = "Medium";
            activitylist(i)="Medium";
            B(i)=1000;
        end
    end 
end
%     B
%     activitylist
    

for jj = 1:Y%can it be 0?
    jj
T = TT(jj); %?
%T = TT;
%v = VV(jj);
%G = AA(jj);%AA;
%Randomly selected A from a list with equal probability
%pos = randi(length(AA));
%A = AA(pos);
   % A
%Select A from a distribution
%A = unifrnd(0,1)*5000;


lya = zeros(N-1,1);%store indivaul lya exp%why n-1?
%td = TD(jj);
y11_init = 0;
y12_init = 0;
y13_init = 0;
y14_init = 0;
y15_init = 0;
y16_init = 0;

y21_init = 0;
y22_init = 0;
y23_init = d0;
y24_init = 0;
y25_init = 0;
y26_init = 0;


%for kk = 2:N %why?
for kk=1:10
    
    ll = -log(rand(1,1))*T;%exp interkick times
    %ll = T; %periodic interkick times
    B(kk)
    
    [t1,y1] = ode23s(@Ultradian,[0 ll],[y11_init;y12_init;y13_init;y14_init;y15_init;y16_init]);
    [t2,y2] = ode23s(@Ultradian,[0 ll],[y21_init;y22_init;y23_init;y24_init;y25_init;y26_init]);
    
    %[t1,y1] = ode23s(@Ultradian,[(kk-1)*ll kk*ll],[y11_init;y12_init;y13_init;y14_init;y15_init;y16_init]);
    %[t2,y2] = ode23s(@Ultradian,[(kk-1)*ll kk*ll],[y21_init;y22_init;y23_init;y24_init;y25_init;y26_init]);
    
    y1(end,3) = y1(end,3) ;
    y2(end,3) = y2(end,3) ;
     
    d = sqrt((y1(end,1)-y2(end,1))^2 + (y1(end,2)-y2(end,2))^2 + (y1(end,3)-y2(end,3))^2 + (y1(end,4)-y2(end,4))^2 + (y1(end,5)-y2(end,5))^2 + (y1(end,6)-y2(end,6))^2);
    lya(kk) = log(d/d0);
    
    y21new = y1(end,1) + (d0/d)*(y2(end,1)-y1(end,1));
    y22new = y1(end,2) + (d0/d)*(y2(end,2)-y1(end,2));
    y23new = y1(end,3) + (d0/d)*(y2(end,3)-y1(end,3));
    y24new = y1(end,4) + (d0/d)*(y2(end,4)-y1(end,4)); 
    y25new = y1(end,5) + (d0/d)*(y2(end,5)-y1(end,5)); 
    y26new = y1(end,6) + (d0/d)*(y2(end,6)-y1(end,6)); 
    
    y11_init = y1(end,1);
    y12_init = y1(end,2);
    y13_init = y1(end,3);
    y14_init = y1(end,4);
    y15_init = y1(end,5);
    y16_init = y1(end,6);

    y21_init = y21new;
    y22_init = y22new;
    y23_init = y23new;
    y24_init = y24new;
    y25_init = y25new;
    y26_init = y26new;
    
end

LL(jj) = mean(lya);
    
end

time=transpose(TT);

% Create a table with the data and variable names
% T = table(time, LL) 
% % Write data to text file
% writetable(T, 'insulin_inter_10.txt')
% type 'insulin_inter_10.txt'

figure(1)
plot(TT,LL,'ro','MarkerSize',5,'MarkerFaceColor','r')
xlabel('T')
ylabel('\Lambda_{max}')
set(gca,'fontsize',20)