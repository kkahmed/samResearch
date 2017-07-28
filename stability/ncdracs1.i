[GlobalParams] 
    global_init_P = 1.0e5
    global_init_V = 0.3 #0.1525 
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

    initial_V = -0.045 #0.11969487  
    initial_V_secondary = 0.06 #0.029349731 
    initial_T = 925

    HT_surface_area_density =  353.0303766 #441.287971 #
    HT_surface_area_density_secondary = 366.9724771 #458.715596 #
    #Hw = 526.266
    #Hw_secondary = 440
    
    Twall_init = 900
    wall_thickness = 0.0009
    dim_wall = 2
    material_wall = ss-mat
    n_wall_elems = 4
  [../]

  [./pipe200] #DRACS hot leg 1 (20)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 2.5'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.45
    n_elems = 20
  [../]  

  [./pipe210] #DRACS hot leg 2 (21)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 5.95'
    orientation = '0 -1 0'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.67
    n_elems = 21
  [../] 

  [./pipe220] #TCHX Manifold (22)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 -3.67 5.95'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 2.60
    n_elems = 15
  [../] 

  [./TCHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos2

    position = '0 -3.67 8.55'
    orientation = '0 -5.407402334 -2.6'
    orientation_secondary = '0 0 -1'
    roughness = 0.000015
    f_secondary = 0.045

    A = 0.1746822
    Dh = 0.0109
    A_secondary = 1.530336
    Dh_secondary = 0.0109
    length = 6.0
    length_secondary = 2.5 #2.73951413
    n_elems = 17

    Hw = 1.5e5
    Hw_secondary = 20.6241 #Converges, 100 does not

    initial_V = 0.0243 #0.04855862 #0.12341942  #0.23470
    initial_V_secondary = -9.21125 #Not scaled to preserve residence time
    initial_T_secondary = 374

    HT_surface_area_density = 366.972535
    HT_surface_area_density_secondary = 100.53195 #Scaled to satisfy Phf conditions 
    
    Twall_init = 800
    #radius_i = 0.00545
    wall_thickness = 0.0009
    
    dim_wall = 2
    material_wall = ss-mat
    n_wall_elems = 4
  [../]

  [./pipe240] #DRACS cold leg 1 (24)
    type = PBOneDFluidComponent 
    eos = eos
    position = '1 -4.43 5.95'
    orientation = '0 1 0'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 4.43
    n_elems = 25
  [../] 
  
  [./pipe250] #DRACS cold leg 2 (25)
    type = PBOneDFluidComponent 
    eos = eos
    position = '1 0 5.95'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 5.95
    n_elems = 34
  [../] 
  
  [./Branch502] #DRACS tank branch 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBVolumeBranch 
    inputs = 'pipe200(out)'			# A = 0.1836403
    outputs = 'pipe210(in) pipe1(in)'   # A = 0.1836403 A = 1
    center = '0 0 5.95' 
    volume = 0.003534292
    K = '0.0 0.0 0.3673'
    Area = 0.03534292
    eos = eos
  [../]

  [./Branch610] #In to DRACS hot leg 1	(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBBranch
    inputs = 'DHX(secondary_in)'		# A = 0.1836403
    outputs = 'pipe200(in)'			# A = 0.03534292
    eos = eos
    K = '0.3666 0.3666'
    #K = '56.3666 56.3666'
    #K = '44.2 44.2'    				# Match m without h specified
    #K = '45.5 45.5'    				# Match m with h specified
    #K = '45.2 45.2' 				# Match m with r5Flibe
    Area = 0.03534292
  [../]

  [./Branch611] #In to TCHX manifold
    type = PBSingleJunction
    inputs = 'pipe210(out)'
    outputs = 'pipe220(in)'
    eos = eos
  [../]

  [./Branch612] #In to TCHX salt tube 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'pipe220(out)' 			# A = 0.03534292
    outputs = 'TCHX(primary_in)' 		# A = 0.1746822
    eos = eos
    K = '0.3655 0.3655'
    #K = '0.0 0.3655'
    Area = 0.03534292
  [../]

  [./Branch613] #In to DRACS cold leg 1 (CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'TCHX(primary_out)' 		# A = 0.1746822
    outputs = 'pipe240(in)' 			# A = 0.03534292
    eos = eos
    K = '0.3655 0.3655'
    #K = '0.3655 0.0'
    Area = 0.03534292
  [../]
  
  [./Branch614] #In to DRACS cold leg 2
    type = PBSingleJunction
    inputs = 'pipe240(out)'
    outputs = 'pipe250(in)'
    eos = eos
  [../]

  [./Branch615] #In to DHX tube side 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'pipe250(out)' 			# A = 0.03534292
    outputs = 'DHX(secondary_out)' 	# A = 0.1836403
    eos = eos
    K = '0.3666 0.3666'
    #K = '0.0 0.3666'
    Area = 0.03534292
  [../]

  [./pipe1] #Pipe to DRACS tank
    type = PBOneDFluidComponent
    eos = eos #eos3
    position = '0 0 5.95'
    orientation = '0 0 1'
    A = 1
    Dh = 1.12838
    length = 0.1
    n_elems = 3
    initial_T = 852.7
    initial_V = 0.0
  [../]

  [./pool1] #DRACS tank
    type = PBLiquidVolume
    center = '0 0 6.5'
    inputs = 'pipe1(out)'
    Steady = 1
    K = '0.0'
    Area = 1
    volume = 0.9
    initial_level = 0.4
    initial_T = 852.7
    initial_V = 0.0
    #scale_factors = '1 1e-1 1e-2'
    display_pps = true
    covergas_component = 'cover_gas1'
    eos = eos #eos3
  [../]

  [./cover_gas1]
	type = CoverGas
	n_liquidvolume = 1
	name_of_liquidvolume = 'pool1'
	initial_P = 2e5
	initial_Vol = 0.5
	initial_T = 852.7
  [../]

  [./inlet1]
  	type = PBTDJ
	input = 'DHX(primary_out)'
     eos = eos
     v_bc =  -0.0453228 #9.77 kg/s in each loop
     #v_bc =  0.11969487 #-51.604 kg/s in total
  	T_bc = 973 #873.61
  [../]
 
  [./outlet1]
  	type = PBTDV
  	input = 'DHX(primary_in)'
     eos = eos
  	p_bc = 10.5e4
  	T_bc = 863
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
    input = DHX(primary_out)
    execute_on = timestep_end
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
  [./DHXTubeBot]
    type = ComponentBoundaryVariableValue
    input = 'DHX:secondary_pipe(in)'
    variable = 'temperature'
  [../]
  [./DHXTubeTop]
    type = ComponentBoundaryVariableValue
    input = 'DHX:secondary_pipe(out)'
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






