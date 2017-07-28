[GlobalParams] 
    global_init_P = 1.0e5
    global_init_V = 0.15 #0.1525 
    global_init_T = 850  
    Tsolid_sf = 1e-3  

  [./PBModelParams]
	pspg = false
	pbm_scaling_factors = '1 1e-2 1e-5'
	#variable_bounding = true
	#V_bounds = '0 10'
	#scaling_velocity = 1
	p_order = 2
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
    k = 20
    Cp = 638
    rho = 6e3
  [../]
[]


[Components]

  [./pipe100]
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 1 0'
    orientation = '0 -1 0'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 1
    n_elems = 5
  [../] 

  [./DHX]
    type = PBOneDFluidComponent
    eos = eos3

    position = '0 0.0 0'
    orientation = '0 0 1'
    A = 0.1836403
    Dh = 0.0109
    roughness = 0.000015
    length = 2.5
    n_elems = 14

    initial_V = 0.029349731 
    heat_source = 10280985
  [../]

  [./pipe200] #DRACS hot leg 1 (20)
    type = PBOneDFluidComponent 
    eos = eos3
    position = '0 0 2.5'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.45
    n_elems = 5
  [../]  

  [./pipe220] #TCHX Manifold (22)
    type = PBOneDFluidComponent 
    eos = eos3
    position = '0 0 5.95'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 2.50
    n_elems = 3
  [../] 

  [./pipe300] #DRACS hot leg 2
    type = PBOneDFluidComponent 
    eos = eos3
    position = '0 0 8.45'
    orientation = '0 1 0'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 1.0
    n_elems = 5
  [../]

  [./TCHX]
    type = PBHeatExchanger
    eos = eos3
    eos_secondary = eos2

    position = '0 1 8.45'
    orientation = '23.86943652456 0 -2.5'
    orientation_secondary = '0 0 -1'
    roughness = 0.000015
    f_secondary = 0.045

    A = 0.0436706
    Dh = 0.0109
    A_secondary = 0.382584
    Dh_secondary = 0.0109
    length = 24
    length_secondary = 2.5 #2.73951413
    n_elems = 17

    Hw = 1.5e5
    Hw_secondary = 20.6241 #Converges, 100 does not

    initial_V = 0.04855862 #0.0243 #0.04855862 #0.12341942  #0.23470
    initial_V_secondary = -9.21125 #Not scaled to preserve residence time
    initial_T_secondary = 374

    HT_surface_area_density = 366.972535
    HT_surface_area_density_secondary = 402.1278 #Scaled to satisfy Phf conditions 
    
    Twall_init = 845
    #radius_i = 0.00545
    wall_thickness = 0.0009
    
    dim_wall = 2
    material_wall = ss-mat
    n_wall_elems = 4
  [../]

  [./pipe240] #DRACS cold leg 1 (24)
    type = PBOneDFluidComponent 
    eos = eos3
    position = '0 1 5.95'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 5.95
    n_elems = 7
  [../] 
  
  [./Branch502] #DRACS tank branch 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBVolumeBranch 
    inputs = 'pipe220(out)'			# A = 0.1836403
    outputs = 'pipe300(in) pipe1(in)'   # A = 0.1836403 A = 1
    center = '0 0 8.45' 
    volume = 0.03534292
    K = '0.0 0.0 10.3673'
    Area = 0.03534292
    eos = eos3
  [../]

  [./Branch610] #In to DRACS hot leg 1	(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBBranch
    inputs = 'DHX(out)'		# A = 0.1836403
    outputs = 'pipe200(in)'			# A = 0.03534292
    eos = eos3
    K = '0.3666 0.3666'
    #K = '56.3666 56.3666'
    #K = '44.2 44.2'    				# Match m without h specified
    #K = '45.5 45.5'    				# Match m with h specified
    #K = '45.2 45.2' 				# Match m with r5Flibe
    Area = 0.03534292
  [../]

  [./Branch611] #In to TCHX manifold
    type = PBSingleJunction
    inputs = 'pipe200(out)'
    outputs = 'pipe220(in)'
    eos = eos3
  [../]

  [./Branch612] #In to TCHX salt tube 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'pipe300(out)' 			# A = 0.03534292
    outputs = 'TCHX(primary_in)' 		# A = 0.1746822
    eos = eos3
    K = '0.3655 0.3655'
    #K = '0.0 0.3655'
    Area = 0.03534292
  [../]

  [./Branch613] #In to DRACS cold leg 1 (CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'TCHX(primary_out)' 		# A = 0.1746822
    outputs = 'pipe240(in)' 			# A = 0.03534292
    eos = eos3
    K = '0.3655 0.3655'
    #K = '0.3655 0.0'
    Area = 0.03534292
  [../]
  
  [./Branch614] #In to DRACS cold leg 2
    type = PBSingleJunction
    inputs = 'pipe240(out)'
    outputs = 'pipe100(in)'
    eos = eos3
  [../]

  [./Branch615] #In to DHX tube side 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'pipe100(out)' 			# A = 0.03534292
    outputs = 'DHX(in)' 	# A = 0.1836403
    eos = eos3
    K = '0.3666 0.3666'
    #K = '0.0 0.3666'
    Area = 0.03534292
  [../]

  [./pipe1] #Pipe to DRACS tank
    type = PBOneDFluidComponent
    eos = eos3 #eos3
    position = '0 0 8.45'
    orientation = '0 0 1'
    A = 0.03534292
    Dh = 0.15
    length = 0.1
    n_elems = 3
    initial_T = 852.7
    initial_V = 0.0
  [../]

  [./pool1] #DRACS tank
    type = PBLiquidVolume
    center = '0 0 9'
    inputs = 'pipe1(out)'
    Steady = 1
    K = '0.0'
    Area = 3
    volume = 2.7
    initial_level = 0.4
    initial_T = 852.7
    initial_V = 0.0
    #scale_factors = '1 1e-1 1e-2'
    display_pps = true
    covergas_component = 'cover_gas1'
    eos = eos3 #eos3
  [../]

  [./cover_gas1]
	type = CoverGas
	n_liquidvolume = 1
	name_of_liquidvolume = 'pool1'
	initial_P = 2e5
	initial_Vol = 1.5
	initial_T = 852.7
  [../]

  [./inlet2]
  	type = PBTDJ
	input = 'TCHX(secondary_in)'
    eos = eos2
	v_bc = -9.21125
  	T_bc = 374
  [../]
 
  [./outlet2]
  	type = PBTDV
  	input = 'TCHX(secondary_out)'
    eos = eos2
  	p_bc = 1.01e5
  	T_bc = 384
  [../]  
[]

[Postprocessors]
  [./DHX_flow]
    type = ComponentBoundaryFlow 
    input = DHX(in)
    execute_on = timestep_end
  [../]
  [./TCHX_q]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 64.10357
    block = 'TCHX:primary_pipe'
    execute_on = timestep_end
  [../]
  [./DHXTubeBot]
    type = ComponentBoundaryVariableValue
    input = 'DHX(out)'
    variable = 'temperature'
  [../]
  [./DHXTubeTop]
    type = ComponentBoundaryVariableValue
    input = 'DHX(in)'
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






