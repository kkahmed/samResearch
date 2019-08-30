[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 1
  nx = 50
  elem_type = EDGE3
[]

[Functions]
  [./v_in]
    type = PiecewiseLinear
    x = '0   100'
    y = '0.2 0.2'
  [../]
  [./p_out]
    type = PiecewiseLinear
    x = '0   100'
    y = '1e5 1e5'
  [../]
  [./f_rate]
    type = PiecewiseLinear
    x = '0   10  11   30   31  100'
    y = '0.0 0.0 0.030 0.030 0.0 0.0'
  [../]
  [./f_axial]
    type = PiecewiseLinear
    axis = x
    x = '0   0.2 0.8 1.0'
    y = '0.0 0.0  45 45'
  [../]
  [./time_stepper_sub]
    type = PiecewiseLinear
    x = '0.0  100  101  1e5'
    y = '0.5  0.5  1.0 1.0'
  [../]
  [./T_in]
    type = PiecewiseLinear
    x = '0   100'
    y = '862 862'
  [../]
[]

[Variables]
  [./pressure]
    initial_condition = 1e5
    order = SECOND
    family = LAGRANGE
  [../]

  [./alphas]
    initial_condition = 0.01
    order = SECOND
    family = LAGRANGE
  [../]

  [./velocity]
    initial_condition = 0.2
    order = FIRST
    family = LAGRANGE
  [../]

  [./temp_l]
    initial_condition = 802
    order = SECOND
    family = LAGRANGE
  [../]

  [./temp_s]
    initial_condition = 732
    order = SECOND
    family = LAGRANGE
  [../]
[]

[UserObjects]
	active = 'eos frozen'
  [./eos]
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
    h_int = 0.0
    h_rad = 0.0
    f_alpha = 0.0
    f_rate = f_rate
    f_axial = f_axial
  [../]
[]

[AuxVariables]
  [./rho]
    order = SECOND
    family = LAGRANGE
    initial_condition = 2279.92
  [../]
  [./freezing]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./freezing_heatflux]
    order = SECOND
    family = LAGRANGE
    initial_condition = 0.0
  [../]
  [./alphaliq]
    order = SECOND
    family = LAGRANGE
    initial_condition = 0.99
  [../]
[]

[AuxKernels]
  [./liquid_frac]
    type = AlphalAux
    variable = alphaliq
    alphas = alphas
  [../]
  [./heat_int]
    type = FreezingHeatFluxAux
    variable = freezing_heatflux
    Tfluid = temp_l
    eos_solid = frozen
    h_int = 0.0
    h_rad = 0.0
  [../]
  [./density]
    type = DensityAux
    variable = rho
    pressure = pressure
    temperature = temp_l
    eos = eos
  [../]
  [./freeze_rate]
    type = MaterialRealAux
    variable = freezing
    property = freezing_rate
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
    element_length = 0.02
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
    element_length = 0.02
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
    h_int = 200
    h_rad = 1.5e-7
    Ax = 0.07854
  [../]

  [./temp_solid]
    type = SolidTemperatureAlphaTimeDerivative
    variable = temp_s
    alphas = alphas
    heatflux = freezing_heatflux
    temperature = temp_l
    eos_solid = frozen
    h_int = 200
    h_rad = 1.5e-7
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
    h_int = 200
    h_rad = 1.5e-7
    element_length = 0.02
  [../]
[]

[BCs]
  [./vleft]
    type = DirichletBC
    variable = velocity
    boundary = left
    value = 0.2
  [../]

  [./pright]
    type = DirichletBC
    variable = pressure
    boundary = right
    value = 1e5
  [../]

  [./Tleft]
    type = DirichletBC
    variable = temp_l
    boundary = left
    value = 862
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
    petsc_options_iname = '-pc_type'   # PETSc otion, using preconditiong
    petsc_options_value = 'lu'         # PETSc otion, using ‘LU’ precondition type in Krylov solve
  [../]

[] # End preconditioning block

[Executioner]
  type = Transient                    # This is a transient simulation

  dt = 0.1                           # Targeted time step size
  dtmin = 1e-5                        # The allowed minimum time step size
  [./TimeStepper]
    type = FunctionDT
    function = time_stepper_sub
    min_dt = 1e-3
  [../]

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-7                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-6                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 20                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-4                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve

  start_time = 0.0                    # Physical time at the beginning of the simulation
  num_steps = 1000                    # Max. simulation time steps
  end_time = 50.0                     # Max. physical time at the end of the simulation
[] # close Executioner section

[Outputs]
  execute_on = 'initial timestep_end'
  exodus = true
  csv = true
[]
