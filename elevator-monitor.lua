peripheral.find("modem", rednet.open)
 
-- Modify these based on your floor and monitor name
monitorName = "monitor_0"
floor = 1
 
monitor = peripheral.wrap(monitorName)
 
CURRENT_FLOOR = 1
IS_MOVING = false
local redstoneSide = "front"
local redstoneTimer = os.startTimer(0.25)
 
term.clear()
print("ElevatorOS Floor Monitor v1.5")
 
function getTimestamp()
 return "[" .. textutils.formatTime(os.time()) .. "]"
end
 
function term.writeTo(_x, _y, _text)
 term.setCursorPos(_x, _y)
 term.write(_text)
end
 
function executeRedstone(_id)
 print(getTimestamp() .. " Outputting Redstone ID " .. _id)
 if _id == 1 then redstoneSide = "front"
 elseif _id == 2 then redstoneSide = "back"
 elseif _id == 3 then redstoneSide = "left"
 elseif _id == 4 then redstoneSide = "right"
 elseif _id == 5 then redstoneSide = "top"
 end
 rs.setOutput(redstoneSide, true)
 redstoneTimer = os.startTimer(0.25)
end
 
function touch(_x, _y)
 local floorId = 0
 -- Floor 1
 if floor ~= 1 then floorId = floorId + 1 end
 if _x >= 4 and _y >= 4 and _x <= 9 and _y <= 8 then
  executeRedstone(floorId) 
 end
 -- Floor 2
 if floor ~= 2 then floorId = floorId + 1 end
 if _x >= 12 and _y >= 4 and _x <= 17 and _y <= 8 then
  executeRedstone(floorId)
 end
 -- Floor 3
 if floor ~= 3 then floorId = floorId + 1 end
 if _x >= 20 and _y >= 4 and _x <= 25 and _y <= 8 then
  executeRedstone(floorId)
 end
 -- Floor 4
 if floor ~= 4 then floorId = floorId + 1 end
 if _x >= 4 and _y >= 12 and _x <= 9 and _y <= 16 then
  executeRedstone(floorId)
 end
 -- Floor 5
 if floor ~= 5 then floorId = floorId + 1 end
 if _x >= 12 and _y >= 12 and _x <= 17 and _y <= 16 then
  executeRedstone(floorId)
 end
 -- Floor 6
 if floor ~= 6 then floorId = floorId + 1 end
 if _x >= 20 and _y >= 12 and _x <= 25 and _y <= 16 then
  executeRedstone(floorId)
 end
end
 
function drawButtons()
 lastTerm = term.current()
 term.redirect(monitor)
 term.setBackgroundColor(colors.black)
 term.clear()
 
 local col = colors.lightBlue
 local grey = colors.lightGray
 if IS_MOVING or CURRENT_FLOOR ~= floor then col = grey end
 
 term.setTextColor(colors.black)
 
 -- Draw Boxes w/ Numbers
 paintutils.drawFilledBox(4, 4, 9, 8, (floor == 1 and grey) or col)
 term.writeTo(6, 6, "01")
 
 paintutils.drawFilledBox(12, 4, 17, 8, (floor == 2 and grey) or col)
 term.writeTo(14, 6, "02")
 
 paintutils.drawFilledBox(20, 4, 25, 8, (floor == 3 and grey) or col)
 term.writeTo(22, 6, "03")
 
 paintutils.drawFilledBox(4, 12, 9, 16, (floor == 4 and grey) or col) 
 term.writeTo(6, 14, "04")
 
 paintutils.drawFilledBox(12, 12, 17, 16, (floor == 5 and grey) or col)
 term.writeTo(14, 14, "05")
 
 paintutils.drawFilledBox(20, 12, 25, 16, (floor == 6 and grey) or col)
 term.writeTo(22, 14, "06")
   
 term.redirect(lastTerm)
end
 
drawButtons()
 
while true do
 event = { os.pullEvent() }
 if event[1] == "monitor_touch" and not IS_MOVING and CURRENT_FLOOR == floor then
  touch(event[3], event[4])
 elseif event[1] == "timer" then
  if event[2] == redstoneTimer then
   rs.setOutput(redstoneSide, false)
  end
 elseif event[1] == "rednet_message" then
  if event[3]:find("elevator_stop") then
   message, data = event[3]:match("([^,]+),([^,]+)")
   print(getTimestamp() .. " Elevator Stopped @ Floor " .. data .. " (" .. event[2] .. ")")
   CURRENT_FLOOR = tonumber(data)
   IS_MOVING = false
   drawButtons()
  elseif event[3] == "elevator_start" then
   print(getTimestamp() .. " Elevator Moving (" .. event[2] .. ")")
   IS_MOVING = true
   drawButtons()
  elseif event[3] == "elevator_reboot" then
   shell.execute("reboot")
  end
 end
end