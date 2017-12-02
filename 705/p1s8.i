[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 2.5
  nx = 10
  elem_type = EDGE3
[]

[Functions]
  #[./v_in]
  #  type = PiecewiseLinear
  #  x = '0   100'
  #  y = '0.5 0.5'
  #[../]
  #[./p_out]
  #  type = PiecewiseLinear
  #  x = '0   100'
  #  y = '1e5 1e5'
  #[../]
  #[./f_rate]
  #  type = PiecewiseLinear
  #  x = '0   10  11  50  51  100'
  #  y = '0.0 0.0 0.1 0.1 0.0 0.0'
  #[../]
  #[./f_axial]
  #  type = PiecewiseLinear
  #  axis = x
  #  x = '0   1'
  #  y = '0.0 80'
  #[../]
[]

[Variables]
  [./psi0]
    initial_condition = 1
    order = SECOND
  [../]

  [./psi1]
    initial_condition = 1
    order = SECOND
  [../]
[]

#[UserObjects]
#	active = 'eos'
#  [./eos] #const salt
#  	type = PTConstantEOS
#  	p_0 = 1.0e5    # Pa
#  	rho_0 = 2279.92   # kg/m^3
#  	#a2 = 1.834e5  # m^2/s^2
#  	beta = 0.0002 # K^{-1}
#  	cp = 2415.78
#  	cv =  2415.78
#  	h_0 = 2.35092e6  # J/kg
#  	T_0 = 973.15      # K
#    mu = 0.00535189 #1x
#    k = 0.7662 #1x
#  [../]
#[]

[Materials]
	active = 'generic'
  [./generic]
    type = GenericConstantMaterial
    block = 0
    prop_names  = 'Et Es0 Es1'
    prop_values = '3.0 2.0 0.4'
  [../]
[]

[AuxVariables]
  [./source]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1
  [../]
  [./scalar_flux]
    order = SECOND
    family = MONOMIAL
    initial_condition = 1.0
  [../]
[]

[AuxKernels]
  [./flux]
    type = FluxAux
    variable = scalar_flux
    psi = psi0
    psi_op = psi1
    order = 2
  [../]
[]

[Kernels]
  [./psi_0]
    type = NeutronSNAngular
    variable = psi0
    psi_op = psi1
    index = 0
    order = 2
    source = source
  [../]

  [./psi_1]
    type = NeutronSNAngular
    variable = psi1
    psi_op = psi0
    index = 1
    order = 2
    source = source
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

  [./psi0left]
    type = MatchedValueBC
    variable = psi0
    boundary = left
    v = psi1
  [../]

  [./psi1right]
    type = DirichletBC
    variable = psi1
    boundary = right
    value = 0.0
  [../]

  [./psi_0left]
    type = NeutronSNAngularBC
    variable = psi0
    index = 0
    order = 2
    boundary = left
  [../]

  [./psi_0right]
    type = NeutronSNAngularBC
    variable = psi0
    index = 0
    order = 2
    boundary = right
  [../]

  [./psi_1left]
    type = NeutronSNAngularBC
    variable = psi1
    index = 1
    order = 2
    boundary = left
  [../]

  [./psi_1right]
    type = NeutronSNAngularBC
    variable = psi1
    index = 1
    order = 2
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
  type = Steady                   # This is a transient simulation

  #dt = 0.1                           # Targeted time step size
  #dtmin = 1e-5                        # The allowed minimum time step size
  #start_time = 0.0                    # Physical time at the beginning of the simulation
  #num_steps = 10                    # Max. simulation time steps
  #end_time = 100.0                     # Max. physical time at the end of the simulation

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-7                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-6                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 20                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-4                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve


[] # close Executioner section

[Outputs]
  execute_on = 'initial timestep_end'
  exodus = true
  csv = true
[]
