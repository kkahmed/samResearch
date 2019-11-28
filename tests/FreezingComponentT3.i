[GlobalParams]
  global_init_P = 1e5
  global_init_V = 0.22
  global_init_T = 860
  [./PBModelParams]
    #pbm_scaling_factors = '1 1e-2 1e-6'
    #variable_bounding = true
    #V_bounds = '0 10'
    #supg_max = true
    p_order = 1
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
  [./reynolds_a]
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
    block = pipe1
  [../]
  [./solidQOutEff]
    type = MaterialRealAux
    variable = solidQOutEff
    property = Q_OutEffective
    factor = -1
    block = pipe1
  [../]
  [./freeze_rate]
    type = MaterialRealAux
    variable = freezing_matprop
    property = freezing_rate
    block = pipe1
  []
  [./reynolds_alpha]
    type = MaterialRealAux
    variable = reynolds_a
    property = Re_alpha
    block = pipe1
  []
  [./ff_alpha]
    type = MaterialRealAux
    variable = friction
    property = friction_alpha
    block = pipe1
  []
[]

[Functions]
  [./v_in]
    type = PiecewiseLinear
    x = '0    140  21600'
    y = '0.22 0.22 0.22'
  [../]
  [./p_out]
    type = PiecewiseLinear
    x = '0   100'
    y = '1e5 1e5'
  [../]
  [./time_stepper_sub]
    type = PiecewiseLinear
    x = '0.0  25   26   6100 6101 10800 10801 12000 12001 5e5'
    y = '2.0 2.0 2.0 2.0 2.0 2.0  2.0  2.0  2.0  2.0'
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
    y = '75  75  90  90  70   70    90   90'
  [../]
  [./temp_ext]
    type = PiecewiseLinear
    x = '0   140 21600'
    y = '373 373 373'
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

  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 4'
    orientation = '3 0 -4'

    A = 0.07854
    Dh = 0.01
    length = 5.0
    n_elems = 100
    #Hw = 900

    solid_phase = true
    eos_solid = frozen
    r_total = 0.005
    h_rad = 2e-8
    htc_ext = htc_ext
    temp_ext = temp_ext
    freeze_model = Linear2
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos = eos
    position = '3 0 0'
    orientation = '1 0 0'
    offset = '2 0 0'

    A = 0.07854
    Dh = 0.1
    length = 3.0
    n_elems = 12
    # Hw = 900
  [../]

  [./Branch4]
    type = PBSingleJunction
    inputs = 'pipe0(out)'
    outputs = 'pipe1(in)'
    eos = eos
    # Area = 0.070686
    # K = '0.1 0.1'
    alphas_outlet = true
    nodal_Tbc = true
  [../]
  [./Branch5]
    type = PBSingleJunction
    inputs = 'pipe1(out)'
    outputs = 'pipe2(in)'
    eos = eos
    # Area = 0.070686
    # K = '0.1 0.1'
    alphas_inlet = true
    nodal_Tbc = true
  [../]

  [./inlet]
    type = PBTDJ
    input = 'pipe0(in)'
    eos = eos
    v_fn = v_in
    T_fn = T_in
  [../]
  [./outlet]
    type = PBTDV
    input = 'pipe2(out)'
    eos = eos
    p_bc = '1.0e5'
    freeze_bc = false
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
  [./timestep_pp]
    type = FunctionValuePostprocessor
    function = time_stepper_sub
  [../]
[../]

[Executioner]
  type = Transient

  petsc_options = '-snes_monitor -snes_linesearch_monitor'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '100'

  dt = 0.1                           # Targeted time step size
  dtmin = 1e-3                        # The allowed minimum time step size
  # [./TimeStepper]
  #   type = FunctionDT
  #   function = time_stepper_sub
  #   min_dt = 1e-3
  # [../]
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1.0
    optimal_iterations = 8
    growth_factor = 2
    iteration_window = 2
    cutback_factor = 0.5
    timestep_limiting_postprocessor = timestep_pp
  [../]

  # [./Quadrature]
  #   type = GAUSS
  #   order = SECOND
  # [../]
  [./Quadrature]
    type = TRAP
    order = FIRST
  [../]

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-5
  nl_max_its = 30
  l_tol = 1e-4 # Relative linear tolerance for each Krylov solve
  l_max_its = 50 # Number of linear iterations for each Krylov solve

  start_time = 0.0                    # Physical time at the beginning of the simulation
  num_steps = 20000                    # Max. simulation time steps
  end_time = 1200.0                     # Max. physical time at the end of the simulation
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
