[GlobalParams] #double heat exchanger 
    global_init_P = 1.0e5
    global_init_V = 0.1525 #0.06 #0.29
    global_init_T = 850  
    Tsolid_sf = 1e-3  

  [./PBModelParams]
	pspg = false
	pbm_scaling_factors = '1 1e-1 1e-4'
	#variable_bounding = true
	#V_bounds = '0 10'
  [../]
[]


[EoS]
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
  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 1 0'
    orientation = '0 -1 0'
  
    A = 0.01767146
    Dh = 0.15
    length = 1
    n_elems = 1
    #f = 0.03903
  [../] 

  [./DHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
    hs_type = cylinder
    radius_i = 0.00545

    position = '0 0 0'
    orientation = '0 0 1'
    A = 0.1112081702
    Dh = 0.0108544891
    A_secondary = 0.09182015
    Dh_secondary = 0.0109
    length = 2.5
    n_elems = 8
    #f = 0.238
    #f_secondary = 0.045
    Hw = 582 #604.98482473 #Overall Ux2
    Hw_secondary = 582 #Overall Ux2

  	initial_V = -0.045 #0.23470 #0.104 #0.04855862 
	initial_V_secondary = 0.029349731 #0.0558126 #0.0115474345
	initial_T = 925

    HT_surface_area_density = 353.0303124
    HT_surface_area_density_secondary = 366.9724771
    
    Twall_init = 900
    wall_thickness = 0.0009
    
    dim_wall = 2
    material_wall = ss-mat
    n_wall_elems = 8
  [../]

  [./pipe2]
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 2.5'
    orientation = '0 0 1'
    
    A = 0.01767146
    Dh = 0.15
    length = 5.0
    n_elems = 3
    #f = 0.03903
  [../]  

  [./pipe3] 
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 0 7.50'
    orientation = '0 1 0'
    
    A = 0.01767146
    Dh = 0.15
    length = 1 
    n_elems = 1
    #f = 0.03903
  [../] 
  
  [./TCHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos2

    position = '0 1.0 7.5'
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
    Hw_secondary = 20.6241 #Converges, 100 does not

  	initial_V = 0.04855862 #0.12341942  #0.23470
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
    eos = eos
    position = '0 1.0 5.0'
    orientation = '0 0 -1'
    
    A = 0.01767146
    Dh = 0.15
    length = 5.0
    n_elems = 3
    #f = 0.03903
  [../] 
  
  [./Branch1]
    type = PBSingleJunction
    inputs = 'pipe1(out)'
    outputs = 'DHX(secondary_out)'
    eos = eos
  [../]

  [./Branch2]
    type = PBSingleJunction
    inputs = 'DHX(secondary_in)'
    outputs = 'pipe2(in)'
    eos = eos
  [../]


  [./Branch3]
    type = PBVolumeBranch #type=PBBranch 
    inputs = 'pipe2(out)'
    outputs = 'pipe3(in) pipe5(in)'
    center = '0 0 7.5' 
    volume = 0.01767146 #0.003534292
    K = '0.0 0.0 10.0'
    #Area =   0.44934 
    Area = 0.01767146
    #initial_P = 9.5e4
    eos = eos
  [../]

  [./Branch4]
    type = PBSingleJunction
    inputs = 'pipe3(out)'
    outputs = 'TCHX(primary_in)'
    eos = eos
  [../]

  [./Branch5]
    type = PBSingleJunction
    inputs = 'TCHX(primary_out)'
    outputs = 'pipe4(in)'
    eos = eos
  [../]
  
  [./Branch6]
    type = PBSingleJunction
    inputs = 'pipe4(out)'
    outputs = 'pipe1(in)'
    eos = eos
  [../]

  [./pipe5] 
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 0 7.5'
    orientation = '0 0 1'
    
    A = 0.01767146
    Dh = 0.15
    length = 0.1
    n_elems = 1
  [../]
  [./pool1]
    type = PBLiquidVolume
    center = '0 0 8.6'
    inputs = 'pipe5(out)'
    Steady = 1
    K = '0.5'
    Area = 3
    volume = 30
    initial_level = 5.0
    initial_T = 1011
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
	initial_P = 2e5
	initial_Vol = 15.0
	initial_T = 950
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
  	T_bc = 374
  [../]
 
  [./outlet2]
  	type = PBTDV
  	input = 'TCHX(secondary_out)'
    eos = eos2
  	p_bc = 1.01e5
  	T_bc = 384
  [../]  

  [./inlet1]
  	type = PBTDJ
	input = 'DHX(primary_out)'
    eos = eos
	v_bc = -0.045
  	T_bc = 1050
  [../]
 
  [./outlet1]
  	type = PBTDV
  	input = 'DHX(primary_in)'
    eos = eos
  	p_bc = 10.5e4
  	T_bc = 873
  [../] 
[]

[Postprocessors]
  [./DHX_flow]
    type = ComponentBoundaryFlow 
    input = DHX(secondary_out)
    #execute_on = timestep_end
  [../]
  [./TCHX_in]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 8.012946
    block = 'TCHX:primary_pipe'
    #execute_on = timestep_end
  [../]
  [./TCHX_out]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 76.924338 #70.198888
    block = 'TCHX:secondary_pipe'
    #execute_on = timestep_end
  [../]
  [./DHX_in]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 39.259855
    block = 'DHX:primary_pipe'
    #execute_on = timestep_end
  [../]
  [./DHX_out]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 33.695466
    block = 'DHX:secondary_pipe'
    #execute_on = timestep_end
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






