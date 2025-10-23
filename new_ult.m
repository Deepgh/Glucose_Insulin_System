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
k  = 0.5;
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

TT = 1:100;%interkick times
%TT = 20;
Y = length(TT);
d0 = 1E-8;
%AA = [100,500,1000];

%AA = 1000:1000:30000;

%Y = length(AA);
N = 10;%no of iterations

LL = zeros(Y,1);%avg lya exp for each inter kick time


for jj = 1:Y%can it be 0?
    jj
T = TT(jj); %?

lya = zeros(N-1,1);%store indivaul lya exp%why n-1?
%td = TD(jj);
y11_init = 0;
y12_init = 0;
y13_init = 0;
y14_init = 0;
y15_init = 0;
y16_init = 0;

y21_init = 0;
y22_init = d0;
y23_init = 0;
y24_init = 0;
y25_init = 0;
y26_init = 0;


for kk = 2:N%why?
    ll = -log(rand(1,1))*T;
    %ll = T;
    [t1,y1] = ode23s(@Ultradian,[0 ll],[y11_init;y12_init;y13_init;y14_init;y15_init;y16_init]);
    [t2,y2] = ode23s(@Ultradian,[0 ll],[y21_init;y22_init;y23_init;y24_init;y25_init;y26_init]);
    
     y1(end,2) = y1(end,2) ;
     y2(end,2) = y2(end,2) ;
     
    d = sqrt((y1(end,1)-y2(end,1))^2 + (y1(end,2)-y2(end,2))^2 + (y1(end,3)-y2(end,3))^2 + (y1(end,4)-y2(end,4))^2 + (y1(end,5)-y2(end,5))^2 + (y1(end,6)-y2(end,6))^2);
    lya(kk-1) = log(d/d0);%why kk-1?&log or ln?
    
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
T = table(time, LL) 
% Write data to text file
writetable(T, 'abc.txt')
type 'abc.txt'

figure(1)
plot(TT,LL,'ro','MarkerSize',5,'MarkerFaceColor','r')
xlabel('T')
ylabel('\Lambda_{max}')
set(gca,'fontsize',20)