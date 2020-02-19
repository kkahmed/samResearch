[GlobalParams] #
    global_init_P = 3.0e5
    global_init_V = 0.356535 #0.06 #0.29
    global_init_T = 854.8076
    #Tsolid_sf = 1e-3

  [./PBModelParams]
    #pspg = true
    p_order = 2
    #pbm_scaling_factors = '1 1e-2 1e-5'
    #variable_bounding = true
    #V_bounds = '0 10'
  [../]
[]


[EOS]
	active = 'eos eos4'
  [./eos]
  	type = SaltEquationOfState
  [../]
  [./eos4]
  	type = SaltEquationOfState
    salt_type = FlibeSolid
  [../]
[]

[MaterialProperties]
  [./ss-mat]
    type = SolidMaterialProps
    k = 5
    Cp = 638
    rho = 6e3
  [../]
[]

[AuxVariables]
  [./solidQEff]
    order = FIRST
    family = MONOMIAL
  [../]
  [./solidQOutEff]
    order = FIRST
    family = MONOMIAL
  [../]
  [./freezing_matprop]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./reynolds]
    order = FIRST
    family = MONOMIAL
  [../]
  [./friction]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./solidQEff]
    type = MaterialRealAux
    variable = solidQEff
    property = Q_effective
    factor = -1
    block = TCHX
  [../]
  [./solidQOutEff]
    type = MaterialRealAux
    variable = solidQOutEff
    property = Q_OutEffective
    factor = -1
    block = TCHX
  [../]
  [./freeze_rate]
    type = MaterialRealAux
    variable = freezing_matprop
    property = freezing_rate
    block = TCHX
  []
  [./reynolds_alpha]
    type = MaterialRealAux
    variable = reynolds
    property = Re_alpha
    block = TCHX
  []
  [./ff_alpha]
    type = MaterialRealAux
    variable = friction
    property = friction_alpha
    block = TCHX
  []
[]

[Functions]
  [./time_stepper_sub]
    type = PiecewiseLinear
    x = '0.0  25   26   6100 6101 10800 10801 12000 12001 5e5'
    y = '1.0  1.0  1.0  1.0  1.0  1.0   1.0   1.0   1.0   1.0'
  [../]
  [./T_perturb]
    type = PiecewiseLinear
    x = '0    400   800   6100    6300    9000    9300    21600'
    y = '993  993   993   993     993     993     993     993'
  [../]
  [./Q_perturb2]
    type = PiecewiseLinear
    x = '0       50  100   500   600 1e5'
    y = '4.0e6 1.0e7 8.0e6 8.0e6 1.2e7 1.2e7'
  [../]
  [./PumpFN]
    type = PiecewiseLinear
    x = '0    100  200 2000  1e5'
    y = '2000 2000 2000 2000 2000'
  [../]
  [./PBTDVTemp]
    type = ParsedFunction
    vals = 'pipe5out'
    vars = 'poolTemp'
    value = poolTemp
  [../]
  [./htc_ext]
    type = PiecewiseLinear
    x = '0   400 800 6100 6300 9000 9300 21600'
    y = '30  30  30  30   30   30   30   30'
  [../]
  [./temp_ext]
    type = PiecewiseLinear
    x = '0   140 21600'
    y = '373 373 373'
  [../]
[]

[Components]
  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '4.52 0 0'
    orientation = '-1 0 0'

    A = 0.01767146
    Dh = 0.15
    length = 4.52
    n_elems = 5
    #f = 0.03903
    #initial_T = 1129
  [../]

  [./DHX]
   type = PBOneDFluidComponent
   eos = eos

   position = '0 0.0 0'
   orientation = '0 0 1'
   A = 0.09182015
   Dh = 0.0109
   roughness = 0.000015
   length = 2.5
   n_elems = 14

   initial_V = 0.068618
   heat_source = Q_perturb2
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos = eos
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
    eos = eos
    position = '0 0 5.98'
    orientation = '1 0 0'

    A = 0.01767146
    Dh = 0.15
    length = 4.01
    n_elems = 5
    #f = 0.03903
    #initial_T = 1353
  [../]


  [./TCHX]
    type = PBOneDFluidComponent
    eos = eos
    position = '4.01 0 5.98'
    orientation = '6 0 0'

    A = 0.0873412
    Dh = 0.0109
    roughness = 0.000015
    length = 6
    n_elems = 50
    initial_V = 0.068618

    solid_phase = true
    eos_solid = eos4
    r_total = 0.00545
    h_rad = 0.0
    htc_ext = htc_ext
    temp_ext = temp_ext
    freeze_model = Linear2
  [../]

  [./Structure]
    type = PBCoupledHeatStructure
    HS_BC_type = 'Coupled Temperature'
    elem_number_radial = 3
    elem_number_axial = 50
    length = 6.0
    material_hs = 'ss-mat'
    width_of_hs = 0.003

    position = '4.01 0 4.98'
    orientation = '6 0 0'
    hs_type = cylinder
    radius_i = 0.00545
    dim_hs = 2

    Ts_init = 773
    T_bc_right = 773
    name_comp_left = TCHX
    eos_left = eos
    HT_surface_area_density_left = 367
  []

  [./pipe4]
    type = PBOneDFluidComponent
    eos = eos
    position = '4.52 0 5.98'
    orientation = '0 0 -1'

    A = 0.01767146
    Dh = 0.15
    length = 5.98
    n_elems = 5
    #f = 0.03903
    #initial_T = 1129
  [../]

  [./Branch1]
    type = PBBranch
    inputs = 'pipe1(out)'
    outputs = 'DHX(in)'
    eos = eos
    Area = 0.01767146
    K = '1.0 1.0'
  [../]

  [./Branch2]
    type = PBBranch
    inputs = 'DHX(out)'
    outputs = 'pipe2(in)'
    eos = eos
    Area = 0.01767146
    K = '1.0 1.0'
  [../]


  [./Branch3]
    type = PBVolumeBranch
    inputs = 'pipe2(out)'
    outputs = 'pipe3(in) pipe5(in)'
    center = '0 0 5.98'
    volume = 0.001767146
    K = '0.0 0.0 10.0'
    Area = 0.01767146
    eos = eos
  [../]

  [./Branch4]
    type = PBSingleJunction
    inputs = 'pipe3(out)'
    outputs = 'TCHX(in)'
    eos = eos
    alphas_outlet = true
    nodal_Tbc = true
  [../]

  [./Branch5]
    type = PBSingleJunction
    inputs = 'TCHX(out)'
    outputs = 'pipe4(in)'
    eos = eos
    alphas_inlet = true
    nodal_Tbc = true
  [../]

  #[./Branch6]
  #  type = PBSingleJunction
  #  inputs = 'pipe4(out)'
  #  outputs = 'pipe1(in)'
  #  eos = eos
  #[../]
  [./Pump_p]
    type = PBPump                               # This is a PBPump component
    eos = eos
    inputs = 'pipe4(out)'
    outputs = 'pipe1(in)'
    K = '0. 0.'                                 # Form loss coefficient at pump inlet and outlet
    Area = 0.01767146                           # Reference pump flow area
    #initial_P = 1.5e5                           # Initial pressure
    Head_fn = PumpFN                                  # Pump head, Pa
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 5.98'
    orientation = '0 0 1'

    A = 0.01767146
    Dh = 0.15
    length = 0.5
    n_elems = 5
    #initial_T = 1353
  [../]
  [./p_out]
  	type = PBTDV
  	input = 'pipe5(out)'
    eos = eos
  	p_bc = 1.01e5
  	T_fn = PBTDVTemp
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
    input = TCHX(in)
    scale_factor = 19.92709
    execute_on = timestep_end
  [../]
  [./TCHX_umin]
    type = ComponentBoundaryVariableValue
    input = TCHX(out)
    variable = velocity
    execute_on = timestep_end
  [../]
  [./TCHX_umax]
    type = ComponentBoundaryVariableValue
    input = TCHX(in)
    variable = velocity
    execute_on = timestep_end
  [../]
  [./DHX_Gr1]
    type = ComponentBoundaryVariableValue
    input = DHX(out)
    variable = temperature
    scale_factor = 4.390e10
    execute_on = timestep_end
  [../]
  [./DHX_Gr2]
    type = ComponentBoundaryVariableValue
    input = DHX(in)
    variable = temperature
    scale_factor = 4.390e10
    execute_on = timestep_end
  [../]
  [./DHX_Gr]
    type = DifferencePostprocessor
    value1 = DHX_Gr1
    value2 = DHX_Gr2
    execute_on = timestep_end
  [../]
  #[./TCHX_q]
  #  type = HeatExchangerHeatRemovalRate
  #  heated_perimeter = 32.05178 #64.10357
  #  block = 'TCHX:primary_pipe'
  #  execute_on = timestep_end
  #[../]
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
  [./Residence]
    type = ResidenceTime
    comp_names = 'pipe1 DHX pipe2 pipe3 TCHX pipe4'
    execute_on = timestep_end
  [../]
  [./pipe5out]
    type = ComponentBoundaryVariableValue
    input = 'pipe5(out)'
    variable = 'temperature'
  [../]
  [./timestep_pp]
    type = FunctionValuePostprocessor
    function = time_stepper_sub
  [../]
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -snes_type -snes_linesearch_type'
    petsc_options_value = 'lu vinewtonrsls basic'
  [../]
  [./FDP]
    type = FDP
    full = true
    solve_type = 'PJFNK'
  [../]
[] # End preconditioning block


[Executioner]
  type = Transient

  petsc_options = '-snes_monitor -snes_linesearch_monitor'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  [./TimeStepper]
    type = FunctionDT
    function = time_stepper_sub
    min_dt = 1e-3
  [../]

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-5
  nl_max_its = 30

  start_time = 0.0
  num_steps = 20000
  end_time = 3600

  l_tol = 1e-4 # Relative linear tolerance for each Krylov solve
  l_max_its = 50 # Number of linear iterations for each Krylov solve

  [./Quadrature]
    type = GAUSS
    order = SECOND
  [../]
[]

[Outputs]
  perf_graph = true
  # print_linear_residuals = true
  [./cp]
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
  [../]
[]

# [Debug]
#   show_var_residual_norms = true
# []
