Models for testing freezing development

MOOSE-style input files

1eq-either -------------------------------
No longer used

example1.i -------------------------------
No longer used

3eq-isothermal -------------------------------
Nozzle effect of constriction, no heat transfer

5eq-HconstQout -------------------------------
Heat transfer, code-calculated freezing


SAM-style input files

FreezingComponent -------------------------------
T1 single component freezing test
T2 like previous but different conditions
T3 attempts to connect to junctions
T4 attempts junction workaround (abandon)
T5 single file transient, most conditions changing
T6 single file transient, more extreme
