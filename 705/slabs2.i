[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 10
  nx = 200
  #elem_type = EDGE3
[]

[Variables]
  [./psi0]
    initial_condition = 0.0
    order = FIRST
  [../]
  [./psi1]
    initial_condition = 0.0
    order = FIRST
  [../]
[]

[Materials]
	active = 'generic'
  [./generic]
    type = GenericConstantMaterial
    block = 0
    prop_names  = 'Et Es0 Es1'
    prop_values = '1.0 0.9 0.0'
  [../]
[]

[AuxVariables]
  [./source]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.0
  [../]
  [./scalar_flux]
    order = FIRST
    family = MONOMIAL
    initial_condition = 0.0
  [../]
[]

[AuxKernels]
  [./flux]
    type = FluxAux
    variable = scalar_flux
    psi = 'psi0 psi1'
    order = 2
  [../]
[]

[Kernels]
  [./psi_0]
    type = NeutronSNAngular
    variable = psi0
    psi_op = 'psi1'
    index = 0
    order = 2
    source = source
    Steady = false
  [../]
  [./psi_1]
    type = NeutronSNAngular
    variable = psi1
    psi_op = 'psi0'
    index = 1
    order = 2
    source = source
    Steady = false
  [../]
[]

[BCs]
  [./psi0left]
    type = DirichletBC
    variable = psi0
    boundary = left
    value = 0
  [../]
  [./psi1right]
    type = DirichletBC
    variable = psi1
    boundary = right
    value = 0
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
  type = Transient                   # This is a transient simulation

  dt = 1e-2                           # Targeted time step size
  dtmin = 1e-5                        # The allowed minimum time step size
  start_time = 0.0                    # Physical time at the beginning of the simulation
  num_steps = 8000                    # Max. simulation time steps
  end_time = 100.0                     # Max. physical time at the end of the simulation

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
