local RS=game:GetService("RunService");local Players=game:GetService("Players")
local TS=game:GetService("TweenService");local Light=game:GetService("Lighting")
local plr=Players.LocalPlayer;local PGui=plr.PlayerGui

-- ── Variables ──
local flyOn,flySpeed,flyConn,bg,bv=false,50,nil,nil,nil
local walkOn,walkDef,walkVal=false,16,50
local jumpOn,jumpDef,jumpVal,jumpConn=false,50,150,nil
local noclipOn,noclipConn=false,nil
local chatSpamOn,chatSpamDelay,chatMsg=false,1,"Joey Hub"
local savedPos,tweenSpd=nil,10
local godOn,godConn=false,nil
local antiKbOn,antiKbConn=false,nil
local autoHealOn,healConn,healTarget=false,nil,100
local silentAimOn=false
local hitboxOn,hitboxSize,hitboxData=false,10,{}
local killAuraOn,killAuraConn,killAuraRange=false,nil,15
local autoAtkOn,autoAtkConn=false,nil
local aimbotOn,aimbotConn,aimTarget=false,nil,nil
local nearOn,nearConn,nearRange=false,nil,100
local espOn,espData=false,{}
local espFill,espOutline=Color3.fromRGB(255,50,50),Color3.fromRGB(255,130,130)
local freezeOn,freezeConn=false,nil
local spectateOn=false;local followOn,followConn=false,nil;local invisOn=false
local fullbrightOn,fbSaved=false,{}
local antiAfkOn,antiAfkConn=false,nil
local fpsSaved,fpsBoostOn=false,{}
local removedWalls,removedTrees={},{}
local waterWalkOn,waterWalkConn=false,nil
local gravityDefault=workspace.Gravity
local fpsCountOn,pingDispOn,coordDispOn,speedoOn=false,false,false,false
local infoHUD,infoConn=nil,nil
local guiColor1,guiColor2=Color3.fromHex("0f7bff"),Color3.fromHex("0ff3ff")
local currentLang="EN"
local WindUI,windUIGuis=nil,{}

-- ── Lang ──
local L={
    EN={main="Main",combat="Combat",players="Players",world="World",settings="Settings",
        fly="Fly",flySpd="Fly Speed",walk="Walk Speed",walkVal="Walk Speed Value",
        jump="High Jump",jumpVal="Jump Power",
        savePos="Save Position",tpSaved="TP to Saved",tweenSaved="Tween to Saved",tweenSpd="Tween Speed",
        chatSpam="Chat Spam",chatMsg="Message",chatDelay="Spam Delay (sec)",
        godMode="God Mode",antiKb="Anti Knockback",autoHeal="Auto Heal",healAmt="Heal Target HP",
        silentAim="Silent Aim",hitbox="Hitbox Expander",hitboxSz="Hitbox Size",
        killAura="Kill Aura",killRange="Kill Aura Range",autoAtk="Auto Attack",
        selPlr="Select Player",refresh="Refresh List",
        tpPlr="TP to Player",tweenPlr="Tween to Player",tweenSpdP="Tween Speed",
        aimbot="Aimbot",nearAim="Aimbot Near",range="Range",
        freezePlr="Freeze Player",spectate="Spectate Player",
        followPlr="Follow Player",pingPlr="Ping Player",
        teamCheck="Team Check",invis="Invisible",
        noclip="NoClip",esp="ESP Players",espColor="ESP Color",plrInfo="Player Info",
        timeChng="Time (0-23)",gravChng="Gravity",rmWalls="Remove Walls",rmTrees="Remove Trees",
        brightSky="Bright Sky",noFog="No Fog",waterWalk="Water Walk",
        fps="FPS Boost",fullbright="FullBright",antiAfk="Anti AFK",
        unlockFPS="Unlock FPS",fovChng="FOV",camShake="Camera Shake Off",
        hideGUI="Hide Game GUI",lagSwitch="Lag Switch",
        rejoin="Rejoin",serverHop="Server Hop",
        fpsCount="FPS Counter",pingDisp="Ping Display",coordDisp="Coordinates",speedo="Speedometer",
        guiColor="GUI Color",lang="Language",reset="Reset GUI"},
    TH={main="หลัก",combat="ต่อสู้",players="ผู้เล่น",world="โลก",settings="ตั้งค่า",
        fly="บิน",flySpd="ความเร็วบิน",walk="วิ่งเร็ว",walkVal="ค่าความเร็ว",
        jump="กระโดดสูง",jumpVal="แรงกระโดด",
        savePos="บันทึกตำแหน่ง",tpSaved="วาปไปที่บันทึก",tweenSaved="เคลื่อนที่ไปที่บันทึก",tweenSpd="ความเร็ว Tween",
        chatSpam="สแปมแชท",chatMsg="ข้อความ",chatDelay="หน่วงเวลา (วิ)",
        godMode="God Mode",antiKb="ป้องกันกระเด็น",autoHeal="ฟื้น HP อัตโนมัติ",healAmt="เป้าหมาย HP",
        silentAim="Silent Aim",hitbox="ขยาย Hitbox",hitboxSz="ขนาด Hitbox",
        killAura="Kill Aura",killRange="ระยะ Kill Aura",autoAtk="โจมตีอัตโนมัติ",
        selPlr="เลือกผู้เล่น",refresh="รีเฟรชรายชื่อ",
        tpPlr="วาปไปหาผู้เล่น",tweenPlr="เคลื่อนที่ไปหาผู้เล่น",tweenSpdP="ความเร็ว Tween",
        aimbot="เล็งอัตโนมัติ",nearAim="เล็งคนใกล้สุด",range="ระยะ",
        freezePlr="แช่แข็งผู้เล่น",spectate="ดูมุมมองผู้เล่น",
        followPlr="ตามผู้เล่น",pingPlr="Ping ผู้เล่น",
        teamCheck="เช็คทีม",invis="ซ่อนตัว",
        noclip="เดินทะลุกำแพง",esp="มองทะลุ",espColor="สี ESP",plrInfo="ข้อมูลผู้เล่น",
        timeChng="เวลา (0-23)",gravChng="แรงโน้มถ่วง",rmWalls="ลบกำแพง",rmTrees="ลบต้นไม้",
        brightSky="ท้องฟ้าสว่าง",noFog="ลบหมอก",waterWalk="เดินบนน้ำ",
        fps="เพิ่ม FPS",fullbright="สว่างทุกที่",antiAfk="กัน AFK",
        unlockFPS="ปลดล็อก FPS",fovChng="FOV",camShake="ปิดกล้องสั่น",
        hideGUI="ซ่อน GUI เกม",lagSwitch="Lag Switch",
        rejoin="เข้าเกมใหม่",serverHop="กระโดดเซิร์ฟ",
        fpsCount="แสดง FPS",pingDisp="แสดง Ping",coordDisp="แสดงพิกัด",speedo="แสดงความเร็ว",
        guiColor="สีหลัก GUI",lang="ภาษา",reset="รีเซ็ต GUI"},
    KH={main="មេ",combat="តស៊ូ",players="អ្នកលេង",world="ពិភពលោក",settings="ការកំណត់",
        fly="ហោះ",flySpd="ល្បឿនហោះ",walk="ដើរលឿន",walkVal="តម្លៃល្បឿន",
        jump="លោតខ្ពស់",jumpVal="កម្លាំងលោត",
        savePos="រក្សាទីតាំង",tpSaved="TP ទៅទីតាំង",tweenSaved="រំកិលទៅទីតាំង",tweenSpd="ល្បឿន Tween",
        chatSpam="ស្ប៉ាម",chatMsg="សារ",chatDelay="យឺតពេល",
        godMode="God Mode",antiKb="ការពារការបោះ",autoHeal="ព្យាបាលស្វ័យប្រវត្តិ",healAmt="គោលដៅ HP",
        silentAim="Silent Aim",hitbox="ពង្រីក Hitbox",hitboxSz="ទំហំ Hitbox",
        killAura="Kill Aura",killRange="ចម្ងាយ Kill Aura",autoAtk="វាយប្រហារស្វ័យប្រវត្តិ",
        selPlr="ជ្រើសអ្នកលេង",refresh="ធ្វើបញ្ជីឡើងវិញ",
        tpPlr="TP ទៅអ្នកលេង",tweenPlr="រំកិលទៅអ្នកលេង",tweenSpdP="ល្បឿន Tween",
        aimbot="កំណត់គោលដៅ",nearAim="គោលដៅជិតបំផុត",range="ចម្ងាយ",
        freezePlr="តក់អ្នកលេង",spectate="មើលទស្សនៈ",
        followPlr="តាមអ្នកលេង",pingPlr="Ping អ្នកលេង",
        teamCheck="ពិនិត្យក្រុម",invis="លាក់ខ្លួន",
        noclip="រត់ទ្លុះជញ្ជាំង",esp="មើលទ្លុះ",espColor="ពណ៌ ESP",plrInfo="ព័ត៌មាន",
        timeChng="ពេលវេលា (0-23)",gravChng="ទំនាញ",rmWalls="លុបជញ្ជាំង",rmTrees="លុបដើមឈើ",
        brightSky="មេឃភ្លឺ",noFog="លុបអ័ព្ទ",waterWalk="ដើរលើទឹក",
        fps="បង្កើន FPS",fullbright="ភ្លឺ",antiAfk="ការពារ AFK",
        unlockFPS="ដោះសោ FPS",fovChng="FOV",camShake="បិទញ័រ",
        hideGUI="លាក់ GUI",lagSwitch="Lag Switch",
        rejoin="ចូលឡើងវិញ",serverHop="ផ្លាស់ម៉ាស៊ីន",
        fpsCount="FPS",pingDisp="Ping",coordDisp="좌標",speedo="ល្បឿន",
        guiColor="ពណ៌ GUI",lang="ភាសា",reset="កំណត់ GUI ឡើងវិញ"},
}

-- ── Helpers ──
local function getHum() local c=plr.Character;return c and c:FindFirstChildWhichIsA("Humanoid") end
local function getHRP() local c=plr.Character;return c and c:FindFirstChild("HumanoidRootPart") end
local function notify(t,m) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title=t,Text=m,Duration=3}) end) end
local STATES={Enum.HumanoidStateType.Climbing,Enum.HumanoidStateType.FallingDown,Enum.HumanoidStateType.Flying,Enum.HumanoidStateType.Freefall,Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,Enum.HumanoidStateType.Landed,Enum.HumanoidStateType.Physics,Enum.HumanoidStateType.PlatformStanding,Enum.HumanoidStateType.Ragdoll,Enum.HumanoidStateType.Running,Enum.HumanoidStateType.RunningNoPhysics,Enum.HumanoidStateType.Seated,Enum.HumanoidStateType.StrafingNoPhysics,Enum.HumanoidStateType.Swimming}
local function setStates(h,v) for _,s in ipairs(STATES) do h:SetStateEnabled(s,v) end;h:ChangeState(v and Enum.HumanoidStateType.RunningNoPhysics or Enum.HumanoidStateType.Swimming) end
local function conn(c) if c then c:Disconnect() end;return nil end
local function debris(obj,t) game:GetService("Debris"):AddItem(obj,t) end

-- ── Fly ──
local function stopFly()
    flyOn=false;flyConn=conn(flyConn)
    if bg then bg:Destroy();bg=nil end;if bv then bv:Destroy();bv=nil end
    local c=plr.Character;if not c then return end
    local h=c:FindFirstChildWhichIsA("Humanoid");if h then setStates(h,true);h.PlatformStand=false end
    local a=c:FindFirstChild("Animate");if a then a.Disabled=false end
end
local function startFly()
    local c=plr.Character;if not c then return end
    local h=c:FindFirstChildWhichIsA("Humanoid");if not h then return end
    local torso=(h.RigType==Enum.HumanoidRigType.R6)and c:FindFirstChild("Torso")or c:FindFirstChild("UpperTorso");if not torso then return end
    local a=c:FindFirstChild("Animate");if a then a.Disabled=true end
    for _,t in ipairs(h:GetPlayingAnimationTracks()) do t:AdjustSpeed(0) end
    setStates(h,false);h.PlatformStand=true
    bg=Instance.new("BodyGyro",torso);bg.P=9e4;bg.maxTorque=Vector3.new(9e9,9e9,9e9);bg.D=100;bg.cframe=torso.CFrame
    bv=Instance.new("BodyVelocity",torso);bv.velocity=Vector3.new(0,.1,0);bv.maxForce=Vector3.new(9e9,9e9,9e9)
    local cam=workspace.CurrentCamera;local cur,last=0,Vector3.new(0,.1,0)
    flyConn=RS.Heartbeat:Connect(function(dt)
        if not flyOn or not c:FindFirstChild("HumanoidRootPart") then return end
        local md=h.MoveDirection;local cf=cam.CoordinateFrame;local wish=Vector3.zero
        if md.Magnitude>.1 then
            local fl=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z);local ri=Vector3.new(cf.RightVector.X,0,cf.RightVector.Z)
            if fl.Magnitude>0 then fl=fl.Unit end;if ri.Magnitude>0 then ri=ri.Unit end
            wish=cf.LookVector*md:Dot(fl)+ri*md:Dot(ri);if wish.Magnitude>0 then wish=wish.Unit end
        end
        cur=cur+((wish.Magnitude>.1 and flySpeed or 0)-cur)*math.min((wish.Magnitude>.1 and 80 or 120)*dt,1)
        if wish.Magnitude>.1 then last=wish end
        if cur>.5 then bv.velocity=last*cur;bg.cframe=cf*CFrame.Angles(-math.rad(math.clamp(cur/math.max(flySpeed,1)*30,0,30)),0,0)
        else bv.velocity=Vector3.zero;bg.cframe=cf end
    end)
end
local function toggleFly(s) flyOn=s;if s then startFly() else stopFly() end end
local function toggleWalk(s) walkOn=s;local h=getHum();if not h then return end;if s then walkDef=h.WalkSpeed;h.WalkSpeed=walkVal else h.WalkSpeed=walkDef end end
local function setWalk(v) walkVal=v*10;if walkOn then local h=getHum();if h then h.WalkSpeed=walkVal end end end
local function stopJump() jumpOn=false;jumpConn=conn(jumpConn);local h=getHum();if h then pcall(function()h.UseJumpPower=true end);h.JumpPower=jumpDef end end
local function startJump()
    local h=getHum();if h then pcall(function()h.UseJumpPower=true end);jumpDef=h.JumpPower end
    jumpConn=RS.Heartbeat:Connect(function() if not jumpOn then return end;local h2=getHum();if not h2 then return end;pcall(function()h2.UseJumpPower=true end);if h2.JumpPower~=jumpVal then h2.JumpPower=jumpVal end end)
end
local function toggleJump(s) jumpOn=s;if s then startJump() else stopJump() end end
local function toggleNoclip(s)
    noclipOn=s
    if s then noclipConn=RS.Stepped:Connect(function() local c=plr.Character;if not c then return end;for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end)
    else noclipConn=conn(noclipConn);local c=plr.Character;if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end
end
local function sendChat(msg)
    pcall(function() local tcs=game:GetService("TextChatService");if tcs.ChatVersion==Enum.ChatVersion.TextChatService then local ch=tcs.TextChannels:FindFirstChild("RBXGeneral");if ch then ch:SendAsync(msg) end end end)
    pcall(function() local ev=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents");if ev and ev:FindFirstChild("SayMessageRequest") then ev.SayMessageRequest:FireServer(msg,"All") end end)
end
local function toggleChatSpam(s) chatSpamOn=s;if s then task.spawn(function() while chatSpamOn do sendChat(chatMsg);task.wait(math.max(chatSpamDelay,.1)) end end) end end
local function savePos() local r=getHRP();if not r then return end;savedPos=r.CFrame;notify("TP","บันทึกตำแหน่งแล้ว ✅") end
local function tpTo(cf) local r=getHRP();if r then r.CFrame=cf end end
local function tweenTo(cf)
    local r=getHRP();if not r then return end;local h=getHum();if h then h.WalkSpeed=0 end
    local tw=TS:Create(r,TweenInfo.new(math.max((cf.Position-r.Position).Magnitude/(tweenSpd*20),.3),Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{CFrame=cf})
    tw:Play();tw.Completed:Connect(function() if h then h.WalkSpeed=walkOn and walkVal or walkDef end end)
end

-- ── Combat ──
local function toggleGod(s) godOn=s;if s then godConn=RS.Heartbeat:Connect(function() if not godOn then return end;local h=getHum();if h and h.Health<h.MaxHealth then h.Health=h.MaxHealth end end) else godConn=conn(godConn) end end
local function toggleAntiKb(s) antiKbOn=s;if s then antiKbConn=RS.Heartbeat:Connect(function() if not antiKbOn then return end;local r=getHRP();if r and r.AssemblyLinearVelocity.Magnitude>50 then r.AssemblyLinearVelocity=Vector3.zero end end) else antiKbConn=conn(antiKbConn) end end
local function toggleAutoHeal(s) autoHealOn=s;if s then healConn=RS.Heartbeat:Connect(function() if not autoHealOn then return end;local h=getHum();if h and h.Health<healTarget then h.Health=math.min(h.Health+1,healTarget) end end) else healConn=conn(healConn) end end
local function getNear() local mr=getHRP();if not mr then return nil end;local best,d=nil,nearRange;for _,p in ipairs(Players:GetPlayers()) do if p==plr then continue end;local c=p.Character;if not c then continue end;local r=c:FindFirstChild("HumanoidRootPart");if not r then continue end;local h=c:FindFirstChildWhichIsA("Humanoid");if not h or h.Health<=0 then continue end;local dist=(r.Position-mr.Position).Magnitude;if dist<d then d=dist;best=p end end;return best end
local function applyHitbox() for _,p in ipairs(Players:GetPlayers()) do if p==plr then continue end;local c=p.Character;if not c then continue end;local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then continue end;if not hitboxData[p] then hitboxData[p]={sz=hrp.Size} end;hrp.Size=Vector3.new(hitboxSize,hitboxSize,hitboxSize) end end
local function removeHitbox() for p,d in pairs(hitboxData) do local c=p.Character;if c then local hrp=c:FindFirstChild("HumanoidRootPart");if hrp then hrp.Size=d.sz end end;hitboxData[p]=nil end end
local function toggleHitbox(s) hitboxOn=s;if s then applyHitbox() else removeHitbox() end end
local function toggleKillAura(s)
    killAuraOn=s
    if s then killAuraConn=RS.Heartbeat:Connect(function()
        if not killAuraOn then return end;local mr=getHRP();if not mr then return end
        for _,p in ipairs(Players:GetPlayers()) do if p==plr then continue end;local c=p.Character;if not c then continue end;local r=c:FindFirstChild("HumanoidRootPart");if not r then continue end
            if (r.Position-mr.Position).Magnitude<=killAuraRange then local bv2=Instance.new("BodyVelocity",r);bv2.Velocity=(r.Position-mr.Position).Unit*100+Vector3.new(0,50,0);bv2.MaxForce=Vector3.new(1e5,1e5,1e5);debris(bv2,.1) end
        end
    end)
    else killAuraConn=conn(killAuraConn) end
end
local function toggleAutoAtk(s) autoAtkOn=s;if s then autoAtkConn=RS.Heartbeat:Connect(function() if not autoAtkOn then return end;local tool=plr.Character and plr.Character:FindFirstChildWhichIsA("Tool");if tool then pcall(function() tool:Activate() end) end end) else autoAtkConn=conn(autoAtkConn) end end

-- ── Players ──
local function stopAimbot() aimbotOn=false;aimbotConn=conn(aimbotConn) end
local function startAimbot()
    aimbotConn=conn(aimbotConn)
    aimbotConn=RS.Heartbeat:Connect(function()
        if not aimbotOn or not aimTarget then return end
        local tc=aimTarget.Character;if not tc then return end;local tr=tc:FindFirstChild("HumanoidRootPart");if not tr then return end
        local mr=getHRP();if not mr then return end
        workspace.CurrentCamera.CFrame=workspace.CurrentCamera.CFrame:Lerp(CFrame.lookAt(mr.Position+Vector3.new(0,1.5,0),tr.Position),0.2)
    end)
end
local function toggleAimbot(s) aimbotOn=s;if s then if not aimTarget then notify("Aimbot","เลือกผู้เล่นก่อน!");aimbotOn=false;return end;startAimbot() else stopAimbot() end end
local function stopNear() nearOn=false;nearConn=conn(nearConn) end
local function startNear()
    nearConn=conn(nearConn)
    nearConn=RS.Heartbeat:Connect(function()
        if not nearOn then return end;local p=getNear();if not p then return end
        local tc=p.Character;if not tc then return end;local tr=tc:FindFirstChild("HumanoidRootPart");if not tr then return end
        local mr=getHRP();if not mr then return end
        workspace.CurrentCamera.CFrame=workspace.CurrentCamera.CFrame:Lerp(CFrame.lookAt(mr.Position+Vector3.new(0,1.5,0),tr.Position+Vector3.new(0,1.5,0)),0.2)
    end)
end
local function toggleNear(s) nearOn=s;if s then startNear() else stopNear() end end
local function makeESP(p)
    if p==plr or espData[p] then return end;local c=p.Character;if not c then return end
    local hl=Instance.new("Highlight");hl.FillColor=espFill;hl.OutlineColor=espOutline;hl.FillTransparency=.55;hl.OutlineTransparency=0;hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Parent=c
    local hrp=c:FindFirstChild("HumanoidRootPart")or c:FindFirstChild("Torso");local bb=nil
    if hrp then bb=Instance.new("BillboardGui");bb.Adornee=hrp;bb.AlwaysOnTop=true;bb.Size=UDim2.new(0,120,0,30);bb.StudsOffset=Vector3.new(0,3.5,0);bb.Parent=hrp
        local lbl=Instance.new("TextLabel",bb);lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1;lbl.Text=p.Name;lbl.TextColor3=espOutline;lbl.TextStrokeTransparency=0;lbl.TextSize=15;lbl.Font=Enum.Font.GothamBold end
    espData[p]={hl=hl,bb=bb}
end
local function removeESP(p) local d=espData[p];if not d then return end;pcall(function()if d.hl then d.hl:Destroy()end end);pcall(function()if d.bb then d.bb:Destroy()end end);espData[p]=nil end
local function updateESP() for _,d in pairs(espData) do if d.hl then d.hl.FillColor=espFill;d.hl.OutlineColor=espOutline end;if d.bb then local l=d.bb:FindFirstChildOfClass("TextLabel");if l then l.TextColor3=espOutline end end end end
local function toggleESP(s) espOn=s;if s then for _,p in ipairs(Players:GetPlayers()) do makeESP(p) end else for p in pairs(espData) do removeESP(p) end;espData={} end end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(.5);if espOn then makeESP(p) end end) end)
Players.PlayerRemoving:Connect(function(p) removeESP(p);if aimTarget==p then aimTarget=nil;if aimbotOn then stopAimbot() end end end)
local function toggleFreeze(s) freezeOn=s;if s then if not aimTarget then notify("Freeze","เลือกผู้เล่นก่อน!");freezeOn=false;return end;freezeConn=RS.Heartbeat:Connect(function() if not freezeOn or not aimTarget then return end;local tc=aimTarget.Character;if not tc then return end;local r=tc:FindFirstChild("HumanoidRootPart");if r then r.AssemblyLinearVelocity=Vector3.zero;r.AssemblyAngularVelocity=Vector3.zero end end) else freezeConn=conn(freezeConn) end end
local function toggleSpectate(s)
    spectateOn=s;local cam=workspace.CurrentCamera
    if s then if not aimTarget then notify("Spectate","เลือกผู้เล่นก่อน!");spectateOn=false;return end;cam.CameraType=Enum.CameraType.Scriptable
        RS.Heartbeat:Connect(function() if not spectateOn then cam.CameraType=Enum.CameraType.Custom;return end;local tc=aimTarget.Character;if not tc then return end;local r=tc:FindFirstChild("HumanoidRootPart");if r then cam.CFrame=CFrame.new(r.Position+Vector3.new(0,5,-10),r.Position) end end)
    else cam.CameraType=Enum.CameraType.Custom end
end
local function toggleFollow(s) followOn=s;if s then if not aimTarget then notify("Follow","เลือกผู้เล่นก่อน!");followOn=false;return end;followConn=RS.Heartbeat:Connect(function() if not followOn or not aimTarget then return end;local tc=aimTarget.Character;if not tc then return end;local tr=tc:FindFirstChild("HumanoidRootPart");if not tr then return end;local mr=getHRP();if not mr then return end;local h=getHum();if h and (tr.Position-mr.Position).Magnitude>5 then h:MoveTo(tr.Position) end end) else followConn=conn(followConn) end end
local function toggleInvis(s) invisOn=s;local c=plr.Character;if not c then return end;for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart")or p:IsA("Decal") then p.LocalTransparencyModifier=s and 1 or 0 end end end
local function showPlayerInfo(t)
    if not t then notify("Info","เลือกผู้เล่นก่อน!");return end
    local c=t.Character;if not c then notify("Info",t.Name.." ไม่มีตัวละคร");return end
    local h=c:FindFirstChildWhichIsA("Humanoid");if not h then return end
    notify("Info",string.format("%s | HP:%.0f/%.0f | Walk:%.0f | Jump:%.0f",t.Name,h.Health,h.MaxHealth,h.WalkSpeed,h.JumpPower))
end
local function doPingPlayer(t) if not t then notify("Ping","เลือกผู้เล่นก่อน!");return end;pcall(function() notify("Ping",t.Name.." | "..math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()).."ms") end) end
local function doTeamCheck(t) if not t then notify("Team","เลือกผู้เล่นก่อน!");return end;notify("Team",t.Name..": "..(t.Team and t.Team.Name or "No Team").." | You: "..(plr.Team and plr.Team.Name or "No Team")) end

-- ── World ──
local function toggleFullbright(s)
    fullbrightOn=s
    if s then fbSaved={B=Light.Brightness,A=Light.Ambient,OA=Light.OutdoorAmbient,T=Light.TimeOfDay,FE=Light.FogEnd,GS=Light.GlobalShadows};Light.Brightness=2;Light.Ambient=Color3.new(1,1,1);Light.OutdoorAmbient=Color3.new(1,1,1);Light.TimeOfDay="14:00:00";Light.FogEnd=100000;Light.GlobalShadows=false
    else if fbSaved.B then Light.Brightness=fbSaved.B;Light.Ambient=fbSaved.A;Light.OutdoorAmbient=fbSaved.OA;Light.TimeOfDay=fbSaved.T;Light.FogEnd=fbSaved.FE;Light.GlobalShadows=fbSaved.GS end;fbSaved={} end
end
local function toggleRemoveWalls(s)
    if s then for _,o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart")and not o:IsA("Terrain") then local n=o.Name:lower();if n:find("wall")or n:find("fence")or n:find("barrier") then table.insert(removedWalls,{obj=o,t=o.Transparency,cc=o.CanCollide});o.Transparency=1;o.CanCollide=false end end end
    else for _,d in ipairs(removedWalls) do pcall(function()d.obj.Transparency=d.t;d.obj.CanCollide=d.cc end) end;removedWalls={} end
end
local function toggleRemoveTrees(s)
    if s then for _,o in ipairs(workspace:GetDescendants()) do local n=o.Name:lower();if n:find("tree")or n:find("bush")or n:find("plant") then if o:IsA("BasePart") then table.insert(removedTrees,{obj=o,t=o.Transparency});o.Transparency=1 end end end
    else for _,d in ipairs(removedTrees) do pcall(function()d.obj.Transparency=d.t end) end;removedTrees={} end
end
local function toggleBrightSky(s) if s then Light.Brightness=5;Light.Ambient=Color3.new(1,1,1);Light.OutdoorAmbient=Color3.new(1,1,1);Light.TimeOfDay="12:00:00" else Light.Brightness=1;Light.OutdoorAmbient=Color3.fromRGB(127,127,127);Light.TimeOfDay="14:00:00" end end
local function toggleNoFog(s) if s then Light.FogEnd=1e6;Light.FogStart=999999 else Light.FogEnd=1000;Light.FogStart=0 end end
local function toggleWaterWalk(s) waterWalkOn=s;if s then waterWalkConn=RS.Heartbeat:Connect(function() if not waterWalkOn then return end;local h=getHum();if h and h:GetState()==Enum.HumanoidStateType.Swimming then h:ChangeState(Enum.HumanoidStateType.Running) end end) else waterWalkConn=conn(waterWalkConn) end end

-- ── Settings ──
local function toggleAntiAfk(s) antiAfkOn=s;if s then antiAfkConn=RS.Heartbeat:Connect(function() if not antiAfkOn then return end;pcall(function()game:GetService("VirtualUser"):CaptureController();game:GetService("VirtualUser"):ClickButton2(Vector2.new())end) end) else antiAfkConn=conn(antiAfkConn) end end
local function applyFPS()
    fpsSaved.B=Light.Brightness;fpsSaved.GS=Light.GlobalShadows;fpsSaved.FE=Light.FogEnd
    Light.GlobalShadows=false;Light.Brightness=2;Light.FogEnd=1e6
    for _,e in ipairs(Light:GetChildren()) do if e:IsA("PostEffect")or e:IsA("Sky") then e.Enabled=false end end
    pcall(function()workspace.Terrain.WaterWaveSize=0;workspace.Terrain.Decoration=false end)
    local n=0;for _,o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart")and not o:IsA("Terrain") then fpsSaved[o]={M=o.Material,CS=o.CastShadow,R=o.Reflectance};o.Material=Enum.Material.SmoothPlastic;o.CastShadow=false;o.Reflectance=0;n=n+1;if n%200==0 then task.wait()end end end
    notify("FPS","เปิดแล้ว! ("..n.." parts)")
end
local function removeFPS()
    if fpsSaved.GS~=nil then Light.GlobalShadows=fpsSaved.GS;Light.Brightness=fpsSaved.B;Light.FogEnd=fpsSaved.FE end
    for _,e in ipairs(Light:GetChildren()) do if e:IsA("PostEffect")or e:IsA("Sky") then e.Enabled=true end end
    pcall(function()workspace.Terrain.Decoration=true end)
    local n=0;for o,d in pairs(fpsSaved) do if typeof(o)=="Instance"and o:IsA("BasePart") then pcall(function()o.Material=d.M;o.CastShadow=d.CS;o.Reflectance=d.R end);n=n+1;if n%200==0 then task.wait()end end end
    fpsSaved={};notify("FPS","ปิดแล้ว")
end
local function doRejoin() notify("Rejoin","กำลังเข้าเกมใหม่...");task.wait(1);pcall(function()game:GetService("TeleportService"):Teleport(game.PlaceId,plr)end) end
local function doServerHop()
    notify("Server Hop","กำลังหาเซิร์ฟเวอร์ใหม่...")
    task.spawn(function()
        local T=game:GetService("TeleportService");local H=game:GetService("HttpService");local found=false
        pcall(function()
            local data=H:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _,s in ipairs(data.data or{}) do if s.id~=game.JobId and s.playing<s.maxPlayers then pcall(function()T:TeleportToPlaceInstance(game.PlaceId,s.id,plr)end);found=true;break end end
        end)
        if not found then pcall(function()T:Teleport(game.PlaceId,plr)end) end
    end)
end

-- ── Info HUD ──
local infoFrame=nil
local function buildInfoHUD()
    if infoHUD then infoHUD:Destroy() end
    infoHUD=Instance.new("ScreenGui");infoHUD.Name="JoeyHubInfo";infoHUD.ResetOnSpawn=false;infoHUD.IgnoreGuiInset=true;infoHUD.Parent=PGui
    local frame=Instance.new("Frame",infoHUD);frame.Size=UDim2.new(0,200,0,88);frame.Position=UDim2.new(0,8,1,-96);frame.BackgroundColor3=Color3.fromRGB(0,0,0);frame.BackgroundTransparency=.5;frame.BorderSizePixel=0
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,6)
    local function lbl(y) local l=Instance.new("TextLabel",frame);l.Size=UDim2.new(1,-8,0,18);l.Position=UDim2.new(0,4,0,y);l.BackgroundTransparency=1;l.TextColor3=Color3.new(1,1,1);l.TextSize=12;l.Font=Enum.Font.GothamBold;l.TextXAlignment=Enum.TextXAlignment.Left;return l end
    local lFPS=lbl(2);local lPing=lbl(24);local lCoord=lbl(46);local lSpeed=lbl(68)
    local fpsCount,lastT=0,tick()
    if infoConn then infoConn:Disconnect() end
    infoConn=RS.Heartbeat:Connect(function()
        fpsCount=fpsCount+1
        if tick()-lastT>=1 then
            if fpsCountOn then lFPS.Text="FPS: "..fpsCount end
            if pingDispOn then pcall(function()lPing.Text="Ping: "..math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()).."ms"end) end
            fpsCount=0;lastT=tick()
        end
        lFPS.Visible=fpsCountOn;lPing.Visible=pingDispOn;lCoord.Visible=coordDispOn;lSpeed.Visible=speedoOn
        if coordDispOn then local r=getHRP();if r then lCoord.Text=string.format("X:%.0f Y:%.0f Z:%.0f",r.Position.X,r.Position.Y,r.Position.Z) end end
        if speedoOn then local r=getHRP();if r then lSpeed.Text=string.format("Speed: %.1f",r.AssemblyLinearVelocity.Magnitude) end end
    end)
    frame.Visible=fpsCountOn or pingDispOn or coordDispOn or speedoOn
    return frame
end
local function updateInfoVis() if infoFrame then infoFrame.Visible=fpsCountOn or pingDispOn or coordDispOn or speedoOn end end

-- ── Respawn ──
plr.CharacterAdded:Connect(function(c)
    task.wait(.7);flyOn=false;flyConn=conn(flyConn);bg=nil;bv=nil
    local h=c:FindFirstChildWhichIsA("Humanoid");if not h then return end
    h.PlatformStand=false
    if walkOn then h.WalkSpeed=walkVal end
    if jumpOn then jumpConn=conn(jumpConn);startJump() end
    if noclipOn then task.wait(.1);toggleNoclip(true) end
    if godOn then toggleGod(false);task.wait(.1);toggleGod(true) end
    local a=c:FindFirstChild("Animate");if a then a.Disabled=false end
end)

-- ══════════════════════════════
--   BUILD GUI — Fix destroy bug
-- ══════════════════════════════
local function buildGUI()
    local Lc=L[currentLang]

    -- Step 1: ลบ GUI เก่าของ WindUI ทุกอัน
    for _,g in ipairs(windUIGuis) do
        if typeof(g)=="Instance" and g.Parent then
            pcall(function() g:Destroy() end)
        end
    end
    windUIGuis={}
    task.wait(0.25)

    -- Step 2: snapshot ก่อนโหลด
    local snapshot={}
    for _,v in ipairs(PGui:GetChildren()) do snapshot[v]=true end

    -- Step 3: โหลด WindUI ใหม่
    WindUI=loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    local W=WindUI:CreateWindow({Title="Joey Hub",Icon="bird",Author="by MINHAJ"})
    W:EditOpenButton({Title="JoeyHub",Icon="monitor",CornerRadius=UDim.new(0,16),StrokeThickness=2,Color=ColorSequence.new(guiColor1,guiColor2),OnlyMobile=false,Enabled=true,Draggable=true})
    W:Tag({Title="v3",Icon="bird",Color=Color3.fromHex("#30ff6a"),Radius=13})

    -- ════ TAB: MAIN ════
    local T1=W:Tab({Title=Lc.main,Icon="book",Locked=false})
    T1:Toggle({Title=Lc.fly,     Desc="",Icon="bird",           Type="Checkbox",Value=false,Callback=function(s)toggleFly(s)end})
    T1:Slider({Title=Lc.flySpd,  Desc="",Step=1,Value={Min=1,Max=50,Default=10},Callback=function(v)flySpeed=v*5 end})
    T1:Toggle({Title=Lc.walk,    Desc="",Icon="person-standing",Type="Checkbox",Value=false,Callback=function(s)toggleWalk(s)end})
    T1:Slider({Title=Lc.walkVal, Desc="",Step=1,Value={Min=1,Max=50,Default=5}, Callback=function(v)setWalk(v)end})
    T1:Toggle({Title=Lc.jump,    Desc="",Icon="arrow-up",       Type="Checkbox",Value=false,Callback=function(s)toggleJump(s)end})
    T1:Slider({Title=Lc.jumpVal, Desc="",Step=1,Value={Min=1,Max=50,Default=5}, Callback=function(v)jumpVal=v*30 end})
    T1:Toggle({Title=Lc.noclip,  Desc="",Icon="layers",         Type="Checkbox",Value=false,Callback=function(s)toggleNoclip(s)end})
    T1:Toggle({Title=Lc.chatSpam,Desc="",Icon="message-circle", Type="Checkbox",Value=false,Callback=function(s)toggleChatSpam(s)end})
    T1:Input({Title=Lc.chatMsg,  Desc="",Icon="pencil",Default="Joey Hub",Locked=false,Callback=function(v)if v and v~=""then chatMsg=v end end})
    T1:Slider({Title=Lc.chatDelay,Desc="",Step=0.1,Value={Min=0.1,Max=10,Default=1},Callback=function(v)chatSpamDelay=v end})
    T1:Button({Title=Lc.savePos,   Desc="",Icon="map-pin",   Callback=function()savePos()end})
    T1:Button({Title=Lc.tpSaved,   Desc="",Icon="map-pin",   Callback=function()if savedPos then tpTo(savedPos)else notify("TP","ยังไม่ได้บันทึก!")end end})
    T1:Button({Title=Lc.tweenSaved,Desc="",Icon="navigation",Callback=function()if savedPos then tweenTo(savedPos)else notify("TP","ยังไม่ได้บันทึก!")end end})
    T1:Slider({Title=Lc.tweenSpd,  Desc="",Step=1,Value={Min=1,Max=20,Default=10},Callback=function(v)tweenSpd=v end})

    -- ════ TAB: COMBAT ════
    local T2=W:Tab({Title=Lc.combat,Icon="sword",Locked=false})
    T2:Toggle({Title=Lc.godMode, Desc="",Icon="shield",     Type="Checkbox",Value=false,Callback=function(s)toggleGod(s)end})
    T2:Toggle({Title=Lc.antiKb,  Desc="",Icon="shield-off", Type="Checkbox",Value=false,Callback=function(s)toggleAntiKb(s)end})
    T2:Toggle({Title=Lc.autoHeal,Desc="",Icon="heart",      Type="Checkbox",Value=false,Callback=function(s)toggleAutoHeal(s)end})
    T2:Slider({Title=Lc.healAmt, Desc="",Step=1,Value={Min=1,Max=100,Default=100},Callback=function(v)healTarget=v end})
    T2:Toggle({Title=Lc.hitbox,  Desc="",Icon="box",        Type="Checkbox",Value=false,Callback=function(s)toggleHitbox(s)end})
    T2:Slider({Title=Lc.hitboxSz,Desc="",Step=1,Value={Min=1,Max=50,Default=10},Callback=function(v)hitboxSize=v;if hitboxOn then applyHitbox()end end})
    T2:Toggle({Title=Lc.killAura,Desc="",Icon="zap",        Type="Checkbox",Value=false,Callback=function(s)toggleKillAura(s)end})
    T2:Slider({Title=Lc.killRange,Desc="",Step=1,Value={Min=5,Max=50,Default=15},Callback=function(v)killAuraRange=v end})
    T2:Toggle({Title=Lc.autoAtk, Desc="",Icon="swords",     Type="Checkbox",Value=false,Callback=function(s)toggleAutoAtk(s)end})

    -- ════ TAB: PLAYERS ════
    local T3=W:Tab({Title=Lc.players,Icon="user",Locked=false})
    local function getPList() local l={};for _,p in ipairs(Players:GetPlayers()) do if p~=plr then table.insert(l,p.Name) end end;return l end
    local dd=T3:Dropdown({Title=Lc.selPlr,Desc="",Values=getPList(),Value="",Callback=function(n)aimTarget=n~=""and Players:FindFirstChild(n)or nil;if aimbotOn and aimTarget then startAimbot()end end})
    T3:Button({Title=Lc.refresh,   Desc="",Icon="refresh-cw", Callback=function()if aimTarget and not Players:FindFirstChild(aimTarget.Name)then aimTarget=nil;if aimbotOn then stopAimbot()end end;pcall(function()dd:Set(getPList())end);notify("Players",#Players:GetPlayers()-1 .." players")end})
    T3:Button({Title=Lc.tpPlr,     Desc="",Icon="map-pin",    Callback=function()if not aimTarget then notify("TP","เลือกผู้เล่นก่อน!");return end;local r=aimTarget.Character and aimTarget.Character:FindFirstChild("HumanoidRootPart");if r then tpTo(r.CFrame*CFrame.new(0,0,3))end end})
    T3:Button({Title=Lc.tweenPlr,  Desc="",Icon="navigation", Callback=function()if not aimTarget then notify("TP","เลือกผู้เล่นก่อน!");return end;local r=aimTarget.Character and aimTarget.Character:FindFirstChild("HumanoidRootPart");if r then tweenTo(r.CFrame*CFrame.new(0,0,3))end end})
    T3:Slider({Title=Lc.tweenSpdP, Desc="",Step=1,Value={Min=1,Max=20,Default=10},Callback=function(v)tweenSpd=v end})
    T3:Toggle({Title=Lc.aimbot,    Desc="",Icon="crosshair",  Type="Checkbox",Value=false,Callback=function(s)toggleAimbot(s)end})
    T3:Toggle({Title=Lc.nearAim,   Desc="",Icon="crosshair",  Type="Checkbox",Value=false,Callback=function(s)toggleNear(s)end})
    T3:Slider({Title=Lc.range,     Desc="",Step=1,Value={Min=1,Max=20,Default=10},Callback=function(v)nearRange=v*10 end})
    T3:Toggle({Title=Lc.freezePlr, Desc="",Icon="snowflake",  Type="Checkbox",Value=false,Callback=function(s)toggleFreeze(s)end})
    T3:Toggle({Title=Lc.spectate,  Desc="",Icon="video",      Type="Checkbox",Value=false,Callback=function(s)toggleSpectate(s)end})
    T3:Toggle({Title=Lc.followPlr, Desc="",Icon="navigation", Type="Checkbox",Value=false,Callback=function(s)toggleFollow(s)end})
    T3:Toggle({Title=Lc.invis,     Desc="",Icon="eye-off",    Type="Checkbox",Value=false,Callback=function(s)toggleInvis(s)end})
    T3:Toggle({Title=Lc.esp,       Desc="",Icon="eye",        Type="Checkbox",Value=false,Callback=function(s)toggleESP(s)end})
    T3:Colorpicker({Title=Lc.espColor,Desc="",Default=espFill,Transparency=0,Locked=false,Callback=function(c)espFill=c;espOutline=Color3.new(math.min(c.R+.25,1),math.min(c.G+.25,1),math.min(c.B+.25,1));updateESP()end})
    T3:Button({Title=Lc.plrInfo,   Desc="",Icon="info",       Callback=function()showPlayerInfo(aimTarget)end})
    T3:Button({Title=Lc.pingPlr,   Desc="",Icon="wifi",       Callback=function()doPingPlayer(aimTarget)end})
    T3:Button({Title=Lc.teamCheck, Desc="",Icon="users",      Callback=function()doTeamCheck(aimTarget)end})

    -- ════ TAB: WORLD ════
    local T4=W:Tab({Title=Lc.world,Icon="globe",Locked=false})
    T4:Toggle({Title=Lc.fullbright,Desc="",Icon="sun",        Type="Checkbox",Value=false,Callback=function(s)toggleFullbright(s)end})
    T4:Toggle({Title=Lc.brightSky, Desc="",Icon="cloud-sun",  Type="Checkbox",Value=false,Callback=function(s)toggleBrightSky(s)end})
    T4:Toggle({Title=Lc.noFog,     Desc="",Icon="cloud-off",  Type="Checkbox",Value=false,Callback=function(s)toggleNoFog(s)end})
    T4:Toggle({Title=Lc.waterWalk, Desc="",Icon="waves",      Type="Checkbox",Value=false,Callback=function(s)toggleWaterWalk(s)end})
    T4:Toggle({Title=Lc.rmWalls,   Desc="",Icon="box-select", Type="Checkbox",Value=false,Callback=function(s)task.spawn(function()toggleRemoveWalls(s)end)end})
    T4:Toggle({Title=Lc.rmTrees,   Desc="",Icon="tree-pine",  Type="Checkbox",Value=false,Callback=function(s)task.spawn(function()toggleRemoveTrees(s)end)end})
    T4:Slider({Title=Lc.timeChng,  Desc="",Step=1,Value={Min=0,Max=23,Default=14},Callback=function(v)Light.TimeOfDay=string.format("%02d:00:00",math.floor(v))end})
    T4:Slider({Title=Lc.gravChng,  Desc="",Step=1,Value={Min=0,Max=200,Default=196},Callback=function(v)workspace.Gravity=v end})

    -- ════ TAB: SETTINGS ════
    local T5=W:Tab({Title=Lc.settings,Icon="settings",Locked=false})
    local fpsOn2=false
    T5:Toggle({Title=Lc.fps,       Desc="",Icon="zap",        Type="Checkbox",Value=false,Callback=function(s)fpsOn2=s;if s then task.spawn(applyFPS)else task.spawn(removeFPS)end end})
    T5:Toggle({Title=Lc.antiAfk,   Desc="",Icon="shield",     Type="Checkbox",Value=false,Callback=function(s)toggleAntiAfk(s)end})
    T5:Slider({Title=Lc.fovChng,   Desc="",Step=1,Value={Min=30,Max=120,Default=70},Callback=function(v)workspace.CurrentCamera.FieldOfView=v end})
    T5:Toggle({Title=Lc.unlockFPS, Desc="",Icon="monitor",    Type="Checkbox",Value=false,Callback=function(s)pcall(function()if s then setfpscap(0)else setfpscap(60)end end)end})
    T5:Toggle({Title=Lc.camShake,  Desc="",Icon="camera-off", Type="Checkbox",Value=false,Callback=function(s)for _,e in ipairs(workspace.CurrentCamera:GetChildren())do if e:IsA("LocalScript")then e.Enabled=not s end end end})
    T5:Toggle({Title=Lc.hideGUI,   Desc="",Icon="layout",     Type="Checkbox",Value=false,Callback=function(s)game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All,not s)end})
    T5:Button({Title=Lc.lagSwitch, Desc="",Icon="wifi-off",   Callback=function()task.spawn(function() local t=tick();while tick()-t<.5 do end end)end})
    T5:Button({Title=Lc.rejoin,    Desc="",Icon="log-in",     Callback=function()doRejoin()end})
    T5:Button({Title=Lc.serverHop, Desc="",Icon="shuffle",    Callback=function()doServerHop()end})
    T5:Toggle({Title=Lc.fpsCount,  Desc="",Icon="activity",   Type="Checkbox",Value=false,Callback=function(s)fpsCountOn=s;updateInfoVis()end})
    T5:Toggle({Title=Lc.pingDisp,  Desc="",Icon="wifi",       Type="Checkbox",Value=false,Callback=function(s)pingDispOn=s;updateInfoVis()end})
    T5:Toggle({Title=Lc.coordDisp, Desc="",Icon="map",        Type="Checkbox",Value=false,Callback=function(s)coordDispOn=s;updateInfoVis()end})
    T5:Toggle({Title=Lc.speedo,    Desc="",Icon="gauge",      Type="Checkbox",Value=false,Callback=function(s)speedoOn=s;updateInfoVis()end})
    T5:Colorpicker({Title=Lc.guiColor,Desc="",Default=guiColor1,Transparency=0,Locked=false,Callback=function(c)guiColor1=c;guiColor2=Color3.new(math.min(c.R+.15,1),math.min(c.G+.15,1),math.min(c.B+.15,1));W:EditOpenButton({Title="JoeyHub",Icon="monitor",CornerRadius=UDim.new(0,16),StrokeThickness=2,Color=ColorSequence.new(guiColor1,guiColor2),OnlyMobile=false,Enabled=true,Draggable=true})end})
    local lm={English="EN",["ภาษาไทย"]="TH",["ភាសាខ្មែរ"]="KH"}
    local ld=currentLang=="TH" and "ภาษาไทย" or currentLang=="KH" and "ភាសាខ្មែរ" or "English"
    T5:Dropdown({Title=Lc.lang,Desc="",Values={"English","ภาษาไทย","ភាសាខ្មែរ"},Value=ld,Callback=function(v)currentLang=lm[v]or"EN" end})
    T5:Button({Title=Lc.reset,Desc="",Icon="refresh-cw",Callback=function()
        task.spawn(function() task.wait(.1);buildGUI();notify("GUI","เปลี่ยนภาษาเรียบร้อย!") end)
    end})

    -- Step 4: รอ 1.5 วิ แล้วจับ GUI ใหม่ทั้งหมดที่ WindUI สร้าง
    task.delay(1.5,function()
        for _,v in ipairs(PGui:GetChildren()) do
            if not snapshot[v] and v:IsA("ScreenGui") then
                local dup=false
                for _,g in ipairs(windUIGuis) do if g==v then dup=true;break end end
                if not dup then table.insert(windUIGuis,v) end
            end
        end
    end)

    infoFrame=buildInfoHUD()
end

buildGUI()

local sound=Instance.new("Sound")
sound.Name="JoeyHubMusic";sound.SoundId="rbxassetid://137837473324419"
sound.Volume=1;sound.Looped=false;sound.RollOffMaxDistance=10000;sound.Parent=workspace
if not sound.IsLoaded then sound.Loaded:Wait() end
sound:Play()
