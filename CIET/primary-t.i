[GlobalParams] 
    global_init_P = 1.0e5
    global_init_V = 1.796
    global_init_T = 874 
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

  [./pipe010] #Active core region (1)	(FINISH HEAT STRUCTURE INPUT, CHECK CCFL)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 5.94445 -5.34'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 1.327511
    Dh = 0.03
    length = 4.58
    n_elems = 26
    initial_V = 0.290
    initial_T = 920
    initial_P = 2.6e5

    WF_user_option = User
    #User_defined_WF_parameters = '32.1 4974.4 -1.0'
    User_defined_WF_parameters = '0.210 32.583 -1.0'

    heat_source = 38815787
    #HT_surface_area_density
    #Ts_init
    #elem_number_of_hs
    #material_hs
    #n_heatstruct
    #name_of_hs
    #width_of_hs
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
    initial_V = 1.993
    initial_P = 2.6e5
  [../] 

  [./Branch030] #Outlet plenum (3)			(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch 
    inputs = 'pipe010(out) pipe020(out)'	# A = 1.327511 (0.2524495)	A = 0.065
    outputs = 'pipe040(in)'   			# A = 0.2512732
    center = '0 5.94445 -0.76' 
    volume = 0.99970002
    K = '0.3668 0.35336 0.0006'			# Check these
    Area = 0.2524495					# L = 3.96
    eos = eos
    initial_V = 2.040
    initial_T = 970
    initial_P = 1.7e5
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
    initial_V = 2.050
    initial_T = 970
    initial_P = 1.3e5
  [../] 

  [./pipe050] #Reactor vessel to hot salt well (5)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 4.46445 3.01'
    orientation = '0 3.72912 0.081'
    roughness = 0.000015
    A = 0.264208
    Dh = 0.58
    length = 3.73
    n_elems = 21
    initial_V = 2.05
    initial_T = 970
  [../] 

  [./pipe060] #Hot well (6)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 8.30 3.09' #'0 8.19357 3.091'
    orientation = '0 1.970888 0.34'
    roughness = 0.000015
    A = 3.3145
    Dh = 1.452610
    length = 2.00
    n_elems = 11
    initial_V = 0.164
    initial_T = 970
  [../] 

  [./pipe070] #Hot salt well to CTAH (7)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 10.271 3.43' 
    orientation = '0 3.22967 -0.046'
    roughness = 0.000015
    A = 0.3041
    Dh = 0.4399955
    length = 3.23
    n_elems = 18
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
  [../]

  [./pipe080] #CTAH hot manifold (8)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 13.5 3.384' 
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.4926017
    Dh = 0.28
    length = 3.418
    n_elems = 19
    initial_V = 1.100
    initial_T = 970
    initial_P = 4.9e5
  [../]

  [./pipe090] #CTAH tubes (salt side) (9)
    type = PBPipe 
    eos = eos
    position = '0 13.5 -0.034'
    orientation = '0 18.4692719 -0.164'
    roughness = 0.000015
    A = 0.4491779
    Dh = 0.004572
    length = 18.47
    n_elems = 99
    initial_V = 1.207
    initial_T = 920
    initial_P = 4.1e5

    HS_BC_type = Temperature
    Hw = 2000
    Ph = 392.9818537
    T_wall = 873.15
    Twall_init = 900
    hs_type = cylinder
    material_wall = ss-mat
    n_wall_elems = 4
    radius_i = 0.002286
    wall_thickness = 0.000889
  [../] 

  [./pipe100] #CTAH cold manifold (10)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 18.2055 -0.197'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.1924226
    Dh = 0.175
    length = 3.418
    n_elems = 19
    initial_V = 2.818
    initial_P = 2.8e5
  [../]

  [./pipe110] #CTAH to drain tank (11)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 18.2055 -3.615'
    orientation = '0 -3.4791917 -0.075'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 3.48
    n_elems = 20
    initial_P = 3.1e5
  [../]

  [./pipe120] #Stand pipe (12)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 14.7263 -3.69'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 6.51
    n_elems = 37
    initial_P = 2.5e5
  [../]

  [./pipe130] #Stand pipe to reactor vessel (13)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 14.7263 2.82'
    orientation = '0 -6.6018536 0.14'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 6.6033378
    n_elems = 37
    initial_P = 1.8e5
  [../]

  [./pipe140] #Injection plenum (14)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 8.12445 2.96'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 3.04
    n_elems = 17
    initial_P = 2.1e5
  [../]

  [./pipe150] #Downcomer (15)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 8.12445 -0.58'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.3038791
    Dh = 0.0560284
    length = 4.76
    n_elems = 27
    initial_V = 1.695
    initial_P = 2.9e5
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
    initial_V = 0.767
    initial_P = 2.5e5
  [../]  

  [./DHX] # DHX shell side (17), DHX tube side (19), DHX tubes structure
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

    initial_V = 0.122 #0.11969487  
    initial_V_secondary = 0.029349731 
    initial_T = 870
    initial_T_secondary = 830
    initial_P = 1.9e5
    initial_P_secondary = 2.0e5

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
    initial_V = 0.767
    initial_T = 860
    initial_P = 2.6e5
  [../]

  [./Branch260] #Top branch (26)			(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch 
    inputs = 'pipe180(out) pipe040(out)'	# A = 0.03534292	A = 0.2512732
    outputs = 'pipe050(in)'   			# A = 0.264208
    center = '0 4.21445 3.01' 
    volume = 0.132104
    K = '0.3713 0.00636 0.0'				# Check these
    Area = 0.264208						# L = 0.5
    eos = eos
    initial_V = 2.052
    initial_T = 970
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

  [./Branch270] #Middle branch (27)		(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch 
    inputs = 'pipe140(out)'				# A = 0.3019068	
    outputs = 'pipe150(in) pipe160(in)'   	# A = 0.3038791	A = 0.03534292
    center = '0 8.12445 -0.33'
    volume = 0.15193955
    K = '0.0 0.0 0.3727'					# Check these
    Area = 0.3038791					# L = 0.5
    eos = eos
    initial_V = 1.784
    initial_P = 2.5e5
  [../]

  #[./pipe270] #placeholder
  #  type = PBOneDFluidComponent 
  #  eos = eos
  #  position = '0 8.12445 -0.08'
  #  orientation = '0 -1 0'
  #  roughness = 0.000015
  #  A = 0.3038791
  #  Dh = 0.0560284
  #  length = 0.5
  #  n_elems = 
  #[../]  

  [./Branch280] #Bottom branch (28)		(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch 
    inputs = 'pipe150(out)'				# A = 0.3038791	
    outputs = 'pipe010(in) pipe020(in)'   	# A = 1.327511 	A = 0.065
    center = '0 8.02445 -5.34' 
    volume = 0.2655022
    K = '0.35964 0.0 0.3750'				# Check these
    Area = 1.327511						# L = 0.2
    eos = eos
    initial_V = 0.388
    initial_P = 3.4e5
  [../]  

  #[./pipe280] #placeholder
  #  type = PBOneDFluidComponent 
  #  eos = eos
  #  position = '0 8.12445 -5.34'
  #  orientation = '0 -1 0'
  #  roughness = 0.000015
  #  A = 1.327511
  #  Dh = 0.03
  #  length = 0.2
  #  n_elems = 
  #[../]

  [./pipe2] #Pipe to primary tank
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 8.25 3.09'
    orientation = '0 0 1'
    A = 1
    Dh = 1.12838
    length = 0.1
    n_elems = 3
    initial_V = 0.0
    initial_T = 970
  [../]

  [./pool2] #Primary Loop Expansion Tank
    type = PBLiquidVolume
    center = '0 8.25 3.64'
    inputs = 'pipe2(out)'
    Steady = 1
    K = '0.0'
    Area = 1
    volume = 0.9
    initial_level = 0.4
    initial_T = 970
    initial_V = 0.0
    #scale_factors = '1 1e-1 1e-2'
    display_pps = true
    covergas_component = 'cover_gas2'
    eos = eos3
  [../]

  [./cover_gas2]
	type = CoverGas
	n_liquidvolume = 1
	name_of_liquidvolume = 'pool2'
	initial_P = 9e4
	initial_Vol = 0.5
	initial_T = 970
  [../]

  [./Branch501] #Primary tank branch 		(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch 
    inputs = 'pipe050(out)'				# A = 0.264208 	
    outputs = 'pipe060(in) pipe2(in)'   	# A = 3.3145 (0.264208)	A = 1 (0.264208)
    center = '0 8.25 3.09' 
    volume = 0.0264208 
    K = '0 0.3744 0.35187'				# Check these
    Area = 0.264208 					# L = 0.2
    eos = eos
    initial_V = 2.052
    initial_T = 970
  [../]  

  #[./pipe501] #placeholder
  #  type = PBOneDFluidComponent 
  #  eos = eos
  #  position = '0 8.20 3.09' 
  #  orientation = '0 1 0'
  #  roughness = 0.000015
  #  A = 0.264208
  #  Dh = 0.58
  #  length = 0.1
  #  n_elems = 
  #[../]

  [./Branch601] # In to hot manifold
    type = PBBranch
    inputs = 'pipe070(out)'			# A = 0.3041
    outputs = 'pipe080(in)'			# A = 0.4926017
    eos = eos
    K = '0.16804 0.16804'
    Area = 0.3041
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
  [../]

  [./Branch602] # In to CTAH salt side
    type = PBBranch
    inputs = 'pipe080(out)'			# A = 0.4926017
    outputs = 'pipe090(in)'			# A = 0.4491779
    eos = eos
    K = '0.01146 0.01146'
    Area = 0.4491779
    initial_V = 1.207
    initial_T = 970
    initial_P = 5.2e5
  [../]

  [./Branch603] # In to cold manifold
    type = PBBranch
    inputs = 'pipe090(out)'			# A = 0.4491779
    outputs = 'pipe100(in)'			# A = 0.1924226
    eos = eos
    K = '0.28882 0.28882'
    Area = 0.1924226
    initial_V = 2.818
    initial_P = 2.5e5
  [../]

  [./Branch604] # In to pipe to drain tank
    type = PBBranch
    inputs = 'pipe100(out)'			# A = 0.1924226
    outputs = 'pipe110(in)'			# A = 0.3019068
    eos = eos
    K = '0.15422 0.15422'
    Area = 0.1924226
    initial_P = 3.1e5
  [../]

  [./Branch605] # In to stand pipe
    type = PBSingleJunction
    inputs = 'pipe110(out)'
    outputs = 'pipe120(in)'
    eos = eos
    initial_P = 3.1e5
  [../]

  [./Branch606] # In to pipe to reactor vessel
    type = PBSingleJunction
    inputs = 'pipe120(out)'
    outputs = 'pipe130(in)'
    eos = eos
    initial_P = 1.9e5
  [../]

  [./Branch607] # In to injection plenum
    type = PBSingleJunction
    inputs = 'pipe130(out)'
    outputs = 'pipe140(in)'
    eos = eos
    initial_P = 1.8e5
  [../]

  [./Diode608] # Fluidic diode		(CHECK FORWARD AND REVERSE K)
    type = PBPump
    inputs = 'pipe160(out)'			# A = 0.03534292
    outputs = 'DHX(primary_in)'		# A = 0.2224163
    eos = eos
    K = '50.0 50.0'
    K_reverse = '1.0 1.0'
    Area = 0.03534292
    initial_V = 0.767
    initial_P = 2.3e5
  [../]

  [./Branch609] # Out of DHX
    type = PBBranch
    inputs = 'DHX(primary_out)'		# A = 0.2224163
    outputs = 'pipe180(in)'			# A = 0.03534292
    eos = eos
    K = '100.3693 100.3693'				# Check K
    Area = 0.03534292
    initial_V = 0.767
    initial_P = 1.3e5
  [../]

  [./Pump] 
    type = PBPump
    inputs = 'pipe060(out)'		# A = 
    outputs = 'pipe070(in)'		# A = 
    eos = eos
    K = '0 0'
    Area = 0.3041
    Head = 369119
    initial_V = 1.783
    initial_T = 970
    initial_P = 2.7e5
  [../]

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
  	p_bc = 1.5e5
  	T_bc = 850
  [../] 
[]

[Postprocessors]
  [./DHX_flow]
    type = ComponentBoundaryFlow 
    input = DHX(primary_out)
    #execute_on = timestep_end
  [../]
  [./DHX_q]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 78.51971015
    block = 'DHX:primary_pipe'
    execute_on = timestep_end
  [../]
  [./DHXshellBot]
    type = ComponentBoundaryVariableValue
    input = 'DHX:primary_pipe(in)'
    variable = 'temperature'
  [../]
  [./DHXshellTop]
    type = ComponentBoundaryVariableValue
    input = 'DHX:primary_pipe(out)'
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

  dt = 1e-1
  dtmin = 1e-8

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-5
  nl_max_its = 100

  start_time = 0.0
  num_steps = 1500
  end_time = 1000

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






