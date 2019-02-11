[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 2.5
  nx = 100
  #elem_type = EDGE3
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
    x = '0   10  11   50   51  100'
    y = '0.0 0.0 0.015 0.015 0.0 0.0'
  [../]
  [./f_axial]
    type = PiecewiseLinear
    axis = x
    x = '0   0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0'
    y = '0.0 13  25  35  42  48  52  55  57  58  58'
  [../]
  [./time_stepper_sub]
    type = PiecewiseLinear
    x = '0.0  50   51  1e5'
    y = '0.1  0.1  1.0 1.0'
  [../]
  [./heat_out]
    type = PiecewiseLinear
    axis = x
    x = '0   2.5'
    y = '-1.2e6 -8.0e5'
  [../]
  [./ftleft]
    type = ParsedFunction
    vals = 'from_master_Tbc_in'
    vars = 'tleft'
    value = tleft
  [../]
  [./fvleft]
    type = ParsedFunction
    vals = 'from_master_vbc_in inletr'
    vars = 'vleft radiusi'
    value = vleft*0.01767146*0.000025/((0.07854)*(radiusi^2))
  [../]
  [./fvright]
    type = ParsedFunction
    vals = 'outletvRAW outletr'
    vars = 'vright radiusi'
    value = vright*0.07854*(radiusi^2)/((0.01767146)*0.000025)
  [../]
  [./fpright]
    type = ParsedFunction
    vals = from_master_pbc_out
    vars = 'pright'
    value = pright
  [../]
[]

[Variables]
  [./pressure]
    initial_condition = 1e5
  [../]

  [./alphas]
    initial_condition = 0
  [../]

  [./velocity]
    initial_condition = 0.2
    #order = SECOND
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
  	type = FrozenEquationOfState
  	salt_type = Flibe
  [../]
[]

[Materials]
	active = 'generic'
  [./generic]
    type = GenericConstantMaterial
    block = 0
    prop_names  = 'friction'
    prop_values = '0.1'
  [../]
[]

[AuxVariables]
  [./rho]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2279.92
  [../]
  [./temperature]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 973.15
  [../]
  [./freezing]
    order = FIRST
    family = MONOMIAL
    initial_condition = 0.0
  [../]
  [./alphaliq]
    order = FIRST
    family = MONOMIAL
    initial_condition = 1.0
  [../]
  [./radius_i]
    order = FIRST
    family = MONOMIAL
    initial_condition = 0.0047434
  [../]
  #[./pressure]
  #  order = CONSTANT
  #  family = MONOMIAL
  #  initial_condition = 1e5
  #[../]
[]

[AuxKernels]
  [./freeze_rate]
    type = FreezingAux
    variable = freezing
    f_rate = f_rate
    f_axial = f_axial
    alphas = alphaliq
    temperature = temperature
    radius = radius_i
    heat_ext = heat_out
    h_int = 10000
  [../]
  [./liquid_frac]
    type = AlphalAux
    variable = alphaliq
    alphas = alphas
  [../]
  [./radius_int]
    type = RadialAux
    variable = radius_i
    alphas = alphas
    Rt = 0.005
  [../]
  [./density]
    type = DensityAux
    variable = rho
    pressure = pressure
    temperature = temperature
    eos = eos
  [../]
[]

[Kernels]
  [./velocity_dot]
    type = FluidVelocityAlphaTimeDerivative
    variable = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    pressure = pressure
    eos = eos
  [../]

  [./velocity_grad]
    type = OneDFluidVelocityAlpha
    variable = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    freezing = freezing
    pressure = pressure
    eos = eos
    element_length = 0.01
    Ax = 0.07854
    gx = 0.0
    dh = 0.01
  [../]

  [./pressure_dot]
    type = FluidPressureAlphaTimeDerivative
    variable = pressure
    rho = rho
    temperature = temperature
    alphas = alphas
    eos = eos
  [../]

  [./pressure_grad]
    type = OneDFluidContinuityAlpha
    #type = OneDFluidPressureAlpha
    variable = pressure
    velocity = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    freezing = freezing
    eos = eos
    element_length = 0.01
    Ax = 0.07854
    gx = 0.0
    dh = 0.01
  [../]

  [./solid_dot]
    type = SolidMassAlphaTimeDerivative
    variable = alphas
    freezing = freezing
    eos = frozen
    Ax = 0.07854
  [../]

  #[./diff]
  #  type = Diffusion
  #  variable = alphas
  #[../]
  #
  #[./alphadot]
  #  type = TimeDerivative
  #  variable = alphas
  #[../]
[]

#[ScalarKernels]
#  [./S_kernel]
#    type = ExampleScalarKernel
#    variable = S
#  [../]
#[]

[BCs]
  #[./abottom]
  #  type = DirichletBC
  #  variable = alphas
  #  boundary = left
  #  value = 0.0
  #[../]
  #
  #[./atop]
  #  type = FunctionDirichletBC
  #  variable = alphas
  #  boundary = right
  #  function = a_out
  #[../]

  [./vleft]
    #type = DirichletBC
    #variable = velocity
    #boundary = left
    #value = 0.2
    type = FunctionDirichletBC
    variable = velocity
    boundary = left
    function = fvleft #0.1
  [../]

  [./pright]
    #type = DirichletBC
    #variable = pressure
    #boundary = right
    #value = 1e5
    type = PostprocessorDirichletBC
    variable = pressure
    boundary = right
    postprocessor = from_master_pbc_out #1e5
  [../]

  [./vbottom]
    type = OneDFluidVelocityAlphaBC
    variable = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    pressure = pressure
    eos = eos
    boundary = left
    #v_fn = v_in
    v_fn = fvleft
  [../]

  [./vtop]
    type = OneDFluidVelocityAlphaBC
    variable = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    pressure = pressure
    eos = eos
    boundary = right
    #p_fn = p_out
    p_fn = fpright
  [../]

  [./pbottom]
    #type = OneDFluidContinuityAlphaBC
    type = OneDFluidPressureAlphaBC
    variable = pressure
    rho = rho
    temperature = temperature
    velocity = velocity
    eos = eos
    #v_fn = v_in
    v_fn = fvleft
    alphas = alphas
    boundary = left
  [../]

  [./ptop]
    #type = OneDFluidContinuityAlphaBC
    type = OneDFluidPressureAlphaBC
    variable = pressure
    rho = rho
    temperature = temperature
    velocity = velocity
    eos = eos
    #p_fn = p_out
    alphas = alphas
    boundary = right
  [../]
[]

[Postprocessors]
  [./from_master_vbc_in]
    type = Receiver
    default = 0.1
  [../]
  [./from_master_Tbc_in]
    type = Receiver
    default = 828.15
  [../]
  [./from_master_pbc_out]
    type = Receiver
    default = 1.45e5
  [../]
  [./from_master_Tbc_out]
    type = Receiver
    default = 728.15
  [../]
  [./outletvRAW]
    type = PointValue
    variable = velocity
    point = '2.5 0 0'
  [../]
  [./outletv]
    type = FunctionValuePostprocessor
    function = fvright
    execute_on = 'timestep_end'
  [../]
  [./inlett]
    type = PointValue
    variable = temperature
    point = '0 0 0'
  [../]
  [./outlett]
    type = PointValue
    variable = temperature
    point = '2.5 0 0'
  [../]
  [./inletp]
    type = PointValue
    variable = pressure
    point = '0 0 0'
  [../]
  [./inletr]
    type = PointValue
    variable = radius_i
    point = '0 0 0'
  [../]
  [./outletr]
    type = PointValue
    variable = radius_i
    point = '2.5 0 0'
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

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-7                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-6                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 20                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-4                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve

  start_time = 0.0                    # Physical time at the beginning of the simulation
  num_steps = 1000                    # Max. simulation time steps
  end_time = 100.0                     # Max. physical time at the end of the simulation
[] # close Executioner section

[Outputs]
  execute_on = 'initial timestep_end'
  exodus = true
  csv = true
[]
