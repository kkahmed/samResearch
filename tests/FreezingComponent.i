[GlobalParams]
  global_init_P = 1e5
  global_init_V = 0.1
  global_init_T = 802
[]

[EOS]
  [./eos]
  	type = SaltEquationOfState
  [../]
  [./frozen] #solid salt
  type = FrozenEquationOfState
  salt_type = Flibe
[../]
[]

[MaterialProperties]
[]

[Functions]
  [./v_in]
    type = PiecewiseLinear
    x = '0   100'
    y = '0.1 0.1'
  [../]
  [./p_out]
    type = PiecewiseLinear
    x = '0   100'
    y = '1e5 1e5'
  [../]
  [./time_stepper_sub]
    type = PiecewiseLinear
    x = '0.0  20   21  1e5'
    y = '0.1  0.1  1.0 1.0'
  [../]
  [./heat_out]
    type = PiecewiseLinear
    axis = x
    x = '0   2.5'
    y = '-1.2e6 -8.0e5'
  [../]
  [./T_in]
    type = PiecewiseLinear
    x = '0   100'
    y = '862 862'
  [../]
[]

[Components]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    eos_solid = frozen
    position = '0 0 0'
    orientation = '0 1 0'

    freezing_model = true

    A = 0.07854
    Dh = 0.01
    length = 2.5
    n_elems = 100
    Rt = 0.005

    f = 0.01
    Hw = 1e4
    h_int = 3000
    heat_ext = heat_out
    #HT_surface_area_density = 200
  [../]

  [./inlet]
    type = PBTDJ
    input = 'pipe1(in)'
    eos = eos
    v_bc = 1
    T_bc = 628.15
  [../]
  [./outlet]
    type = PBTDV
    input = 'pipe1(out)'
    eos = eos
    p_bc = '1.0e5'
  [../]
[]

#[Postprocessors]
#  [./heat_removal]
#    type = HeatExchangerHeatRemovalRate
#    heated_perimeter = 0.0628
#    block = 'pipe1'
#  [../]
#[]

[Preconditioning]
  active = 'SMP_PJFNK'

  [./SMP_PJFNK]
    type = SMP
    full = true

    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -mat_fd_type -mat_mffd_type'
    petsc_options_value = 'lu ds ds'
  [../]
[] # End preconditioning block


[Executioner]
  type = Transient

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
  num_steps = 10000                    # Max. simulation time steps
  end_time = 1000.0                     # Max. physical time at the end of the simulation

  #[./Quadrature]
  #  type = TRAP
  #  order = FIRST
  #[../]
[] # close Executioner section

[Outputs]
  perf_graph = true
  print_linear_residuals = false
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
