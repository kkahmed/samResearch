[GlobalParams]
  global_init_P = 1e5
  global_init_V = 0.4
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
  [./freezing_matprop]
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
    variable = freezing_matprop
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
    x = '0   150 250  1200 1350 2400 2550 3600 3750 4800 4950 6000 6150 8200 8350 21600'
    y = '0.4 0.4 0.3  0.3  0.4  0.4  0.3  0.3  0.4  0.4  0.3  0.3  0.4  0.4  0.3  0.3'
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
    x = '0   150 250  1200 1350 2400 2550 3600 3750 4800 4950 6000 6150 8200 8350 21600'
    y = '860 860 820  820  860  860  820  820  860  860  820  820  860  860  820  820'
  [../]
  [./htc_ext]
    type = PiecewiseLinear
    x = '0   150 250  1200 1350 2400 2550 3600 3750 4800 4950 6000 6150 8200 8350 21600'
    y = '50  50  80  80  50   50   80  80  50   50   80  80  50   50   80  80'
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
    # Hw = 300

    solid_phase = true
    eos_solid = frozen
    r_total = 0.005
    h_rad = 1e-8
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
    type = FDP
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
  end_time = 12000.0                     # Max. physical time at the end of the simulation

  [./Quadrature]
     type = GAUSS
     order = AUTO
  [../]
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

[Debug]
  show_var_residual_norms = true
[]
