[GlobalParams] #for comparison of steady state dracs performance , prior to full-pbfhr model
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
    k = 40
    Cp = 583.333
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

    position = '0 0 0'
    orientation = '0 0 1'
    A = 0.222
    Dh = 0.0109
    A_secondary = 0.1840
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

    HT_surface_area_density = 354.411275 #Heated perimeter / AreaX
    HT_surface_area_density_secondary = 366.999488
    
    Twall_init = 900
    wall_thickness = 0.0009
    
    dim_wall = 2
    material_wall = ss-mat
    n_wall_elems = 8
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

  #[./pipe230] #TCHX salt tube (23)
  #  type = PBOneDFluidComponent 
  #  eos = eos
  #  position = '0 -3.67 8.55'
  #  orientation = '5.407402334 0 -2.6'
  #  roughness = 0.000015
  #  A = 0.1746822
  #  Dh = 0.0109
  #  length = 6.0
  #  n_elems = 34

  #  initial_V = 0.04855862
  #[../] 
  
		  [./TCHX]
		    type = PBHeatExchanger
		    eos = eos
		    eos_secondary = eos2

		    position = '0 -3.67 8.55'
		    orientation = '5.407402334 0 -2.6'
		    orientation_secondary = '0 0 -1'

		    A = 0.175
		    Dh = 0.0109
		    A_secondary = 0.382584
		    Dh_secondary = 0.0109
		    length = 6.0
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

		    HT_surface_area_density = 366.893142
		    HT_surface_area_density_secondary = 402.7746 #Scaled to satisfy Phf conditions 
		    
		    Twall_init = 800
		    wall_thickness = 0.0009
		    
		    dim_wall = 1
		    material_wall = ss-mat
		    n_wall_elems = 12
		  [../]

  [./pipe240] #DRACS cold leg 1 (24)
    type = PBOneDFluidComponent 
    eos = eos
    position = '0 -3.67 5.95'
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
    position = '0 0 5.95'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 5.95
    n_elems = 34
  [../] 
  
  [./Branch502] #DRACS tank branch (CHECK ABRUPT AREA CHANGE MODEL)
    type = PBVolumeBranch 
    inputs = 'pipe200(out)'
    outputs = 'pipe210(in) pipe5(in)'
    center = '0 0 5.95' 
    volume = 0.003534292 #0.003534292
    K = '0.0 0.0 0.0'
    Area = 0.03534292
    eos = eos
  [../]

  [./Branch610] #In to DRACS hot leg 1 (CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'DHX(secondary_in)'
    outputs = 'pipe200(in)'
    eos = eos
    K = '0.366 0.366'
    Area = 0.03534292
  [../]

  [./Branch611] #In to TCHX manifold
    type = PBSingleJunction
    inputs = 'pipe210(out)'
    outputs = 'pipe220(in)'
    eos = eos
  [../]

  [./Branch612] #In to TCHX salt tube (CHECK ABRUPT AREA CHANGE MODEL)
    type = PBSingleJunction
    inputs = 'pipe220(out)'
    outputs = TCHX(primary_in) #'pipe230(in)'
    eos = eos
  [../]

  [./Branch613] #In to DRACS cold leg 1 (CHECK ABRUPT AREA CHANGE MODEL)
    type = PBSingleJunction
    inputs = TCHX(primary_out) #'pipe230(out)'
    outputs = 'pipe240(in)'
    eos = eos
  [../]
  
  [./Branch614] #In to DRACS cold leg 2
    type = PBSingleJunction
    inputs = 'pipe240(out)'
    outputs = 'pipe250(in)'
    eos = eos
  [../]

  [./Branch615] #In to DHX tube side (CHECK ABRUPT AREA CHANGE MODEL)
    type = PBSingleJunction
    inputs = 'pipe250(out)'
    outputs = 'DHX(secondary_out)'
    eos = eos
  [../]

  [./pipe5] #Pipe to DRACS tank branch
    type = PBOneDFluidComponent
    eos = eos3
    position = '0 0 5.95'
    orientation = '0 0 1'
    
    A = 1
    Dh = 0.15
    length = 0.1
    n_elems = 1
  [../]

  [./pool1] #DRACS tank branch
    type = PBLiquidVolume
    center = '0 0 7.05'
    inputs = 'pipe5(out)'
    Steady = 1
    K = '0.5'
    Area = 1
    volume = 0.9
    initial_level = 0.4
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
	initial_Vol = 0.5
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
  	T_bc = 973
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
    heated_perimeter = 64.2063
    block = 'TCHX:primary_pipe'
    #execute_on = timestep_end
  [../]
  [./TCHX_out]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 154.095 #76.924338 
    block = 'TCHX:secondary_pipe'
    #execute_on = timestep_end
  [../]
  [./DHX_in]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 78.679303
    block = 'DHX:primary_pipe'
    execute_on = timestep_end
  [../]
  [./DHX_out]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 67.527906
    block = 'DHX:secondary_pipe'
    execute_on = timestep_end
  [../]
  [./coldleg]
    type = ComponentNodalVariableValue
    input = 'pipe250(0)'
    variable = 'temperature'
  [../]
  [./corecold]
    type = ComponentBoundaryVariableValue
    input = 'DHX:primary_pipe(in)'
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






