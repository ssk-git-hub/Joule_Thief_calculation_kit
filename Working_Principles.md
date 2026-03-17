# Working Principles of Joule Thief Converters

[简体中文](Working_Principles_zh.md)

### How does it work?
![Circuit Diagram](Images/circuit_diagram_BJT.png)
As shown in the circuit diagram above, the Joule Thief alternates between two main states: the "Turn-on" phase and the "Turn-off" phase. The circuit relies on the mutual inductance between the primary coil ($L_1$) and the secondary coil ($L_2$) of the transformer to form a positive feedback loop.

#### (a) Turn-on phase
When the power source ($V_{\text{oc}}$) is connected, a small current initially flows into the control terminal (the Base of the BJT or the Gate of an NMOS) through $L_2$, slightly turning on the transistor switch. This allows current ($i_1$) to start flowing from the power source through the primary coil ($L_1$) into the collector/drain of the switch.

As $i_1$ increases, the changing magnetic field formed in $L_1$ induces a positive voltage ($V_{L2}$) in the secondary coil $L_2$ due to the dot convention of the transformer. This induced voltage adds to the input voltage, significantly raising the voltage at the control terminal (and injecting base current for a BJT). This forms a **positive feedback loop**: more primary current $\rightarrow$ higher induced secondary voltage $\rightarrow$ stronger switch turn-on $\rightarrow$ even more primary current. Then, the switch is driven into a strong conduction state, and the primary coil stores energy in its magnetic field as $i_1$ ramps up. The diode remains reverse-biased blocking the output voltage from discharging backwards. 

Some popular explanations suggest that self-oscillation is achieved through inductor saturation. I believe this is inaccurate because the saturation current of an inductor is typically much greater than the current at which a semiconductor switch reaches saturation.

#### (b) Turn-off phase
As $i_1$ continues to increase, its growth rate ($\mathrm{d}i_1/\mathrm{d}t$) gradually decreases and approaches zero due to the transistor's specific current-voltage characteristics constrained by the circuit (e.g., the BJT approaching saturation). According to Faraday's law of induction ($V = L \cdot \mathrm{d}i/\mathrm{d}t$), the induced voltage $V_{L2}$ drops as well. This reduces the base/gate drive, which pulls the transistor out of its strong conduction state, further reducing $i_1$. This triggers the **reverse positive feedback loop**: $i_1$ begins to decrease ($\mathrm{d}i_1/\mathrm{d}t < 0$) $\rightarrow$ $V_{L2}$ flips to negative $\rightarrow$ switch rapidly turns off completely.

With the switch completely turned "Off" (as seen in Figure b), the current $i_1$ through $L_1$ cannot instantly disappear. Instead, the inductor creates a massive positive voltage spike to force the current to keep flowing. This high voltage forward-biases the diode, releasing the stored magnetic energy from $L_1$ into the output capacitor ($C_L$) and the load ($R_L$). Once the magnetic energy is completely transferred via the diode current ($i_D$), $i_1$ drops to zero, reopening the path for base/gate current, and the "Turn-on" phase begins again.

In our paper, we performed detailed mathematical modeling for Joule Thief circuits based on BJT and NMOS, and provided closed-form analytical solutions, allowing their performance to be directly predicted through theory (such as output voltage and oscillation frequency). I have also provided MATLAB and Python code to help you with the calculations; you only need to input your circuit parameters.

Even if you do not need to perform calculations, I also suggest that you carefully follow the analysis and derivation in the paper once (it is not complicated and only requires a little bit of calculus and power electronics modeling knowledge) to gain a deeper understanding of this circuit.

### Limitations of the theory
The analytical models above are completed based on a series of assumptions, among which the idealized boundary condition $i_1(0)=0$ will lead to larger deviations at higher load $R_L$ (for example, greater than 100k ohm). Therefore, in such situations, please design in combination with simulations.

In addition, for BJT, three parameters $\beta_F$, $\beta_R$, and $I_S$ are required, which you can extract from the SPICE model provided by the manufacturer. However, the $\beta_F$ cannot always be directly applied in the calculation; you need to perform a calibration based on experimental results (or simulation results) because actual BJTs experience reduced gain at high currents due to the high-injection effect. It is also recommended to calibrate $\beta_n$ for the NMOS.

### Useful rules of thumb
Assuming the power supply voltage is 1V, for the BJT, the maximum conversion efficiency is around 70-80%. If a low-threshold NMOS is used, the maximum conversion efficiency can reach over 90%.

This circuit is actually not very sensitive to the inductance value of the transformer. 1mH is a common value. If the internal resistance of the power supply is low, reducing it to 100uH or even lower is also acceptable (which may lead to an output voltage drop of about 10%). The turns ratio is an important parameter that can directly change the output voltage magnitude, and it can be optimized according to your own needs.

The selection of the semiconductor switch is also quite important. If low cost is preferred, a BJT can be used (while adding a 1-10k ohm resistor at the base terminal), but the power supply voltage must be at least 0.7V or higher to operate. If high conversion efficiency is preferred, it is recommended to use a low-threshold NMOS ($V_{th} < 0.5V$) while ensuring that the $R_{ds(on)}$ and gate capacitance are small. If low-voltage start-up is preferred, a zero-threshold NMOS is recommended. After integration using CMOS, the performance will be further improved. Additionally, it is recommended to use a Schottky diode, which has a forward voltage drop of about $0.2$ to $0.3\text{V}$, lower than the $0.7\text{V}$ of a standard silicon diode, thereby helping to increase the output voltage.

It should be noted that when the Joule Thief is working, both the gate and drain terminals of the NMOS will withstand very large voltage spikes (significantly larger than $V_{out}$). This high voltage can easily exceed the maximum rating of the transistor and cause permanent damage, such as gate oxide breakdown. Therefore, I only recommend attempting low voltage applications (output voltage not higher than 5V). When experimenting, please carefully check your device's datasheet and be aware of circuit safety risks.
