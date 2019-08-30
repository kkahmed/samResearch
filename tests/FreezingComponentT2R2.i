[GlobalParams]
  global_init_P = 1e5
  global_init_V = 0.2
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
    variable = reynolds
    property = Re_alpha
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
    x = '0   140 21600'
    y = '0.2 0.2 0.2'
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
[]

[Components]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '0 1 0'

    A = 0.07854
    Dh = 0.01
    length = 5.0
    n_elems = 100
    # Hw = 900

    solid_phase = true
    eos_solid = frozen
    r_total = 0.005
    h_rad = 2e-8
    htc_ext = htc_ext
    #temp_ext = temp_ext
  [../]

  [./inlet]
    type = PBTDJ
    input = 'pipe1(in)'
    eos = eos
    v_fn = v_in
    T_fn = T_in
    freeze_bc = true
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

  start_time = 15.0                    # Physical time at the beginning of the simulation
  num_steps = 20000                    # Max. simulation time steps
  end_time = 1200.0                     # Max. physical time at the end of the simulation
[] # close Executioner section

[Outputs]
  perf_graph = true
  print_linear_residuals = true
  # [./cp]
  #   type = Checkpoint
  # [../]
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

[Problem]
  restart_file_base = 'FreezingComponent_cp_cp/0015'
[]

[Debug]
  show_var_residual_norms = true
[]
