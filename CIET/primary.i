[GlobalParams] 
    global_init_P = 1.0e5
    global_init_V = 1.0
    global_init_T = 950  
    Tsolid_sf = 1e-3  

  [./PBModelParams]
	pspg = false
	pbm_scaling_factors = '1 1e-1 1e-4'
	#variable_bounding = true
	#V_bounds = '0 10'
  [../]
[]


[EOS]
	active = 'eos eos3'
  [./eos]
  	type = SaltEquationOfState
  [../]
  [./eos3] #const salt
  	type = PTConstantEOS
  	p_0 = 1.0e5    # Pa
  	rho_0 = 2279.92   # kg/m^3
  	#a2 = 1.834e5  # m^2/s^2
  	beta = 0 # K^{-1}
  	cp = 2415.78
  	cv =  2415.78
  	h_0 = 2.35092e6  # J/kg
  	T_0 = 973.15      # K
  	mu = 1.23e-5 #1x
 	k = 0.0251 #1x
  [../]
[] 

[Materials]
  [./ss-mat]
    type = SolidMaterialProps
    k = 40
    Cp = 583.333
    rho = 6e3
  [../]
  [./h451]
    type = SolidMaterialProps
    k = 80
    Cp = 1323.92
    rho = 2.266e3
  [../]
  [./pebble]
    type = SolidMaterialProps
    k = 15
    Cp = 1323.92
    rho = 2.266e3
  [../]
[]


[Components]

  [./pipe010] #Active core region (1)	FINISH HEAT STRUCTURE INPUT, CHECK CCFL
    type = PBPipe 
    eos = eos
    position = '0 5.94445 -5.34'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 1.327511
    Dh = 0.03
    length = 4.58
    n_elems = 26

    WF_user_option = User
    User_defined_WF_parameters = '32.1 4974.4 1.0'
  [../] 

  [./pipe020] #Core bypass (2)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 7.92445 -5.34'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.065
    Dh = 0.01
    length = 4.58
    n_elems = 26
  [../] 

  [./Branch030] #Outlet plenum (3)		(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch 
    inputs = 'pipe010(out) pipe020(out)'	# A = 1.327511 (0.2524495)	A = 0.065
    outputs = 'pipe040(in)'   			# A = 0.2512732
    center = '0 5.94445 -0.76' 
    volume = 0.99970002
    K = '0.0 0.0 0.0'				# Compute these
    Area = 0.2524495				# L = 3.96
    eos = eos
  [../]  

  #[./pipe030] #placeholder
  #  type = PBOneDFluidComponent 
  #  eos = eos
  #  position = '0 7.92445 -0.76'
  #  orientation = '0 -1 0'
  #  roughness = 0.000015
  #  A = 0.2524495
  #  Dh = 0.5669468
  #  length = 3.96
  #  n_elems = 
  #[../]

  [./pipe040] #Hot salt extraction pipe (4)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 3.96445 -0.76'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.2512732
    Dh = 0.5656244
    length = 3.77
    n_elems = 21
  [../] 

  [./pipe160] #Downcomer to DHX (16)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 1 -0.58'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 0.58
    n_elems = 3
  [../]  

  [./DHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
    hs_type = cylinder

    radius_i = 0.00545
    position = '0 0.5 0'
    orientation = '0 0 1'
    A = 0.2224163
    Dh = 0.01085449
    A_secondary = 0.1836403
    Dh_secondary = 0.0109
    roughness = 0.000015
    roughness_secondary = 0.000015
    length = 2.5
    n_elems = 14

    initial_V = 0.11969487  
    initial_V_secondary = 0.029349731 
    initial_T = 925

    HT_surface_area_density = 353.0303766
    HT_surface_area_density_secondary = 366.9724771
    Hw = 526.266
    Hw_secondary = 440
    
    Twall_init = 900
    wall_thickness = 0.0009
    dim_wall = 2
    material_wall = ss-mat
    n_wall_elems = 4
  [../]

  [./pipe180] #DHX to hot leg (18)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 1 2.5'
    orientation = '0 2.96445 .51'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.008
    n_elems = 17
  [../]

  [./Branch260] #Top branch (26)		(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch 
    inputs = 'pipe180(out) pipe040(out)'	# A = 0.03534292	A = 0.2512732
    outputs = 'pipe050(in)'   			# A = 0.264208
    center = '0 4.21445 3.01' 
    volume = 0.132104
    K = '0.0 0.0 0.0'				# Compute these
    Area = 0.264208					# L = 0.5
    eos = eos
  [../]

  #[./pipe260] #placeholder
  #  type = PBOneDFluidComponent 
  #  eos = eos
  #  position = '0 3.96445 3.01'
  #  orientation = '0 1 0'
  #  roughness = 0.000015
  #  A = 0.264208
  #  Dh = 0.58
  #  length = 0.5
  #  n_elems = 
  #[../]  

  [./inlet1]
  	type = PBTDJ
	input = 'DHX(secondary_out)'
     eos = eos
     v_bc =  0.02879044 #10.697 kg/s in total
  	T_bc = 799.15
  [../]
 
  [./outlet1]
  	type = PBTDV
  	input = 'DHX(secondary_in)'
     eos = eos
  	p_bc = 10.5e4
  	T_bc = 973
  [../] 
[]

[Postprocessors]
 

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
  type = Steady
  #type = Transient  

  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  #dt = 1e-2
  #dtmin = 1e-8

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-5
  nl_max_its = 100

  #start_time = 0.0
  #num_steps = 15000
  #end_time = 100

  l_tol = 1e-5 # Relative linear tolerance for each Krylov solve
  l_max_its = 200 # Number of linear iterations for each Krylov solve

   [./Quadrature]
      type = TRAP
      order = FIRST
   [../]
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






