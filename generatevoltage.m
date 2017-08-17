function V = generatevoltage(p,T,Vreset,Vthresh,V0)

V = zeros(1,T);
V(1) = V0;
for t = 1:T-1
    if V(t) == Vthresh
        V(t+1) = Vreset;
    else
        dV = ((rand(1)<p)-0.5)*2;
        V(t+1) = V(t) + dV;
    end
    if V(t+1) > Vthresh
        V(t+1) = Vthresh;
    end
end