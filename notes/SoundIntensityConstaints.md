A theoretical result on what must be done to conserve observed sound signal intensity can inform out experimentation. 

We'll use $R$ to denote the distance between the two flies, and $r_m$ to denote the distance from a fly to a microphone.

From physics, $I = k\frac{P(R)}{R^2}$. Because of the dependence of $P$ on $R$, we can differentiate wrt to $R$ and observe conservation of intensity, $\frac{d}{dR}I = 0$, when $P \ne 0$ .
$$
\frac{d}{dR}I = k\frac{P'(R)}{R^2} -2k\frac{P(R)}{R^3} =0
$$
this comes to a differential equation
$$
\frac{dP}{dR} = 2\frac{P(R)}{R}
$$
whose solution is 
$$
P(R) \propto CR^2
$$
Equation (3) must hold if intensity is to be conserved. 

Now suppose there is some optimal intensity for fly communication call it $I_{opt}$. If two flies are of distance $R$ apart, the pressure at that distance is be $P(r) = I_ {opt}\frac{^2R}{k}$. If we can get the pressure at that point to have the given intensity then intensity is conserved. Well pressure drops off $P \propto 1/R$. So we have 
$$
P = \frac{P_0}{R} = kI_{opt}R^2
$$
yielding explicitly
$$
P_{0, opt} = kI_{opt}R^3
$$
Checking equation (3) confirms equation (5) does in fact make sense. 

We are not done yet, however, as we must still calculate actual $P_0$ from observed intensity. If the microphone is at distance $r_m$ from the fly, then $I_{observed} = k\frac{P_0}{r_m^2}$, yielding 
$$
P_{0, observed} \propto  I_{observed}r_m^2
$$
We should then expect $P_{0, observed} \propto R^3 \propto  I_{observed}r_m^2$ if our assumptions are correct. It would be instructive if they are not correct and will give us insight into what the fly is actually doing. 

We shall now try to demonstrate this empirically. 