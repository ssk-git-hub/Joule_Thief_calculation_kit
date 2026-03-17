# Open Source Calculation Code for Joule Thief Converter

[简体中文](README_zh.md)

This repository provides the open-source calculation code (MATLAB and Python) and SPICE simulation files for [Joule Thief](https://en.wikipedia.org/wiki/Joule_thief) converters detailed in our IEEE Transactions on Industrial Electronics (TIE) paper. It is designed to help researchers and engineers calculate performance and explore parameters based on our analytical models. If you have any questions about the repository, feel free to submit an issue to me.

### What is a Joule Thief circuit?
For non-technical people: It allows a lower DC input voltage to be converted into a higher DC output voltage. Its structure is very simple, requiring only a semiconductor switch, a transformer, a diode, a filter capacitor, and a load.

For technical experts: It is a self-oscillating boost converter that operates in boundary conduction mode. It belongs to a type of blocking oscillator, and its earliest origins may date back nearly 100 years to when vacuum tubes were still in use. As far as I know, the 1999 article "One volt LED--A bright light" in the magazine Everyday Practical Electronics made this circuit popular among the public.

### What is it used for?
For non-technical people: Its cost is extremely low and it is easy to build, making it very popular in the DIY community. It is also suitable as an educational circuit project for students. A common demonstration is to connect a battery that is considered dead to a joule thief, thereby lighting up a 1.5V LED.

For technical experts: Due to its very low component count, it is highly suitable for ultra-low power power management circuits, especially for power sources with relatively high internal impedance. As shown in our paper, when paired with a zero-threshold voltage NMOS and facing a source internal resistance of 300 ohms, it can start up at a mere 50mV voltage. This powerful cold-start capability gives it huge potential in the field of ultra-low voltage energy harvesting. 

In summary, this is a very simple circuit (more interesting than you thought before), and its capabilities are currently underestimated. 

Our results have been published in the renowned power electronics journal IEEE Transactions on Industrial Electronics. There are still many potential applications in the future, and we welcome everyone to continue digging deeper. We have open-sourced its calculation code, hoping to facilitate further research by other engineers or scholars.

### Using the Calculation Code
We provide analytical calculation scripts for both BJT and NMOS based circuits, implemented in MATLAB and Python. You only need to input your circuit parameters (such as open-circuit voltage $V_{oc}$, source internal resistance $R_{in}$, primary inductance $L_1$, turns ratio $a$, along with specific transistor/diode static parameters). The code will directly output the predicted steady-state performance metrics:
- Output voltage across the load ($V_{out}$)
- Switching frequency ($freq$)
- Power conversion efficiency ($eff$)

We have included ready-to-run parameter examples for specific hardware models (such as BJT SMMBT3904LT1G and NMOS SiUD412ED) inside the source code to help you get started immediately.

### Regarding Simulation Files
I have provided LTSPICE (free to use) simulation files as a reference. You can replace the components in them through custom configuration or use the SPICE models from the manufacturers. For specific designs, I recommend using the theory for rapid parameter exploration first, and then combining it with simulations to observe the waveforms and verify the performance.

![LTSpice simulation](Images/LTSpice_simulation.png)

### Working Principles
If you are interested in how it works (including detailed circuit analysis, limitations of the theory, and useful rules of thumb), please read our **[Working Principles](Working_Principles.md)** document or refer to our IEEE TIE paper.

### Citation
If you find the above information helpful, please cite our paper:

> S. Su and S. Aunet, "Self-Oscillating Joule Thief Converters for MEMS Electromagnetic Energy Harvesting: Analytical Modeling and Experimental Validation," in IEEE Transactions on Industrial Electronics, doi: 10.1109/TIE.2026.3663767.
> 
> https://ieeexplore.ieee.org/document/11434838
