# RUN WITH --use-petsc-dm

[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 5.0
  nx = 100
  elem_type = EDGE3
[]

[Functions]
  [./v_in]
    type = PiecewiseLinear
    x = '0   140 250 3600 3750 21600'
    y = '0.2 0.2 0.05 0.05 0.2 0.2'
  [../]
  [./p_out]
    type = PiecewiseLinear
    x = '0   100'
    y = '1e5 1e5'
  [../]
  [./time_stepper_sub]
    type = PiecewiseLinear
    x = '0.0  25   26  6100 6101 10800 10801 12000 12001 5e5'
    y = '1.0  1.0  1.0  1.0 1.0  1.0   1.0   1.0   1.0  1.0'
  [../]
  [./T_in]
    type = PiecewiseLinear
    x = '0   140 250 3600 3750 21600'
    y = '860 860 785 785  860  860'
  [../]
[]

[Variables]
  [./pressure]
    # initial_condition = 1e5
    order = SECOND
    family = LAGRANGE
  [../]

  [./alphas]
    # initial_condition = 0.0012
    order = SECOND
    family = LAGRANGE
  [../]

  [./velocity]
    # initial_condition = 0.2
    order = FIRST
    family = LAGRANGE
  [../]

  [./temp_l]
    # initial_condition = 860
    order = SECOND
    family = LAGRANGE
    scaling = 1e-6
  [../]

  [./temp_s]
    # initial_condition = 732.1
    order = SECOND
    family = LAGRANGE
    scaling = 1e-5
  [../]
[]

[UserObjects]
	active = 'eos frozen'
  [./eos] #const salt
  	#type = PTConstantEOS
  	#p_0 = 1.0e5    # Pa
  	#rho_0 = 2279.92   # kg/m^3
  	##a2 = 1.834e5  # m^2/s^2
  	#beta = 0.0002 # K^{-1}
  	#cp = 2415.78
  	#cv =  2415.78
  	#h_0 = 2.35092e6  # J/kg
  	#T_0 = 973.15      # K
    #mu = 0.00535189 #1x
    #k = 0.7662 #1x
    type = SaltEquationOfState
    salt_type = Flibe
  [../]
  [./frozen] #solid salt
  	type = SaltEquationOfState
  	salt_type = FlibeSolid
  [../]
[]

[Materials]
	active = 'solid'
  [./solid]
    type = PBOneDSolidMaterial
    block = 0
    rho = rho
    velocity = velocity
    temperature = temp_l
    alphas = alphas
    temp_solid = temp_s
    pressure = pressure
    r_total = 0.005
    Ax = 0.07854
    eos = eos
    eos_solid = frozen
    h_int = interfaceHTC
    h_rad = 2e-8
    heatflux = freezing_heatflux
    #f_alpha = 0.05
  [../]
  # [./liquid]
  #   type = PBOneDFluidMaterial
  #   block = 0
  #   rho = rho
  #   velocity = velocity
  #   temperature = temp_l
  #   pressure = pressure
  #   Dh = 0.01
  #   gx = 0.0
  #   eos = eos
  #   low_advection_limit = 1e-6
  #   element_length = 0.05
  #   solid_phase = true
  # [../]
[]

# [Bounds]
#   [./alphas_bound]
#     type = BoundsAux
#     variable = bounds_dummy
#     bounded_variable = alphas
#     upper = 0.9999
#     lower = 0.0001
#   []
# []

[AuxVariables]
  [./rho]
    order = SECOND
    family = MONOMIAL
    # initial_condition = 2279.92
  [../]
  [./freezing_heatflux]
    order = SECOND
    family = MONOMIAL
    # initial_condition = 0.0
  [../]
  [./alphaliq]
    order = SECOND
    family = LAGRANGE
    # initial_condition = 0.9988
  [../]
  [./interfaceHTC]
    order = SECOND
    family = MONOMIAL
  [../]
  [./interface_temperature]
    order = SECOND
    family = LAGRANGE
  [../]
  [./temp_external]
    order = SECOND
    family = LAGRANGE
  [../]
  [./htc_external]
    order = SECOND
    family = LAGRANGE
  [../]
  [./freezing]
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = 0.0
  [../]
  [./reynolds]
    order = SECOND
    family = MONOMIAL
  [../]
  [./friction]
    order = SECOND
    family = MONOMIAL
  [../]
  [./bounds_dummy]
  [../]
[]

[AuxKernels]
  [./liquid_frac]
    type = AlphalAux
    variable = alphaliq
    alphas = alphas
  [../]
  [./interfaceHTCAUX]
    type = PBHeatTransferCoefficient
    variable = interfaceHTC
    rho = rho
    velocity = velocity
    temperature = temp_l
    pressure = pressure
    Twall = interface_temperature
    eos = eos
    g = 9.81
    Dh = 0.01
    D_heated = 0.01
    length = 0.0 #vertical length!
    alphas = alphas
    HTC_geometry_type = Pipe
  [../]
  # [./interfaceHTCconstant]
  #   type = ConstantAux
  #   variable = interfaceHTC
  #   value = 900.0
  # [../]
  [./heat_int]
    type = FreezingHeatFluxAux
    variable = freezing_heatflux
    Tfluid = temp_l
    eos_solid = frozen
    h_int = interfaceHTC
    h_rad = 2e-8
  [../]
  [./density]
    type = DensityAux
    variable = rho
    pressure = pressure
    temperature = temp_l
    eos = eos
  [../]
  [./temp_int]
    type = ConstantAux
    variable = interface_temperature
    value = 732.15
  []
  [./temp_ext]
    type = ConstantAux
    variable = temp_external
    value = 373.0
  []
  [./htc_ext]
    type = ConstantAux
    variable = htc_external
    value = 75.0
  []
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

[Kernels]
  [./velocity_dot]
    type = FluidVelocityAlphaTimeDerivative
    variable = velocity
    rho = rho
    temperature = temp_l
    alphas = alphas
    pressure = pressure
    eos = eos
  [../]

  [./velocity_grad]
    type = OneDFluidVelocityAlpha
    variable = velocity
    rho = rho
    temperature = temp_l
    alphas = alphas
    pressure = pressure
    eos = eos
    element_length = 0.05
    Ax = 0.07854
    gx = 0.0
    dh = 0.01
  [../]

  [./pressure_dot]
    type = FluidPressureAlphaTimeDerivative
    variable = pressure
    rho = rho
    temperature = temp_l
    alphas = alphas
    eos = eos
  [../]

  [./pressure_grad]
    type = OneDFluidContinuityAlpha
    variable = pressure
    velocity = velocity
    rho = rho
    temperature = temp_l
    alphas = alphas
    eos = eos
    element_length = 0.05
    Ax = 0.07854
    gx = 0.0
    dh = 0.01
  [../]

  [./solid_dot]
    type = SolidMassAlphaTimeDerivative
    variable = alphas
    temperature = temp_l
    temp_solid = temp_s
    eos_solid = frozen
    Ax = 0.07854
  [../]

  [./temp_solid]
    type = SolidTemperatureAlphaTimeDerivative
    variable = temp_s
    alphas = alphas
    heatflux = freezing_heatflux
    temperature = temp_l
    temp_ext = temp_external
    h_ext = htc_external
    eos_solid = frozen
    Ax = 0.07854
    dh = 0.01
    r_total = 0.005
  [../]

  [./temp_dot]
    type = FluidTemperatureAlphaTimeDerivative
    variable = temp_l
    rho = rho
    pressure = pressure
    alphas = alphas
    eos = eos
  [../]

  [./temp_liquid]
    type = OneDFluidTemperatureAlpha
    variable = temp_l
    velocity = velocity
    rho = rho
    pressure = pressure
    alphas = alphas
    temp_solid = temp_s
    heatflux = freezing_heatflux
    eos = eos
    eos_solid = frozen
    Ax = 0.07854
    element_length = 0.05
  [../]
[]

[BCs]
  [./vleft]
    type = FunctionDirichletBC
    variable = velocity
    boundary = left
    function = v_in
  [../]

  [./pright]
    type = DirichletBC
    variable = pressure
    boundary = right
    value = 1e5
  [../]

  [./Tleft]
    type = FunctionDirichletBC
    variable = temp_l
    boundary = left
    function = T_in
  [../]

  [./vbottom]
    type = OneDFluidVelocityAlphaBC
    variable = velocity
    rho = rho
    temperature = temp_l
    alphas = alphas
    pressure = pressure
    eos = eos
    boundary = left
    v_fn = v_in
  [../]

  [./vtop]
    type = OneDFluidVelocityAlphaBC
    variable = velocity
    rho = rho
    temperature = temp_l
    alphas = alphas
    pressure = pressure
    eos = eos
    boundary = right
    p_fn = p_out
  [../]

  [./pbottom]
    type = OneDFluidPressureAlphaBC
    variable = pressure
    rho = rho
    temperature = temp_l
    velocity = velocity
    eos = eos
    v_fn = v_in
    alphas = alphas
    boundary = left
  [../]

  [./ptop]
    type = OneDFluidPressureAlphaBC
    variable = pressure
    rho = rho
    temperature = temp_l
    velocity = velocity
    eos = eos
    alphas = alphas
    boundary = right
  [../]

  [./tbottom]
    type = OneDFluidTemperatureAlphaBC
    variable = temp_l
    rho = rho
    velocity = velocity
    pressure = pressure
    alphas = alphas
    eos = eos
    v_fn = v_in
    T_fn = T_in
    boundary = left
  [../]

  [./ttop]
    type = OneDFluidTemperatureAlphaBC
    variable = temp_l
    rho = rho
    velocity = velocity
    pressure = pressure
    alphas = alphas
    eos = eos
    boundary = right
  [../]
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type = SMP                         # Single-Matrix Preconditioner
    full = true                        # Using the full set of couplings among all variables
    solve_type = 'PJFNK'               # Using Preconditioned JFNK solution mehtod
    petsc_options_iname = '-pc_type -snes_type -snes_linesearch_type'   # PETSc otion, using preconditiong
    petsc_options_value = 'lu vinewtonrsls basic'         # PETSc otion, using ‘LU’ precondition type in Krylov solve
  [../]
[] # End preconditioning block

[Executioner]
  type = Transient                    # This is a transient simulation

  dt = 0.1                           # Targeted time step size
  dtmin = 1e-3                        # The allowed minimum time step size
  [./TimeStepper]
    type = FunctionDT
    function = time_stepper_sub
    min_dt = 1e-3
  [../]

  petsc_options = '-snes_monitor -snes_linesearch_monitor'
  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-7                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-6                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 20                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-4                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve

  start_time = 15.0                    # Physical time at the beginning of the simulation
  num_steps = 50000                    # Max. simulation time steps
  end_time = 12000.0                     # Max. physical time at the end of the simulation
[] # close Executioner section

[Problem]
  restart_file_base = '5eq-HconstTest1_cp_cp/0015'
[]

[Outputs]
  # [./cp]
  #   type = Checkpoint
  # [../]
  execute_on = 'initial timestep_end'
  exodus = true
  # csv = true
  perf_graph = true
[]

[Debug]
  show_var_residual_norms = true
[]
