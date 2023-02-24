
--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

Generator1 = find_dataref("sim/cockpit2/electrical/generator_amps[0]")
Generator2 = find_dataref("sim/cockpit2/electrical/generator_amps[1]")
Generator3 = find_dataref("sim/cockpit2/electrical/generator_amps[2]")
Generator4 = find_dataref("sim/cockpit2/electrical/generator_amps[3]")
Generator_apu = find_dataref("sim/cockpit/electrical/generator_apu_on")
Generator_gpu = find_dataref("sim/cockpit/electrical/gpu_on")
BleedL = find_dataref("laminar/B747/air/duct_pressure_L")
BleedR = find_dataref("laminar/B747/air/duct_pressure_R")
Pack1_Sw = find_dataref("laminar/B747/air/pack_ctrl/sel_dial_pos[0]")
Pack2_Sw = find_dataref("laminar/B747/air/pack_ctrl/sel_dial_pos[1]")
Pack3_Sw = find_dataref("laminar/B747/air/pack_ctrl/sel_dial_pos[2]")
UFan_Sw = find_dataref("laminar/B747/button_switch/position[38]")
LFan_Sw = find_dataref("laminar/B747/button_switch/position[39]")
Hyd1_Pr = find_dataref(" sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1")
Hyd2_Pr = find_dataref(" sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2")
Radio_Frq = find_dataref("sim/cockpit2/radios/actuators/com2_frequency_hz")
Radio_Sw = find_dataref("laminar/B747/comm/rtp_R/off_status") 
VHF2_Sw = find_dataref("laminar/B747/comm/rtp_R/vhf_R_status") 
Transp_cd = find_dataref("sim/cockpit/radios/transponder_code")
Transp_md = find_dataref("sim/cockpit2/radios/actuators/transponder_mode")
--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--
Packs_L = create_dataref("sim/cockpit2/Cooling/Packs_L", "number")
Packs_U = create_dataref("sim/cockpit2/Cooling/Packs_U", "number")
Packs_R = create_dataref("sim/cockpit2/Cooling/Packs_R", "number")
Packs_EXT = create_dataref("sim/cockpit2/Cooling/Packs_EXT", "number")
Avionics_Power	= create_dataref("sim/cockpit2/electrical/Avionics_Power", "number")
HydPump = create_dataref("sim/cockpit2/hydraulics/HydPump", "number")
ATCGRD 	= create_dataref("sim/cockpit2/ATC/ATCGRD", "number")
ATCCTR 	= create_dataref("sim/cockpit2/ATC/ATCCTR", "number")
ATCTWR 	= create_dataref("sim/cockpit2/ATC/ATCTWR", "number")
ATCAPP 	= create_dataref("sim/cockpit2/ATC/ATCAPP", "number")
U_Fans = create_dataref("sim/cockpit2/Cooling/U_Fans", "number")
L_Fans = create_dataref("sim/cockpit2/Cooling/L_Fans", "number")
-- Avionics -------------------------------------------------

function Avionics()

   if Generator1 > 5 or Generator2 > 5
     or Generator3 > 5 or Generator4 > 5
	 then Eng_Gen = 1 
	 elseif Generator1 == 0 and Generator2 == 0
     and Generator3 == 0 and Generator4 == 0
	 then Eng_Gen = 0 
end

   if Eng_Gen == 1 or Generator_apu == 1 or Generator_gpu == 1 then
	Avionics_Power = 1 
	elseif Eng_Gen == 0 and Generator_apu == 0 and Generator_gpu == 0  then
	Avionics_Power = 0 
end
end

--  Packs--------------------------------------------------

function Packs ()
     if Avionics_Power == 1 then 
	     if BleedL > 10 then  
		     if Pack1_Sw == 1 
			     then Packs_L = 1
				 elseif Pack1_Sw == 0
				 then Packs_L = 0
				 end
		 elseif BleedL < 5
		 then Packs_L = 0
		 end
	elseif Avionics_Power == 0
	then Packs_L = 0
	end
	
	     if Avionics_Power == 1 then 
	     if BleedR > 10 then  
		     if Pack3_Sw == 1 
			     then Packs_R = 1
				 elseif Pack3_Sw == 0
				 then Packs_R = 0
				 end
		 elseif BleedR < 5
		 then Packs_R= 0
		 end
	elseif Avionics_Power == 0
	then Packs_R = 0
	end
	
		     if Avionics_Power == 1 then 
	     if BleedR > 10 or BleedL > 10 then  
		     if Pack2_Sw >= 1 
			     then Packs_U = 1
				 elseif Pack2_Sw == 0
				 then Packs_U = 0
				 end
		 elseif BleedR < 5 and BleedL < 5
		 then Packs_U = 0
		 end
	elseif Avionics_Power == 0
	then Packs_U = 0
	end

   if Packs_L == 1 or Packs_R == 1 
   then Packs_EXT = 1
	elseif Packs_L == 0 and Packs_R == 0 
	then Packs_EXT = 0
	end

	 if Avionics_Power == 1 then 
	     if UFan_Sw == 1
		 then U_Fans = 1 
		 elseif UFan_Sw == 0
		then U_Fans = 0
		end
	 elseif Avionics_Power == 0
     then U_Fans = 0
     end
	 
	 	 if Avionics_Power == 1 then 
	     if LFan_Sw == 1
		 then L_Fans = 1 
		 elseif LFan_Sw == 0
		then L_Fans = 0
		end
	 elseif Avionics_Power == 0
     then L_Fans = 0
     end
end	 
	 
-- Hydraulics -------------------------------------------------

function Hydraulics ()
   if Avionics_Power == 1 then
         if Hyd1_Pr > 500 or Hyd2_Pr > 500 
		 then HydPump = 1
		 elseif Hyd1_Pr < 100 and Hyd2_Pr < 100 
		 then HydPump = 0
		 end	
	elseif Avionics_Power
	then HydPump = 0
end
end


-- ATC-----------------------------------
	
 function ATC ()
     if Avionics_Power == 1  then
           if Radio_Sw == 0 then
		      if Transp_cd == 2000 then
			  if Transp_md == 1 then
			  if VHF2_Sw == 1 then
	           if Radio_Frq > 11810 and Radio_Frq < 11890 
		      then ATCGRD = 1
		      else ATCGRD = 0
		      end
			 elseif VHF2_Sw == 0
			 then ATCGRD = 0
			 end
			 elseif Transp_md > 1
			 then ATCGRD = 0
			 end
			 elseif Transp_cd  ~= 2000
			 then ATCGRD = 0
			 end
	      elseif Radio_Sw == 1
      	 then ATCGRD = 0
	      end
	elseif Avionics_Power == 0
	then ATCGRD = 0
	end
	
	
	   if Avionics_Power == 1  then
           if Radio_Sw == 0 then
		      if Transp_cd == 2000 then
			  if Transp_md == 1 then
			if VHF2_Sw == 1 then
			 if Radio_Frq > 11910 and Radio_Frq < 11990 
			  then ATCCTR = 1
		      else ATCCTR = 0
		      end
			 elseif VHF2_Sw == 0 
			 then ATCCTR = 0
			 end
			 elseif Transp_md > 1
			 then ATCCTR = 0
			 end
			 elseif Transp_cd  ~= 2000
			 then ATCCTR = 0
			 end
	      elseif Radio_Sw == 1
      	 then ATCCTR = 0
	      end
	elseif Avionics_Power == 0
	then ATCCTR = 0
	end

   if Avionics_Power == 1  then
           if Radio_Sw == 0 then
		      if Transp_cd == 2000 then
			  if Transp_md == 1 then
			  if VHF2_Sw == 1 then
			  if Radio_Frq > 12010 and Radio_Frq < 12090 
			  then ATCTWR = 1
		      else ATCTWR = 0
		      end
			  elseif VHF2_Sw == 0
			 then ATCTWR = 0
			 end
			 elseif Transp_md > 1
			 then ATCTWR = 0
			 end
			 elseif Transp_cd  ~= 2000
			 then ATCTWR = 0
			 end
	      elseif Radio_Sw == 1
      	 then ATCTWR = 0
	      end
	elseif Avionics_Power == 0
	then ATCTWR = 0
	end	
	
	   if Avionics_Power == 1  then
           if Radio_Sw == 0 then
		      if Transp_cd == 2000 then
			  if Transp_md == 1 then
			  if VHF2_Sw == 1 then
			 if Radio_Frq > 12110 and Radio_Frq < 12190 
			  then ATCAPP = 1
		      else ATCAPP = 0
		      end
			  elseif VHF2_Sw == 0 
			 then ATCAPP = 0
			 end
			 elseif Transp_md > 1 
			 then ATCAPP = 0
			 end
			 elseif Transp_cd  ~= 2000
			 then ATCAPP = 0
			 end
	      elseif Radio_Sw == 1
      	 then ATCAPP = 0
	      end
	elseif Avionics_Power == 0
	then ATCAPP = 0
	end
end


function after_physics()
    Hydraulics()
	Packs()
	Avionics() 
	ATC()
end