Models for comparison to stability

All are double DRACS

ncdracs1.i -------------------------------
Steep TCHX, DHX model, Q = , Re = ,
Not converging

ncdracs1c.i -------------------------------
Steep TCHX, heated pipe, Q = , Re = ,
Core channel model, not converging

ncdracs2.i -------------------------------

ncdracs3.i -------------------------------
Shallow TCHX, DHX model, Q = , Re = ,

ncdracs3d.i -------------------------------
Shallow TCHX, heated pipe, Q = , Re = ,
Core channel model, simpler loop design

ncdracs3e.i -------------------------------
Shallow TCHX, heated pipe,
Q = 2.363, Re = 27746, m = 5.23, Re_TCHX = 1612
Core channel model, old loop design ... actually runs

ncdracs3f.i -------------------------------
Shallow TCHX, heated pipe,
Q = 3.051, Re = 41436, m = 7.913, Re_TCHX = 2436
Core channel model, old loop design ... actually runs

ncdracs4e.i -------------------------------
Shallow TCHX, heated pipe, constant properties
Q = 2.363, Re = 27746, m = 5.23, Re_TCHX = 1612
Core channel model, old loop design ... actually runs

ncdracs5B.i -------------------------------
Shallow TCHX, heated pipe, constant properties, q=10507150
5Bs: Stable, starts at uniform temp (file specified IC)
5Bt1: Creates artificial low Re high Gr case (inprogress)
5Bt2: Would use 5Bt1 to restart a transient (inprogress)
5Bu: Divergent, starts at Bs and attempts a large jump

ncdracs5E.i -------------------------------
Shallow TCHX, heated pipe, constant properties,
q=11309065 Re=246 Gr=9.05e12 Gr=6.51e13 (boundary)
5Es: Stable, starts at uniform temp (file specified IC)
5Et1:
5Et2:
5Et3:
5Et4:
5Et5:
5Et6:
5Et7:

ncdracs5H.i -------------------------------
Shallow TCHX, heated pipe, constant properties,
q=14393356 Re=618 Gr=2.31e13 Gr=9.02e13 (boundary)
5Hs: Stable, starts at uniform temp (file specified IC)
5Ht1:
5Ht2:
5Ht3:
5Ht4:
5Ht5: Creates artificial normal Re high Gr case using pump loss (in progress)
5Ht6:
5Ht7: Creates artificial normal Re moderate Gr case using pump loss (in progress)
5Hu: Stable, starts at uniform temp (file specified IC)
5Hu7: Creates artificial normal Re moderate Gr case using pumps loss (in progress)

ncdracs5K.i -------------------------------
Shallow TCHX, heated pipe, constant properties,
q=19019791 Re=1833 Gr=7.09e13 Gr=1.50e14 (boundary)
5Ks: Stable, starts at uniform temp (file specified IC)
5Ksb: Mesh refinement
5Ks_v2: Modified with new Gr for Journal paper
5Kt1: Creates artificial normal Re high Gr case using K factors
5Kt2: Uses 5Kt1 to restart a return to normal conditions transient - stable
5Kt3: Creates artificial normal Re high Gr case using K factors
5Kt4: Uses 5Kt3 to restart a perturbation transient, same K factors - stable
5Kt5: Creates artificial normal Re high Gr case using pump loss, GrALT
5Kt6: 5Kt5 then returns below boundary to 5Kt7 level
5Kt6a: Finer time step
5Kt6b: Mesh refinement
5Kt7: Creates artificial normal Re moderate Gr case using pump loss, GrALT
5Ku: Attempted to start at higher temps from s, not effective

ncdracs6C.i -------------------------------
Steep TCHX, heated pipe, constant properties,
q=10280968 Re=128 Gr=1.98e12 Gr=3.52e12 (boundary)
6Cs: Stable, starts at uniform temp (file specified IC)
6Ct1: Creates artificial normal Re high Gr case using K factors
6Ct2: Uses 6Ct1 to restart a return to normal conditions transient - stable
6Ct3: Creates artificial normal Re high Gr case using K factors
6Ct4: Uses 6Ct3 to restart a perturbation transient, same K factors - stable
6Ct5: Creates artificial normal Re high Gr case using pump loss, GrALT
6Ct6: Unused
6Ct7: Creates artificial normal Re moderate Gr case using pump loss, GrALT
6Ct8: Unused
6Ct9: Creates artificial normal Re boundary Gr case using pump loss
6Cu: Stable, starts at uniform temp (file specified IC)
6Cub: Mesh refinement (not running yet)
6Cu5: 6Ct5 but split pump, matches exactly
6Cu6: Unused
6Cu7: 6Ct7 but split pump, matches exactly
6Cv5: 6Cu5 but aims left on Gr vs Re to go unstable, GrALT
6Cv5a: Finer time step
6Cv5b: Mesh refinement (not running yet)
6Cv6: 6CvX but aims up-right on Gr vs Re to go (unstable?), GrALT
6Cv7: 6Cu7 but aims right to Gr vs Re stay stable, GrALT

ncdracs6G.i -------------------------------
Steep TCHX, heated pipe, constant properties,
q=12337162 Re=246 Gr=4.22e12 Gr=1.06e13 (boundary)
6Gs: Stable, starts at uniform temp (file specified IC)
6Gt1:
6Gt2:
6Gt3:
6Gt4:
6Gt5: Creates artificial normal Re high Gr case using pump loss, GrALT
6Gt6: Unused
6Gt7: Creates artificial normal Re moderate Gr case using pump loss, GrALT

ncdracs7G.i -------------------------------
Steep TCHX, heated pipe, T-dep properties,
q=12337162 Re=246 Gr=4.22e12 Gr=1.06e13 (boundary)
7Gs: Stable, starts at uniform temp (file specified IC)
7Gt1:
7Gt2:
7Gt3:
7Gt4:
7Gt5: Creates artificial normal Re high Gr case using pump loss
7Gt6: Unused
7Gt7: Creates artificial normal Re moderate Gr case using pump loss
