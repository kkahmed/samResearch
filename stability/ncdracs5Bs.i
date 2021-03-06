[GlobalParams] #
    global_init_P = 3.0e5
    global_init_V = 0.095143 #0.06 #0.29
    global_init_T = 850
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
  	cp = 207300 #100x scaled (boils over ~10 K)
  	cv =  155136    #100x scaled (boils over ~10 K)
  	h_0 = 2.678e6  # J/kg
  	T_0 = 374      # K
  	mu = 1.23e-5 #1x
 	  k = 0.0251 #1x
  [../]
  [./eos3] #const salt
    type = PTConstantEOS
    p_0 = 1.0e5    # Pa
    rho_0 = 1995.142   # kg/m^3
    #a2 = 1.834e5  # m^2/s^2
    beta = 0.0002143124 # K^{-1}
    cp = 2415.78
    cv =  2415.78
    h_0 = 2.35092e6  # J/kg
    T_0 = 856.7124      # K
    mu = 0.008891 #1x
    k = 1.057981 #1x
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
    y = '10507150 10507150 30507150 30507150 10507150 507150 507150 10507150 10507150'
  [../]
  #[./Q_perturb2]
  #  type = PiecewiseLinear
  #  x = '0        35       40     50     55       60       70       75       1000'
  #  y = '19019791 19019791 519791 519791 19019791 39019791 39019791 19019791 19019791'
  #[../]
  [./Q_perturb2]
    type = PiecewiseLinear
    x = '0        1e5'
    y = '10507150 10507150'
  [../]
[]

[Components]
  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 1 0'
    orientation = '0 -1 0'

    A = 0.01767146
    Dh = 0.15
    length = 1
    n_elems = 3
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

    initial_V = 0.018311 #0.029349731
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
    n_elems = 3
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
    length = 1
    n_elems = 3
    #f = 0.03903
    #initial_T = 1353
  [../]

  [./TCHX]
    type = PBHeatExchanger
    eos = eos3
    eos_secondary = eos2

    position = '0 1.0 5.98'
    orientation = '23.86943652456 0 -2.5'
    orientation_secondary = '0 0 -1'

    A = 0.0218353
    Dh = 0.0109
    A_secondary = 0.191292
    Dh_secondary = 0.0109
    length = 24
    length_secondary = 2.5 #2.73951413
    n_elems = 12
    #f = 0.238
    f_secondary = 0.045
    Hw = 1.5e5 #Turned this down from e5
    #Hw_secondary = 20.6226325 #22.6 #Overall U, scaled by (2.5/24)*(As/A)
    #Hw_secondary = 197.977272 #22.6 #Overall U, scaled by (As/A)
    #Hw_secondary = 20.6241 #Converges, 100 does not
    Hw_secondary = 27.1 #Tuned to match Mohamed's overall U

  	initial_V = 0.077 #0.04855862 #0.12341942  #0.23470
	initial_V_secondary = -9.21125 #Not scaled to preserve residence time
	initial_T_secondary = 374

    HT_surface_area_density = 366.97
    HT_surface_area_density_secondary = 402.1278 #Scaled to satisfy Phf conditions

    Twall_init = 800
    wall_thickness = 0.0009

    dim_wall = 1
    material_wall = ss-mat
    n_wall_elems = 12
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 1.0 3.48'
    orientation = '0 0 -1'

    A = 0.01767146
    Dh = 0.15
    length = 3.48
    n_elems = 3
    #f = 0.03903
    #initial_T = 1129
  [../]

  [./Branch1]
    type = PBBranch
    inputs = 'pipe1(out)'
    outputs = 'DHX(in)'
    eos = eos3
    Area = 0.01767146
    K = '0.0 0.0'
  [../]

  [./Branch2]
    type = PBBranch
    inputs = 'DHX(out)'
    outputs = 'pipe2(in)'
    eos = eos3
    Area = 0.01767146
    K = '0.0 0.0'
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
    K = '0.0 0.0'
  [../]

  [./Branch5]
    type = PBBranch
    inputs = 'TCHX(primary_out)'
    outputs = 'pipe4(in)'
    eos = eos3
    Area = 0.01767146
    K = '0.0 0.0'
  [../]

  [./Branch6]
    type = PBSingleJunction
    inputs = 'pipe4(out)'
    outputs = 'pipe1(in)'
    eos = eos3
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 0 5.98'
    orientation = '0 0 1'

    A = 0.01767146
    Dh = 0.15
    length = 0.1
    n_elems = 3
    #initial_T = 1129
  [../]
  [./pool1]
    type = PBLiquidVolume
    center = '0 0 7.08'
    inputs = 'pipe5(out)'
    Steady = 0
    K = '0.5'
    Area = 3
    volume = 30
    initial_level = 5.0
    initial_T = 1006
    initial_V = 0.0
    #scale_factors = '1 1e-1 1e-2'
    display_pps = true
    covergas_component = 'cover_gas1'
    eos = eos3
  [../]
  [./cover_gas1]
	type = CoverGas
	n_liquidvolume =1
	name_of_liquidvolume = 'pool1'
	initial_P = 1e5
	initial_Vol = 15.0
	initial_T = 1006
  [../]
#  [./p_out]
#  	type = PBTDV
#  	input = 'pipe5(out)'
#	eos = eos
#  	p_bc = 1.01e5
#  	T_bc = 1050
#  [../]

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
  [./TCHX_Re]
    type = ComponentBoundaryFlow
    input = TCHX(primary_in)
    scale_factor = 56.14623
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
    scale_factor = 2.264e10
    execute_on = timestep_end
  [../]
  [./DHX_Gr2]
    type = ComponentBoundaryVariableValue
    input = DHX(in)
    variable = temperature
    scale_factor = 2.264e10
    execute_on = timestep_end
  [../]
  [./DHX_Gr]
    type = DifferencePostprocessor
    value1 = DHX_Gr1
    value2 = DHX_Gr2
    execute_on = timestep_end
  [../]
  [./TCHX_q]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 8.012946 #64.10357
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
  end_time = 1000

  l_tol = 1e-5 # Relative linear tolerance for each Krylov solve
  l_max_its = 200 # Number of linear iterations for each Krylov solve

  [./Quadrature]
     type = GAUSS
     order = SECOND
  [../]
[]

[Problem]
  #restart_file_base = 'ncdracs5Ks_out_cp/2859'
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
