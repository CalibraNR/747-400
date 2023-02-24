
--**********************************************************************--
--** 				             FIND X-PLANE DATAREFS            	                        **--
--**********************************************************************--

Altitude = find_dataref ("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
Gear = find_dataref ("sim/flightmodel2/gear/deploy_ratio[0]")
Flaps = find_dataref ("sim/cockpit2/controls/flap_handle_deploy_ratio")
Battery = find_dataref("sim/cockpit2/electrical/battery_on[0]")
On_Ground = find_dataref ("sim/flightmodel/failures/onground_any")
ASpeed = find_dataref ("sim/flightmodel/position/indicated_airspeed")
Throttle = find_dataref ("sim/cockpit2/engine/actuators/throttle_ratio_all")
VSpeed = find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
Airborne = find_dataref("sim/flightmodel/state/Airborne")
DsH = find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_dh_lit_pilot")
RollGr = find_dataref("sim/cockpit2/gauges/indicators/roll_AHARS_deg_copilot")

--**********************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS           **--
--***********************************************************************--

Dont_sink = create_dataref("sim/cockpit/Warning/Dont_sink", "number")
Low_Terrain = create_dataref("sim/cockpit/Warning/Low_Terrain", "number")
Low_Gear = create_dataref("sim/cockpit/Warning/Low_Gear", "number")
Low_Flaps = create_dataref("sim/cockpit/Warning/Low_Flaps", "number")
Terrain = create_dataref("sim/cockpit/Warning/Terrain", "number")
Pull_Up = create_dataref("sim/cockpit/Warning/Pull_Up", "number")
Sinkrate = create_dataref("sim/cockpit/Warning/Sinkrate", "number")
BankWr = create_dataref("sim/cockpit/Warning/BankWr", "number")
Minimim = create_dataref("sim/cockpit/Warning/Minimim", "number")

--------------------------------------------------------------------------------------------


function GPWS()

	if Airborne == 1 and  Battery == 1 and On_Ground == 0 
	then WSys = true
	else WSys = false
	end

--Dont_sink-------------------------------------------------------

	if WSys == true  then
	      if (ASpeed < 120  and ASpeed > 80 ) then 
		      if Flaps < 0.8 then 
				 if VSpeed > 500
                       then Dont_sink = 1
                      elseif VSpeed < -200
				 then Dont_sink = 0
				end				
		     elseif Flaps > 0.9
		     then Dont_sink = 0
		     end
		 elseif ASpeed > 140
	      then Dont_sink = 0
	      end
	else Dont_sink = 0
	end

--Low_Terrain -------------------------------------------------------

	if WSys == true  then
	if ASpeed > 200 then
		if (Altitude < 1600  and Altitude > 200)  then
		      if  Flaps < 0.2 then
		          if (VSpeed < -200 and VSpeed > -2400)
			     then Low_Terrain = 1
		          elseif (VSpeed > 0  or VSpeed < -2500)
                     then Low_Terrain = 0
			     end
		     elseif Flaps > 0.8 
			then Low_Terrain = 0
		     end
		 elseif (Altitude > 1800  or  Altitude < 200)
		then Low_Terrain = 0
		 end
	elseif ASpeed < 180
	then Low_Terrain = 0
	end
	else Low_Terrain = 0
	end

--Low_Gear -------------------------------------------------------

	if WSys == true  then
		if Altitude < 400 and ASpeed < 200 then
		     if Gear < 0.1 then
		          if VSpeed < 300
			     then Low_Gear = 1
		          elseif VSpeed > 400
                    then Low_Gear = 0
			     end
		     elseif Gear > 0.9 then
		     Low_Gear = 0
		     end
		elseif Altitude > 500 or  ASpeed > 200 
		then Low_Gear = 0
		end
	else Low_Gear = 0
	end

--Low_Flaps-------------------------------------------------------

	if WSys == true  then
		     if Flaps < 0.4 and Altitude < 600 then
			     if (VSpeed < -50 and VSpeed > -2500) then
		          if (Throttle < 0.7 and ASpeed < 200)
			     then Low_Flaps = 1
		          elseif Throttle > 0.8 or ASpeed > 220
                    then Low_Flaps = 0
			     end
			elseif	 (VSpeed > 200 or VSpeed < -2500)
			then Low_Flaps = 0
			end
		elseif Flaps > 0.6  or Altitude > 1000 
		then Low_Flaps = 0
		end
	else Low_Flaps = 0
	end   

--Pull_Up-------------------------------------------------------

	if WSys == true  then
		if (Altitude > 3500 and Altitude < 10000) then
			if  ASpeed > 260 then
				if  VSpeed < -5000 
				then Pull_UpH = 1
				elseif  VSpeed > -4800 
				then Pull_UpH = 0
				end
			elseif ASpeed < 240
			then Pull_UpH = 0
			end
		elseif  (Altitude < 3500 or Altitude > 11000)
		then Pull_UpH = 0
		end
	else Pull_UpH = 0
	end

	if WSys == true  then
		if Altitude < 3500 then
			if  ASpeed > 260 then
				if  VSpeed < -2600 
				then Pull_UpL = 1
				elseif  VSpeed > -2500 
				then Pull_UpL = 0
				end
			elseif ASpeed < 250
			then Pull_UpL = 0
			end
		elseif  Altitude > 3500
		then Pull_UpL = 0
		end
	else Pull_UpL = 0
	end

	if Pull_UpL == 1 or Pull_UpH == 1
	then Pull_Up = 1
	elseif Pull_UpL == 0 and Pull_UpH == 0
	then Pull_Up = 0
	end

--Sinkrate-------------------------------------------------------

	if WSys == true  then
	    if Altitude < 3000 and ASpeed < 180 then
	         if (VSpeed < -2600 and VSpeed > -3500 )
		     then SinkrateL = 1
	          elseif (VSpeed > -2500  or  VSpeed < -3600 )
			then SinkrateL = 0
	          end
		elseif Altitude > 3000 or ASpeed > 200
		then SinkrateL = 0
	    end	  
	else SinkrateL = 0
	end
	
		if WSys == true  then
		     if (Altitude > 3100 and Altitude < 10000) then
		          if (VSpeed < -3500 and VSpeed > -5000)
			     then SinkrateH = 1
		          elseif (VSpeed > -3500  or VSpeed < -5000)
				then SinkrateH = 0
		          end
			elseif (Altitude < 3100  or Altitude > 10000)
			then SinkrateH = 0
		     end	  
	else SinkrateH = 0
     end
	 
	if SinkrateL == 1 or SinkrateH == 1
	then Sinkrate = 1
	elseif SinkrateL == 0 and SinkrateH == 0
	then Sinkrate = 0
	end
end

function Minimums()
	if Airborne == 1 and Battery == 1 then 
	   if Altitude < 800 
	   then Descent = 1
		else Descent = 0
		end
		else Descent = 0
	end
	
	if Descent == 1 then
	   if DsH == 1 
	   then Minimim = 1
	   else Minimim = 0
	   end
	 else Minimim = 0 
	 end
end

function Bank_W()
	if WSys == true then 
	      if (Bank < -36 or Bank > 36)
	      then BankWr = 1
		 elseif (Bank > -34 and Bank < 34 )
		 then BankWr = 0
		 end
	else BankWr = 0
	end
end

function after_physics()
	GPWS() 
	Minimums()
	 Bank_W()
end