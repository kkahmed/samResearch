[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 1
  nx = 20
  #elem_type = QUAD4
[]


[Variables]
  [./velocity]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.2
  [../]

  [./alphas]
    initial_condition = 0.1
  [../]
[]

[UserObjects]
	active = 'eos'
  [./eos] #const salt
  	type = PTConstantEOS
  	p_0 = 1.0e5    # Pa
  	rho_0 = 1   # kg/m^3
  	#a2 = 1.834e5  # m^2/s^2
  	beta = 0 # K^{-1}
  	cp = 2415.78
  	cv =  2415.78
  	h_0 = 2.35092e6  # J/kg
  	T_0 = 973.15      # K
  	mu = 1.23e-5 #1x
 	k = 0.0251 #1x
  [../]
[]

[AuxVariables]
  [./rho]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1
  [../]
  [./temperature]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1
  [../]
[]

[Kernels]
  [./time]
    type = FluidPressureAlphaTimeDerivative
    variable = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    eos = eos
  [../]

  [./grad]
    type = OneDFluidPressureAlpha
    variable = velocity
    velocity = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    eos = eos
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
  [./bottom]
    type = DirichletBC
    variable = velocity
    boundary = left
    value = 0.0
  [../]

  [./bottom2]
    type = OneDFluidPressureAlphaBC
    variable = velocity
    velocity = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    eos = eos
    boundary = left
  [../]

  [./top]
    type = OneDFluidPressureAlphaBC
    variable = velocity
    velocity = velocity
    rho = rho
    temperature = temperature
    alphas = alphas
    eos = eos
    boundary = right
  [../]

  [./atop]
    type = DirichletBC
    variable = alphas
    boundary = right
    value = 0.1
  [../]

  [./abot]
    type = DirichletBC
    variable = alphas
    boundary = left
    value = 0.1
  [../]
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type = SMP                         # Single-Matrix Preconditioner
    full = true                        # Using the full set of couplings among all variables
    solve_type = 'NEWTON'               # Using Preconditioned JFNK solution mehtod
    petsc_options_iname = '-pc_type'   # PETSc otion, using preconditiong
    petsc_options_value = 'ilu'         # PETSc otion, using ‘LU’ precondition type in Krylov solve
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
  num_steps = 100                     # Max. simulation time steps
  end_time = 1.                       # Max. physical time at the end of the simulation
  [../]
[] # close Executioner section

[Outputs]
  execute_on = 'initial timestep_end'
  exodus = true
  csv = true
[]
