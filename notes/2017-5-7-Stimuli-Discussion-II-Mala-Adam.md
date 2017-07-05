The first closed loop experiment that will be run will use natural data for azimuthal movement and looming in closed loop. The best way to design the closed loop system is to write it down very explicitly mathematically and then implement these equations in MATLAB. The bad way to this is to invent the equations in a more hacky way as you do the coding.

Suppose $\mathbf{M}, \mathbf{F}$ are the actual positions of the male and female flies respectively and $\tilde{F}$ is the computed position of the female fly. We want to derive a 1-lag autoregressive control system for the position of the female fly in response to the movement of the male.

$$
\tilde{F}_{x}(t+1) = F_{x}(t+1)\\
$$

$$
\tilde{F}_{y}(t+1)=\text{bounded}\bigg(\tilde{F}_y(t)+\Delta t\frac{\alpha\dot{M}_y}{\tilde{F}_y-M_y} +\zeta\bigg)
$$

where $\text{bounded}$ is a filter on the position of the female to keep the position of the female bounded

$$
\text{bounded}(y) =
\begin{cases}
y,& \text{if } y \in [\min y, \max y]\\
y_\text{min} ,&\text{if } t<\min y\\
y_\text{max},&\text{if } y>\max y\\
\end{cases}
$$

Equation (1) is saying that the position of the female updates such that the female moves in a direction opposite the male with magnitude inversely proportional to the distance between them. We add $\zeta$ gaussian noise for realistic jitter.

We can rewrite these equations for polar coordinates:

$$
\tilde{F}_{\theta}(t+1) = F_{\theta}(t+1)\\
$$

$$
\tilde{F}_{r}(t+1)=\text{bounded}\bigg(\tilde{F}_r(t)+\Delta t\frac{\alpha\dot{M}_r}{\tilde{F}_r-M_r} +\zeta\bigg)
$$
