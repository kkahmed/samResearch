[GlobalParams]
  global_init_P = 1.1e5
  global_init_V = 0.5
  global_init_T = 628.15
  Tsolid_sf = 1e-1

  [./PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6'
    passive_scalar = traced_particle
    passive_scalar_diffusivity = 0
    global_init_PS = 200
    p_order = 2
    Courant_control = true
  [../]
[]

[EOS]
  [./eos]
    type = PBSodiumEquationOfState
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

    A = 0.44934
    Dh = 2.972e-3
    length = 1
    n_elems = 10
    f = 0.001
  [../]

  [./CH1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '0 0 1'

    A = 0.44934
    Dh = 2.972e-3
    length = 0.8
    n_elems = 10

    f = 0.022 #Mcadms
    heat_source = 5e7
    scalar_source = 1e4                # Volumetric scalar source
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0.8'
    orientation = '0 0 1'

    A = 0.44934
    Dh = 2.972e-3
    length = 5.18
    n_elems = 10
    f = 0.001
  [../]

  [./pipe3]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 5.98'
    orientation = '0 1 0'

    A = 0.44934
    Dh = 2.972e-3
    length = 1
    n_elems = 10
    f = 0.001
  [../]

  [./IHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos

    position = '0 0.976 5.98'
    orientation = '0 0 -1'
    A = 0.44934
    Dh = 0.0186
    A_secondary = 0.44934
    Dh_secondary = 0.0186
    length = 0.8
    n_elems = 10
    f = 0.022

    initial_V_secondary = -0.2

    HT_surface_area_density = 1e3
    HT_surface_area_density_secondary = 1e3

    Twall_init = 628.15
    wall_thickness = 0.004

    dim_wall = 1
    material_wall = ss-mat
    n_wall_elems = 2
    scalar_source = -1e4
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 1.0 5.18'
    orientation = '0 0 -1'

    A = 0.44934
    Dh = 2.972e-3
    length = 5.18
    n_elems = 10
    f = 0.001
  [../]

  [./Branch1]
    type = PBBranch
    inputs = 'pipe1(out)'
    outputs = 'CH1(in) '
    eos = eos
    K = '0.0 0.0'
    Area = 0.44934
  [../]
  [./Branch2]
    type = PBBranch
    inputs = 'CH1(out) '
    outputs = 'pipe2(in)'
    K = '0.0 0.0'
    Area = 0.44934
    eos = eos
  [../]
  [./Branch3]
    type = PBBranch
    inputs = 'pipe2(out)'
    outputs = 'pipe3(in) pipe5(in)'
    K = '0.0 0.0 10.0'
    Area = 0.44934
    initial_P = 1e5
    eos = eos
#     center = '0 0 5.98'
#     volume = 1e-3
  [../]
  [./Branch4]
    type = PBBranch
    inputs = 'pipe3(out)'
    outputs = 'IHX(primary_in)'
    K = '0.0 0.0'
    Area = 0.44934
    eos = eos
  [../]
  [./Branch5]
    type = PBBranch
    inputs = 'IHX(primary_out)'
    outputs = 'pipe4(in)'
    K = '0.0 0.0'
    Area = 0.44934
    eos = eos
  [../]

###### swith between Brach6 and Pump_p for natural circulation or forced flow

  [./Pump_p]
    type = PBPump                               # This is a PBPump component
    eos = eos
    inputs = 'pipe4(out)'
    outputs = 'pipe1(in)'
    K = '0. 0.'                                 # Form loss coefficient at pump inlet and outlet
    Area = 0.44934                              # Reference pump flow area
    initial_P = 1.5e5                           # Initial pressure
    Head = 1e3                                  # Pump head, Pa
  [../]

  #[./Branch6]
  #  type = PBBranch
  #  inputs = 'pipe4(out)'
  #  outputs = 'pipe1(in)'
  #  eos = eos
  #[../]

  [./pipe5]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 5.98'
    orientation = '0 0 1'
    A = 0.44934
    Dh = 2.972e-3
    length = 0.1
    n_elems = 2
    f = 0.001
  [../]
  [./p_out]
    type = PBTDV
    input = 'pipe5(out)'
    eos = eos
    p_bc = '1e5'
    T_bc = 628.15
    S_bc = 200
  [../]

  [./inlet2]
    type = PBTDJ
    input = 'IHX(secondary_in)'
    eos = eos
    v_bc = -1
    T_bc = 606.15
    S_bc = 200
  [../]

  [./outlet2]
    type = PressureOutlet
    input = 'IHX(secondary_out)'
    eos = eos
    p_bc = 1.0e5
  [../]
[]

[Postprocessors]
  [./CH1_flow]                                      # Output mass flow rate at inlet of CH1
    type = ComponentBoundaryFlow
    input = CH1(in)
  [../]
  [./CH1_TP_in]
    type = ComponentBoundaryVariableValue
    variable = traced_particle
    input = CH1(in)
  [../]
  [./CH1_TP_out]
    type = ComponentBoundaryVariableValue
    variable = traced_particle
    input = CH1(out)
  [../]
  [./IHX_TP_in]
    type = ComponentBoundaryVariableValue
    variable = traced_particle
    input = IHX(primary_in)
  [../]
  [./IHX_TP_out]
    type = ComponentBoundaryVariableValue
    variable = traced_particle
    input = IHX(primary_out)
  [../]
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.1
  dtmin = 1e-3
#   [./TimeStepper]
#     type = FunctionDT
#     time_t = ' 0      2     3   10   11    50   51   1e5'
#     time_dt =' 0.1  0.1   0.2  0.2   0.5  0.5    1     1'
#     min_dt = 1e-3
#   [../]
  # [./TimeStepper]
  #   type = CourantNumberTimeStepper
  #   dt = 0.05
  #   Courant_number = 2
  # [../]
  start_time = 0.0
  end_time = 200.0
  num_steps = 1000

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-7
  nl_max_its = 20
  l_tol = 1e-6
  l_max_its = 100

  [./Quadrature]
    type = GAUSS
    order = SECOND
  [../]
[]

[Outputs]
  print_linear_residuals = false
  [./out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end'
    sequence = false
  [../]
  [./csv]
    type = CSV
  []
  [./console]
    type = Console
    perf_log = true
  [../]
[]
