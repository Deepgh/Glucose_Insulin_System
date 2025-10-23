function out = Ultradian(t,y)
global E Vp Vi Vg tp ti td Rm Rg C1 C2 C3 C4 C5 a1 Ub U0 Um a b G K 
kappa = (1/C4)*((1/Vi)-(1/(ti*E)));
f1 = @(x) Rm/(1 + exp((-x/(Vg*C1))+a1));
f2 = @(x) Ub*(1 - exp((-x/(C2*Vg))));
f3 = @(x) (1/(C3*Vg))*(U0 + ((Um - U0)/(1 + (kappa*x)^(-b))));
f4 = @(x) Rg/(1+exp(a*((x/(C5*Vp))-1)));
IG = @(x) G;%*(heaviside(x-360)-heaviside(x-360-K)+heaviside(x-720)-heaviside(x-720-K)+heaviside(x-1080)-heaviside(1080-K));%1000/60*(m1*k*exp(-k*x));%+ heaviside(x-720)*m2*k*exp(k*(720-x)) + heaviside(x-1080)*k*m3*exp(k*(1080-x)));

out = [f1(y(3))-E*((y(1)/Vp)-(y(2)/Vi))-(y(1)/tp);
    E*((y(1)/Vp)-(y(2)/Vi))-(y(2)/ti);
    f4(y(6))+IG(t)-f2(y(3))-f3(y(2))*y(3);
    (1/td)*(y(1)-y(4));(1/td)*(y(4)-y(5));
    (1/td)*(y(5)-y(6))];
end