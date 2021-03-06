[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 1
  nx = 20
  #elem_type = QUAD4
[]

[Functions]
  [./v_in]
    type = PiecewiseLinear
    x = '0   100'
    y = '0.5 0.5'
  [../]
  [./p_out]
    type = PiecewiseLinear
    x = '0   100'
    y = '1e5 1e5'
  [../]
  [./a_out]
    type = PiecewiseLinear
    x = '0   10  40  100'
    y = '0.0 0.0 0.1 0.1'
  [../]
[]

[Variables]
  [./alphas]
    initial_condition = 0
  [../]

  [./velocity]
    initial_condition = 0.5
  [../]
[]

[UserObjects]
	active = 'eos'
  [./eos] #const salt
  	type = PTConstantEOS
  	p_0 = 1.0e5    # Pa
  	rho_0 = 2279.92   # kg/m^3
  	#a2 = 1.834e5  # m^2/s^2
  	beta = 0 # K^{-1}
  	cp = 2415.78
  	cv =  2415.78
  	h_0 = 2.35092e6  # J/kg
  	T_0 = 973.15      # K
    mu = 0.00535189 #1x
    k = 0.7662 #1x
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
  [./pressure]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.0e5
  [../]
[]

[Kernels]
  [./time]
    type = FluidVelocityAlphaTimeDerivative
    variable = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    pressure = pressure
    eos = eos
  [../]

  [./grad]
    type = OneDFluidVelocityAlpha
    variable = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    pressure = pressure
    eos = eos
    gx = 0
    dh = 0.1
  [../]

  [./diff]
    type = Diffusion
    variable = alphas
  [../]

  [./alphadot]
    type = TimeDerivative
    variable = alphas
  [../]
[]

#[ScalarKernels]
#  [./S_kernel]
#    type = ExampleScalarKernel
#    variable = S
#  [../]
#[]

[BCs]
  [./abottom]
    type = DirichletBC
    variable = alphas
    boundary = left
    value = 0.0
  [../]

  [./atop]
    type = FunctionDirichletBC
    variable = alphas
    boundary = right
    function = a_out
  [../]

  #[./vleft]
  #  type = DirichletBC
  #  variable = velocity
  #  boundary = left
  #  value = 0.5
  #[../]

  [./vbottom]
    type = OneDFluidVelocityAlphaBC
    variable = velocity
    rho = rho
    temperature = temperature
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
    temperature = temperature
    alphas = alphas
    pressure = pressure
    eos = eos
    boundary = right
    p_fn = p_out
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
