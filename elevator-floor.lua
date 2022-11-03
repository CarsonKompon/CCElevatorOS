peripheral.find("modem", rednet.open)
 
-- Modify based on your floor
floor = 1
 
CURRENT_FLOOR = 1
IS_MOVING = false
local checkTimer = os.startTimer(1)
 
term.clear()
print("ElevatorOS Floor Handler v1.5")
 
function getTimestamp()
 return "[" .. textutils.formatTime(os.time()) .. "]"
end
 
function myStop()
 rednet.broadcast("elevator_stop," .. floor)
 print(getTimestamp() .. " Elevator Stopped @ Floor " .. floor .. " (SELF)")
 CURRENT_FLOOR = floor
 IS_MOVING = false
end
 
function netStop(sender, newFloor)
 print(getTimestamp() .. " Elevator Stopped @ Floor " .. newFloor .. " (" .. sender .. ")")
 IS_MOVING = false
 CURRENT_FLOOR = newFloor
end
 
function netMoving(sender)
 print(getTimestamp() .. " Elevator Moving (" .. sender .. ")")
 IS_MOVING = true
end
 
while true do
    event, sender, message = os.pullEvent()
 if event == "redstone" then
        if rs.getInput("back") then
            checkTimer = os.startTimer(1)
        end
 elseif event == "timer" then
  if sender == checkTimer and rs.getInput("back") then
   myStop()
  end
    elseif event == "rednet_message" then       
  if message:find("elevator_stop") then
   m1, data = message:match("([^,]+),([^,]+)")
   netStop(sender, data)
  elseif message == "elevator_start" then
   netMoving(sender)
  elseif message == "elevator_reboot" then
   shell.execute("reboot")
  end
    end 
end