import numpy as np

def calculate_nmos_resistive(V_oc, R_in, a, L_1, R_L, beta_n, V_th, V_D):
    """
    Calculates steady-state performance of NMOS Joule Thief (Section II-C).
    Covers the general case with non-zero source resistance (Rin > 0).
    
    Inputs:
      V_oc   : Open-circuit voltage of the source [V]
      R_in   : Source internal resistance [Ohm]
      a      : Transformer turns ratio (N2/N1)
      L_1    : Primary inductance [H]
      R_L    : Load resistance [Ohm]
      beta_n : NMOS transconductance parameter (mu_n * Cox * W/L) [A/V^2]
      V_th   : NMOS Threshold voltage [V]
      V_D    : Diode forward voltage drop [V]
      
    Outputs:
      V_out  : Output voltage across R_L [V]
      freq   : Switching frequency [Hz]
      P_in   : Input power [W]
      P_out  : Output power [W]
      eff    : Power conversion efficiency
    """
    
    # 1. Calculate Unified Model Coefficients
    # b1, b2, b3 per Eqs. (S.18)-(S.19) in this supplementary material
    b1 = 1 + 2 * a
    b2 = (a + 1) * R_in
    b3 = (a + 1) * V_oc - V_th
    
    # 2. Calculate V_ds* at peak current per Eq. (S.18)
    V_ds_star = (np.sqrt(b1 * (2 * beta_n * b2 * b3 + b1)) - b1) / \
                (beta_n * b1 * b2)

    # 3. Calculate peak primary current per Eq. (S.19)
    i_peak = (beta_n * b2 * b3 + b1 - np.sqrt(b1 * (2 * beta_n * b2 * b3 + b1))) / \
             (beta_n * b2**2)
             
    # --- Alternative estimation for extremely small Rin (Rin -> 0) ---
    # When Rin is very small (approaching 0), the above formulas involve 0/0 and can cause NaN.
    # By performing a Taylor expansion on Rin (i.e., b2) at exactly 0, we can obtain the simplified equations below.
    # You can uncomment and use these if your Rin is extremely small or close to zero.
    # 
    # V_ds_star = b3 / b1
    # i_peak = (beta_n * b3**2) / (2 * b1)
    # -----------------------------------------------------------------

    # 4. Calculate Turn-on Time (Eq. 16 in main text)
    t_on = (2 * L_1 * i_peak) / (2 * V_oc - i_peak * R_in - V_ds_star)

    # 5. Calculate Output Voltage and Turn-off Time (Eqs. 20-21 in main text)
    gamma_3 = (V_ds_star - 2 * V_D)**2 + 4 * R_L * i_peak * \
              (2 * V_oc - V_ds_star - i_peak * R_in)

    V_out = 0.25 * (V_ds_star - 2 * V_D + np.sqrt(gamma_3))
    
    t_off = (4 * i_peak * L_1) / (V_ds_star + 2 * i_peak * R_in + \
            2 * V_D - 4 * V_oc + np.sqrt(gamma_3))

    # 6. Performance Metrics
    freq = 1 / (t_on + t_off)              # Switching Frequency
    
    # Input Power (Triangular Waveform Approx)
    i_avg = i_peak / 2                     
    P_in = (V_oc - R_in * i_avg) * i_avg  
    
    P_out = V_out**2 / R_L                 # Output Power
    eff = P_out / P_in                     # Efficiency
    
    return V_out, freq, P_in, P_out, eff

if __name__ == "__main__":
    # Example Usage (SiUD412ED NMOS):
    V_oc = 1.0       # 1V input
    R_in = 100.0     # 100 Ohm source resistance
    a = 1.0          # 1:1 turns ratio
    L_1 = 1e-3       # 1mH primary inductance
    R_L = 10e3       # 10kOhm load
    beta_n = 0.9     # Transconductance parameter [A/V^2]
    V_th = 0.35      # Threshold voltage [V]
    V_D = 0.3        # Schottky diode forward drop (RB521S30T1G) [V]

    V_out, freq, P_in, P_out, eff = calculate_nmos_resistive(V_oc, R_in, a, L_1, R_L, beta_n, V_th, V_D)
    
    print(f"NMOS Model: SiUD412ED")
    print(f"Output Voltage: {V_out:.3f} V")
    print(f"Switching Frequency: {freq:.1f} Hz")
    print(f"Efficiency: {eff*100:.1f} %")
