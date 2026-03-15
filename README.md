# Open Source Calculation Code for Joule Thief Converter / 焦耳小偷转换器开源计算代码

This repository provides the open-source calculation code (MATLAB and Python) and SPICE simulation files for the Joule Thief converters detailed in our IEEE Transactions on Industrial Electronics (TIE) paper. It is designed to help researchers and engineers calculate performance and explore parameters based on our analytical models. If you have any questions about the repository, feel free to submit an issue to me.

本仓库提供了我们在IEEE Transactions on Industrial Electronics (TIE)期刊论文中详细介绍的焦耳小偷（Joule Thief）转换器的开源计算代码（包含MATLAB和Python）以及SPICE仿真文件。它旨在帮助研究人员和工程师基于我们的解析模型，轻松地计算性能并探索电路参数。如果你对仓库有任何疑问，都可以提issue问我。

### What is a Joule Thief circuit? / Joule Thief电路是什么？
For non-technical people: It allows a lower DC input voltage to be converted into a higher DC output voltage. Its structure is very simple, requiring only a semiconductor switch, a transformer, a diode, a filter capacitor, and a load.

对于非技术人员来说：它能让一个较低的DC输入电压，转换成一个较高的DC输出电压。它的结构非常简单，仅需要一个半导体开关，一个变压器，一个二极管，一个滤波电容和负载。

For technical experts: It is a self-oscillating boost converter that operates in boundary conduction mode. It belongs to a type of blocking oscillator, and its earliest origins may date back nearly 100 years to when vacuum tubes were still in use. As far as I know, the name "Joule Thief" comes from the 1999 article "One volt LED--A bright light" in the magazine Everyday Practical Electronics.

对于技术专家来说：它是一种自振荡的boost转换器，工作在边界导通模式。它是属于blocking oscillator的一种，最早的起源可能已有接近100年历史，当时还在使用真空管。据我所知，Joule Thief这个名字来自于1999年的杂志《Everyday Practical Electronics》中的这篇文章“One volt LED--A bright light”。

### What is it used for? / Joule Thief有什么用？
For non-technical people: Its cost is extremely low and it is easy to build, making it very popular in the DIY community. It is also suitable as an educational circuit project for students. A common demonstration is to connect a battery that is considered dead to a joule thief, thereby lighting up a 1.5V LED.

对于非技术人员来说：它的成本非常低，并且容易制作，因此在DIY社区很受欢迎，也适合作为给学生练习的电路教学项目。一个常见的演示是，把一个已经认为用光了的电池，连接上joule thief，从而点亮需要1.5V的LED。

For technical experts: Due to its very low component count, it is highly suitable for ultra-low power power management circuits, especially for power sources with relatively high internal impedance. As analyzed in our paper, when paired with a zero-threshold voltage NMOS and facing a source internal resistance of 300 ohms, it can start up at a mere 50mV. This powerful cold-start capability gives it huge potential in the field of ultra-low voltage energy harvesting. Our theoretical results have been published in the renowned power electronics journal IEEE Transactions on Industrial Electronics. There are still many potential applications in the future, and we welcome everyone to continue digging deeper. We have open-sourced its calculation code, hoping to facilitate further research by other engineers or scholars.

对于技术专家来说：它由于元件数量很少，它非常适合用于超低功耗的电源管理电路，尤其是对于较高阻抗的电源。正如我的论文所分析，当配合上零阈值电压的NMOS，并且面对电源内阻300ohm时，它能在仅仅50mV的电压下启动。这一强大的冷启动能力，让它在超低电压的能量采集领域有巨大潜力。我们的这一理论结果已经发表在了著名的电力电子期刊IEEE Transactions on Industrial Electronics。未来还有很多有潜力的应用，欢迎大家继续深入挖掘。我们把它的计算代码开源了，希望能方便其他工程师或者学者对它的进一步研究。

In summary, this is a very simple circuit (more interesting than you thought before). Its capabilities are currently underestimated, and it has enormous potential applications in the field of energy harvesting.

总而言之，这是一个非常简单的电路（比你之前想的更有趣）。它的能力目前也被低估了，并且在能量采集领域有着巨大的应用潜力。

### How does it work? / 它工作原理是什么？
![Circuit Diagram](Images/circuit_diagram_BJT.png)
As shown in the circuit diagram above, the Joule Thief alternates between two main states: the "Turn-on" phase and the "Turn-off" phase. The circuit heavily relies on the mutual inductance between the primary coil ($L_1$) and the secondary coil ($L_2$) of the transformer to form a positive feedback loop.

如上面的电路图所示，Joule Thief主要在两个主要阶段之间交替切换：“导通”阶段和“关断”阶段。该电路严重依赖于变压器初级线圈（$L_1$）和次级线圈（$L_2$）之间的互感来形成正反馈回路。

**(a) Turn-on phase** / **(a) 导通阶段**: 
When the power source ($V_{\text{oc}}$) is connected, a small current initially flows into the control terminal (the Base of the BJT or the Gate of an NMOS) through $L_2$, slightly turning on the transistor switch. This allows current ($i_1$) to start flowing from the power source through the primary coil ($L_1$) into the collector/drain of the switch.

当电源（$V_{\text{oc}}$）连接时，最初有一小股电流通过$L_2$流入控制端（BJT的基极或NMOS的栅极），使晶体管开关轻微导通。这使得电流（$i_1$）开始从电源流经初级线圈（$L_1$），进入开关的集电极/漏极。

Crucially, as $i_1$ increases, the changing magnetic field formed in $L_1$ induces a positive voltage ($V_{L2}$) in the secondary coil $L_2$ due to the dot convention of the transformer. This induced voltage adds to the input voltage, significantly raising the voltage at the control terminal (and injecting base current for a BJT). This forms a **positive feedback loop**: more primary current $\rightarrow$ higher induced secondary voltage $\rightarrow$ stronger switch turn-on $\rightarrow$ even more primary current. Then, the switch is driven into a strong conduction state, and the primary coil stores energy in its magnetic field as $i_1$ ramps up. The diode remains reverse-biased blocking the output voltage from discharging backwards. Some popular explanations suggest that self-oscillation is achieved through inductor saturation. I believe this is inaccurate because the saturation current of an inductor is typically much greater than the current at which a semiconductor switch reaches saturation.

至关重要的是，随着$i_1$的增加，由于变压器的同名端极性，$L_1$中形成的不断变化的磁场会在次级线圈$L_2$中感应出正向电压（$V_{L2}$）。该感应电压与输入电压叠加，显著提高了控制端的电压（对于BJT则注入基极电流）。这就形成了一个**正反馈回路**：更多的初级电流 $\rightarrow$ 更高的次级感应电压 $\rightarrow$ 开关导通更强 $\rightarrow$ 更多的初级电流。随后，开关被极大地驱动进入强导通状态，随着$i_1$不断上升，初级线圈在其磁场中储存能量。在此期间二极管保持反向偏置，阻止输出电压反向放电。在一些流行的解释中，会认为自振荡是通过电感饱和做到的。我认为这并不准确，因为电感的饱和电流通常远大于半导体开关达到饱和时的电流。

**(b) Turn-off phase** / **(b) 关断阶段**: 
As $i_1$ continues to increase, its growth rate ($\mathrm{d}i_1/\mathrm{d}t$) gradually decreases and approaches zero due to the transistor's specific current-voltage characteristics constrained by the circuit (e.g., the BJT approaching saturation). According to Faraday's law of induction ($V = L \cdot \mathrm{d}i/\mathrm{d}t$), the induced voltage $V_{L2}$ drops as well. This reduces the base/gate drive, which pulls the transistor out of its strong conduction state, further reducing $i_1$. This triggers the **reverse positive feedback loop**: $i_1$ begins to decrease ($\mathrm{d}i_1/\mathrm{d}t < 0$) $\rightarrow$ $V_{L2}$ flips to negative $\rightarrow$ switch rapidly turns off completely.

随着$i_1$继续增加，受到电路约束的晶体管非线性偏置特性的影响（例如BJT逐渐接近饱和区），$i_1$的增长率（$\mathrm{d}i_1/\mathrm{d}t$）逐渐下降并趋于零。根据法拉第电磁感应定律（$V = L \cdot \mathrm{d}i/\mathrm{d}t$），感应电压$V_{L2}$也会下降。这就减少了基极/栅极的驱动电压和电流，将晶体管拉出强导通状态，进一步使$i_1$减小。这触发了**反向正反馈回路**：$i_1$开始减小（$\mathrm{d}i_1/\mathrm{d}t < 0$） $\rightarrow$ $V_{L2}$翻转为负 $\rightarrow$ 开关迅速完全关断。

With the switch completely turned "Off" (as seen in Figure b), the current $i_1$ through $L_1$ cannot instantly disappear. Instead, the inductor creates a massive positive voltage spike to force the current to keep flowing. This high voltage forward-biases the diode, releasing the stored magnetic energy from $L_1$ into the output capacitor ($C_L$) and the load ($R_L$). Once the magnetic energy is completely transferred via the diode current ($i_D$), $i_1$ drops to zero, reopening the path for base/gate current, and the "Turn-on" phase begins again.

随着开关完全“关断”（如图b所示），流经$L_1$的电流$i_1$无法瞬间消失。相反，电感器会产生一个巨大的正向电压尖峰，迫使电流继续流动。这个高电压使二极管正向偏置，将$L_1$中储存的磁能释放到输出电容（$C_L$）和负载（$R_L$）中。一旦通过二极管电流（$i_D$）将磁能完全转移，$i_1$下降到0，从而重新打开了初期的基极/栅极电流路径，“导通”阶段再次开始。

In our paper, we performed detailed mathematical modeling for Joule Thief circuits based on BJT and NMOS, and provided closed-form analytical solutions, allowing their performance to be directly predicted through theory (such as output voltage and oscillation frequency). I have also provided MATLAB and Python code to help you with the calculations; you only need to input your circuit parameters.

在我们的论文中，我们对基于BJT和NMOS的joule thief进行了详细的数学建模，并且给出了封闭解，从而可以直接通过理论来预测性能（比如输出电压和振荡频率）。我也提供了matlab和python代码来帮助你计算，你只需要提供电路参数。

Even if you do not need to perform calculations, I also suggest that you carefully follow the analysis and derivation in the paper once (it is not complicated and only requires a little bit of calculus and power electronics modeling knowledge) to gain a deeper understanding of this circuit.

即使你不需要进行计算，我也建议你仔细跟着论文的分析和推导走一遍（它并不复杂，只需要一点微积分和电力电子建模知识），从而对这个电路有更深入的认识。

### Limitations of the theory / 这套理论有什么限制？
The analytical models above are completed based on a series of assumptions, among which the idealized boundary condition $i_1(0)=0$ will lead to larger deviations at higher load $R_L$ (for example, greater than 100k ohm). Therefore, in such situations, please design in combination with simulations.

上面的推导是基于一系列理论假设完成的，其中理想边界条件$i_1(0)=0$在较高负载$R_L$（例如大于100k ohm）以上后，会导致较大的偏差，所以在这种场合下，请结合仿真来进行设计。

In addition, for BJT, three parameters $\beta_F$, $\beta_R$, and $I_S$ are required, which you can extract from the SPICE model provided by the manufacturer. However, the $\beta_F$ cannot always be directly applied in the calculation; you need to perform a calibration based on experimental results (or simulation results) because actual BJTs experience reduced gain at high currents due to the high-injection effect. It is also recommended to calibrate $\beta_n$ for the NMOS.

另外，对于BJT，需要$\beta_F$，$\beta_R$和$I_S$这三个参数，你可以通过制造商提供的spice模型来提取。但这个$\beta_F$通常不能直接应用在计算中，你需要根据实验结果（或者仿真结果）来进行一次校正，因为大电流下的高注入效应（high-injection effect）会导致BJT的电流增益显著降低。NMOS的$\beta_n$也建议进行一次校正。

### Useful rules of thumb / 一些有用的经验规则
Assuming the power supply voltage is 1V, for the BJT, the maximum conversion efficiency is around 70-80%. If a low-threshold NMOS is used, the maximum conversion efficiency can reach over 90%.

假设电源电压是1V，对于BJT来说，那么最高转换效率大约在70-80%左右。如果使用低阈值的NMOS，那么最高转换效率可达90%以上。

This circuit is actually not very sensitive to the inductance value of the transformer. 1mH is a common value. If the internal resistance of the power supply is low, reducing it to 100uH or even lower is also acceptable (which may lead to an output voltage drop of about 10%). The turns ratio is an important parameter that can directly change the output voltage magnitude, and it can be optimized according to your own needs.

这一电路对于变压器的电感值其实并不敏感，1mH是一个常见的值，如果电源内阻较低，降低到100uH甚至更低也可以（可能导致输出电压降低10%左右）。而匝数比则是一个重要的参数，它能直接改变输出电压的大小，可以根据自己需求来优化。

The selection of the semiconductor switch is also quite important. If low cost is preferred, a BJT can be used (while adding a 1-10k ohm resistor at the base terminal), but the power supply voltage must be at least 0.7V or higher to operate. If high conversion efficiency is preferred, it is recommended to use a low-threshold NMOS ($V_{th} < 0.5V$) while ensuring that the $R_{ds(on)}$ and gate capacitance are small. If low-voltage start-up is preferred, a zero-threshold NMOS is recommended. After integration using CMOS, the performance will be further improved. Additionally, it is recommended to use a Schottky diode, which has a forward voltage drop of about $0.2$ to $0.3\text{V}$, lower than the $0.7\text{V}$ of a standard silicon diode, thereby helping to increase the output voltage.

半导体开关的选择也是相当重要。如果优先低成本，可以使用BJT（同时加入1-10k ohm的电阻在base端），但此时电源电压至少要0.7V以上才能工作。如果优先高转换效率，建议使用低阈值NMOS（$V_{th}$小于0.5V），同时确保$R_{ds(on)}$和gate电容较小。如果优先低电压启动，则建议使用零阈值NMOS。使用CMOS集成后，性能还会进一步提升。另外，建议使用肖特基二极管（Schottky diode），它的正向导通电压降大约在0.2到0.3V，比普通硅二极管的0.7V更低，这有助于提高输出电压。

It should be noted that when the Joule Thief is working, both the gate and drain terminals of the NMOS will withstand very large voltage spikes (significantly larger than $V_{out}$). This high voltage can easily exceed the maximum rating of the transistor and cause permanent damage, such as gate oxide breakdown. Therefore, I only recommend attempting low voltage applications (output voltage not higher than 5V). When experimenting, please carefully check your device's datasheet and be aware of circuit safety risks.

需要注意的是，Joule Thief工作时，NMOS的gate和drain端都会承受巨大的电压尖峰（比$V_{out}$更大幅度）。这个高电压极易超过晶体管的最大额定电压，从而导致诸如栅极氧化层击穿等永久性损坏。所以我只建议进行低电压的尝试（输出电压不高于5V）。实验时，请务必仔细核对器件的数据手册，并注意电路的安全风险。

### Using the Calculation Code / 如何使用计算代码
We provide analytical calculation scripts for both BJT and NMOS based circuits, implemented in MATLAB and Python. You only need to input your circuit parameters (such as open-circuit voltage $V_{oc}$, source internal resistance $R_{in}$, primary inductance $L_1$, turns ratio $a$, along with specific transistor/diode static parameters). The code will directly output the predicted steady-state performance metrics:
- Output voltage across the load ($V_{out}$)
- Switching frequency ($freq$)
- Input power ($P_{in}$) and Output power ($P_{out}$)
- Power conversion efficiency ($eff$)

我们提供了基于BJT和NMOS两种电路的解析计算脚本，分别用MATLAB和Python实现。你只需要输入一些电路参数（例如开路电压$V_{oc}$，电源内阻$R_{in}$，初级电感$L_1$，匝数比$a$，以及具体的晶体管/二极管静态参数）。代码会自动输出预测的稳态运行指标：
- 负载端的输出电压（$V_{out}$）
- 开关振荡频率（$freq$）
- 输入功率（$P_{in}$）和输出功率（$P_{out}$）
- 功率转换效率（$eff$）

We have included ready-to-run parameter examples for specific hardware models (such as BJT SMMBT3904LT1G and NMOS SiUD412ED) inside the source code to help you get started immediately.

我们还在源代码中附带了针对特定硬件型号（例如BJT SMMBT3904LT1G和NMOS SiUD412ED）的可运行参数示例代码，帮助你可以立即开始运行测试。

### Regarding Simulation Files / 关于仿真文件
I have provided LTSPICE (free software) simulation files as a reference. You can replace the components in them through custom configuration or use the SPICE models from the manufacturers. For specific designs, I recommend using the theory for rapid parameter exploration first, and then combining it with simulations to observe the waveforms and verify the performance.

我提供了LTSPICE（免费软件）的仿真文件作为参考，你可以替换其中的元件，通过自定义或者使用制造商的spice模型。具体设计时，我建议使用理论进行快速参数探索，然后结合仿真来观察波形和检查性能。

![LTSpice simulation](Images/LTSpice_simulation.png)

### Citation / 引用
If you find the above information helpful, please cite our paper:
如果你觉得上述信息对你有帮助，请引用我们的论文：

> S. Su and S. Aunet, "Self-Oscillating Joule Thief Converters for MEMS Electromagnetic Energy Harvesting: Analytical Modeling and Experimental Validation," in IEEE Transactions on Industrial Electronics, doi: 10.1109/TIE.2026.3663767.
> 
> https://ieeexplore.ieee.org/document/11434838
