function [V_out, freq, P_in, P_out, eff] = calculate_bjt_full(V_oc, a, L_1, R_L, R_b, I_s, beta_F, beta_R, V_T, V_D)
    % Calculates steady-state performance of BJT Joule Thief (Section II-B).
    %
    % Inputs:
    %   V_oc   : Open-circuit source voltage [V]
    %   a      : Transformer turns ratio (N2/N1)
    %   L_1    : Primary inductance [H]
    %   R_L    : Load resistance [Ohm]
    %   R_b    : Base resistance [Ohm]
    %   I_s    : Saturation current [A]
    %   beta_F : Forward current gain
    %   beta_R : Reverse current gain
    %   V_T    : Thermal voltage [V] (~26mV at 300K)
    %   V_D    : Diode forward voltage drop [V]
    %
    % Outputs:
    %   V_out  : Output voltage across R_L [V]
    %   freq   : Switching frequency [Hz]
    %   P_in   : Input power [W]
    %   P_out  : Output power [W]
    %   eff    : Power conversion efficiency
    %
    % Example Usage (SMMBT3904LT1G BJT):
    %   V_oc = 1;        % 1V input
    %   a = 1;           % 1:1 turns ratio
    %   L_1 = 1e-3;      % 1mH primary inductance
    %   R_L = 10e3;      % 10kOhm load
    %   R_b = 10e3;      % 10kOhm base resistor
    %   I_s = 20.5e-15;  % Saturation current (20.5fA) [A]
    %   beta_F = 100;    % Forward current gain
    %   beta_R = 1.88;   % Reverse current gain
    %   V_T = 0.026;     % Thermal voltage at 300K [V]
    %   V_D = 0.3;       % Schottky diode forward drop (RB521S30T1G) [V]
    %
    %   [V_out, freq, P_in, P_out, eff] = calculate_bjt_full(V_oc, a, L_1, R_L, R_b, I_s, beta_F, beta_R, V_T, V_D);
    %   fprintf('BJT Model: SMMBT3904LT1G\n');
    %   fprintf('V_out = %.3f V, Freq = %.1f Hz, Efficiency = %.1f%%\n', V_out, freq, eff*100);
    % 1. Calculate Peak Voltage Condition
    % xi_1 and xi_2 per Eq. (S.11) in this supplementary material
    xi_1 = V_oc + (I_s .* R_b ./ (1 + a)) .* (1 ./ beta_F + 1 ./ beta_R) - ...
           (V_T ./ (1 + a)) .* (a + log((a .* V_T .* beta_R) ./ (I_s .* R_b)));
           
    xi_2 = (a .* beta_R) ./ ((1 + a) .* beta_F) .* exp(xi_1 ./ V_T);
    
    % Solve for V_CE* at peak current per Eq. (S.11)
    V_CE = xi_1 - V_T .* lambertw(xi_2);
    
    % 2. Calculate V_BE* per Eq. (S.10)
    V_BE = log((a .* V_T .* beta_R) ./ (I_s .* R_b)) .* V_T + V_CE;
    
    % 3. Calculate peak currents using Ebers-Moll model
    % i_BE per Eq. (S.5), i_peak per Eq. (S.12)
    i_BE = I_s .* ((-1 + exp(V_BE ./ V_T)) ./ beta_F + ...
           (-1 + exp((V_BE - V_CE) ./ V_T)) ./ beta_R);
    i_peak = I_s .* (exp(V_BE ./ V_T) - exp((V_BE - V_CE) ./ V_T) - ...
             (-1 + exp((V_BE - V_CE) ./ V_T)) ./ beta_R);

    % 4. Calculate Turn-on Time (Eq. 8 in main text)
    t_on = (2 .* i_peak .* L_1) ./ (2 .* V_oc - V_CE); 
    
    % 5. Calculate Turn-off Time and Output Voltage (Eqs. 12-13 in main text)
    gamma_1 = (2 .* (V_oc - V_D)) ./ (2 .* V_oc - V_CE);
    gamma_2 = ((2 .* V_D - V_CE).^2 + 4 .* i_peak .* R_L .* (2 .* V_oc - V_CE)) ./ ...
              (2 .* V_oc - V_CE).^2;
    
    V_out = (V_oc - V_D) + (i_peak .* R_L - 2 .* (V_oc - V_D)) ./ ...
            (1 + gamma_1 + sqrt(gamma_2));
            
    t_off = (i_peak .* L_1 .* (1 + gamma_1 + sqrt(gamma_2))) ./ ...
            (i_peak .* R_L + 2 .* (V_D - V_oc));

    % 6. Performance Metrics
    freq = 1 ./ (t_on + t_off);      % Switching Frequency
    
    % Input Power (Triangular Waveform Approx)
    P_in = V_oc .* (i_peak + i_BE) ./ 2; 
    
    P_out = V_out.^2 ./ R_L;         % Output Power
    eff = P_out ./ P_in;             % Efficiency
end