[GlobalParams]
    global_init_P = 1.0e5
    global_init_V = 1.796
    global_init_T = 874
    Tsolid_sf = 1e-3

  [./PBModelParams]
	#pspg = false
	#pbm_scaling_factors = '1 1e-2 1e-6'
	#variable_bounding = true
	#V_bounds = '0 10'
     #scaling_velocity = 1
     supg_max = true
     p_order = 2
  [../]
[]


[EOS]
	active = 'eos eos3'
  [./eos]
  	type = SaltEquationOfState
     #salt_type = r5Flibe
  [../]
  [./eos3] #const salt
  	type = PTConstantEOS
  	p_0 = 1.0e5    # Pa
  	rho_0 = 1980 #2279.92   # kg/m^3
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

[MaterialProperties]
  [./ss-mat]
    type = SolidMaterialProps
    k = 40
    Cp = 583.333
    rho = 6e3
  [../]
  [./h451]
    type = SolidMaterialProps
    k = 173.49544 #80
    Cp = 1323.92
    #rho = 2.266e3
    #rho = 1.5937e3		#ratio=1.42185
    #rho = 3.204608e3  	# b
    #rho = 4.532e3   	# c
    rho = 4914.2582      # d
  [../]
  [./fuel]
    type = SolidMaterialProps
    k = 32.5304 #15
    Cp = 1323.92
    #rho = 2.266e3
    #rho = 1.5937e3		#ratio=1.42185
    #rho = 3.204608e3  	# b
    #rho = 4.532e3   	# c
    rho = 4914.2582      # d
  [../]
[]

[Functions]
  active = 'Paxial Phead3 shutdownPower2'
  [./uniform]                                # Function name
    type = PiecewiseLinear                   # Function type
    axis = 0                                 # X-co-ordinate is used for x
    x = '0  4.58'                            # The x abscissa values
    y = '1  1'                               # The y abscissa values
  [../]

  [./Paxial]                                 # Function name
    type = PiecewiseConstant                  # Function type
    axis = 0                                 # X-co-ordinate is used for x
    direction = right
    xy_data =
		'0.176153846153846	0.0939862040
		0.352307692307692	0.2648701900
		0.528461538461539	0.4186657800
		0.704615384615385	0.5895497920
		0.880769230769231	0.7689779760
		1.056923076923080	0.9056851700
		1.233076923076920	0.9825829780
		1.409230769230770	1.0082155720
		1.585384615384620	1.0167597700
		1.761538461538460	1.0167597700
		1.937692307692310	1.0509365880
		2.113846153846150	1.1363785680
		2.290000000000000	1.2047321780
		2.466153846153850	1.2218205740
		2.642307692307690	1.2303647720
		2.818461538461540	1.2559973660
		2.994615384615380	1.2389089700
		3.170769230769230	1.1961879800
		3.346923076923080	1.1278343700
		3.523076923076920	1.0509365880
		3.699230769230770	1.0851133800
		3.875384615384620	1.1192901720
		4.051538461538460	1.1876437820
		4.227692307692310	1.2645415640
		4.403846153846150	1.3499835700
		4.580000000000000	1.2132763760'
  [../]

  [./Phead]
    type = PiecewiseLinear
x = 	'0		1000		1004.5	1009		1013.5	1018		1022.5
	1027		1031.5	1036		1040.5	1045		1049.5	1054
	1058.5	1063		1067.5	1072		1076.5	1081		10000'
y = 	'367475	367475	182810.4	89968.8	43302.0	19845.0	8054.3
	2127.7 	-851.3 	-2348.7 	-3101.3 	-3479.6 	-3669.8 	-3765.4
	-3813.4	-3837.6	-3849.7	-3855.8	-3858.9	-3860.4	-3861.9'
  [../]

  [./Phead2]
    type = PiecewiseLinear
    #x = '0 	 100    104.5  109 	  113.5 118   122.5 127  131.5 136   140.5 145   148   150.5 152    154   157.5 160    170   175   185   200   300   10000'
    #y = '367475 367475 182810 89969  43302 19845 8054  2128 -851  -1500 -1700 -1720 -1720 -1730 -1760 -1790 -1830 -1850 -1980  -2010 -2100 -2200 -2500 -2500'
    x = '0 	 400    404.5  409 	  413.5 418   422.5 427  431.5 436   440.5 445   448   450.5 452    454   457.5 460   480   500   600   10000'
    y = '367475 367475 182810 89969  43302 19845 8054  2128 -851  -1500 -1700 -1720 -1720 -1730 -1760 -1790 -1830 -1870 -2150 -2350 -2500 -2500'
  [../]

  [./Phead3]
    type = ParsedFunction
    #value = min(367475,367475*exp(-0.14*(min(t,135)-100))-10000)+((max(min(t,131),130)-130)*(50000*exp(-0.5*(min(t,155)-130))-50000))
    #value = min(367475,377475*exp(-0.14*(min(t,200)-100))-10000)
    #value = min(367475,400377*exp(-0.1528583*(min(t,131)-100))-3862)
    #value = min(367475,371377*exp(-0.1528583*(min(t,200)-100))-3862)
    #value = min(367475,371377*exp(-0.1528583*(min(t,1100)-1000))-3862)

    # 1 Working low velocity implementation
    #value = max(min(367475,371377*exp(-0.1528583*(min(t,200)-100))-3862),-3300)-6*(max(min(t,395),195)-195)-3.6*(max(min(t,400),260)-260)+0.2*(max(min(t,5400),1000)-1000) #a
    #value = max(min(367475,371377*exp(-0.1528583*(min(t,200)-100))-3862),-3200)-6*(max(min(t,375),195)-195)-3.6*(max(min(t,400),260)-260)+0.2*(max(min(t,5400),1000)-1000) #b
    #value = max(min(367475,371377*exp(-0.1528583*(min(t,200)-100))-3862),-3200)-7*(max(min(t,375),195)-195)-3.6*(max(min(t,400),260)-260)+0.2*(max(min(t,5400),1000)-1000) #c
    #value = max(min(367475,371377*exp(-0.1528583*(min(t,200)-100))-3862),-3200)-6*(max(min(t,375),195)-195)-3.6*(max(min(t,400),260)-260)+0.2*(max(min(t,5400),1000)-1000) #7d
    #value = max(min(367475,371377*exp(-0.1528583*(min(t,200)-100))-3862),-3000)-6*(max(min(t,375),195)-195)+0.2*(max(min(t,1300),1000)-1000)+0.2*(max(min(t,5400),1500)-1500) #4c
    #value = min(367475,371377*exp(-0.157*(min(t,130)-100))-3862)-65*(max(min(t,130),120)-120)-50*(max(min(t,140),125)-125)+5*(max(min(t,144),137)-137)-22*(max(min(t,150),144)-144)-1000*(1-exp(-1*(max(min(t,165),153)-153)))-9*(max(min(t,375),195)-195)-3.6*(max(min(t,400),260)-260)+0.2*(max(min(t,5400),1000)-1000) #7e
    value = min(367475,371377*exp(-0.157*(min(t,430)-400))-3862)-65*(max(min(t,430),420)-420)-50*(max(min(t,440),425)-425)+5*(max(min(t,444),437)-437)-22*(max(min(t,450),444)-444)-1000*(1-exp(-1*(max(min(t,465),453)-453)))-9*(max(min(t,675),495)-495)-3.6*(max(min(t,700),560)-560)+0.2*(max(min(t,5700),1300)-1300) #7e

    #-150*(max(min(t,163),155)-155)

    # 2 Pump head goes to zero only
    # value = max(min(367475,371377*exp(-0.1528583*(min(t,200)-100))-3862),0)

    # 3 Somewhere in between
    # value = max(min(367475,371377*exp(-0.1528583*(min(t,200)-100))-3862),-1600)+0.5*(max(min(t,1700),900)-900)+1.0*(max(min(t,2500),2000)-2000)

    #+(0.1*(max(min(t,155),145)-145)*(200*exp(-0.3*(min(t,180)-145))-200))
  [../]

  [./shutdownPower]
    type = PiecewiseLinear
    x = '0	1000	1001	1002	1004	1008	1016	1024	1032	1040	1048	1060	1120	1240	1480	1960	2440	2920	3400	3880	4360	4600	13200'
    y = '1.0000000000	1.0000000000	0.0529661017	0.0508474576	0.0478813559	0.0440677966	0.0402966102	0.0378389831	0.0360593220	0.0347033898	0.0335593220	0.0321610169	0.0279237288	0.0242372881	0.0210169492	0.0179237288	0.0161016949	0.0147881356	0.0137711864	0.0130084746	0.0123728814	0.0120762712	0.0081355932'
  [../]

  [./shutdownPower2]
    type = PiecewiseLinear
    x = '0	400	401	402	404	408	416	424	432	440	448	460	520	640	880	1360	1840	2320	2800	3280	3760	4000	12600'
    y = '1.0000000000	1.0000000000	0.0529661017	0.0508474576	0.0478813559	0.0440677966	0.0402966102	0.0378389831	0.0360593220	0.0347033898	0.0335593220	0.0321610169	0.0279237288	0.0242372881	0.0210169492	0.0179237288	0.0161016949	0.0147881356	0.0137711864	0.0130084746	0.0123728814	0.0120762712	0.0081355932'
  [../]

[]

[Components]

  [./reactor]
    type = ReactorPower
    initial_power = 2.36e8				# Initial total reactor power
    decay_heat = shutdownPower2
  [../]

  [./pipe010] #Active core region (1)	(FINISH HEAT STRUCTURE INPUT, CHECK CCFL)
    type = PBCoreChannel
    eos = eos
    position = '0 4.94445 -5.34'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 1.327511
    Dh = 0.03
    length = 4.58
    n_elems = 13 #26
    initial_V = 0.290
    initial_T = 920
    initial_P = 2.6e5

    WF_user_option = User
    #User_defined_WF_parameters = '32.1 4974.4 -1.0'
    User_defined_WF_parameters = '5.467 847.17 -1.0'

    #HT_surface_area_density = 211.1		#Preserves #ofpins such that core mass is = relap
    HT_surface_area_density = 133.33		#Preserves surface area
    Ts_init = 950
    elem_number_of_hs = '5 5 2'
    material_hs = 'h451 fuel h451'
    n_heatstruct = 3
    fuel_type = cylinder
    name_of_hs = 'inner fuel outer'
    #width_of_hs = '0.011410887	0.002114398	0.001474715' #'0.0125 0.0015 0.0010'
    #width_of_hs = '0.017125078	0.003173219	0.002213203' #surface area, stored heat too large
    #width_of_hs = '0.012109259	0.002243804	0.001564971' #less stored heat b
    #width_of_hs = '0.008562539	0.001586609	0.001106602' #less stored heat c
    width_of_hs = '0.007896334	0.001463164	0.001020503' #less stored heat d

    power_fraction = '0 1 0'
    power_shape_function = Paxial
    HTC_geometry_type = Bundle
    PoD = 1.1
    dim_hs = 2
  [../]

  [./pipe020] #Core bypass (2)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 5.92445 -5.34'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.065
    Dh = 0.01
    length = 4.58
    n_elems = 13 #26
    initial_V = 1.993
    initial_P = 2.6e5
  [../]

  [./Branch030] #Outlet plenum (3)			(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch
    inputs = 'pipe010(out) pipe020(out)'	# A = 1.327511 (0.2524495)	A = 0.065
    outputs = 'pipe040(in)'   			# A = 0.2512732
    center = '0 4.94445 -0.76'
    volume = 0.99970002
    K = '0.3668 0.35336 0.0006'			# Check these
    Area = 0.2524495					# L = 3.96
    eos = eos
    initial_V = 2.040
    initial_T = 970
    initial_P = 1.7e5
    width = 2
    height = 0.2
    nodal_Tbc = true
  [../]

  #[./pipe030] #placeholder
  #  type = PBOneDFluidComponent
  #  eos = eos
  #  position = '0 7.92445 -0.76'
  #  orientation = '0 -1 0'
  #  roughness = 0.000015
  #  A = 0.2524495
  #  Dh = 0.5669468
  #  length = 3.96
  #  n_elems =
  #[../]

  [./pipe040] #Hot salt extraction pipe (4)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 3.96445 -0.76'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.2512732
    Dh = 0.5656244
    length = 3.77
    n_elems = 11 #21
    initial_V = 2.050
    initial_T = 970
    initial_P = 1.3e5
  [../]

  [./pipe050] #Reactor vessel to hot salt well (5)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 4.46445 3.01'
    orientation = '0 3.72912 0.081'
    roughness = 0.000015
    A = 0.264208
    Dh = 0.58
    length = 3.73
    n_elems = 11 #21
    initial_V = 2.05
    initial_T = 970
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./pipe060] #Hot well (6)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 8.30 3.09' #'0 8.19357 3.091'
    orientation = '0 1.970888 0.34'
    roughness = 0.000015
    A = 3.3145
    Dh = 1.452610
    length = 2.00
    n_elems = 6 #11
    initial_V = 0.164
    initial_T = 970
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./pipe070] #Hot salt well to CTAH (7)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 10.271 3.43'
    orientation = '0 3.22967 -0.046'
    roughness = 0.000015
    A = 0.3041
    Dh = 0.4399955
    length = 3.23
    n_elems = 9 #18
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
    scale_factors = '1 1e-1 1e-6'

    #WF_user_option = User		#Help pump coastdown case 3
    #User_defined_WF_parameters = '-7.15 2000000 -1'
  [../]

  [./pipe080] #CTAH hot manifold (8)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 13.5 3.384'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.4926017
    Dh = 0.28
    length = 3.418
    n_elems = 10 #19
    initial_V = 1.100
    initial_T = 970
    initial_P = 4.9e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./pipe090] #CTAH tubes (salt side) (9)
    type = PBPipe
    eos = eos
    position = '0 13.5 -0.034'
    orientation = '0 18.4692719 -0.164'
    roughness = 0.000015
    A = 0.4491779
    Dh = 0.004572
    length = 18.47
    n_elems = 50 #99
    initial_V = 1.207
    initial_T = 920
    initial_P = 4.1e5
    scale_factors = '1 1e-1 1e-6'

    HS_BC_type = Temperature
    Hw = 2 #000 		#cut for transient
    Ph = 392.9818537
    T_wall = 873.15
    Twall_init = 900
    hs_type = cylinder
    material_wall = ss-mat
    dim_wall = 2
    n_wall_elems = 4
    radius_i = 0.002286
    wall_thickness = 0.000889
  [../]

  [./pipe100] #CTAH cold manifold (10)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 18.2055 -0.197'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.1924226
    Dh = 0.175
    length = 3.418
    n_elems = 10 #19
    initial_V = 2.818
    initial_P = 2.8e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./pipe110] #CTAH to drain tank (11)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 18.2055 -3.615'
    orientation = '0 -3.4791917 -0.075'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 3.48
    n_elems = 10 #20
    initial_P = 3.1e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./pipe120] #Stand pipe (12)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 14.7263 -3.69'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 6.51
    n_elems = 19 #37
    initial_P = 2.5e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./pipe130] #Stand pipe to reactor vessel (13)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 14.7263 2.82'
    orientation = '0 -6.6018536 0.14'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 6.6033378
    n_elems = 19 #37
    initial_P = 1.8e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./pipe140] #Injection plenum (14)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 8.12445 2.96'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 3.04
    n_elems = 9 #17
    initial_P = 2.1e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./pipe150] #Downcomer (15)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 8.12445 -0.58'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.3038791
    Dh = 0.0560284
    length = 4.76
    n_elems = 14 #27
    initial_V = 1.695
    initial_P = 2.9e5
  [../]

  [./pipe160] #Downcomer to DHX (16)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 1 -0.58'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 0.58
    n_elems = 3 #3
    initial_V = 0.767
    initial_P = 2.5e5
  [../]

  [./DHX] # DHX shell side (17), DHX tube side (19), DHX tubes structure
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
    hs_type = cylinder

    radius_i = 0.00545
    position = '0 0.5 0'
    orientation = '0 0 1'
    A = 0.2224163
    Dh = 0.01085449
    A_secondary = 0.1836403
    Dh_secondary = 0.0109
    roughness = 0.000015
    roughness_secondary = 0.000015
    length = 2.5
    n_elems = 7 #14

    initial_V = 0.122 #0.11969487
    initial_V_secondary = 0.029349731
    initial_T = 870
    initial_T_secondary = 830
    initial_P = 1.9e5
    initial_P_secondary = 2.0e5

    #HT_surface_area_density = 353.0303766
    #HT_surface_area_density_secondary = 366.9724771
    HT_surface_area_density =  441.287971 #353.0303766
    HT_surface_area_density_secondary = 458.715596 #366.9724771
    #Hw = 526.266
    #Hw_secondary = 440
    HTC_geometry_type = Pipe
    HTC_geometry_type_secondary = Pipe
    PoD = 1.1

    Twall_init = 900
    wall_thickness = 0.0009
    dim_wall = 2
    material_wall = ss-mat
    n_wall_elems = 4
  [../]

  [./pipe180] #DHX to hot leg (18)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 1 2.5'
    orientation = '0 2.96445 .51'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.008
    n_elems = 9 #17
    initial_V = 0.767
    initial_T = 860
    initial_P = 2.6e5
  [../]

  [./pipe200] #DRACS hot leg 1 (20)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 2.5'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.45
    n_elems = 10 #20
  [../]

  [./pipe210] #DRACS hot leg 2 (21)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 -0.2 5.95'
    orientation = '0 -1 0'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.67
    n_elems = 11 #21
  [../]

  [./pipe220] #TCHX Manifold (22)
    type = PBOneDFluidComponent
    eos = eos
    position = '0 -3.87 5.95'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 2.60
    n_elems = 8 #15
  [../]

  [./pipe230] #TCHX salt tube (23)
    type = PBPipe
    eos = eos
    position = '0 -3.87 8.55'
    orientation = '0 -5.407402334 -2.6'
    roughness = 0.000015
    A = 0.1746822
    Dh = 0.0109
    length = 6.0
    n_elems = 17 #34
    initial_V = 0.04855862

    HS_BC_type = Temperature
    Hw = 1000
    #Ph = 64.10356978
    HT_surface_area_density = 366.972535
    T_wall = 799.15
    Twall_init = 800
    hs_type = cylinder
    material_wall = ss-mat
    dim_wall = 2
    n_wall_elems = 4
    radius_i = 0.00545
    wall_thickness = 0.0009
  [../]

  [./pipe240] #DRACS cold leg 1 (24)
    type = PBOneDFluidComponent
    eos = eos
    position = '1 -4.43 5.95'
    orientation = '0 1 0'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 4.43
    n_elems = 13 #25
  [../]

  [./pipe250] #DRACS cold leg 2 (25)
    type = PBOneDFluidComponent
    eos = eos
    position = '1 0 5.95'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 5.95
    n_elems = 17 #34
  [../]

  [./Branch260] #Top branch (26)			(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch
    inputs = 'pipe180(out) pipe040(out)'	# A = 0.03534292	A = 0.2512732
    outputs = 'pipe050(in)'   			# A = 0.264208
    center = '0 4.21445 3.01'
    volume = 0.132104
    K = '0.3713 0.00636 0.0'				# Check these
    Area = 0.264208						# L = 0.5
    eos = eos
    initial_V = 2.052
    initial_T = 970
    height = 0.1
    nodal_Tbc = true
  [../]

  #[./pipe260] #placeholder
  #  type = PBOneDFluidComponent
  #  eos = eos
  #  position = '0 3.96445 3.01'
  #  orientation = '0 1 0'
  #  roughness = 0.000015
  #  A = 0.264208
  #  Dh = 0.58
  #  length = 0.5
  #  n_elems =
  #[../]

  [./Branch270] #Middle branch (27)		(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch
    inputs = 'pipe140(out)'				# A = 0.3019068
    outputs = 'pipe150(in) pipe160(in)'   	# A = 0.3038791	A = 0.03534292
    center = '0 8.12445 -0.33'
    volume = 0.15193955
    K = '0.0 0.0 0.3727'					# Check these
    Area = 0.3038791					# L = 0.5
    eos = eos
    initial_V = 1.784
    initial_P = 2.5e5
    width = 0.2
  [../]

  #[./pipe270] #placeholder
  #  type = PBOneDFluidComponent
  #  eos = eos
  #  position = '0 8.12445 -0.08'
  #  orientation = '0 -1 0'
  #  roughness = 0.000015
  #  A = 0.3038791
  #  Dh = 0.0560284
  #  length = 0.5
  #  n_elems =
  #[../]

  [./Branch280] #Bottom branch (28)		(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch
    inputs = 'pipe150(out)'				# A = 0.3038791
    outputs = 'pipe010(in) pipe020(in)'   	# A = 1.327511 	A = 0.065
    center = '0 6.53445 -5.34'			# 8.02445
    volume = 0.2655022
    #K = '0.35964 0.0 0.3750'				# Check these
    K = '0.35964 0.0 0.6000'
    Area = 1.327511						# L = 0.2
    eos = eos
    initial_V = 0.388
    initial_P = 3.4e5
    width = 3.18
    height = 0.2
  [../]

  #[./pipe280] #placeholder
  #  type = PBOneDFluidComponent
  #  eos = eos
  #  position = '0 8.12445 -5.34'
  #  orientation = '0 -1 0'
  #  roughness = 0.000015
  #  A = 1.327511
  #  Dh = 0.03
  #  length = 0.2
  #  n_elems =
  #[../]

  [./pipe2] #Pipe to primary tank
    type = PBOneDFluidComponent
    eos = eos #eos3
    position = '0 8.25 3.19'
    orientation = '0 0 1'
    A = 1
    Dh = 1.12838
    length = 0.1
    n_elems = 1
    initial_V = 0.0
    initial_T = 970
  [../]

  [./pool2] #Primary Loop Expansion Tank
    type = PBLiquidVolume
    center = '0 8.25 3.74'
    inputs = 'pipe2(out)'
    Steady = 1
    K = '0.0'
    Area = 1
    volume = 0.9
    initial_level = 0.4
    initial_T = 970
    initial_V = 0.0
    #scale_factors = '1 1e-1 1e-2'
    display_pps = false
    covergas_component = 'cover_gas2'
    eos = eos #eos3
  [../]

  [./cover_gas2]
	type = CoverGas
	n_liquidvolume = 1
	name_of_liquidvolume = 'pool2'
	initial_P = 9e4
	initial_Vol = 0.5
	initial_T = 970
  [../]

  [./Branch501] #Primary tank branch 		(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBVolumeBranch
    inputs = 'pipe050(out)'				# A = 0.264208
    outputs = 'pipe060(in) pipe2(in)'   	# A = 3.3145 (0.264208)	A = 1 (0.264208)
    center = '0 8.25 3.09'
    volume = 0.0264208
    K = '0 0.3744 0.35187'				# Check these
    Area = 0.264208 					# L = 0.2
    eos = eos
    initial_V = 2.052
    initial_T = 970
    scale_factors = '1 1e-1 1e-6'
    width = 0.1
  [../]

  #[./pipe501] #placeholder
  #  type = PBOneDFluidComponent
  #  eos = eos
  #  position = '0 8.20 3.09'
  #  orientation = '0 1 0'
  #  roughness = 0.000015
  #  A = 0.264208
  #  Dh = 0.58
  #  length = 0.1
  #  n_elems =
  #[../]

  [./pipe1] #Pipe to DRACS tank
    type = PBOneDFluidComponent
    eos = eos #eos3
    position = '0 0 5.95'
    orientation = '0 0 1'
    A = 1
    Dh = 1.12838
    length = 0.1
    n_elems = 1
    initial_T = 852.7
  [../]

  [./pool1] #DRACS tank
    type = PBLiquidVolume
    center = '0 0 6.5'
    inputs = 'pipe1(out)'
    Steady = 1
    K = '0.0'
    Area = 1
    volume = 0.9
    initial_level = 0.4
    initial_T = 852.7
    initial_V = 0.0
    #scale_factors = '1 1e-1 1e-2'
    display_pps = true
    covergas_component = 'cover_gas1'
    eos = eos #eos3
  [../]

  [./cover_gas1]
	type = CoverGas
	n_liquidvolume = 1
	name_of_liquidvolume = 'pool1'
	initial_P = 2e5
	initial_Vol = 0.5
	initial_T = 852.7
  [../]

  [./Branch502] #DRACS tank branch 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBVolumeBranch
    inputs = 'pipe200(out)'			# A = 0.1836403
    outputs = 'pipe210(in) pipe1(in)'   # A = 0.1836403 A = 1
    center = '0 -0.1 5.95'
    volume = 0.003534292
    K = '0.0 0.0 0.3673'
    Area = 0.03534292
    eos = eos
  [../]

  [./Branch601] # In to hot manifold
    type = PBBranch
    inputs = 'pipe070(out)'			# A = 0.3041
    outputs = 'pipe080(in)'			# A = 0.4926017
    eos = eos
    K = '0.16804 0.16804'
    Area = 0.3041
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./Branch602] # In to CTAH salt side
    type = PBBranch
    inputs = 'pipe080(out)'			# A = 0.4926017
    outputs = 'pipe090(in)'			# A = 0.4491779
    eos = eos
    K = '0.01146 0.01146'
    Area = 0.4491779
    initial_V = 1.207
    initial_T = 970
    initial_P = 5.2e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./Branch603] # In to cold manifold
    type = PBBranch
    inputs = 'pipe090(out)'			# A = 0.4491779
    outputs = 'pipe100(in)'			# A = 0.1924226
    eos = eos
    K = '0.28882 0.28882'
    Area = 0.1924226
    initial_V = 2.818
    initial_P = 2.5e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./Branch604] # In to pipe to drain tank
    type = PBPump #PBBranch
    inputs = 'pipe100(out)'			# A = 0.1924226
    outputs = 'pipe110(in)'			# A = 0.3019068
    eos = eos
    K = '0.15422 0.15422'
    K_reverse = '2000000 2000000'
    Area = 0.1924226
    initial_P = 3.1e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./Branch605] # In to stand pipe
    type = PBSingleJunction
    inputs = 'pipe110(out)'
    outputs = 'pipe120(in)'
    eos = eos
    initial_P = 3.1e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./Branch606] # In to pipe to reactor vessel
    type = PBSingleJunction
    inputs = 'pipe120(out)'
    outputs = 'pipe130(in)'
    eos = eos
    initial_P = 1.9e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./Branch607] # In to injection plenum
    type = PBSingleJunction
    inputs = 'pipe130(out)'
    outputs = 'pipe140(in)'
    eos = eos
    initial_P = 1.8e5
    scale_factors = '1 1e-1 1e-6'
  [../]

  [./Diode608] # Fluidic diode		(CHECK FORWARD AND REVERSE K)
    type = PBPump
    inputs = 'pipe160(out)'			# A = 0.03534292
    outputs = 'DHX(primary_in)'		# A = 0.2224163
    eos = eos
    K = '50.0 50.0'
    K_reverse = '1.0 1.0'
    Area = 0.03534292
    initial_V = 0.767
    initial_P = 2.3e5
    scale_factors = '1 1e-2 1e-6'
  [../]

  [./Branch609] # Out of DHX
    type = PBBranch
    inputs = 'DHX(primary_out)'		# A = 0.2224163
    outputs = 'pipe180(in)'			# A = 0.03534292
    eos = eos
    #K = '100.3693 100.3693'				# Check K
    K = '94.8693 94.8693'
    Area = 0.03534292
    initial_V = 0.767
    initial_P = 1.3e5
    scale_factors = '1 1e-2 1e-6'
  [../]

  [./Branch610] #In to DRACS hot leg 1	(CHECK ABRUPT AREA CHANGE MODEL AND COEFFS)
    type = PBBranch
    inputs = 'DHX(secondary_in)'		# A = 0.1836403
    outputs = 'pipe200(in)'			# A = 0.03534292
    eos = eos
    K = '56.3666 56.3666'
    #K = '44.2 44.2'    				# Match m without h specified
    #K = '45.5 45.5'    				# Match m with h specified
    #K = '45.2 45.2' 				# Match m with r5Flibe
    Area = 0.03534292
    scale_factors = '1 1e-2 1e-6'
  [../]

  [./Branch611] #In to TCHX manifold
    type = PBSingleJunction
    inputs = 'pipe210(out)'
    outputs = 'pipe220(in)'
    eos = eos
  [../]

  [./Branch612] #In to TCHX salt tube 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'pipe220(out)' 			# A = 0.03534292
    outputs = 'pipe230(in)' 			# A = 0.1746822
    eos = eos
    K = '0.3655 0.3655'
    #K = '0.0 0.3655'
    Area = 0.03534292
  [../]

  [./Branch613] #In to DRACS cold leg 1 (CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'pipe230(out)' 			# A = 0.1746822
    outputs = 'pipe240(in)' 			# A = 0.03534292
    eos = eos
    K = '0.3655 0.3655'
    #K = '0.3655 0.0'
    Area = 0.03534292
  [../]

  [./Branch614] #In to DRACS cold leg 2
    type = PBSingleJunction
    inputs = 'pipe240(out)'
    outputs = 'pipe250(in)'
    eos = eos
  [../]

  [./Branch615] #In to DHX tube side 	(CHECK ABRUPT AREA CHANGE MODEL)
    type = PBBranch
    inputs = 'pipe250(out)' 			# A = 0.03534292
    outputs = 'DHX(secondary_out)' 	# A = 0.1836403
    eos = eos
    K = '0.3666 0.3666'
    #K = '0.0 0.3666'
    Area = 0.03534292
    scale_factors = '1 1e-2 1e-6'
  [../]

  [./Pump]
    type = PBPump
    inputs = 'pipe060(out)'		# A =
    outputs = 'pipe070(in)'		# A =
    eos = eos
    K = '0 0'
    K_reverse = '2000000 2000000'
    Area = 0.3041
    #Head = 369119 original, 367725 match SS
    #Head = 367475
    Head_fn = Phead3
    initial_V = 1.783
    initial_T = 970
    initial_P = 2.7e5
    scale_factors = '1 1e-1 1e-6'
  [../]

[]

[Postprocessors]
  [./DHX_flow]
    type = ComponentBoundaryFlow
    input = DHX(primary_out)
    execute_on = timestep_end
  [../]
  [./DHX_q]
    type = HeatExchangerHeatRemovalRate
    heated_perimeter = 78.51971015
    block = 'DHX:primary_pipe'
    execute_on = timestep_end
  [../]
  [./DHXshellBot]
    type = ComponentBoundaryVariableValue
    input = 'DHX:primary_pipe(in)'
    variable = 'temperature'
  [../]
  [./DHXshellTop]
    type = ComponentBoundaryVariableValue
    input = 'DHX:primary_pipe(out)'
    variable = 'temperature'
  [../]
  [./DHXTubeBot]
    type = ComponentBoundaryVariableValue
    input = 'DHX:secondary_pipe(in)'
    variable = 'temperature'
  [../]
  [./DHXTubeTop]
    type = ComponentBoundaryVariableValue
    input = 'DHX:secondary_pipe(out)'
    variable = 'temperature'
  [../]
  [./Corev]
    type = ComponentBoundaryVariableValue
    input = 'pipe010(in)'
    variable = 'velocity'
  [../]
  [./Corerho]
    type = ComponentBoundaryVariableValue
    input = 'pipe010(in)'
    variable = 'rho'
  [../]
  [./Bypassv]
    type = ComponentBoundaryVariableValue
    input = 'pipe020(in)'
    variable = 'velocity'
  [../]
  [./Bypassrho]
    type = ComponentBoundaryVariableValue
    input = 'pipe020(in)'
    variable = 'rho'
  [../]
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'lu'
  [../]
  [./FDP]
    type = FDP
    full = true
    solve_type = 'PJFNK'
  [../]

[] # End preconditioning block


[Executioner]
  #type = Steady
  type = Transient

  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '300'

  dt = 1
  dtmin = 1e-3

  [./TimeStepper]
    type = FunctionDT
    #time_t = '   0   99   100    700   701   1e5'
    #time_t = '   0   999  1000   1600  1601  1e5'

    #time_t = '   0   400 401 998  999   1250  1251  1500 1501 4000 4001 1e5'
    #time_dt ='   1   1   5   5    0.2   0.2   0.5   0.5  1    1     5    5'

    #time_t = '   0   98  99   500   501   1000  1001  2000 2001 1e5'
    time_t = '   0   380  390 1500  1510  2500  2510  3000 3010 1e6'
    time_dt ='   1   1   0.1  0.1   0.5   0.5   1     1    5     5'

    #time_t = '   0   98  99   125 126 500   501   1000  1001  2000 2001 1e5'
    #time_t = '   0   980  990   5000   5010   10000  10010  20000 20010 1e6'
    #time_dt ='   1   1   0.2  0.2 0.1 0.1 0.5   0.5   1     1    5     5'
  [../]

  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-4
  nl_max_its = 30

  start_time = 400.0
  num_steps = 15000
  end_time = 432

  l_tol = 1e-5 # Relative linear tolerance for each Krylov solve
  l_max_its = 200 # Number of linear iterations for each Krylov solve

   [./Quadrature]
      type = GAUSS # SIMPSON
      order = SECOND
   [../]
[]

[Problem]
  #restart_file_base = 'pbfhr-t_out_cp/0658'  #c1 right after transient
  #restart_file_base = 'pbfhr-t_out_cp/3043'  #c1 after coastdown, for long term
  # restart_file_base = 'pbfhr_out_cp/0001'
  #restart_file_base = 'pbfhr-t_out_cp(c2)/3912'
  restart_file_base = 'pbfhr-t_out_cp/0506'
[]

[Outputs]
  print_linear_residuals = false
  [./out]
    type = Checkpoint
  [../]

  [./out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end'
    interval = 5
    sequence = false
  [../]
  [./csv]
    type = CSV
    interval = 5
  [../]

  [./console]
    type = Console
    perf_log = true
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]
