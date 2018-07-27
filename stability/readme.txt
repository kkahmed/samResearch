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

ncdracs5K.i -------------------------------
Shallow TCHX, heated pipe, constant properties, q=19019791
5Ks: Stable, starts at uniform temp (file specified IC)
5Kt1: Creates artificial normal Re high Gr case
5Kt2: Uses 5Kt1 to restart a transient - stable
5Kt3: Creates artificial normal Re moderate Gr case
5Kt4: Uses 5Kt3 to restart a transient - stable
5Ku: Attempted to start at higher temps from s, not effective

ncdracs6C.i -------------------------------
Steep TCHX, heated pipe, constant properties, q=10280968
6Cs: Stable, starts at uniform temp (file specified IC)
6Ct1: Creates artificial normal Re high Gr case
6Ct2: Uses 6Ct1 to restart a transient - stable
6Ct3: Creates artificial normal Re highest Gr case
6Ct4: Uses 6Ct3 to restart a transient - ?
