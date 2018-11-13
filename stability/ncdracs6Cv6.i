[GlobalParams] #
    global_init_P = 3.0e5
    global_init_V = 0.278037 #0.06 #0.29
    global_init_T = 841.7258
    Tsolid_sf = 1e-3

  [./PBModelParams]
    #pspg = true
    p_order = 2
    pbm_scaling_factors = '1 1e-2 1e-5'
    #variable_bounding = true
    #V_bounds = '0 10'
  [../]
[]


[EOS]
	active = 'eos eos2 eos3'
  [./eos]
  	type = SaltEquationOfState
  [../]
  [./eos2] #steam
  	type = PTConstantEOS
  	p_0 = 1.0e5    # Pa
  	rho_0 = 0.5959   # kg/m^3
  	#a2 = 1.834e5  # m^2/s^2
  	beta = 0.00289 # K^{-1}
    cp = 2073000 #1000x scaled (boils over ~1 K)
  	cv =  1551360    #1000x scaled (boils over ~1 K)
  	h_0 = 2.678e6  # J/kg
  	T_0 = 374      # K
  	mu = 1.23e-5 #1x
 	  k = 0.0251 #1x
  [../]
  [./eos3] #const salt
    type = PTConstantEOS
    p_0 = 1.0e5    # Pa
    rho_0 = 2002.455   # kg/m^3
    #a2 = 1.834e5  # m^2/s^2
    beta = 0.0002143124 # K^{-1}
    cp = 2415.78
    cv =  2415.78
    h_0 = 2.35092e6  # J/kg
    T_0 = 841.7258      # K
    mu = 0.00956 #1x
    k = 1.050488 #1x
  [../]
[]

[Materials]
  [./ss-mat]
    type = SolidMaterialProps
    k = 2000 #20
    Cp = 0.01 #638
    rho = 6e3
  [../]
[]

[Functions]
  [./T_perturb]
    type = PiecewiseLinear
    x = '0   30  40  60  70  1000'
    y = '373 373 473 473 373 373'
  [../]
  [./Q_perturb1]
    type = PiecewiseLinear
    x = '0        35       40       50       55       60     70     75       1000'
    y = '19019791 19019791 39019791 39019791 19019791 519791 519791 19019791 19019791'
  [../]
  #[./Q_perturb2]
  #  type = PiecewiseLinear
  #  x = '0        35       40     50     55       60       70       75       1000'
  #  y = '19019791 19019791 519791 519791 19019791 39019791 39019791 19019791 19019791'
  #[../]
  #[./Q_perturb2]
  #  type = PiecewiseLinear
  #  x = '0        1e5'
  #  y = '30280968 30280968'
  #[../]
  [./Q_perturb2]
    type = PiecewiseLinear
    x = '2000     3000     1e5' #For restart from 6Cs
    y = '10280968 27280968 27280968'
  [../]
  [./PumpFN]
    type = PiecewiseLinear
    x = '2000  3000  1e5' #For restart from 5Ks
    y = '0.0   -900  -900' #y = '0.0   0.0   0.0'
  [../]
  [./PBTDVTemp]
    type = ParsedFunction
    vals = 'pipe5out'
    vars = 'poolTemp'
    value = poolTemp
  [../]
  [./Gr_alt]
    type = ParsedFunction
    vals = 'DHXRhoTop DHXRhoBot DHX_Gr3 DHX_Gr4'
    vars = 'p1 p2 Gr3 Gr4'
    value = (Gr3-Gr4)*((1/3)*(p1-p2)^2+(p1*p2))
  [../]
  [./Gr_loop]
    type = ParsedFunction
    vals = 'DHXRhoTop DHXRhoBot DHX_Gr5 DHX_Gr6'
    vars = 'p1 p2 Gr5 Gr6'
    value = (Gr5-Gr6)*((1/3)*(p1-p2)^2+(p1*p2))/((p1+p2)/2)
  [../]
  [./Gr_boundary]
    type = ParsedFunction
    vals = 'TCHX_Re'
    vars = 'Re'
    value = (if(Re<=128.432,1,0))*(Re*2.850e10-1.374e11)+(if(Re<138.797,1,0))*(if(Re>128.432,1,0))*(Re*3.560e10-1.049e12)+(if(Re>=138.797,1,0))*(Re*4.272e10-2.037e12)
  [../]
  [./Gr_bound2]
    type = ParsedFunction
    vals = 'TCHX_Re'
    vars = 'Re'
    value = (if(Re<=128.432,1,0))*(Re*3.321e10-2.532e11)+(if(Re<138.797,1,0))*(if(Re>128.432,1,0))*(Re*4.160e10-1.331e12)+(if(Re>=138.797,1,0))*(Re*4.992e10-2.486e12)
  [../]
[]

[Components]
  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 4.52 0'
    orientation = '0 -1 0'

    A = 0.01767146
    Dh = 0.15
    length = 4.52
    n_elems = 5
    #f = 0.03903
    #initial_T = 1129
  [../]

  [./DHX]
    type = PBOneDFluidComponent
    eos = eos3

    position = '0 0.0 0'
    orientation = '0 0 1'
    A = 0.09182015
    Dh = 0.0109
    roughness = 0.000015
    length = 2.5
    n_elems = 14

    initial_V = 0.05351 #0.029349731
    heat_source = Q_perturb2
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 0 2.5'
    orientation = '0 0 1'

    A = 0.01767146
    Dh = 0.15
    length = 3.48
    n_elems = 5
    #f = 0.03903
    #initial_T = 1353
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 0 5.98'
    orientation = '0 1 0'

    A = 0.01767146
    Dh = 0.15
    length = 4.01
    n_elems = 5
    #f = 0.03903
    #initial_T = 1353
  [../]

  [./TCHX]
    type = PBHeatExchanger
    eos = eos3
    eos_secondary = eos2

    position = '0 4.01 5.98'
    orientation = '5.45435606 0 -2.5'
    orientation_secondary = '0 0 -1'

    A = 0.0873412
    Dh = 0.0109
    A_secondary = 0.765168
    Dh_secondary = 0.0109
    length = 6
    length_secondary = 2.5 #2.73951413
    n_elems = 12
    #f = 0.238
    f_secondary = 0.045
    Hw = 1.5e5 #Turned this down from e5
    #Hw_secondary = 20.6226325 #22.6 #Overall U, scaled by (2.5/24)*(As/A)
    #Hw_secondary = 197.977272 #22.6 #Overall U, scaled by (As/A)
    #Hw_secondary = 20.6241 #Converges, 100 does not
    Hw_secondary = 26.2 #Tuned to match Mohamed's overall U

  	initial_V = 0.056254 #0.04855862 #0.12341942  #0.23470
	initial_V_secondary = -9.21125 #Not scaled to preserve residence time
	initial_T_secondary = 374

    HT_surface_area_density = 366.97 #0.0109/(0.00545^2)
    HT_surface_area_density_secondary = 100.5325 #0.0109*234*4*pi*6/(0.765168*2.5)

    Twall_init = 800
    wall_thickness = 0.0009

    dim_wall = 1
    material_wall = ss-mat
    n_wall_elems = 12
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 4.52 3.48'
    orientation = '0 0 -1'

    A = 0.01767146
    Dh = 0.15
    length = 3.48
    n_elems = 5
    #f = 0.03903
    #initial_T = 1129
  [../]

  [./Branch1]
    type = PBBranch
    inputs = 'pipe1(out)'
    outputs = 'DHX(in)'
    eos = eos3
    Area = 0.01767146
    K = '0.0 0.0' #K = '6.2 6.2'
  [../]

  [./Branch2]
    type = PBBranch
    inputs = 'DHX(out)'
    outputs = 'pipe2(in)'
    eos = eos3
    Area = 0.01767146
    K = '0.0 0.0' #K = '6.2 6.2'
  [../]


  [./Branch3]
    type = PBVolumeBranch #type=PBBranch
    inputs = 'pipe2(out)'
    outputs = 'pipe3(in) pipe5(in)'
    center = '0 0 5.98'
    volume = 0.01767146 #0.003534292
    K = '0.0 0.0 10.0'
    #Area =   0.44934
    Area = 0.01767146
    #initial_P = 9.5e4
    eos = eos3
  [../]

  [./Branch4]
    type = PBBranch
    inputs = 'pipe3(out)'
    outputs = 'TCHX(primary_in)'
    eos = eos3
    Area = 0.01767146
    K = '0.0 0.0' #K = '6.2 6.2'
  [../]

  #[./Branch5]
  #  type = PBBranch
  #  inputs = 'TCHX(primary_out)'
  #  outputs = 'pipe4(in)'
  #  eos = eos3
  #  Area = 0.01767146
  #  K = '0.0 0.0'
  #[../]
  [./P2]
    type = PBPump                               # This is a PBPump component
    eos = eos3
    inputs = 'TCHX(primary_out)'
    outputs = 'pipe4(in)'
    K = '0. 0.'                                 # Form loss coefficient at pump inlet and outlet
    Area = 0.01767146                           # Reference pump flow area
    #initial_P = 1.5e5                           # Initial pressure
    Head_fn = PumpFN                                  # Pump head, Pa
  [../]

  #[./Branch6]
  #  type = PBSingleJunction
  #  inputs = 'pipe4(out)'
  #  outputs = 'pipe1(in)'
  #  eos = eos3
  #[../]
  [./P1]
    type = PBPump                               # This is a PBPump component
    eos = eos3
    inputs = 'pipe4(out)'
    outputs = 'pipe1(in)'
    K = '0. 0.'                                 # Form loss coefficient at pump inlet and outlet
    Area = 0.01767146                           # Reference pump flow area
    #initial_P = 1.5e5                           # Initial pressure
    Head_fn = PumpFN                                  # Pump head, Pa
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 0 5.98'
    orientation = '0 0 1'

    A = 0.01767146
    Dh = 0.15
    length = 0.5
    n_elems = 5
    #initial_T = 1353
  [../]
  #[./pool1]
  #  type = PBLiquidVolume
  #  center = '0 0 7.08'
  #  inputs = 'pipe5(out)'
  #  Steady = 0
  #  K = '0.5'
  #  Area = 3
  #  volume = 30
  #  initial_level = 5.0
  #  initial_T = 885
  #  initial_V = 0.0
  #  #scale_factors = '1 1e-1 1e-2'
  #  display_pps = true
  #  covergas_component = 'cover_gas1'
  #  eos = eos3
  #[../]
  #[./cover_gas1]
	#type = CoverGas
	#n_liquidvolume =1
	#name_of_liquidvolume = 'pool1'
	#initial_P = 1e5
	#initial_Vol = 15.0
	#initial_T = 885
  #[../]
  [./p_out]
  	type = PBTDV
  	input = 'pipe5(out)'
    eos = eos3
  	p_bc = 1.01e5
  	T_fn = PBTDVTemp
  [../]

  [./inlet2]
  	type = PBTDJ
	input = 'TCHX(secondary_in)'
    eos = eos2
	v_bc = -9.21125
     T_bc = 373 #T_fn = T_perturb
  [../]

  [./outlet2]
  	type = PBTDV
  	input = 'TCHX(secondary_out)'
    eos = eos2
  	p_bc = 1.01e5
  	T_bc = 383
  [../]
[]

[Postprocessors]
  [./DHX_flow]
    type = ComponentBoundaryFlow
    input = DHX(in)
    execute_on = timestep_end
  [../]
  [./TCHX_Re] #Constant rho, constant mu
    type = ComponentBoundaryFlow
    input = TCHX(primary_in)
    scale_factor = 13.05379
    execute_on = timestep_end
  [../]
  [./TCHX_umin]
    type = ComponentBoundaryVariableValue
    input = TCHX(primary_out)
    variable = velocity
    execute_on = timestep_end
  [../]
  [./TCHX_umax]
    type = ComponentBoundaryVariableValue
    input = TCHX(primary_in)
    variable = velocity
    execute_on = timestep_end
  [../]
  [./DHX_Gr1]
    type = ComponentBoundaryVariableValue
    input = DHX(out)
    variable = temperature
    scale_factor = 1.972e10 #(p^2)Bg(H^3)/(u^2)
    execute_on = timestep_end
  [../]
  [./DHX_Gr2]
    type = ComponentBoundaryVariableValue
    input = DHX(in)
    variable = temperature
    scale_factor = 1.972e10 #(p^2)Bg(H^3)/(u^2)
    execute_on = timestep_end
  [../]
  [./DHX_Gr3]
    type = ComponentBoundaryVariableValue
    input = DHX(out)
    variable = temperature
    scale_factor = 4.919e3 #Bg(H^3)/(u^2)
    execute_on = timestep_end
  [../]
  [./DHX_Gr4]
    type = ComponentBoundaryVariableValue
    input = DHX(in)
    variable = temperature
    scale_factor = 4.919e3 #Bg(H^3)/(u^2)
    execute_on = timestep_end
  [../]
  [./DHX_Gr5]
    type = ComponentBoundaryVariableValue
    input = DHX(out)
    variable = temperature
    scale_factor = 1.120e7 #(dp/dT)g(H^3)/(u^2)
    execute_on = timestep_end
  [../]
  [./DHX_Gr6]
    type = ComponentBoundaryVariableValue
    input = DHX(in)
    variable = temperature
    scale_factor = 1.120e7 #(dp/dT)g(H^3)/(u^2)
    execute_on = timestep_end
  [../]
  [./DHXRhoTop]
    type = ComponentBoundaryVariableValue
    input = 'DHX(out)'
    variable = 'rho'
  [../]
  [./DHXRhoBot]
    type = ComponentBoundaryVariableValue
    input = 'DHX(in)'
    variable = 'rho'
  [../]
  [./DHX_GrAlt] #DHX integral rho, constant mu
    type = FunctionValuePostprocessor
    function = Gr_alt
    execute_on = timestep_end
  [../]
  [./DHX_GrBoundary]
    type = FunctionValuePostprocessor
    function = Gr_boundary
    execute_on = timestep_end
  [../]
  [./DHX_GrLoop] #DHX integral rho, improved Beta, constant mu
    type = FunctionValuePostprocessor
    function = Gr_loop
    execute_on = timestep_end
  [../]
  [./DHX_GrBound2] #Alternate T-dep Beta in calculation
    type = FunctionValuePostprocessor
    function = Gr_bound2
    execute_on = timestep_end
  [../]
  [./DHX_Gr] #Constant rho, constant mu
    type = DifferencePostprocessor
    value1 = DHX_Gr1
    value2 = DHX_Gr2
    execute_on = timestep_end
  [../]
  [./TCHX_q]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 32.05178 #64.10357
    block = 'TCHX:primary_pipe'
    execute_on = timestep_end
  [../]
  [./DHXTubeTop]
    type = ComponentBoundaryVariableValue
    input = 'DHX(out)'
    variable = 'temperature'
  [../]
  [./DHXTubeBot]
    type = ComponentBoundaryVariableValue
    input = 'DHX(in)'
    variable = 'temperature'
  [../]
  [./DHXTubeAvg_K]
    type = LinearCombinationPostprocessor
    pp_names = 'DHXTubeBot DHXTubeTop'
    pp_coefs = '0.5 0.5'
    b = -273.15
    execute_on = timestep_end
  [../]
  [./v1]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(out)'
    variable = 'velocity'
  [../]
  [./v0]
    type = ComponentBoundaryVariableValue
    input = 'DHX(out)'
    variable = 'velocity'
  [../]
  [./v2]
    type = ComponentBoundaryVariableValue
    input = 'pipe2(out)'
    variable = 'velocity'
  [../]
  #[./v3a]
  #  type = ComponentBoundaryVariableValue
  #  input = 'Branch3(in)'
  #  variable = 'velocity'
  #[../]
  [./v3]
    type = ComponentBoundaryVariableValue
    input = 'pipe3(out)'
    variable = 'velocity'
  [../]
  [./v6]
    type = ComponentBoundaryVariableValue
    input = 'TCHX(primary_out)'
    variable = 'velocity'
  [../]
  [./v4]
    type = ComponentBoundaryVariableValue
    input = 'pipe4(out)'
    variable = 'velocity'
  [../]
  [./Residence]
    type = InverseLinearCombinationPostprocessor
    pp_names = 'v1   v0  v2   v3   v6 v4'
    pp_coefs = '4.52 2.5 3.48 5.01 6  3.48'
    b = 0.0
    execute_on = timestep_end
  [../]
  [./pipe5out]
    type = ComponentBoundaryVariableValue
    input = 'pipe5(out)'
    variable = 'temperature'
  [../]
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'lu'
  [../]
  [./FDP]
    type = FDP
    full = true
    solve_type = 'PJFNK'
  [../]

[] # End preconditioning block


[Executioner]
  #type = Steady
  type = Transient

  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  #dt = 1e-1
  #dtmin = 1e-6
  [./TimeStepper]
    type = FunctionDT
    time_t = '0.0   5.0   5.1  200  201  1e5'
    time_dt ='0.05  0.05  0.1  0.1  1.0  1.0'
    min_dt = 1e-3
  [../]

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-5
  nl_max_its = 100

  start_time = 0.0
  num_steps = 10000
  end_time = 6000

  l_tol = 1e-5 # Relative linear tolerance for each Krylov solve
  l_max_its = 200 # Number of linear iterations for each Krylov solve

  [./Quadrature]
     type = GAUSS
     order = SECOND
  [../]
[]

[Problem]
  restart_file_base = 'ncdracs6Cu_out_cp/3869'
[]

[Outputs]
  print_linear_residuals = false
  [./out]
    type = Checkpoint
  [../]

  [./out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end'
    sequence = false
  [../]

  [./console]
    type = Console
    perf_log = true
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]
