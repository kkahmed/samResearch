[GlobalParams] 
    global_init_P = 1.0e5
    global_init_V = 0.1525 
    global_init_T = 350  
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
     salt_type = DowthermA
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
[]


[Components]

  [./pipe030a] #DHX Tube Side (DRACS) Bottom
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 0'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.000718
    Dh = 0.00693
    length = 0.11113
    n_elems = 1
  [../]  

  [./pipe030] #DHX Tube Side (DRACS)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0.11113'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.000718
    Dh = 0.00693
    length = 1.18745
    n_elems = 11

    #WF_user_option = User
    #User_defined_WF_parameters = '32.1 4974.4 -1.0'

    heat_source = 1172898
    #heat_source = 38815787
    #HT_surface_area_density
    #Ts_init
    #elem_number_of_hs
    #material_hs
    #n_heatstruct
    #name_of_hs
    #width_of_hs
  [../] 

  [./pipe030b] #DHX Tube Side (DRACS) Top
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 1.29858'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.000718
    Dh = 0.00693
    length = 0.18416
    n_elems = 2
  [../]  

  [./pipe031] #DHX Outlet Mixer (DRACS loop)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 1.48274'
    orientation = '0 0 1'
    f=0 #roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 0.33
    n_elems = 1
  [../]  

  [./pipe031a] #DHX Outlet Mixer Pipe (DRACS loop)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 1.81274'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 0.14308
    n_elems = 1
  [../]  

  [./pipe032] #DRACS hot leg 1
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 1.95582'
    orientation = '0 -0.581798 0.813333'
    roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 0.23812
    n_elems = 2
  [../] 

  [./pipe033] #DRACS hot leg 2
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 2.5'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 3.01
    n_elems = 28
  [../] 

  [./pipe035a] #TCHX Horizontal
    type = PBPipe 
    eos = eos
    position = '0 -1 6'
    orientation = '0 -1 0'
    f=0 #roughness = 0.000015
    A = 0.00133
    Dh = 0.0119
    length = 1.14851
    n_elems = 11

    HS_BC_type = Temperature
    Hw = 
    #Ph = 
    HT_surface_area_density = 
    T_wall = 
    Twall_init = 300
    hs_type = cylinder
    material_wall = ss-mat
    n_wall_elems = 5
    radius_i = 0.00595
    wall_thickness = 0.000406
    p_order = 2
  [../] 	 

  [./pipe035b] #TCHX Vertical
    type = PBPipe 
    eos = eos
    position = '0 -2.5 6'
    orientation = '0 0 -1'
    f=0 #roughness = 0.000015
    A = 0.00133
    Dh = 0.0119
    length = 0.41592
    n_elems = 4

    HS_BC_type = Temperature
    Hw = 
    #Ph = 
    HT_surface_area_density = 
    T_wall = 
    Twall_init = 300
    hs_type = cylinder
    material_wall = ss-mat
    n_wall_elems = 5
    radius_i = 0.00595
    wall_thickness = 0.000406
    p_order = 2
  [../] 	  

  [./pipe036] #TCHX Outlet Mixer
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 -2.5 5.5'
    orientation = '0 0.5150788 -0.8571429'
    f=0 #roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 0.33
    n_elems = 1
  [../] 

  [./pipe036a] #TCHX Outlet Mixer Pipe
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 -2.5 5.5'
    orientation = '0 0.5150788 -0.8571429'
    roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 0.2034
    n_elems = 2
  [../] 
  
  [./pipe037] #DRACS cold leg 1
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 -2.5 5'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 1.7736
    n_elems = 16
  [../] 

  [./pipe037a] #DRACS Flowmeter
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 -2.5 3.2'
    orientation = '0 0 -1'
    f=0 #roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 0.36
    n_elems = 1
  [../] 
  
  [./pipe038] #DRACS cold leg 2
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 -2.5 2.9'
    orientation = '0 0.6099332 -0.79245283'
    roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 0.33654
    n_elems = 3
  [../] 

  [./pipe039] #DRACS cold leg 3
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 -2.5 2.5'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.000611
    Dh = 0.0279
    length = 1.91142
    n_elems = 18
  [../] 

  [./Branch034] #DRACS tank branch 
    type = PBVolumeBranch 
    inputs = 'pipe033(out)'			# A = 
    outputs = 'pipe402(in) pipe035a(in)'   # A =  A = 
    center = '0 0 6' 
    volume = 0.000337547
    K = '2.75 0.0 4.25'
    Area = 0.000611
    eos = eos
  [../]

  [./pipe402] #Pipe to DRACS tank
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 0 6'
    orientation = '0 0 1'
    A = 1
    Dh = 1.12838
    length = 0.1
    n_elems = 1
  [../]

  [./pool402] #DRACS tank
    type = PBLiquidVolume
    center = '0 0 6.55'
    inputs = 'pipe402(out)'
    Steady = 1
    K = '0.0'
    Area = 1
    volume = 0.9
    initial_level = 0.4
    initial_V = 0.0
    #scale_factors = '1 1e-1 1e-2'
    display_pps = true
    covergas_component = 'cover_gas1'
    #eos = eos3
  [../]

  [./cover_gas1]
	type = CoverGas
	n_liquidvolume = 1
	name_of_liquidvolume = 'pool402'
	initial_P = 2e5
	initial_Vol = 0.5
  [../]
 
  [./Branch531] 
    type = PBSingleJunction
    inputs = 'pipe030a(out)'
    outputs = 'pipe030(in)'
    eos = eos
  [../]

  [./Branch532] 
    type = PBBranch
    inputs = 'pipe030(out)' 		
    outputs = 'pipe030b(in)' 		
    eos = eos
    K = '3.3 3.3'
    Area = 0.000718
  [../]

  [./Branch533] 
    type = PBSingleJunction
    inputs = 'pipe030b(out)'
    outputs = 'pipe031a(in)'
    eos = eos
  [../]

  [./Branch534] 
    type = PBBranch
    inputs = 'pipe031a(out)' 		
    outputs = 'pipe031(in)' 		
    eos = eos
    K = '3.3 3.3'
    Area = 0.000718
  [../]

  [./inlet1]
  	type = PBTDJ
	input = 'DHX(primary_in)'
     eos = eos
    #v_bc =  -0.0453228 #9.77 kg/s in each loop
     v_bc =  0.11969487 #-51.604 kg/s in total
  	T_bc = 873.61
  [../]
 
  [./outlet1]
  	type = PBTDV
  	input = 'DHX(primary_out)'
     eos = eos
  	p_bc = 10.5e4
  	T_bc = 863
  [../] 
[]

[Postprocessors]
  [./DHX_flow]
    type = ComponentBoundaryFlow 
    input = DHX(secondary_out)
    #execute_on = timestep_end
  [../]
  [./DHX_q]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 78.51971015
    block = 'DHX:primary_pipe'
    execute_on = timestep_end
  [../]
  #[./DHX_out]
  #  type = HeatExchangerHeatRemovalRate
  #  heated_perimeter = 67.39093233
  #  block = 'DHX:secondary_pipe'
  #  execute_on = timestep_end
  #[../]
  [./dracscold]
    type = ComponentNodalVariableValue
    input = 'pipe250(0)'
    variable = 'temperature'
  [../]
  [./dracshot]
    type = ComponentNodalVariableValue
    input = 'pipe210(0)'
    variable = 'temperature'
  [../]
  #[./DHXshellBot]
  #  type = ComponentBoundaryVariableValue
  #  input = 'DHX:primary_pipe(in)'
  #  variable = 'temperature'
  #[../]
  #[./DHXshellTop]
  #  type = ComponentBoundaryVariableValue
  #  input = 'DHX:primary_pipe(out)'
  #  variable = 'temperature'
  #[../]
  [./DHXshellBot]
	type = ComponentNodalVariableValue
	input =  'DHX:primary_pipe(0)'
	variable = 'temperature'
  [../]
  [./DHXshellTop]
	type = ComponentNodalVariableValue
	input =  'DHX:primary_pipe(14)'
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






