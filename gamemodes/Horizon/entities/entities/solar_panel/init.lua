AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:SpawnFunction( ply, tr )
		
	local ent = ents.Create("solar_panel")
	ent:SetPos( tr.HitPos + Vector(0, 0, 5))
	ent:Spawn()
	local phys = ent:GetPhysicsObject()	
	return ent

end
 
 function ENT:Initialize()
 	
	self:SetModel( "models/solar_panel.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( ONOFF_USE )
					
	self.linkable = true
	self.connections = {}
	self.networkID = nil
	self.deviceType = "generator"
		
	--Resource Rates
	self.energyRate = 30
		
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:resourceExchange()

	-- use this function to place generate/consume resource function calls
	
	GAMEMODE:generateResource( self.networkID, "energy", self.energyRate )


end
   
function ENT:Think()	
	
	-- Check to see if a) there is LOS to the sun, and b) the device is connected to a network
	-- if true, then generate energy.
	if self:traceSun() == true and self.networkID != nil then
		self:resourceExchange()		
	end
		
	-- Use random number to avoid lag spikes with lots of solar panels.
	self.Entity:NextThink( CurTime() + math.Rand( 0.8, 1.2 ) )
	return true	
	
    
end

function ENT:traceSun()

	-- This device needs LOS to the sun to function. For this method to work, any map created will
	-- need to have an env_sun entity present.
	-- Use centre of world if sun not found.
	
	local sun = GAMEMODE:GetSun()
	if sun then
		local startPos = sun:GetPos()
	else
		local startPos = Vector(0, 0, 0)
	end
	
	local endPos = 	self:GetPos()
	local tracedata = {}
	tracedata.start = startPos
	tracedata.endpos = endPos
	tracedata.filter = self
	
	local trace = util.TraceLine(tracedata)
	
	if trace.Hit == true then
	
		local trResult = trace.Entity
		
		if trResult:GetClass() != "solar_panel" then		
			return false
		end			
	
	end
	
	return true
	
end

 