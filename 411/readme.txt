Use this to approach steady:
[Executioner]
  #type = Steady
  type = Transient

  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  dt = 1e-1
  dtmin = 1e-3

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-5
  nl_max_its = 100

  start_time = 0.0
  num_steps = 1000
  end_time = 100

  l_tol = 1e-5 # Relative linear tolerance for each Krylov solve
  l_max_its = 200 # Number of linear iterations for each Krylov solve

   [./Quadrature]
      type = GAUSS
      order = SECOND
   [../]
[]

fxdracs transients utilize:
T_step for core heating then re-cool
v_step for primary flow rate rise
Hw_secondary for heat removal activation

Case 1: slowest initial primary side v = 0.0045
Case 2: fastest initial primary side v = 0.0090
Case 3: middle initial primary side v = 0.0068

550dracs transients utilize:
Mostly Case 3 parameters
fxdracs-t3.i -> 550dracs-t3.i
then
Case 3: Tstep peak 1073
Case 4: Tstep peak 1173
Case 5: Tstep peak 1273
