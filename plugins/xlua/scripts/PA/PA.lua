
--**********************************************************************--
--** 				             FIND X-PLANE DATAREFS            	   **--
--**********************************************************************--


Grd_Speed = find_dataref ("sim/flightmodel/position/groundspeed", "number")
Gr_On_Ground = find_dataref ("sim/flightmodel/failures/onground_all", "number")
Altitude = find_dataref ("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot", "number")
Belt_On = find_dataref ("laminar/B747/safety/seat_belts/sel_dial_pos","number")
Smok_On = find_dataref (" laminar/B747/safety/no_smoking/sel_dial_pos","number")
Park = find_dataref("sim/flightmodel/controls/parkbrake","number")
Eng1 =  find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[0]","number")
Eng2 = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[1]","number")
Eng3 =  find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[2]","number")
Eng4 = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[3]","number")
Light1 = find_dataref("sim/cockpit2/switches/landing_lights_switch[1]","number")
Light2 = find_dataref("sim/cockpit2/switches/landing_lights_switch[2]","number")
Light3 = find_dataref("sim/cockpit2/switches/landing_lights_switch[3]","number")
Light4 = find_dataref("sim/cockpit2/switches/landing_lights_switch[0]","number")
VSpeed = find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot","number")

--**********************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS           **--
--***********************************************************************--

--PA  -------------------------------------------------------------
Boarding = create_dataref("sim/sounds/PA/Boarding", "number")
PBoarding = create_dataref("sim/sounds/PA/PBoarding", "number")
Taxi = create_dataref("sim/sounds/PA/Taxi", "number")
After_Takeoff = create_dataref("sim/sounds/PA/After_Takeoff", "number")
After_Landing = create_dataref("sim/sounds/PA/After_Landing", "number")
Gate_Arv = create_dataref("sim/sounds/PA/Gate_Arv", "number")
Approach = create_dataref("sim/sounds/PA/Approach", "number")
Descent = create_dataref("sim/sounds/PA/Descent", "number")
Takeoff = create_dataref("sim/sounds/PA/Takeoff", "number")
in_Cruise = create_dataref("sim/sounds/PA/in_Cruise", "number")
--Debug -------------------------------------------------------------
Gear_Roll = create_dataref("sim/flightmodel/state/Gear_Roll", "number")
Airborne = create_dataref("sim/flightmodel/state/Airborne", "number")
CruiseAlt = create_dataref("sim/flightmodel/state/CruiseAlt", "number")



function Aircraft_Pos()

-- Flight Phases -----------------------------

	if Altitude > 100 then
		Airborne = 1
	end
	if Airborne == 1 then
		if Altitude > 18000 then
		   CruiseAlt = 1
		 elseif Airborne == 0  then
		   CruiseAlt = 0
		end
	end
	
	if Gr_On_Ground == 1 then
		if Airborne == 1 then
		   in_Ground = 1
		 elseif Airborne == 0  then
		   in_Ground = 0
		end
	end


      if Gr_On_Ground == 1 then  
	      if Grd_Speed > 5 then
	      Gear_Roll = 1
	      end
      end
	  
-- Boarding  & Takeoff----------------------------

local Light = Light1 + Light2 + Light3 + Light4
	 if Airborne == 0 then
           if Smok_On == 0 and Light < 1  then  
	      PBoarding = 1
		 else
		 PBoarding = 0
	end
	end
	
	 if Airborne == 0  then
           if Belt_On >= 1 and Gear_Roll == 0 and Light < 1 then  
	      Boarding = 1
		 end
	end
	 if Airborne == 0  then
	      if Belt_On >= 1 and Gear_Roll == 1 and Light < 1 then  
           Taxi = 1
		 end
	end
	 if Airborne == 0  then
	      if Belt_On >= 1 and Gear_Roll == 1 and Light >= 2 then 
	      Takeoff = 1
	      Taxi = 0
		 end
	end
 
-- After Takeoff----------------------------

	if Airborne == 1 then 
	      if Grd_Speed > 80 and Altitude > 3000 then
	 	      if Belt_On >= 1 and VSpeed > 10 and CruiseAlt == 0 then
				 After_Takeoff = 1
			 end
		 end
	end
		
	if Airborne == 1 then 
		 if Grd_Speed > 80 and Altitude > 12000 then
		      if Belt_On == 0 and Light < 4 and VSpeed > 10 then
				 in_Cruise = 1
			 end
		 end
	 end

-- Descent  ---------------------------------------------------------------

      if CruiseAlt == 1 and Grd_Speed > 100 then
         if  (Altitude < 16000 and Altitude > 12000) then 
                if Belt_On >= 1 then
	          Descent = 1
	          end
		end
	end

--  Approach ---------------------------------------------------------------

	if CruiseAlt == 1 and Grd_Speed > 80 then
         if  Altitude < 5000 and Belt_On >= 1 then
		Approach = 1
		 end
	end

-- Landing ----------------------------------------------------------------

	if in_Ground == 1 and CruiseAlt == 1 then
	    if Grd_Speed < 20 and Belt_On >= 1 then
		After_Landing = 1 
	     end
     end

-- Gate Arrival ---------------------------------------------------------------

Engines = Eng1 + Eng2 + Eng3 + Eng4
	if in_Ground == 1 and CruiseAlt == 1 then 
      	if Grd_Speed < 1 and Park >= 1 and Belt_On == 0 and Engines == 0 then
			Gate_Arv = 1
	      end
      end
end

function after_physics()
	Aircraft_Pos() 
end