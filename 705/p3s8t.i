[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 1.25
  nx = 125
  #elem_type = EDGE3
[]

[Functions]
  [./Et_fn]
    type = PiecewiseConstant
    axis = x
    x = '0      0.25'
    y = '1.6480 3.6907'
  [../]
  [./Es0_fn]
    type = PiecewiseConstant
    axis = x
    x = '0      0.25'
    y = '0.7278 3.6710'
  [../]
  [./Es1_fn]
    type = PiecewiseConstant
    axis = x
    x = '0   0.25'
    y = '0.0 0.0'
  [../]
  [./source_fn]
    type = PiecewiseConstant
    axis = x
    x = '0   0.25'
    y = '0.0 1.0 '
  [../]
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
  [./psi2]
    initial_condition = 0.0
    order = FIRST
  [../]
  [./psi3]
    initial_condition = 0.0
    order = FIRST
  [../]
  [./psi4]
    initial_condition = 0.0
    order = FIRST
  [../]
  [./psi5]
    initial_condition = 0.0
    order = FIRST
  [../]
  [./psi6]
    initial_condition = 0.0
    order = FIRST
  [../]
  [./psi7]
    initial_condition = 0.0
    order = FIRST
  [../]
[]

[Materials]
  active = 'generic'
  [./generic]
    type = GenericFunctionMaterial
    block = 0
    prop_names  = 'Et Es0 Es1'
    prop_values = 'Et_fn Es0_fn Es1_fn'
  [../]
[]

[AuxVariables]
  [./source]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.0
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
    psi = 'psi0 psi1 psi2 psi3 psi4 psi5 psi6 psi7'
    order = 8
  [../]
  [./sourceAux]
    type = FunctionAux
    variable = source
    function = source_fn
  [../]
[]

[Kernels]
  [./psi_0]
    type = NeutronSNAngular
    variable = psi0
    psi_op = 'psi1 psi2 psi3 psi4 psi5 psi6 psi7'
    index = 0
    order = 8
    source = source
    Steady = false
  [../]
  [./psi_1]
    type = NeutronSNAngular
    variable = psi1
    psi_op = 'psi0 psi2 psi3 psi4 psi5 psi6 psi7'
    index = 1
    order = 8
    source = source
    Steady = false
  [../]
  [./psi_2]
    type = NeutronSNAngular
    variable = psi2
    psi_op = 'psi0 psi1 psi3 psi4 psi5 psi6 psi7'
    index = 2
    order = 8
    source = source
    Steady = false
  [../]
  [./psi_3]
    type = NeutronSNAngular
    variable = psi3
    psi_op = 'psi0 psi1 psi2 psi4 psi5 psi6 psi7'
    index = 3
    order = 8
    source = source
    Steady = false
  [../]
  [./psi_4]
    type = NeutronSNAngular
    variable = psi4
    psi_op = 'psi0 psi1 psi2 psi3 psi5 psi6 psi7'
    index = 4
    order = 8
    source = source
    Steady = false
  [../]
  [./psi_5]
    type = NeutronSNAngular
    variable = psi5
    psi_op = 'psi0 psi1 psi2 psi3 psi4 psi6 psi7'
    index = 5
    order = 8
    source = source
    Steady = false
  [../]
  [./psi_6]
    type = NeutronSNAngular
    variable = psi6
    psi_op = 'psi0 psi1 psi2 psi3 psi4 psi5 psi7'
    index = 6
    order = 8
    source = source
    Steady = false
  [../]
  [./psi_7]
    type = NeutronSNAngular
    variable = psi7
    psi_op = 'psi0 psi1 psi2 psi3 psi4 psi5 psi6'
    index = 7
    order = 8
    source = source
    Steady = false
  [../]
[]

[BCs]
  [./psi0left]
    type = MatchedValueBC
    variable = psi0
    boundary = left
    v = psi7
  [../]
  [./psi1left]
    type = MatchedValueBC
    variable = psi1
    boundary = left
    v = psi6
  [../]
  [./psi2left]
    type = MatchedValueBC
    variable = psi2
    boundary = left
    v = psi5
  [../]
  [./psi3left]
    type = MatchedValueBC
    variable = psi3
    boundary = left
    v = psi4
  [../]
  [./psi4right]
    type = MatchedValueBC
    variable = psi4
    boundary = right
    v = psi3
  [../]
  [./psi5right]
    type = MatchedValueBC
    variable = psi5
    boundary = right
    v = psi2
  [../]
  [./psi6right]
    type = MatchedValueBC
    variable = psi6
    boundary = right
    v = psi1
  [../]
  [./psi7right]
    type = MatchedValueBC
    variable = psi7
    boundary = right
    v = psi0
  [../]

  [./psi_0left]
    type = NeutronSNAngularBC
    variable = psi0
    index = 0
    order = 8
    boundary = left
  [../]
  [./psi_0right]
    type = NeutronSNAngularBC
    variable = psi0
    index = 0
    order = 8
    boundary = right
  [../]

  [./psi_1left]
    type = NeutronSNAngularBC
    variable = psi1
    index = 1
    order = 8
    boundary = left
  [../]
  [./psi_1right]
    type = NeutronSNAngularBC
    variable = psi1
    index = 1
    order = 8
    boundary = right
  [../]

  [./psi_2left]
    type = NeutronSNAngularBC
    variable = psi2
    index = 2
    order = 8
    boundary = left
  [../]
  [./psi_2right]
    type = NeutronSNAngularBC
    variable = psi2
    index = 2
    order = 8
    boundary = right
  [../]

  [./psi_3left]
    type = NeutronSNAngularBC
    variable = psi3
    index = 3
    order = 8
    boundary = left
  [../]
  [./psi_3right]
    type = NeutronSNAngularBC
    variable = psi3
    index = 3
    order = 8
    boundary = right
  [../]

  [./psi_4left]
    type = NeutronSNAngularBC
    variable = psi4
    index = 4
    order = 8
    boundary = left
  [../]
  [./psi_4right]
    type = NeutronSNAngularBC
    variable = psi4
    index = 4
    order = 8
    boundary = right
  [../]

  [./psi_5left]
    type = NeutronSNAngularBC
    variable = psi5
    index = 5
    order = 8
    boundary = left
  [../]
  [./psi_5right]
    type = NeutronSNAngularBC
    variable = psi5
    index = 5
    order = 8
    boundary = right
  [../]

  [./psi_6left]
    type = NeutronSNAngularBC
    variable = psi6
    index = 6
    order = 8
    boundary = left
  [../]
  [./psi_6right]
    type = NeutronSNAngularBC
    variable = psi6
    index = 6
    order = 8
    boundary = right
  [../]

  [./psi_7left]
    type = NeutronSNAngularBC
    variable = psi7
    index = 7
    order = 8
    boundary = left
  [../]
  [./psi_7right]
    type = NeutronSNAngularBC
    variable = psi7
    index = 7
    order = 8
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
  num_steps = 9000                    # Max. simulation time steps
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
