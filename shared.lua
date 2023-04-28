
reportTypes = {
    [1] = {"Rapor", {18, 17, 64, 15, 14, 16}, "SUP", 214, 6, 6, "Use this type if you are reporting a player about a issue that has occured." },
   [2] = {"Soru", {18, 17, 64, 15, 14, 16}, "INT", 255, 126, 0, "Use this type if you are having a issue with a interior." },
   [3] = {"Item Issue", {18, 17, 64, 15, 14, 16}, "ITM", 255, 126, 0, "Use this type if you need items spawned or anything related to your item invetory." },
   [4] = {"General Question", {30, 18, 17, 64, 15, 14, 16}, "SUP", 70, 200, 30, "Use this type if you have any questions." },
   [5] = {"Vehicle Related Issues", {30, 18, 17, 64, 15, 14, 16}, "VEH", 255, 126, 0, "Use this type if you have a issue with a vehicle." },
   [6] = {"Vehicle Build/Import Requests", {39, 43}, "VCT", 176, 7, 237, "Use this type to contact the VCT." },
   [7] = {"Scripting Question", {32}, "ScrT", 148, 126, 12, "Use this type if you with to contact the Scripting Team." },
   [8] = {"Vehicle Break In", {14, 18, 17, 64, 15}, "VEH-BI", 255, 126, 0, "Use this type if you wish to report for a vehicle break in."},
   [9] = {"Interior Break In", {14, 18, 17, 64, 15}, "INT-BI", 255, 126, 0, "Use this type if you wish to report for an interior break in."}
   --[8] = {"Mapping Issue", {44, 28}, "MAP", 0, 0, 0 }, MAXIME IF YOU EVER WANT TO BRING THIS BACK, UNCOMMENT
}


function getReportTypes( type )
   return type and reportTypes[type] or reportTypes
end

adminTeams =exports.vrp_integration:getAdminStaffNumbers()
auxiliaryTeams =exports.vrp_integration:getAuxiliaryStaffNumbers()
SUPPORTER =exports.vrp_integration:getSupporterNumber()

function getReportInfo(row, element)
   if not isElement(element) then
       element = nil
   end

   local staff = reportTypes[tonumber(row)][2]
   local players = getElementsByType("player")
   local vcount = 0
   local scount = 0


   for k,v in ipairs(staff) do
       if v == 39 or v == 43 then

           for key, player in ipairs(players) do
               if exports.vrp_integration:isPlayerVCTMember(player) or exports.vrp_integration:isPlayerVehicleConsultant(player) then
                   vcount = vcount + 1
                   save = player
               end
           end

           if vcount==0 then
               return false, "There is currently no VCT Members online. Contact them here: http://forums.owlgaming.net/forms.php?do=form&fid=42"
           elseif vcount==1 and save == element then -- Callback for checking if a aux staff logs out
               return false, "There is currently no VCT Members online. Contact them here: http://forums.owlgaming.net/forms.php?do=form&fid=42"
           end
       elseif v == 32 then

           for key, player in ipairs(players) do
               if exports.vrp_integration:isPlayerScripter(player) then
                   scount = scount + 1
                   save = player
               end
           end

           if scount==0 then
               return false, "There is currently no members of the Scripting team online. Use Support Center at www.owlgaming.net/support.php"
           elseif scount==1 and save == element then -- Callback for checking if a aux staff logs out
               return false, "There is currently no members of the Scripting team online. Use Support Center at www.owlgaming.net/support.php"
           end
       end
   end

   local name = reportTypes[row][1]
   local abrv = reportTypes[row][3]
   local red = reportTypes[row][4]
   local green = reportTypes[row][5]
   local blue = reportTypes[row][6]

   return staff, false, name, abrv, red, green, blue
end

function isSupporterReport(row)
   local staff = reportTypes[row][2]

   for k, v in ipairs(staff) do
       if v == SUPPORTER then
           return true
       end
   end
   return false
end

function isAdminReport(row)
   local staff = reportTypes[row][2]

   for k, v in ipairs(staff) do
       if string.find(adminTeams, v) then
           return true
       end
   end
   return false
end

function isAuxiliaryReport(row)
   local staff = reportTypes[row][2]

   for k, v in ipairs(staff) do
       if string.find(auxiliaryTeams, v) then
           return true
       end
   end
   return false
end

function showExternalReportBox(thePlayer)
   if not thePlayer then return false end
   return (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3")
end

function showTopRightReportBox(thePlayer)
   if not thePlayer then return false end
   return (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "1" or getElementData(thePlayer, "report_panel_mod") == "3")
end
