[GlobalParams]
  global_init_P = 1e5
  global_init_V = 0.20
  global_init_T = 860
  [./PBModelParams]
    #pbm_scaling_factors = '1 1e-2 1e-6'
    #variable_bounding = true
    #V_bounds = '0 10'
    #supg_max = true
    p_order = 2
  [../]
[]

[EOS]
  [./eos]
  	type = SaltEquationOfState
  [../]
  [./frozen] #solid salt
    type = SaltEquationOfState
    salt_type = FlibeSolid
  [../]
[]

[AuxVariables]
  [./freezing]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./reynolds_a]
    order = SECOND
    family = MONOMIAL
  [../]
  [./reynolds]
    order = SECOND
    family = MONOMIAL
  [../]
  [./friction]
    order = SECOND
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./freeze_rate]
    type = MaterialRealAux
    variable = freezing
    property = freezing_rate
  []
  [./reynolds_alpha]
    type = MaterialRealAux
    variable = reynolds_a
    property = Re_alpha
  []
  [./reynolds]
    type = MaterialRealAux
    variable = reynolds
    property = Re
  []
  [./ff_alpha]
    type = MaterialRealAux
    variable = friction
    property = friction_alpha
  []
[]

[Functions]
  [./v_in]
    type = PiecewiseLinear
    x = '0    140  21600'
    y = '0.20 0.20 0.20'
  [../]
  [./p_out]
    type = PiecewiseLinear
    x = '0   100'
    y = '1e5 1e5'
  [../]
  [./time_stepper_sub]
    type = PiecewiseLinear
    x = '0.0  25   26   6100 6101 10800 10801 12000 12001 5e5'
    y = '1.0 1.0 1.0 1.0 1.0 1.0  1.0  1.0  1.0  1.0'
  [../]
  [./T_in]
    type = PiecewiseLinear
    x = '0   140 400 6100 6300 9000 9300 21600'
    y = '860 860 830 830  860  860  830  830'
    # type = ParsedFunction
    # value = 850+10*cos(pi*t/400)
  [../]
  [./htc_ext]
    type = PiecewiseLinear
    x = '0   140 400 6100 6300 9000 9300 21600'
    y = '75  75  140 140  70   70   140  140'
  [../]
  [./temp_ext]
    type = PiecewiseLinear
    x = '0   140 21600'
    y = '373 373 373'
  [../]
  [./fp0p1T]
    type = ParsedFunction
    vals = 'p0p1T'
    vars = 'T'
    value = T
  [../]
  [./fp0p1v]
    type = ParsedFunction
    vals = 'p0p1v'
    vars = 'v'
    value = v
  [../]
  [./fp0p1P]
    type = ParsedFunction
    vals = 'p0p1P'
    vars = 'P'
    value = P
  [../]
[]

[Components]
  [./pipe0]
    type = PBOneDFluidComponent
    eos = eos
    position = '-3 0 4'
    orientation = '1 0 0'

    A = 0.07854
    Dh = 0.1
    length = 3.0
    n_elems = 12
    # Hw = 900
  [../]

  [./p0p1a]
    type = PBTDV
    input = 'pipe0(out)'
    eos = eos
    p_fn = fp0p1P
  [../]

  [./p0p1b]
    type = PBTDJ
    input = 'pipe1(in)'
    eos = eos
    v_fn = fp0p1v
    T_fn = fp0p1T
    freeze_bc = true
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 4'
    orientation = '3 0 -4'

    A = 0.07854
    Dh = 0.01
    length = 5.0
    n_elems = 100
    Hw = 900

    solid_phase = true
    eos_solid = frozen
    r_total = 0.005
    h_rad = 2e-8
  [../]

  # [./pipe2]
  #   type = PBOneDFluidComponent
  #   eos = eos
  #   position = '3 0 0'
  #   orientation = '1 0 0'
  #   offset = '2 0 0'
  #
  #   A = 0.07854
  #   Dh = 0.1
  #   length = 3.0
  #   n_elems = 12
  #   # Hw = 900
  # [../]

  # [./Branch4]
  #   type = PBSingleJunction
  #   inputs = 'pipe0(out)'
  #   outputs = 'pipe1(in)'
  #   eos = eos
  #   # Area = 0.070686
  #   # K = '0.1 0.1'
  #   alphas_outlet = true
  #   nodal_Tbc = true
  # [../]
  # [./Branch5]
  #   type = PBSingleJunction
  #   inputs = 'pipe1(out)'
  #   outputs = 'pipe2(in)'
  #   eos = eos
  #   # Area = 0.070686
  #   # K = '0.1 0.1'
  #   alphas_inlet = true
  #   nodal_Tbc = true
  # [../]

  [./inlet]
    type = PBTDJ
    input = 'pipe0(in)'
    eos = eos
    v_fn = v_in
    T_fn = T_in
  [../]
  [./outlet]
    type = PBTDV
    input = 'pipe1(out)'
    eos = eos
    p_bc = '1.0e5'
    freeze_bc = true
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
[] # End preconditioning block

[Postprocessors]
  [./p0p1T]
    type = ComponentBoundaryVariableValue
    input = pipe0(out)
    variable = temperature
    execute_on = LINEAR
  [../]
  [./p0p1v]
    type = ComponentBoundaryVariableValue
    input = pipe0(out)
    variable = velocity
    execute_on = LINEAR
  [../]
  [./p0p1P]
    type = ComponentBoundaryVariableValue
    input = pipe1(in)
    variable = pressure
    execute_on = LINEAR
  [../]
[../]

[Executioner]
  type = Transient

  petsc_options = '-snes_monitor -snes_linesearch_monitor'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '100'

  dt = 0.1                           # Targeted time step size
  dtmin = 1e-3                        # The allowed minimum time step size
  [./TimeStepper]
    type = FunctionDT
    function = time_stepper_sub
    min_dt = 1e-3
  [../]

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-7
  nl_max_its = 20
  l_tol = 1e-4 # Relative linear tolerance for each Krylov solve
  l_max_its = 100 # Number of linear iterations for each Krylov solve

  start_time = 0.0                    # Physical time at the beginning of the simulation
  num_steps = 20000                    # Max. simulation time steps
  end_time = 10.0                     # Max. physical time at the end of the simulation
[] # close Executioner section

[Outputs]
  perf_graph = true
  print_linear_residuals = true
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

[Debug]
  show_var_residual_norms = true
[]
