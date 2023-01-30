function y = em_Liley(t, params)
he_rest=params(1);
hi_rest=params(2);
Nee_beta=params(3);
Nei_beta=params(4);
Nie_beta=params(5);
Nii_beta=params(6);
Gamma_e=params(7);
Gamma_i=params(8);
gamma_e=params(9);
gamma_i=params(10);
Tau_e=params(11);
Tau_i=params(12);
Se_max=params(13);
Si_max=params(14);
mu_e=params(15);
mu_i=params(16);
sigma_e=params(17);
sigma_i=params(18);
he_eq=params(19);
hi_eq=params(20);
pee=params(21);
pei=params(22);
pie=0;
pii=0;
ss=params(25);
dt=t(2)-t(1);


Se=@(input_e)((Se_max)./(1+exp(-sqrt(2)*(input_e-mu_e)/(sigma_e))));
Si=@(input_i)((Si_max)./(1+exp(-sqrt(2)*(input_i-mu_i)/(sigma_i))));

N = length(t);
dW = randn(1,N)*sqrt(dt)*ss*Gamma_e*gamma_e*exp(1);

% combine params
gammae1 = (gamma_e^2);
gammae2 = Gamma_e*gamma_e*exp(1);
gammae3 = -2*gamma_e;
gammai1 = gamma_i^2;
gammai2 = Gamma_i*gamma_i*exp(1);
gammai3 = -2*gamma_i;
abs1 = abs(he_eq-he_rest);
abs2 = abs(hi_eq-he_rest);
abs3 = abs(he_eq-hi_rest);
abs4 = abs(hi_eq-hi_rest);
te = (1/Tau_e);
ti = (1/Tau_i);

% Define RHS
f=@(y)([te*(he_rest-y(1)+y(3).*((he_eq-y(1))./abs1)+y(7).*((hi_eq-y(1))./abs2));...
ti*(hi_rest-y(2)+y(5).*((he_eq-y(2))./abs3)+y(9).*((hi_eq-y(2))./abs4));...
y(4);...
(gammae3*y(4)-gammae1*y(3)+(gammae2*Nee_beta).*Se(y(1))+gammae2*(pee));...
y(6);...
(gammae3*y(6)-gammae1*y(5)+(gammae2*Nei_beta).*Se(y(1))+gammae2*(pei));...
y(8);...
(gammai3*y(8)-gammai1*y(7)+(gammai2*Nie_beta).*Si(y(2))+gammai2*(pie));...
y(10);...
(gammai3*y(10)-gammai1*y(9)+(gammai2*Nii_beta).*Si(y(2))+gammai2*(pii))]);
y=zeros(10,length(t));
y(:,1)=params(26:end)';

for ii=2:N
    y(:,ii)=y(:,ii-1)+dt*f(y(:,ii-1));
    y(4,ii) =  y(4,ii)+ dW(ii);
end
end
    
    